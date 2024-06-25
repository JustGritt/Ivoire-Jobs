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

	v1.Get("/", func(c *fiber.Ctx) error {
		return c.JSON(fiber.Map{
			"message": "Welcome to Barassage private API",
		})
	})

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
	service.Get("/collection", ctl.GetAll)
	service.Get("/collection/user", ctl.GetServiceByUserId)
	service.Get("/:id", ctl.GetServiceById)
	service.Put("/:id", middlewares.RequireLoggedIn(), ctl.UpdateService)
	service.Delete("/:id", middlewares.RequireLoggedIn(), ctl.DeleteService)

	// Reports Group
	report := v1.Group("/report")
	report.Post("/", middlewares.RequireLoggedIn(), ctl.CreateReport) // Ensure this route is correct
	report.Get("/collection", ctl.GetAllReports)
	report.Put("/:id", ctl.ValidateReport)

}
