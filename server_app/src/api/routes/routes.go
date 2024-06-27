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
	auth.Get("/verify-email", ctl.VerifyEmail)
	// Requires authentication
	auth.Get("/me", middlewares.RequireLoggedIn(), ctl.GetMyProfile)

	// Service Group
	service := v1.Group("/service")
	service.Post("/", middlewares.RequireLoggedIn(), ctl.CreateService)
	service.Get("/search", ctl.SearchService)
	service.Get("/collection", ctl.GetAll)
	service.Get("/:id/rating", ctl.GetAllRatingsFromService)
	//service.Get("/collection/user", ctl.GetServiceByUserId)
	service.Get("/:id", ctl.GetServiceById)
	service.Put("/:id", middlewares.RequireLoggedIn(), ctl.UpdateService)
	service.Delete("/:id", middlewares.RequireLoggedIn(), ctl.DeleteService)

	// Booking Group
	booking := v1.Group("/booking")
	booking.Post("/", middlewares.RequireLoggedIn(), ctl.CreateBooking)
	booking.Get("/collection", ctl.GetBookings)
	booking.Put("/:id", middlewares.RequireLoggedIn(), ctl.UpdateBooking)

	// Report Group
	report := v1.Group("/report")
	report.Post("/", middlewares.RequireLoggedIn(), ctl.CreateReport) // Ensure this route is correct
	report.Get("/collection", ctl.GetAllReports)
	report.Put("/:id", ctl.ValidateReport)

	// Category Group
	category := v1.Group("/category")
	category.Get("/collection", ctl.GetAllCategories)
	category.Post("/", middlewares.RequireLoggedIn(), ctl.CreateCategory)

	// Ban Group
	ban := v1.Group("/ban", middlewares.RequireAdmin())
	ban.Post("/", ctl.CreateBan)
	ban.Get("/collection", ctl.GetAllBans)
	ban.Delete("/:id", ctl.DeleteBan)

	// Rating Group
	rating := v1.Group("/rating")
	rating.Post("/", middlewares.RequireLoggedIn(), ctl.CreateRating)
	rating.Get("/collection", middlewares.RequireLoggedIn(), ctl.GetAllRatings)
	rating.Get("/pending", middlewares.RequireAdmin(), ctl.GetPendingRatings)
	rating.Get("/:id", middlewares.RequireAdmin(), ctl.GetRatingByID)
	rating.Put("/:id", middlewares.RequireAdmin(), ctl.ValidateRating)
	rating.Delete("/:id", middlewares.RequireAdmin(), ctl.DeleteRating)

	// User Group
	user := v1.Group("/user")
	user.Get("/:id/service", middlewares.RequireLoggedIn(), ctl.GetServiceByUserId)

	// Member Group
	member := v1.Group("/member", middlewares.RequireLoggedIn())
	member.Post("/", ctl.CreateMember)
	member.Put("/:id/validate", middlewares.RequireAdmin(), ctl.ValidateMember)

}
