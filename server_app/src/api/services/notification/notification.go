package notification

import (
	"barassage/api/configs"
	"barassage/api/models/user"
	notifRepo "barassage/api/repositories/notificationPreference"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"log"

	"firebase.google.com/go/v4/messaging"
	"github.com/appleboy/go-fcm"
)

var notif *fcm.Client

// Domain type for notification domains
type Domain string

const (
	ServiceDomain Domain = "service"
	BookingDomain Domain = "booking"
	MessageDomain Domain = "message"
)

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

func Send(ctx context.Context, data map[string]string, user *user.User, domain Domain) (*messaging.BatchResponse, error) {
	if notif == nil {
		return nil, errors.New("FCM client not initialized")
	}
	if user == nil {
		return nil, errors.New("user is nil")
	}
	userNotif, err := notifRepo.GetByUserID(user.ID)
	if err != nil {
		if err.Error() == "record not found" {
			return nil, fmt.Errorf("user notification preference not found for user: %w", err)
		}
		return nil, fmt.Errorf("error fetching user notification preferences: %w", err)
	}
	if userNotif == nil {
		return nil, errors.New("user notification preference is nil")
	}

	// Check the user preference for notification
	if !userNotif.PushNotification {
		return nil, errors.New("PushNotification is false, not sending notification")
	}

	switch domain {
	case ServiceDomain:
		if !userNotif.ServiceNotification {
			return nil, errors.New("ServiceNotification is false, not sending notification")
		}
	case BookingDomain:
		if !userNotif.BookingNotification {
			return nil, errors.New("BookingNotification is false, not sending notification")
		}
	case MessageDomain:
		if !userNotif.MessageNotification {
			return nil, errors.New("MessageNotification is false, not sending notification")
		}
	default:
		return nil, fmt.Errorf("unknown domain: %s", domain)
	}

	//create the Tokens array
	var tokens []string
	for _, token := range user.PushToken {
		tokens = append(tokens, token.Token)
	}

	message := &messaging.MulticastMessage{
		Data:   data,
		Tokens: tokens,
	}

	res, err := notif.SendMulticast(ctx, message)
	if err != nil {
		return nil, fmt.Errorf("error sending message: %w", err)
	}
	// Handle failed tokens
	if res.FailureCount > 0 {
		var failedTokens []string
		for idx, resp := range res.Responses {
			if !resp.Success {
				// The order of responses corresponds to the order of the registration tokens.
				failedTokens = append(failedTokens, tokens[idx])
			}
		}
		log.Printf("List of tokens that caused failures: %v\n", failedTokens)
	}

	return res, nil
}
