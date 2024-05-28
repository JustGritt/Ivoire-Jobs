package controllers

import (
	mail "barassage/api/mailer"
	"fmt"

	"github.com/gofiber/fiber/v2"
)

func SendMail(c *fiber.Ctx) error {
	to := "charles258@hotmail.fr"
	subject := "Reset your password"
	data := map[string]interface{}{
		"action_url": "https://www.google.com",
		"email":      to,
	}

	// Send the email
	response, err := mail.SendEmail("welcome", to, subject, data)
	if err != nil {
		fmt.Printf("Error sending email: %v\n", err)
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Error sending email",
		})
	}

	// Log the response for debugging
	fmt.Printf("Email send response: %+v\n", response)

	return c.SendString("Reset Password Email Sent")
}
