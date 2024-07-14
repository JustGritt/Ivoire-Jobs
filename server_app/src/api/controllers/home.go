package controllers

import (
	userRepo "barassage/api/repositories/user"
	"barassage/api/services/notification"
	"context"
	"log"
	"net/http"

	"github.com/gofiber/fiber/v2"
)

// HomeController godoc
// @Summary Return a welcome message
// @Description Return a welcome message
// @Tags Home
// @Success 200 {object} Response
// @Router /home [get]
func HomeController(c *fiber.Ctx) error {

	//SendNotificationMessage("service", "created")
	//get the user from the context
	user, err := userRepo.GetById("d4e1f48c-8afc-458a-a63b-e08e5ffbae12")
	if err != nil {
		log.Fatalf("error getting user: %v", err)
	}
	domain := notification.ServiceDomain
	resp, err := notification.Send(
		context.TODO(),
		map[string]string{
			"Indexeur": "Le poulet c'est delicieux",
		},
		user,
		domain,
	)
	if err != nil {
		log.Printf("error sending message: %v", err)
		return c.Status(http.StatusInternalServerError).JSON(HTTPResponse(http.StatusInternalServerError, "Error", err.Error()))
	}
	log.Printf("%d messages were sent successfully\n", resp.SuccessCount)
	response := HTTPResponse(http.StatusOK, "Success", "Welcome Home")
	return c.JSON(response)
}
