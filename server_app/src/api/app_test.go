// /api/app_test.go

package app

import (
	"barassage/api/database"
	"barassage/api/routes"
	"io"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/DATA-DOG/go-sqlmock"
	"github.com/gofiber/fiber/v2"
	"github.com/stretchr/testify/assert"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

// Setup function to initialize the app with routes and middlewares
func setupApp() *fiber.App {
	app := fiber.New(fiber.Config{
		ServerHeader:      "Fiber",
		StreamRequestBody: true,
		TrustedProxies:    []string{"*"},
	})

	// Setup middlewares
	app.Use(func(c *fiber.Ctx) error {
		return c.Next()
	})

	// Setup routes
	routes.SetupRoutes(app)
	return app
}

// SetupTestDatabase initializes a mock database
func setupTestDatabase() (*gorm.DB, sqlmock.Sqlmock, error) {
	db, mock, err := sqlmock.New()
	if err != nil {
		return nil, nil, err
	}

	gormDB, err := gorm.Open(postgres.New(postgres.Config{
		Conn: db,
	}), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Silent),
	})
	if err != nil {
		return nil, nil, err
	}

	return gormDB, mock, nil
}

// TestMain sets up the necessary configurations for tests
func TestMain(m *testing.M) {
	// Setup mock database
	db, mock, err := setupTestDatabase()
	if err != nil {
		panic(err)
	}
	database.PgDB = db
	defer mock.ExpectClose()

	// Run tests
	m.Run()
}

func TestGetEndpoint(t *testing.T) {
	app := setupApp()

	req := httptest.NewRequest("GET", "/api/v1/home", nil)
	resp, err := app.Test(req)

	//show the app url
	t.Log(req.Host)
	assert.NoError(t, err)
	assert.Equal(t, 200, resp.StatusCode)
}

func TestPostEndpoint(t *testing.T) {
	app := setupApp()

	body := `{"key":"value"}`
	req := httptest.NewRequest("POST", "/your_post_endpoint", strings.NewReader(body))
	req.Header.Set("Content-Type", "application/json")

	resp, err := app.Test(req)

	assert.NoError(t, err)
	assert.Equal(t, 201, resp.StatusCode)

	bodyBytes, err := io.ReadAll(resp.Body)
	assert.NoError(t, err)
	assert.JSONEq(t, `{"key":"value"}`, string(bodyBytes))
}

func TestInvalidRoute(t *testing.T) {
	app := setupApp()

	req := httptest.NewRequest("GET", "/invalid_route", nil)
	resp, err := app.Test(req)

	assert.NoError(t, err)
	assert.Equal(t, 404, resp.StatusCode)
}

func TestMiddleware(t *testing.T) {
	app := setupApp()

	req := httptest.NewRequest("GET", "/your_endpoint", nil)
	req.Header.Set("X-Test-Header", "test")
	resp, err := app.Test(req)

	assert.NoError(t, err)
	assert.Equal(t, 200, resp.StatusCode)
	assert.Equal(t, "test", req.Header.Get("X-Test-Header"))
}
