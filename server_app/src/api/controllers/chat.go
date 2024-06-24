package controllers

import (
	"log"
	"sync"

	roomRepo "barassage/api/repositories/room"

	"github.com/gofiber/contrib/websocket"
	"github.com/gofiber/fiber/v2"
)

// Client represents a websocket client
type Client struct {
	ID     string
	Conn   *websocket.Conn
	RoomID string
}

// Message represents a message in the chat
type Message struct {
	SenderID string `json:"senderId"`
	RoomID   string `json:"roomId"`
	Content  string `json:"content"`
}

// Room represents a chat room in memory
type Room struct {
	ID        string
	CreatorID string
	ClientID  string
	Clients   map[*Client]bool
}

// RoomManager manages all the rooms and clients
type RoomManager struct {
	Rooms map[string]*Room
	Mutex sync.Mutex
}

// Global instance of RoomManager
var roomManager = RoomManager{
	Rooms: make(map[string]*Room),
}

// AddClientToRoom adds a client to a room
func AddClientToRoom(client *Client, roomID string) error {
	roomManager.Mutex.Lock()
	defer roomManager.Mutex.Unlock()

	// Check if room exists in the database
	roomFound, err := roomRepo.GetByID(roomID)
	if err != nil {
		return fiber.NewError(fiber.StatusNotFound, "Room not found")
	}

	room, exists := roomManager.Rooms[roomID]
	if !exists {
		room = &Room{
			ID:        roomID,
			CreatorID: roomFound.CreatorID,
			ClientID:  roomFound.ClientID,
			Clients:   make(map[*Client]bool),
		}
		roomManager.Rooms[roomID] = room
	}

	room.Clients[client] = true
	client.RoomID = roomID
	log.Printf("Client %s joined room %s", client.ID, roomID)
	return nil
}

// RemoveClientFromRoom removes a client from a room
func RemoveClientFromRoom(client *Client, roomID string) {
	roomManager.Mutex.Lock()
	defer roomManager.Mutex.Unlock()

	if room, exists := roomManager.Rooms[roomID]; exists {
		delete(room.Clients, client)
		if len(room.Clients) == 0 {
			delete(roomManager.Rooms, roomID)
		}
		log.Printf("Client %s left room %s", client.ID, roomID)
	}
}

// BroadcastMessageToRoom sends a message to all clients in the same room
func BroadcastMessageToRoom(message Message) {
	roomManager.Mutex.Lock()
	defer roomManager.Mutex.Unlock()

	if room, exists := roomManager.Rooms[message.RoomID]; exists {
		for client := range room.Clients {
			if err := client.Conn.WriteJSON(message); err != nil {
				log.Println("WriteJSON error:", err)
				client.Conn.Close()
				RemoveClientFromRoom(client, message.RoomID)
			}
		}
	}
}

// ChatWebSocket handles websocket connections for chat
func ChatWebSocket(c *fiber.Ctx) error {
	if websocket.IsWebSocketUpgrade(c) {
		c.Locals("allowed", true)
		return c.Next()
	}
	return fiber.ErrUpgradeRequired
}

// ChatHandler handles websocket connections for chat
func ChatHandler(c *websocket.Conn) {
	client := &Client{
		ID:   c.Params("id"),
		Conn: c,
	}
	roomID := c.Query("roomId") // Assuming roomId is passed as a query parameter

	if err := AddClientToRoom(client, roomID); err != nil {
		log.Println("AddClientToRoom error:", err)
		c.Close()
		return
	}

	defer func() {
		RemoveClientFromRoom(client, roomID)
		client.Conn.Close()
	}()

	for {
		var msg Message
		if err := c.ReadJSON(&msg); err != nil {
			log.Println("ReadJSON error:", err)
			break
		}
		msg.SenderID = client.ID
		msg.RoomID = client.RoomID

		/*
			// Save message to the database
			if err := models.SaveMessage(msg.SenderID, msg.RoomID, msg.Content); err != nil {
				log.Println("SaveMessage error:", err)
			}
		*/

		BroadcastMessageToRoom(msg)
	}
}
