package controllers

import (
	"encoding/json"
	"fmt"
	"log"
	"sync"
	"time"

	cfg "barassage/api/configs"
	"barassage/api/models/message"
	messageRepo "barassage/api/repositories/message"
	roomRepo "barassage/api/repositories/room"

	"github.com/gofiber/contrib/websocket"
	jwt "github.com/golang-jwt/jwt/v4"
)

// Room structure to manage participants
type Room struct {
	Participants map[string]*websocket.Conn
	mu           sync.Mutex
}

var rooms = make(map[string]*Room)

// ErrorMessage represents the structure of an error message to send to the client
type ErrorMessage struct {
	Error string `json:"error"`
}

// Custom close codes
const (
	CloseCodeNormalClosure    = websocket.CloseNormalClosure
	CloseCodePolicyViolation  = 1008
	CloseCodeInternalError    = websocket.CloseInternalServerErr
	CloseCodeInvalidToken     = 4001
	CloseCodeInvalidUserID    = 4002
	CloseCodeRoomFull         = 4003
	CloseCodeNotAllowedInRoom = 4004
)

// Time intervals for ping-pong mechanism
const (
	pingPeriod = 30 * time.Second
	pongWait   = 60 * time.Second
)

// HandleWebSocket manages the WebSocket connection
func HandleWebSocket(c *websocket.Conn) {
	// Ensure connection is closed after handling
	defer func() {
		if err := c.Close(); err != nil {
			log.Println("Error closing connection:", err)
		}
	}()

	// Set the initial read deadline
	c.SetReadDeadline(time.Now().Add(pongWait))
	c.SetPongHandler(func(string) error {
		c.SetReadDeadline(time.Now().Add(pongWait))
		return nil
	})

	// Start a goroutine to send ping messages periodically
	ticker := time.NewTicker(pingPeriod)
	defer ticker.Stop()
	go func() {
		for {
			<-ticker.C
			if err := c.WriteMessage(websocket.PingMessage, nil); err != nil {
				log.Println("Error sending ping:", err)
				return
			}
		}
	}()

	// Extract token from query parameters
	tokenString := c.Query("token")
	if tokenString == "" {
		sendErrorAndClose(c, CloseCodePolicyViolation, "Missing token")
		return
	}

	// Parse and validate the token
	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return []byte(cfg.GetConfig().JWTAccessSecret), nil
	})

	if err != nil || !token.Valid {
		sendErrorAndClose(c, CloseCodeInvalidToken, fmt.Sprintf("Invalid token: %v", err))
		return
	}

	// Extract user ID from token claims
	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok || !token.Valid {
		sendErrorAndClose(c, CloseCodeInvalidToken, "Invalid token claims")
		return
	}

	userID, ok := claims["userID"].(string)
	if !ok {
		sendErrorAndClose(c, CloseCodeInvalidUserID, "Invalid user ID in token claims")
		return
	}

	roomID := c.Params("id")

	if roomID == "" {
		sendErrorAndClose(c, CloseCodePolicyViolation, "Missing roomID")
		return
	}

	// Get the room
	dbRoom, err := roomRepo.GetByID(roomID)
	if err != nil {
		sendErrorAndClose(c, CloseCodeInternalError, fmt.Sprintf("Error getting room: %v", err))
		return
	}

	// Check if the userID can participate in the room
	if dbRoom.ClientID != userID && dbRoom.CreatorID != userID {
		sendErrorAndClose(c, CloseCodeNotAllowedInRoom, "User is not allowed to participate in the room")
		return
	}

	log.Println("Room:", dbRoom)

	room := getRoom(roomID)
	if !addParticipantToRoom(room, userID, c) {
		sendErrorAndClose(c, CloseCodeRoomFull, "Room is full or user already exists")
		return
	}

	defer removeParticipantFromRoom(room, userID)

	for {
		mt, message, err := c.ReadMessage()
		if err != nil {
			log.Println("read error:", err)
			break
		}

		//get the receiver id from the room
		var receiverID string
		if dbRoom.ClientID == userID {
			receiverID = dbRoom.CreatorID
		} else {
			receiverID = dbRoom.ClientID
		}

		// Save the message to the database
		err = saveMessage(roomID, userID, receiverID, message)
		if err != nil {
			sendError(c, fmt.Sprintf("Error saving message: %v", err))
			continue
		}

		broadcastToRoom(room, mt, message)
	}
}

func getRoom(roomID string) *Room {
	if room, exists := rooms[roomID]; exists {
		return room
	}
	newRoom := &Room{
		Participants: make(map[string]*websocket.Conn),
	}
	rooms[roomID] = newRoom
	return newRoom
}

func addParticipantToRoom(room *Room, userID string, conn *websocket.Conn) bool {
	room.mu.Lock()
	defer room.mu.Unlock()

	if len(room.Participants) >= 2 {
		return false
	}

	if _, exists := room.Participants[userID]; exists {
		return false
	}

	room.Participants[userID] = conn
	return true
}

func removeParticipantFromRoom(room *Room, userID string) {
	room.mu.Lock()
	defer room.mu.Unlock()
	delete(room.Participants, userID)
}

func broadcastToRoom(room *Room, messageType int, message []byte) {
	room.mu.Lock()
	defer room.mu.Unlock()

	for _, conn := range room.Participants {
		if err := conn.WriteMessage(messageType, message); err != nil {
			log.Println("write error:", err)
		}
	}
}

func saveMessage(roomID string, senderID string, receiverID string, content []byte) error {
	room := getRoom(roomID)
	room.mu.Lock()
	defer room.mu.Unlock()

	msg := message.Message{
		RoomID:     roomID,
		SenderID:   senderID,
		ReceiverID: receiverID,
		Content:    string(content),
		Seen:       len(room.Participants) >= 2,
	}

	return messageRepo.Create(&msg)
}
func sendError(c *websocket.Conn, errorMsg string) {
	errMsg := ErrorMessage{Error: errorMsg}
	errMsgJSON, _ := json.Marshal(errMsg)
	if err := c.WriteMessage(websocket.TextMessage, errMsgJSON); err != nil {
		log.Println("Error sending error message:", err)
	}
}

func sendErrorAndClose(c *websocket.Conn, closeCode int, errorMsg string) {
	sendError(c, errorMsg)
	c.WriteMessage(websocket.CloseMessage, websocket.FormatCloseMessage(closeCode, errorMsg))
}
