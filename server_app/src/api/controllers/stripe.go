package controllers

import (
	"fmt"
	"os"

	"github.com/gofiber/fiber/v2"
	"github.com/stripe/stripe-go/v72"
	"github.com/stripe/stripe-go/v72/paymentintent"
	"github.com/stripe/stripe-go/v72/webhook"
)

func HandleWebhook(c *fiber.Ctx) error {
	// Limit the request body size

	payload := c.Body()

	// This is your Stripe CLI webhook secret for testing your endpoint locally.
	endpointSecret := "whsec_v5yv9qtQNyQWfH8aatIQW7AdmcwXvRzj"

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
		// Then define and call a function to handle the event payment_intent.succeeded
		fmt.Println("PaymentIntent was successful!")
	default:
		fmt.Fprintf(os.Stderr, "Unhandled event type: %s\n", event.Type)
	}

	return c.Status(fiber.StatusOK).SendString("Event received")
}

func HandleCreatePaymentIntent(c *fiber.Ctx) error {
	stripe.Key = os.Getenv("STRIPE_PRIVATE_KEY")
	// Create a PaymentIntent
	params := &stripe.PaymentIntentParams{
		Amount:   stripe.Int64(1099),
		Currency: stripe.String(string(stripe.CurrencyEUR)),
	}
	pi, err := paymentintent.New(params)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).SendString(err.Error())
	}

	return c.JSON(fiber.Map{
		"client_secret": pi.ClientSecret,
	})

}
