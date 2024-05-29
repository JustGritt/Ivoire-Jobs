package controllers

import (
	cfg "barassage/api/configs"
	userRepo "barassage/api/repositories/user"
	"fmt"
	"net/http"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// VerifyEmail Godoc
// @Summary Verify Email
// @Description Verifies a user's email address
// @Tags Auth
// @Produce json
// @Param token query string true "Verification Token"
// @Success 200 {object} Response
// @Failure 400 {object} ErrorResponse
// @Failure 401 {object} ErrorResponse
// @Router /auth/verify-email [get]
func VerifyEmail(c *fiber.Ctx) error {
	tokenString := c.Query("token")
	if tokenString == "" {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Token is required"})
	}

	// Parse and validate the token
	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return []byte(cfg.GetConfig().JWTAccessSecret), nil
	})

	if err != nil || !token.Valid {
		return c.Status(http.StatusUnauthorized).JSON(fiber.Map{"error": "Invalid token"})
	}

	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok || !token.Valid {
		return c.Status(http.StatusUnauthorized).JSON(fiber.Map{"error": "Invalid token claims"})
	}

	userID := claims["user_id"].(string)
	// Fetch the user by ID and verify their email address
	u, err := userRepo.GetById(userID)
	if err != nil || u == nil {
		return c.Status(http.StatusNotFound).JSON(fiber.Map{"error": "User not found"})
	}

	u.Active = true
	if err := userRepo.Update(u); err != nil {
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{"error": "Could not verify email"})
	}

	return c.Status(http.StatusOK).JSON(fiber.Map{"message": "Email verified successfully"})
}
