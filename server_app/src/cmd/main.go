package main

import (
	"fmt"

	// Configs
	cfg "barassage/api/configs"

	// models

	"barassage/api/models/ban"
	"barassage/api/models/booking"
	"barassage/api/models/category"
	"barassage/api/models/configuration"
	"barassage/api/models/contact"
	im "barassage/api/models/image"
	myLog "barassage/api/models/log"
	"barassage/api/models/member"
	"barassage/api/models/message"
	"barassage/api/models/notificationPreference"
	"barassage/api/models/pushToken"
	"barassage/api/models/rating"
	refreshtoken "barassage/api/models/refreshToken"
	"barassage/api/models/report"
	"barassage/api/models/room"
	"barassage/api/models/service"
	myUser "barassage/api/models/user"

	// database
	db "barassage/api/database"
)

func main() {

	// load config
	cfg.LoadConfig()

	// Connect to Postgres
	db.ConnectPostgres()

	// Drop all tables
	//drop the many2many table first
	db.PgDB.Migrator().DropTable(
		&myUser.User{},
		"service_categories",
		&category.Category{},
		&service.Service{},
		&booking.Booking{},
		&im.Image{},
		&report.Report{},
		&ban.Ban{},
		&rating.Rating{},
		&member.Member{},
		&pushToken.PushToken{},
		&configuration.Configuration{},
		&notificationPreference.NotificationPreference{},
		&room.Room{},
		&message.Message{},
		&refreshtoken.RefreshToken{},
		&contact.Contact{},
		&member.Member{},
		&pushToken.PushToken{},
		&configuration.Configuration{},
		&notificationPreference.NotificationPreference{},
		&room.Room{},
		&message.Message{},
		&refreshtoken.RefreshToken{},
		&myLog.Log{},
	)

	// Migration
	db.PgDB.AutoMigrate(
		&myUser.User{},
		&category.Category{},
		&service.Service{},
		&booking.Booking{},
		&im.Image{},
		&report.Report{},
		&ban.Ban{},
		&rating.Rating{},
		&member.Member{},
		&pushToken.PushToken{},
		&configuration.Configuration{},
		&notificationPreference.NotificationPreference{},
		&room.Room{},
		&message.Message{},
		&refreshtoken.RefreshToken{},
		&contact.Contact{},
		&member.Member{},
		&pushToken.PushToken{},
		&configuration.Configuration{},
		&notificationPreference.NotificationPreference{},
		&room.Room{},
		&message.Message{},
		&refreshtoken.RefreshToken{},
		&myLog.Log{},
	)

	// Seed the database
	db.SeedDatabase(db.PgDB)
	fmt.Println("Database seeding completed.")
}
