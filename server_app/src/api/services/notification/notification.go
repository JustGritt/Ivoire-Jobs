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
	"os"

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

	fmt.Println(cfg.PrivateKey)

	// Marshal the credentials map to JSON
	credentialsJSON, err := json.Marshal(credentials)
	if err != nil {
		log.Fatalf("error marshaling credentials: %v", err)
	}

	// Write the JSON credentials to a temporary file
	tempFile, err := os.CreateTemp("", "serviceAccountKey-.json")
	if err != nil {
		log.Fatalf("error creating temp file: %v", err)
	}
	defer tempFile.Close()

	_, err = tempFile.Write(credentialsJSON)
	if err != nil {
		log.Fatalf("error writing to temp file: %v", err)
	}

	// Initialize Firebase App
	app, err := firebase.NewApp(ctx, nil, option.WithCredentialsFile(tempFile.Name()))
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
				Body:  "You have a new notification",
			},
		},
		Tokens: tokens,
		APNS: &messaging.APNSConfig{
			Payload: &messaging.APNSPayload{
				Aps: &messaging.Aps{
					Alert: &messaging.ApsAlert{
						Title: "Barassage",
						Body:  "You have a new notification",
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
