package app

import (
	"fmt"
	"log"

	// Configs
	cfg "barassage/api/configs"
	"barassage/api/services/bucket"

	// Swagger
	docs "barassage/api/docs" // Swagger Docs

	// routes
	"barassage/api/routes"

	// database
	db "barassage/api/database"

	//mailer
	mail "barassage/api/services/mailer"

	//fcm notification
	notif "barassage/api/services/notification"

	// models
	"barassage/api/models/ban"
	"barassage/api/models/booking"
	"barassage/api/models/category"
	"barassage/api/models/configuration"
	"barassage/api/models/image"
	"barassage/api/models/member"
	"barassage/api/models/pushToken"
	"barassage/api/models/rating"
	"barassage/api/models/report"
	"barassage/api/models/service"
	"barassage/api/models/user"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/gofiber/fiber/v2/middleware/recover"
)

// Run starts the app
// @title Barassage API
// @version 1.0
// @description This is the Barassage API
// @termsOfService http://swagger.io/terms/
// @contact.name barassage
// @license.name MIT
// @BasePath /api/v1
// @schemes http https
// @securityDefinitions.apikey Bearer
// @in header
// @name Authorization
// @description Type "Bearer" followed by a space and JWT token.
func Run() {
	app := fiber.New(fiber.Config{
		ServerHeader:      "Fiber",
		StreamRequestBody: true,
		TrustedProxies:    []string{"*"},
	})

	/*
		====== Setup Configs ============
	*/

	cfg.LoadConfig()
	config := cfg.GetConfig()

	/*
		====== Setup DB ============
	*/

	// Connect to Postgres
	db.ConnectPostgres()

	// Migration
	db.PgDB.AutoMigrate(
		&user.User{},
		&service.Service{},
		&booking.Booking{},
		&image.Image{},
		&report.Report{},
		&category.Category{},
		&ban.Ban{},
		&rating.Rating{},
		&member.Member{},
		&pushToken.PushToken{},
		&configuration.Configuration{},
	)

	/*
		============ Set Up Utils ============
	*/

	// Mailer
	mail.InitMailer()

	// S3
	bucket.InitS3Manager()

	// FCM notification
	notif.InitFCM()

	/*
		============ Set Up Middlewares ============
	*/

	// Default Log Middleware
	app.Use(logger.New())

	// Recovery Middleware
	app.Use(recover.New())

	// cors
	app.Use(cors.New(cors.Config{
		AllowOrigins: "*",
		AllowHeaders: "Origin, Content-Type, Accept, Authorization, Access-Control-Allow-Origin, Access-Control-Allow-Methods",
		AllowMethods: "GET, POST, PUT, PATCH, HEAD, DELETE, OPTIONS",
	}))


	/*
		============ Set Up Routes ============
	*/
	routes.SetupRoutes(app)

	/*
		============ Setup Swagger ===============
	*/

	// FIXME, In Production, Port Should not be added to the Swagger Host
	if config.Host == "localhost" {
		docs.SwaggerInfo.Host = config.Host + ":" + config.Port
	} else {
		docs.SwaggerInfo.Host = config.Host
	}

	// Run the app and listen on given port
	port := fmt.Sprintf(":%s", config.Port)
	//app.Listen(port)
	if err := app.Listen(port); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}
