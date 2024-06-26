package middlewares

import (
	"fmt"
	"net/http"

	cfg "barassage/api/configs"

	jwtware "github.com/gofiber/jwt/v2"
	jwt "github.com/golang-jwt/jwt/v4"

	fiber "github.com/gofiber/fiber/v2"
)

// RequireLoggedIn ensures access only to logged in users by checking for token presence and validity
func RequireLoggedIn() fiber.Handler {
	return jwtware.New(jwtware.Config{
		SigningKey:   []byte(cfg.GetConfig().JWTAccessSecret),
		ErrorHandler: jwtError,
	})
}

// TODO, Research how fiber checks for expired token?
func jwtError(c *fiber.Ctx, err error) error {
	if err.Error() == "Missing or malformed JWT" {
		var errorList []*fiber.Error
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusUnauthorized,
				Message: "Missing or Malformed Authentication Token",
			},
		)
		return c.Status(http.StatusUnauthorized).JSON(fiber.Map{"errors": errorList})

	}

	var errorList []*fiber.Error
	errorList = append(
		errorList,
		&fiber.Error{
			Code:    fiber.StatusUnauthorized,
			Message: "Invalid or Expired Authentication Token",
		},
	)
	return c.Status(http.StatusUnauthorized).JSON(fiber.Map{"errors": errorList})
}

// RequireAdmin Ensures a route can only be accessed by an admin user
func RequireAdmin() fiber.Handler {
	return func(c *fiber.Ctx) error {
		token := c.Get("Authorization")
		token = token[7:]
		if token == "" {
			return c.Status(http.StatusUnauthorized).JSON(fiber.Map{"error": "Missing Authorization Token"})
		}

		claims := jwt.MapClaims{}
		_, err := jwt.ParseWithClaims(token, claims, func(token *jwt.Token) (interface{}, error) {
			return []byte(cfg.GetConfig().JWTAccessSecret), nil
		})

		fmt.Println(claims)
		if err != nil {
			return c.Status(http.StatusUnauthorized).JSON(fiber.Map{"error": "Invalid or Expired Token"})
		}

		if claims["role"] != "admin" {
			return c.Status(http.StatusForbidden).JSON(fiber.Map{"error": "Unauthorized Access"})
		}

		return c.Next()
	}
}
