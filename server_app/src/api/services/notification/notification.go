package notification

import (
	"context"
	"log"

	"firebase.google.com/go/v4/messaging"
	"github.com/appleboy/go-fcm"
)

var notif *fcm.Client

// InitFCM initializes the FCM client
func InitFCM() *fcm.Client {
	ctx := context.Background()
	client, err := fcm.NewClient(
		ctx,
		fcm.WithCredentialsFile("./google-services.json"),
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
