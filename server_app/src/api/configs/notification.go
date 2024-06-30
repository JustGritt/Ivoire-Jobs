package configs

import "os"

// FcmNotifcationConfig holds the configuration for the Stripe service
type FCMConfig struct {
	Type                    string
	ProjectId               string
	PrivateId               string
	PrivateKey              string
	ClientEmail             string
	ClientId                string
	AuthUri                 string
	TokenUri                string
	AuthProviderX509CertUrl string
	ClientX509CertUrl       string
	UniverseDomain          string
}

// GetFCMConfig returns the Stripe configuration
func GetFCMConfig() FCMConfig {
	return FCMConfig{
		Type:                    os.Getenv("FCM_TYPE"),
		ProjectId:               os.Getenv("FCM_PROJECT_ID"),
		PrivateId:               os.Getenv("FCM_PRIVATE_KEY_ID"),
		PrivateKey:              os.Getenv("FCM_PRIVATE_KEY"),
		ClientEmail:             os.Getenv("FCM_CLIENT_EMAIL"),
		ClientId:                os.Getenv("FCM_CLIENT_ID"),
		AuthUri:                 os.Getenv("FCM_AUTH_URI"),
		TokenUri:                os.Getenv("FCM_TOKEN_URI"),
		AuthProviderX509CertUrl: os.Getenv("FCM_AUTH_PROVIDER_X509_CERT_URL"),
		ClientX509CertUrl:       os.Getenv("FCM_CLIENT_X509_CERT_URL"),
		UniverseDomain:          os.Getenv("FCM_UNIVERSE_DOMAIN"),
	}
}
