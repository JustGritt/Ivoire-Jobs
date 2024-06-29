package controllers

import (
	"log"
	"net/http"

	"barassage/api/services/notification"

	"firebase.google.com/go/v4/messaging"
	"github.com/gofiber/fiber/v2"
)

// HomeController godoc
// @Summary Return a welcome message
// @Description Return a welcome message
// @Tags Home
// @Success 200 {object} Response
// @Router /home [get]
func HomeController(c *fiber.Ctx) error {

	// Send to a single device
	token := "test"
	resp, err := notification.Send(
		c.Context(),
		&messaging.Message{
			Token: token,
			Data: map[string]string{
				"foo": "bar",
			},
		},
	)
	if err != nil {
		log.Fatal(err)
	}
	log.Printf("Successfully sent message: %v", resp)
	response := HTTPResponse(http.StatusOK, "Success", "Welcome Home")
	return c.JSON(response)
}
