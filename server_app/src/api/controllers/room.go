package controllers

import (
	"barassage/api/models/room"
	"fmt"

	roomRepo "barassage/api/repositories/room"
	serviceRepo "barassage/api/repositories/service"

	"net/http"

	"github.com/gofiber/fiber/v2"
	jwt "github.com/golang-jwt/jwt/v4"
)

type RoomObject struct {
	ClientID  string `json:"-"`
	CreatorID string `json:"-"`
	ServiceID string `json:"service_id" validate:"required"`
}

type RoomOutput struct {
	ID       string    `json:"id"`
	Messages []Message `json:"messages"`
}

type Message struct {
	SenderID   string `json:"sender_id"`
	ReceiverID string `json:"receiver_id"`
	Content    string `json:"content"`
	CreatedAt  string `json:"created_at"`
}

// CreateOrGetRoom handles the creation of a new room or get an existing room
// @Summary CreateOrGetRoom
// @Description Create a room or get an existing room
// @Tags Room
// @Produce json
// @Param payload body RoomObject true "CreateOrGetRoom Body"
// @Success 201 {object} Response
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /service/{id}/room [get]
func CreateOrGetRoom(c *fiber.Ctx) error {
	var roomInput RoomObject
	var errorList []*fiber.Error
	user := c.Locals("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)
	userID := claims["userID"]

	if userID == nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "Can't extract user info from request",
			},
		)
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	//get the service id from the url

	serviceID := c.Params("id")
	if serviceID == "" {
		errorList = append(errorList, &fiber.Error{
			Code:    fiber.StatusBadRequest,
			Message: "Service ID is required",
		})
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	// retrive the service
	service, err := serviceRepo.GetByID(serviceID)
	if err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    fiber.StatusBadRequest,
			Message: "Service not found",
		})
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	if service.UserID == userID {
		errorList = append(errorList, &fiber.Error{
			Code:    fiber.StatusBadRequest,
			Message: "Cannot create room with yourself",
		})
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	roomInput.ClientID = userID.(string)
	roomInput.CreatorID = service.UserID
	roomInput.ServiceID = serviceID

	//map the input to room object
	roomInputMapped := mapInputToRoomObject(roomInput)

	// Create or get the room
	room, err := roomRepo.CreateOrGetRoom(roomInputMapped)
	if err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    fiber.StatusInternalServerError,
			Message: "Failed to create room",
		})
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	_ = CreateLog(&LogObject{
		Level:      "info",
		Type:       "Room",
		Message:    fmt.Sprintf("Room created with ID: %s", room.ID),
	})

	roomOutput := mapRoomToOutput(*room)
	return c.Status(http.StatusCreated).JSON(HTTPResponse(http.StatusCreated, "Room", roomOutput))

}

// ============================================================
// =================== Private Methods ========================
// ============================================================

func mapInputToRoomObject(input RoomObject) room.Room {
	return room.Room{
		ServiceID: input.ServiceID,
		CreatorID: input.CreatorID,
		ClientID:  input.ClientID,
	}
}

func mapRoomToOutput(room room.Room) RoomOutput {
	var messages []Message
	//there is no message please return empty array
	if len(room.Messages) == 0 {
		messages = []Message{}
	} else {
		for _, m := range room.Messages {
			messages = append(messages, Message{
				SenderID:   m.SenderID,
				ReceiverID: m.ReceiverID,
				Content:    m.Content,
				CreatedAt:  m.CreatedAt.Format("2006-01-02 15:04:05"),
			})
		}
	}
	return RoomOutput{
		ID:       room.ID,
		Messages: messages,
	}
}
