package controllers

import (
	notifRepo "barassage/api/repositories/notificationPreference"
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
	userNotif, err := notifRepo.GetAll()
	if err != nil {
		log.Fatalf("error getting user: %v", err)
	}
	for _, user := range userNotif {
		dbUser, _ := userRepo.GetById(user.UserID)
		fmt.Println(dbUser.Email)
		domain := notification.PushNotification
		resp, err := notification.Send(
			c.Context(),
			map[string]string{
				"title": "Welcome Home",
				"body":  "Welcome Home",
			},
			dbUser,
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
