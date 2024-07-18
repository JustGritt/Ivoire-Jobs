package controllers

import (
	userRepo "barassage/api/repositories/user"
	"barassage/api/services/notification"
	"fmt"
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
	users, err := userRepo.GetAll()
	if err != nil {
		log.Fatalf("error getting user: %v", err)
	}
	for _, user := range users {
		fmt.Println(user.Email)
		domain := notification.ServiceDomain
		resp, err := notification.Send(
			c.Context(),
			map[string]string{
				"title": "Welcome Home",
				"body":  "Welcome Home",
			},
			&user,
			domain,
		)
		if err != nil {
			log.Printf("error sending message: %v", err)
		} else {
			log.Printf("%d messages were sent successfully\n", resp.SuccessCount)
		}
	}
	response := HTTPResponse(http.StatusOK, "Success", "Welcome Home")
	return c.JSON(response)
}
