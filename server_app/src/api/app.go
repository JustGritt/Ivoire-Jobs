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

	// models
	"barassage/api/models/report"
	"barassage/api/models/booking"
	"barassage/api/models/image"
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

	// Drop on serve restarts in dev
	//db.PgDB.Migrator().DropTable(&user.User{}, &report.Report{}, &service.Service{})

	// Seeder
	db.SeedDatabase(db.PgDB)

	// Migration
	db.PgDB.AutoMigrate(&user.User{}, &service.Service{}, &booking.Booking{}, &image.Image{}, &report.Report{})

	/*
		============ Set Up Utils ============
	*/

	// Mailer
	mail.InitMailer()

	// S3
	bucket.InitS3Manager()

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
		AllowHeaders: "Origin, Content-Type, Accept",
	}))

	/*
		============ Set Up Routes ============
	*/
	routes.SetupRoutes(app)
	app.Use(cors.New())
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
