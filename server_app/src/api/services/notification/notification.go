package notification

import (
	"barassage/api/configs"
	"barassage/api/models/user"
	notifRepo "barassage/api/repositories/notificationPreference"
	"context"
	"encoding/base64"
	"errors"
	"fmt"
	"log"

	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/messaging"
	"google.golang.org/api/option"
)

// Domain type for notification domains
type Domain string

const (
	ServiceDomain    Domain = "service"
	BookingDomain    Domain = "booking"
	MessageDomain    Domain = "message"
	PushNotification Domain = "push"
)

var notif *messaging.Client

// InitFCM initializes the FCM client
func InitFCM() *messaging.Client {
	cfg := configs.GetConfig().FCM
	ctx := context.Background()

	privateKeyBytes, err := base64.StdEncoding.DecodeString(cfg.PrivateKey)
	if err != nil {
		log.Fatalf("error decoding private key: %v", err)
	}
	privateKey := string(privateKeyBytes)

	credentialsJSON := fmt.Sprintf(`{
		"type": "%s",
		"project_id": "%s",
		"private_key_id": "%s",
		"private_key": "%s",
		"client_email": "%s",
		"client_id": "%s",
		"auth_uri": "%s",
		"token_uri": "%s",
		"auth_provider_x509_cert_url": "%s",
		"client_x509_cert_url": "%s",
		"universe_domain": "%s"
	}`, cfg.Type, cfg.ProjectId, cfg.PrivateId, privateKey, cfg.ClientEmail, cfg.ClientId, cfg.AuthUri, cfg.TokenUri, cfg.AuthProviderX509CertUrl, cfg.ClientX509CertUrl, cfg.UniverseDomain)

	// Initialize Firebase App
	app, err := firebase.NewApp(ctx, nil, option.WithCredentialsJSON([]byte(credentialsJSON)))
	if err != nil {
		log.Fatalf("error initializing Firebase app: %v", err)
	}

	client, err := app.Messaging(ctx)
	if err != nil {
		log.Fatalf("error initializing Firebase Messaging client: %v", err)
	}

	notif = client
	log.Println("FCM client initialized successfully")
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
	case PushNotification:
		if !userNotif.PushNotification {
			return nil, errors.New("PushNotification is false, not sending notification")
		}
	default:
		return nil, fmt.Errorf("unknown domain: %s", domain)
	}

	// Create the Tokens array
	var tokens []string
	for _, token := range user.PushToken {
		tokens = append(tokens, token.Token)
	}

	// Send message using SendEachForMulticast
	responses, err := notif.SendEachForMulticast(ctx, &messaging.MulticastMessage{
		Data: data,
		Android: &messaging.AndroidConfig{
			Priority: "high",
			Notification: &messaging.AndroidNotification{
				Title: "Barassage",
				Body:  data["Body"],
			},
		},
		Tokens: tokens,
		APNS: &messaging.APNSConfig{
			Payload: &messaging.APNSPayload{
				Aps: &messaging.Aps{
					Alert: &messaging.ApsAlert{
						Title: "Barassage",
						Body:  data["Body"],
					},
				},
			},
		},
	})

	if err != nil {
		return nil, fmt.Errorf("error sending message: %w", err)
	}

	// Handle responses
	var successCount, failureCount int
	var failedTokens []string
	for idx, resp := range responses.Responses {
		if resp.Success {
			successCount++
		} else {
			failureCount++
			failedTokens = append(failedTokens, tokens[idx])
			log.Printf("Error sending message to token %s: %v\n", tokens[idx], resp.Error)
		}
	}

	log.Printf("Successfully sent %d messages, failed to send %d messages\n", successCount, failureCount)
	if failureCount > 0 {
		log.Printf("List of tokens that caused failures: %v\n", failedTokens)
	}

	return &messaging.BatchResponse{
		SuccessCount: successCount,
		FailureCount: failureCount,
		Responses:    responses.Responses,
	}, nil
}
