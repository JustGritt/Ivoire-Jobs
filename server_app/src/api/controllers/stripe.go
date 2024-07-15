package controllers

import (
	cfg "barassage/api/configs"
	bookingRepo "barassage/api/repositories/booking"
	userRepo "barassage/api/repositories/user"
	"barassage/api/services/notification"
	"fmt"
	"log"
	"os"

	"github.com/gofiber/fiber/v2"
	"github.com/stripe/stripe-go/v72/webhook"
)

func HandleWebhook(c *fiber.Ctx) error {
	// Limit the request body size
	cfg.GetStripeConfig()
	endpointSecret := cfg.GetStripeConfig().WebhookKey

	payload := c.Body()

	// Pass the request body and Stripe-Signature header to ConstructEvent, along
	// with the webhook signing key.
	event, err := webhook.ConstructEvent(payload, c.Get("Stripe-Signature"), endpointSecret)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).SendString("Error verifying webhook signature")
	}

	// Unmarshal the event data into an appropriate struct depending on its Type
	switch event.Type {
	case "payment_intent.created":
		fmt.Println("PaymentIntent was created!")
	case "payment_intent.succeeded":
		fmt.Println(event.Data.Object)
		//get the booking ID from the metadata
		bookingID := event.Data.Object["metadata"].(map[string]interface{})["booking_id"].(string)
		if bookingID == "" {
			return c.Status(fiber.StatusBadRequest).SendString("Booking ID not found")
		}
		booking, err := bookingRepo.GetByID(bookingID)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).SendString(err.Error())
		}
		//update the booking status to paid
		booking.Status = "fulfilled"
		err = bookingRepo.Update(booking)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).SendString(err.Error())
		}

		message := map[string]string{
			"Title": "Booking fulfilled",
			"Body":  "Your booking has been fulfilled",
		}

		dbUser, err := userRepo.GetById(booking.UserID)
		if err != nil {
			log.Printf("error getting user: %v", err)
		}

		domain := notification.BookingDomain
		resp, err := notification.Send(c.Context(), message, dbUser, domain)
		if err != nil {
			log.Printf("error sending message: %v", err)
		}
		log.Printf("%d messages were sent successfully\n", resp.SuccessCount)

		// Then define and call a function to handle the event payment_intent.succeeded
		fmt.Println("PaymentIntent was successful!")
	case "payment_intent.canceled":
		fmt.Println("PaymentIntent was canceled!")
		bookingID := event.Data.Object["metadata"].(map[string]interface{})["booking_id"].(string)
		if bookingID == "" {
			return c.Status(fiber.StatusBadRequest).SendString("Booking ID not found")
		}
		booking, err := bookingRepo.GetByID(bookingID)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).SendString(err.Error())
		}
		//update the booking status to paid
		booking.Status = "cancelled"
		err = bookingRepo.Update(booking)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).SendString(err.Error())
		}

		message := map[string]string{
			"Title": "Booking has been cancelled",
			"Body":  "Sorry, your booking has been cancelled please check your payment method and try again",
		}

		dbUser, err := userRepo.GetById(booking.UserID)
		if err != nil {
			log.Printf("error getting user: %v", err)
		}

		domain := notification.BookingDomain
		resp, err := notification.Send(c.Context(), message, dbUser, domain)
		if err != nil {
			log.Printf("error sending message: %v", err)
		}
		log.Printf("%d messages were sent successfully\n", resp.SuccessCount)

	default:
		fmt.Fprintf(os.Stderr, "Unhandled event type: %s\n", event.Type)
	}

	return c.Status(fiber.StatusOK).SendString("Event received")
}
