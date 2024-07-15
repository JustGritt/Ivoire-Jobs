package stripe

import (
	"barassage/api/configs"
	"barassage/api/models/booking"
	"barassage/api/models/user"
	"fmt"
	"log"

	// Configs

	serviceRepo "barassage/api/repositories/service"

	"github.com/stripe/stripe-go/v74"
	"github.com/stripe/stripe-go/v74/account"
	"github.com/stripe/stripe-go/v74/accountlink"
	"github.com/stripe/stripe-go/v74/paymentintent"
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
	price := int64(service.Price)
	log.Println("Price: ", price)
	if err != nil {
		return nil, err
	}

	// Get the stripe account ID of the member
	/*
		member, err := memberRepo.GetByID(booking.CreatorID)
		if err != nil {
			return nil, err
		}
		stripeAccountID := member.StripeAccountID
	*/

	// Create a PaymentIntent
	params := &stripe.PaymentIntentParams{
		Amount:   stripe.Int64(price),
		Currency: stripe.String(string(stripe.CurrencyXOF)),
		/*
			TransferData: &stripe.PaymentIntentTransferDataParams{
				Destination: stripe.String(stripeAccountID),
			},
		*/
		Params: stripe.Params{
			Metadata: map[string]string{
				"booking_id": booking.ID,
			},
		},
	}
	pi, err := paymentintent.New(params)
	if err != nil {
		return nil, err
	}
	return pi, nil
}

func CreateExpressAccount(user *user.User) (*stripe.Account, error) {
	cfg := configs.GetConfig().Stripe
	stripe.Key = cfg.PrivateKey

	// Create an account
	params := &stripe.AccountParams{
		Type:    stripe.String(string(stripe.AccountTypeStandard)),
		Country: stripe.String("CI"),
		Email:   stripe.String(user.Email),
		Individual: &stripe.PersonParams{
			FirstName: stripe.String(user.Firstname),
			LastName:  stripe.String(user.Lastname),
		},
		BusinessType: stripe.String("individual"),
	}

	acct, err := account.New(params)
	if err != nil {
		return nil, fmt.Errorf("failed to create Stripe account: %w", err)
	}

	return acct, nil
}

func GetAccountLink(accountID string) (*stripe.AccountLink, error) {
	params := &stripe.AccountLinkParams{
		Account: stripe.String(accountID),
		Type:    stripe.String("account_onboarding"),
	}

	link, err := accountlink.New(params)
	if err != nil {
		return nil, err
	}

	return link, nil
}
