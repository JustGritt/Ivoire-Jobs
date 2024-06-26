package controllers

import (
	cfg "barassage/api/configs"
	userRepo "barassage/api/repositories/user"
	"fmt"
	"net/http"
	"time"

	"barassage/api/services/mailer"

	"github.com/gofiber/fiber/v2"
	jwt "github.com/golang-jwt/jwt/v4"
)

type ResetPasswordRequest struct {
	Email string `json:"email"`
}

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

// create a function to reset password. the user should only give his email and i will send a token to his email
// the token will be valid for 1 hour
// ResetPassword Godoc
// @Summary Reset Password
// @Description Sends a reset password link to the user's email
// @Tags Auth
// @Produce json
// @Param email body string true "Email"
// @Success 200 {object} Response
// @Failure 400 {object} ErrorResponse
// @Failure 401 {object} ErrorResponse
// @Router /auth/reset-password [post]
func ResetPassword(c *fiber.Ctx) error {

	var req ResetPasswordRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request"})
	}

	u, err := userRepo.GetByEmail(req.Email)
	if err != nil || u == nil {
		return c.Status(http.StatusNotFound).JSON(fiber.Map{"error": "User not found"})
	}

	// Generate a new token
	token := jwt.New(jwt.SigningMethodHS256)
	claims := token.Claims.(jwt.MapClaims)
	claims["user_id"] = u.ID
	claims["exp"] = jwt.TimeFunc().Add(time.Minute * 10).Unix()

	tokenString, err := token.SignedString([]byte(cfg.GetConfig().JWTAccessSecret))
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{"error": "Could not generate token"})
	}

	// Send the token to the user's email
	resetPasswordLink := fmt.Sprintf("%s/confirm-password?token=%s", cfg.GetConfig().FrontendURL, tokenString)
	emailData := map[string]interface{}{
		"action_url": resetPasswordLink,
		"email":      u.Email,
	}

	_, err = mailer.SendEmail("confirm-password", u.Email, "Reset Password", emailData)
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{"error": "Could not send email"})
	}

	return c.Status(http.StatusOK).JSON(fiber.Map{"message": "Reset password link sent successfully"})
}
