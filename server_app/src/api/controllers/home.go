package controllers

import (
	"context"
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
	token := "dZGeqepVHk0pr25DTN6EY4:APA91bHLgtqodZI_8jQ5tuE6SY5rQGeGFMORpVW6I1nre2e5K9kImjyHn4FOrbJ3RWPxDThwwOR7Tgku-1QMAZ-VsnNPy45I7y2WuV_o1fK__DGCxm8PBxs6RWJwsG6AvH64Urdot1ME"
	resp, err := notification.Send(
		context.TODO(),
		&messaging.Message{
			Token: token,
			Data: map[string]string{
				"Indexeur": "Le poulet c'est delicieux",
			},
		},
	)
	if err != nil {
		log.Fatalf("error sending message: %v", err)
	}
	log.Println("success count:", resp.SuccessCount)
	log.Println("failure count:", resp.FailureCount)
	log.Println("message id:", resp.Responses[0].MessageID)
	log.Println("error msg:", resp.Responses[0].Error)

	response := HTTPResponse(http.StatusOK, "Success", "Welcome Home")
	return c.JSON(response)
}
