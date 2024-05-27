package main

import (
	"github.com/JustGritt/Ivoire-Jobs/database"
	_ "github.com/JustGritt/Ivoire-Jobs/docs"
	"github.com/JustGritt/Ivoire-Jobs/routes"
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/gofiber/fiber/v2/middleware/monitor"
	jwtware "github.com/gofiber/jwt/v3"
	"github.com/gofiber/swagger"
	"github.com/golang-jwt/jwt/v4"
)

const (
	apiKey = "my-super-secret-key"
)

func restricted(c *fiber.Ctx) error {
	user, ok := c.Locals("user").(*jwt.Token)
	if !ok {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"message": "Unauthorized"})
	}

	claims, ok := user.Claims.(jwt.MapClaims)
	if !ok {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"message": "Unauthorized"})
	}

	id, ok := claims["user_id"].(float64)
	if !ok {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"message": "Unauthorized"})
	}

	param, err := c.ParamsInt("id")
	if err != nil || int(id) != param {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"message": "Unauthorized"})
	}

	return c.Next()
}

func setupRoutes(app *fiber.App) {
	app.Get("/swagger/*", swagger.HandlerDefault)

	app.Get("/metrics", monitor.New())

	// Login route
	app.Post("/api/login", routes.Login)
	app.Post("/api/users", routes.CreateUser)
	app.Get("/api/users", routes.GetUsers)

	app.Use(jwtware.New(jwtware.Config{
		ErrorHandler: func(c *fiber.Ctx, err error) error {
			// Token is missing, returns with error code 400 "Missing or malformed JWT"
			return c.Status(400).JSON(fiber.Map{
				"message": "Missing or malformed JWT",
			})
		},
		SigningKey: []byte("secret"),
	}))

	app.Get("/api/users/:id", restricted, routes.GetUser)

	// Restricted Routes
	//app.Get("/restricted")
}

// @title Fiber API - Ivoire Job
// @version 1.0
// @description This is a sample swagger for Fiber
// @termsOfService http://swagger.io/terms/
// @contact.name API Support
// @contact.email fiber@swagger.io
// @license.name Apache 2.0
// @license.url http://www.apache.org/licenses/LICENSE-2.0.html
// @host fuzzy-space-guacamole-4vgqq7x6qw9fqjx6-3000.app.github.dev
// @securityDefinitions.apikey BearerAuth
// @in header
// @name Authorization
// @BasePath /
func main() {
	database.Connect()
	app := fiber.New()
	//app.Use(cors.New())
	app.Use(logger.New())
	app.Use(logger.New(logger.Config{
		Format: "[${ip}]:${port} ${status} - ${method} ${path}\n",
	}))

	setupRoutes(app)

	app.Listen(":3000")
}
