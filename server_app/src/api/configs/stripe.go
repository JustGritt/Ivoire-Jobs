package configs

import "os"

// StripeConfig holds the configuration for the Stripe service
type StripeConfig struct {
	PrivateKey string
	PublicKey  string
	WephookKey string
}

// GetStripeConfig returns the Stripe configuration
func GetStripeConfig() StripeConfig {
	return StripeConfig{
		PrivateKey: os.Getenv("STRIPE_PRIVATE_KEY"),
		PublicKey:  os.Getenv("STRIPE_PUBLISHABLE_KEY"),
		WephookKey: os.Getenv("STRIPE_WEBHOOK_SECRET"),
	}
}
