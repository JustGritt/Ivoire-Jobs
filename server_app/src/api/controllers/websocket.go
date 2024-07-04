package controllers

import (
	"fmt"
	"log"
	"sync"

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

// HandleWebSocket manages the WebSocket connection
func HandleWebSocket(c *websocket.Conn) {
	defer c.Close()

	// Extract token from query parameters
	tokenString := c.Query("token")
	if tokenString == "" {
		log.Println("Missing token")
		return
	}

	// Parse and validate the token
	// Parse and validate the token
	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return []byte(cfg.GetConfig().JWTAccessSecret), nil
	})

	if err != nil || !token.Valid {
		log.Println("Invalid token:", err)
		return
	}

	// Extract user ID from token claims
	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok || !token.Valid {
		log.Println("Invalid token claims")
		return
	}

	userID := claims["userID"].(string)

	roomID := c.Params("id")

	if roomID == "" {
		log.Println("Missing roomID")
		return
	}

	//get the room
	dbRoom, err := roomRepo.GetByID(roomID)
	if err != nil {
		log.Println("Error getting room:", err)
		return
	}

	log.Println("Room:", dbRoom)

	room := getRoom(roomID)
	if !addParticipantToRoom(room, userID, c) {
		log.Println("Room is full or user already exists")
		return
	}

	defer removeParticipantFromRoom(room, userID)

	for {
		mt, message, err := c.ReadMessage()
		if err != nil {
			log.Println("read error:", err)
			break
		}

		// Save the message to the database
		err = saveMessage(roomID, userID, dbRoom.CreatorID, message)
		if err != nil {
			log.Println("Error saving message:", err)
			continue
		}

		broadcastToRoom(room, userID, mt, message)
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

func broadcastToRoom(room *Room, senderID string, messageType int, message []byte) {
	room.mu.Lock()
	defer room.mu.Unlock()

	for userID, conn := range room.Participants {
		if userID != senderID {
			if err := conn.WriteMessage(messageType, message); err != nil {
				log.Println("write error:", err)
			}
		}
	}
}

func saveMessage(roomID string, senderID string, receiverID string, content []byte) error {

	msg := message.Message{
		RoomID:     roomID,
		SenderID:   senderID,
		ReceiverID: receiverID,
		Content:    string(content),
	}

	return messageRepo.Create(&msg)
}
