package controllers

import (
	"encoding/json"
	"time"

	"github.com/gofiber/contrib/websocket"
)

type NotificationManager struct {
	clients      map[*websocket.Conn]bool
	addClient    chan *websocket.Conn
	removeClient chan *websocket.Conn
	broadcast    chan NotificationMessage
	countClients chan chan int
}

type NotificationMessage struct {
	Topic   string `json:"topic"`
	Message string `json:"message"`
}

var manager = NotificationManager{
	clients:      make(map[*websocket.Conn]bool),
	addClient:    make(chan *websocket.Conn),
	removeClient: make(chan *websocket.Conn),
	broadcast:    make(chan NotificationMessage),
	countClients: make(chan chan int),
}

// Start the notification manager to handle clients and messages
func (manager *NotificationManager) start() {
	for {
		select {
		case conn := <-manager.addClient:
			manager.clients[conn] = true
		case conn := <-manager.removeClient:
			if _, ok := manager.clients[conn]; ok {
				delete(manager.clients, conn)
				conn.Close()
			}
		case message := <-manager.broadcast:
			messageJSON, _ := json.Marshal(message)
			for conn := range manager.clients {
				if err := conn.WriteMessage(websocket.TextMessage, messageJSON); err != nil {
					conn.Close()
					delete(manager.clients, conn)
				}
			}
		case reply := <-manager.countClients:
			reply <- len(manager.clients)
		}
	}
}

// HandleNotificationsWebSocket manages WebSocket connections for notifications
func HandleNotificationsWebSocket(c *websocket.Conn) {
	defer func() {
		manager.removeClient <- c
	}()

	c.SetReadDeadline(time.Now().Add(pongWait))
	c.SetPongHandler(func(string) error {
		c.SetReadDeadline(time.Now().Add(pongWait))
		return nil
	})

	ticker := time.NewTicker(pingPeriod)
	defer ticker.Stop()
	go func() {
		for {
			<-ticker.C
			if err := c.WriteMessage(websocket.PingMessage, nil); err != nil {
				return
			}
		}
	}()

	manager.addClient <- c

	for {
		_, _, err := c.ReadMessage()
		if err != nil {
			break
		}
	}
}

// SendNotificationMessage broadcasts a message to all connected clients
func SendNotificationMessage(topic, message string) {
	manager.broadcast <- NotificationMessage{
		Topic:   topic,
		Message: message,
	}
}

// GetClientCount returns the number of currently connected clients
func GetClientCount() int {
	reply := make(chan int)
	manager.countClients <- reply
	return <-reply
}

func init() {
	go manager.start()
}
