package notification

import (
	"barassage/api/configs"
	"context"
	"fmt"
	"log"

	"firebase.google.com/go/v4/messaging"
	"github.com/appleboy/go-fcm"
)

var notif *fcm.Client

// InitFCM initializes the FCM client
func InitFCM() *fcm.Client {
	cfg := configs.GetConfig().FCM
	fmt.Println(cfg)
	ctx := context.Background()
	client, err := fcm.NewClient(
		ctx,
		fcm.WithCredentialsFile("./fcm.json"),
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
