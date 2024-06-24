package routes

import (
	// Controllers
	ctl "barassage/api/controllers"
	// Middlewares
	"barassage/api/middlewares"

	"github.com/gofiber/fiber/v2"
	swagger "github.com/gofiber/swagger"
)

// SetupRoutes setups router
func SetupRoutes(app *fiber.App) {

	api := app.Group("/api")
	v1 := api.Group("/v1")

	v1.Use("/docs/*", swagger.HandlerDefault)

	/*
		v1.Get("/", func(c *fiber.Ctx) error {
			return c.JSON(fiber.Map{
				"message": "Welcome to Barassage private API",
			})
		})

		// Websocket
		ws := v1.Group("/ws")

		ws.Use(func(c *fiber.Ctx) error {
			if websocket.IsWebSocketUpgrade(c) {
				c.Locals("allowed", true)
				return c.Next()
			}
			return fiber.ErrUpgradeRequired
		})

		ws.Get("/:id", websocket.New(ctl.ChatHandler))
	*/

	// Stripe Webhook
	v1.Post("/stripe/webhook", ctl.HandleWebhook)
	v1.Get("/stripe/create-payment-intent", ctl.HandleCreatePaymentIntent)

	v1.Get("/home", ctl.HomeController)

	// Auth Group
	auth := v1.Group("/auth")
	auth.Post("/register", ctl.Register)
	auth.Post("/login", ctl.Login)
	auth.Post("/logout", ctl.Logout)
	auth.Post("/refresh", ctl.RefreshAuth)
	auth.Get("/auth/verify-email", ctl.VerifyEmail)
	// Requires authentication
	auth.Get("/me", middlewares.RequireLoggedIn(), ctl.GetMyProfile)

	// Service Group
	service := v1.Group("/service")
	service.Post("/", middlewares.RequireLoggedIn(), ctl.CreateService)
	service.Get("/search", ctl.SearchService)
	service.Get("/collection", ctl.GetAll)
	service.Get("/collection/user", ctl.GetServiceByUserId)
	service.Get("/:id", ctl.GetServiceById)
	service.Put("/:id", middlewares.RequireLoggedIn(), ctl.UpdateService)
	service.Delete("/:id", middlewares.RequireLoggedIn(), ctl.DeleteService)

	// Booking Group
	booking := v1.Group("/booking")
	booking.Post("/", middlewares.RequireLoggedIn(), ctl.CreateBooking)
	booking.Get("/collection", ctl.GetBookings)
	booking.Put("/:id", middlewares.RequireLoggedIn(), ctl.UpdateBooking)

	// Reports
	report := v1.Group("/report")
	report.Post("/:id", middlewares.RequireLoggedIn(), ctl.CreateReport)
	report.Get("/collection", ctl.GetAllReports)

}
