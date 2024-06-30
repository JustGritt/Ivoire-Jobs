package notification

import (
	"barassage/api/configs"
	"context"
	"encoding/json"
	"log"

	"firebase.google.com/go/v4/messaging"
	"github.com/appleboy/go-fcm"
)

var notif *fcm.Client

// InitFCM initializes the FCM client
func InitFCM() *fcm.Client {
	cfg := configs.GetConfig().FCM
	ctx := context.Background()
	credentials := map[string]string{
		"type":                        cfg.Type,
		"project_id":                  cfg.ProjectId,
		"private_key_id":              cfg.PrivateId,
		"private_key":                 cfg.PrivateKey,
		"client_email":                cfg.ClientEmail,
		"client_id":                   cfg.ClientId,
		"auth_uri":                    cfg.AuthUri,
		"token_uri":                   cfg.TokenUri,
		"auth_provider_x509_cert_url": cfg.AuthProviderX509CertUrl,
		"client_x509_cert_url":        cfg.ClientX509CertUrl,
		"universe_domain":             cfg.UniverseDomain,
	}

	// Marshal the credentials map to JSON
	credentialsJSON, err := json.Marshal(credentials)
	if err != nil {
		log.Fatalf("error marshaling credentials: %v", err)
	}

	client, err := fcm.NewClient(
		ctx,
		fcm.WithCredentialsJSON(credentialsJSON),
	)

	if err != nil {
		log.Fatalf("error initializing FCM client: %v", err)
	}
	notif = client
	return notif
}

func Send(ctx context.Context, message *messaging.Message) (*messaging.BatchResponse, error) {
	if notif == nil {
		log.Println("FCM client not initialized")
		return nil, nil
	}
	return notif.Send(ctx, message)
}
