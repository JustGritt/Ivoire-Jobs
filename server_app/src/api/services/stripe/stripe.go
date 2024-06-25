package stripe

import (
	"barassage/api/configs"
	"barassage/api/models/booking"
	"log"

	// Configs
	serviceRepo "barassage/api/repositories/service"

	"github.com/stripe/stripe-go/v72"
	"github.com/stripe/stripe-go/v72/paymentintent"
)

/*
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
*/

func CreatePaymentIntent(booking *booking.Booking) (*stripe.PaymentIntent, error) {
	cfg := configs.GetConfig().Stripe
	stripe.Key = cfg.PrivateKey
	//from the ServiceId, get the service and get the amount
	service, err := serviceRepo.GetByID(booking.ServiceID)
	price := int64(service.Price * 100)
	log.Println("Price: ", price)
	if err != nil {
		return nil, err
	}
	params := &stripe.PaymentIntentParams{
		Amount:   stripe.Int64(price),
		Currency: stripe.String(string(stripe.CurrencyEUR)),
	}
	pi, err := paymentintent.New(params)
	if err != nil {
		return nil, err
	}
	return pi, nil
}
