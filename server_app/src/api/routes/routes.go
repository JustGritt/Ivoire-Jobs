package routes

import (
	// Controllers
	ctl "barassage/api/controllers"
	// Middlewares
	"barassage/api/middlewares"

	"github.com/gofiber/contrib/websocket"

	_ "embed"

	"github.com/gofiber/fiber/v2"
	swagger "github.com/gofiber/swagger"
)

//go:embed index.html
var indexHTML string

// SetupRoutes setups router
func SetupRoutes(app *fiber.App) {

	api := app.Group("/api", middlewares.CheckAppStatus())
	v1 := api.Group("/v1")

	v1.Use("/docs/*", swagger.HandlerDefault)

	// Stripe Webhook
	v1.Post("/stripe/webhook", ctl.HandleWebhook)
	v1.Get("/stripe/create-payment-intent", ctl.HandleCreatePaymentIntent) // TODO remove after hadnling properly in booking.go

	v1.Get("/home", ctl.HomeController)

	// Auth Group
	auth := v1.Group("/auth")
	auth.Post("/register", ctl.Register)
	auth.Post("/login", ctl.Login)
	auth.Post("/admin-login", ctl.AdminLogin)
	auth.Post("/logout", ctl.Logout)
	auth.Post("/refresh", ctl.RefreshAuth)
	auth.Get("/verify-email", ctl.VerifyEmail)
	auth.Get("/me", middlewares.RequireLoggedIn(), ctl.GetMyProfile)
	auth.Put("/update-profile", middlewares.RequireLoggedIn(), ctl.UpdateProfile)
	auth.Patch("/update-token", middlewares.RequireLoggedIn(), ctl.PatchToken)
	auth.Get("/users", middlewares.RequireAdmin(), ctl.GetAllUsers)
	auth.Get("/admin", middlewares.RequireAdmin(), ctl.GetAllUsers)

	// Contact Group
	contact := v1.Group("/contact")
	contact.Post("/create", middlewares.RequireLoggedIn(), ctl.AddContactInfo) //TODO this is maybe not needed

	// Service Group
	service := v1.Group("/service")
	service.Get("/search", ctl.SearchService)
	service.Get("/trending", ctl.GetTrendingServices)
	service.Get("/collection", ctl.GetAll)
	service.Get("/bans", ctl.GetAllBannedServices)
	service.Get("/:id/rating", ctl.GetAllRatingsFromService)
	service.Get("/:id", ctl.GetServiceById)
	service.Get("/:id/room", middlewares.RequireLoggedIn(), ctl.CreateOrGetRoom)
	service.Post("/", middlewares.RequireLoggedIn(), ctl.CreateService)
	service.Put("/:id", middlewares.RequireLoggedIn(), ctl.UpdateService)
	service.Delete("/:id", middlewares.RequireLoggedIn(), ctl.DeleteService)

	// Booking Group
	booking := v1.Group("/booking")
	booking.Get("/collection", middlewares.RequireLoggedIn(), ctl.GetBookings)
	booking.Post("/", middlewares.RequireLoggedIn(), ctl.CreateBooking)
	booking.Put("/:id", middlewares.RequireLoggedIn(), ctl.UpdateBooking)

	// Report Group
	report := v1.Group("/report")
	report.Get("/collection", middlewares.RequireAdmin(), ctl.GetAllReports)
	report.Get("/pending", middlewares.RequireAdmin(), ctl.GetAllPendingReports)
	report.Put("/:id", middlewares.RequireAdmin(), ctl.ValidateReport)
	report.Post("/", middlewares.RequireLoggedIn(), ctl.CreateReport)

	// Category Group
	category := v1.Group("/category")
	category.Get("/collection", ctl.GetAllCategories)
	category.Post("/", middlewares.RequireLoggedIn(), ctl.CreateCategory)

	// Ban Group ONLY FOR ADMIN
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
	user.Get("/member/status", middlewares.RequireLoggedIn(), ctl.GetUserMemberStatus)

	// Member Group
	member := v1.Group("/member", middlewares.RequireLoggedIn())
	member.Post("/", ctl.CreateMember)
	member.Put("/:id/validate", middlewares.RequireAdmin(), ctl.ValidateMember)
	member.Get("/pending", middlewares.RequireAdmin(), ctl.GetAllPendingRequests)

	// Configuration Group ONLY FOR ADMIN
	configuration := v1.Group("/configuration", middlewares.RequireAdmin())
	configuration.Post("/", ctl.CreateConfiguration)
	configuration.Get("/:key", ctl.GetConfigurationByKey)
	configuration.Put("/:key", ctl.UpdateConfiguration)

	//notification-preferences
	notification := v1.Group("/notification-preference", middlewares.RequireLoggedIn())
	notification.Put("/", ctl.CreateOrUpdateNotificationPreference)

	// Room Group
	room := v1.Group("/room")
	room.Get("/:id/ws", websocket.New(ctl.HandleWebSocket)) // Add this line

	// Serve the embedded HTML file at /test
	app.Get("/test", func(c *fiber.Ctx) error {
		return c.Type("html").SendString(indexHTML)
	})
}
