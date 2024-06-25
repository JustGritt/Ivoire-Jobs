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

// RequireAdmin ensures a route can only be accessed by an admin user
func RequireAdmin() fiber.Handler {
	return func(c *fiber.Ctx) error {
		// Retrieve the user token from the context
		userToken := c.Locals("user")
		fmt.Println(userToken)

		// Check if the user token is not nil
		if userToken == nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
				"errors": []string{"Missing or invalid token"},
			})
		}

		// Assert the user token type
		user, ok := userToken.(*jwt.Token)
		if !ok {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
				"errors": []string{"Invalid token format"},
			})
		}

		// Extract claims from the token
		claims, ok := user.Claims.(jwt.MapClaims)
		if !ok {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
				"errors": []string{"Invalid token claims"},
			})
		}

		// Retrieve the user role from the claims
		role, ok := claims["role"].(string)
		if !ok || role != "admin" {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
				"errors": []string{"You're not authorized"},
			})
		}

		// Proceed to the next middleware/handler
		return c.Next()
	}
}
