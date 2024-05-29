package controllers

import (
	"fmt"
	"net/http"

	cfg "barassage/api/configs"
	"barassage/api/models/user"
	"barassage/api/services/auth"

	"github.com/form3tech-oss/jwt-go"
	"github.com/gofiber/fiber/v2"
)

// RefreshRequest represents the request structure for refreshing tokens
type RefreshRequest struct {
	RefreshToken string `json:"refreshToken" validate:"required"`
}

// RefreshResponse represents the response structure for refreshing tokens
type RefreshResponse struct {
	AccessToken  string `json:"accessToken"`
	RefreshToken string `json:"refreshToken"`
}

// RefreshAuth Godoc
// @Summary Refresh Auth
// @Description Returns a fresh access token
// @Tags Auth
// @Produce json
// @Param payload body RefreshRequest true "Refresh Token"
// @Success 200 {object} RefreshResponse
// @Failure 400 {object} ErrorResponse
// @Router /auth/refresh [post]
// @Security Bearer
func RefreshAuth(c *fiber.Ctx) error {
	var req RefreshRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid request payload",
		})
	}

	// Validate the refresh token
	refreshTokenClaims := &auth.RefreshClaims{}
	token, err := jwt.ParseWithClaims(req.RefreshToken, refreshTokenClaims, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return []byte(cfg.GetConfig().JWTRefreshSecret), nil
	})
	if err != nil || !token.Valid {
		return c.Status(http.StatusUnauthorized).JSON(fiber.Map{
			"error": "Invalid refresh token",
		})
	}

	// Fetch user details using Id from refresh token claims
	u := user.User{
		Role: refreshTokenClaims.Role,
		ID:   refreshTokenClaims.UserID,
	}

	// Issue a new access token
	newAccessToken, err := auth.IssueAccessToken(u)
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
			"error": "Could not issue new access token",
		})
	}

	// Optionally, issue a new refresh token
	newRefreshToken, err := auth.IssueRefreshToken(u)
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
			"error": "Could not issue new refresh token",
		})
	}

	// Return the new tokens
	return c.Status(http.StatusOK).JSON(RefreshResponse{
		AccessToken:  newAccessToken.Token,
		RefreshToken: newRefreshToken.Token,
	})
}
