package controllers

import (
	"fmt"
	"net/http"
	"time"

	cfg "barassage/api/configs"
	refreshtoken "barassage/api/models/refreshToken"
	"barassage/api/models/user"
	refreshTokenRepo "barassage/api/repositories/refreshToken"
	"barassage/api/services/auth"

	"github.com/gofiber/fiber/v2"
	jwt "github.com/golang-jwt/jwt/v4"
	"github.com/google/uuid"
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

	// Issue a new refresh token
	// Check if the user has a refresh token
	dbRefreshToken, _ := refreshTokenRepo.GetRefreshTokenForUser(u.ID)
	var tokenDetails *auth.TokenDetails

	if dbRefreshToken == nil {
		// Create a new refresh token
		expireTime := time.Now().Add(14 * 24 * time.Hour).Unix()
		tokenID := uuid.New().String()

		tokenDetails, err = auth.IssueRefreshToken(u, tokenID, expireTime)
		if err != nil {
			return c.Status(http.StatusInternalServerError).JSON(HTTPErrorResponse([]*Response{
				{
					Code:    http.StatusInternalServerError,
					Message: "Something Went Wrong: Could Not Issue Token",
					Data:    err.Error(),
				},
			}))
		}

		dbRefreshToken = &refreshtoken.RefreshToken{
			TokenID:   tokenDetails.TokenUUID,
			UserID:    u.ID,
			ExpiresAt: tokenDetails.TokenExpires,
		}

		if err := refreshTokenRepo.Create(dbRefreshToken); err != nil {
			return c.Status(http.StatusInternalServerError).JSON(HTTPErrorResponse([]*Response{
				{
					Code:    http.StatusInternalServerError,
					Message: "Something Went Wrong: Could Not Save Token",
					Data:    err.Error(),
				},
			}))
		}
	}

	expireTime := time.Now().Add(14 * 24 * time.Hour).Unix()
	tokenDetails, err = auth.IssueRefreshToken(u, dbRefreshToken.TokenID, expireTime)
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(HTTPErrorResponse([]*Response{
			{
				Code:    http.StatusInternalServerError,
				Message: "Something Went Wrong: Could Not Issue Token",
				Data:    err.Error(),
			},
		}))
	}
	if time.Until(time.Unix(dbRefreshToken.ExpiresAt, 0)) < 7*24*time.Hour {
		dbRefreshToken.TokenID = tokenDetails.TokenUUID
		dbRefreshToken.ExpiresAt = tokenDetails.TokenExpires

		if err := refreshTokenRepo.Update(dbRefreshToken); err != nil {
			return c.Status(http.StatusInternalServerError).JSON(HTTPErrorResponse([]*Response{
				{
					Code:    http.StatusInternalServerError,
					Message: "Something Went Wrong: Could Not Update Token",
					Data:    err.Error(),
				},
			}))
		}
	}

	// Return the new tokens
	return c.Status(http.StatusOK).JSON(RefreshResponse{
		AccessToken:  newAccessToken.Token,
		RefreshToken: tokenDetails.Token,
	})
}
