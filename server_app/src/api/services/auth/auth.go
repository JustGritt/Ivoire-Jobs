package auth

import (
	"time"

	"barassage/api/models/user"

	cfg "barassage/api/configs"

	jwt "github.com/golang-jwt/jwt/v4"
	"github.com/google/uuid"
)

// TokenDetails Represents token object
type TokenDetails struct {
	Token        string
	TokenUUID    string
	TokenExpires int64
}

// RefreshClaims represents refresh token JWT claims
type RefreshClaims struct {
	RefreshTokenID string `json:"refreshTokenID"`
	UserID         string `json:"userID"`
	Role           string `json:"role"`
	jwt.MapClaims
}

// AccessClaims represents access token JWT claims
type AccessClaims struct {
	AccessTokenID string `json:"accessTokenID"`
	UserID        string `json:"userID"`
	Role          string `json:"role"`
	jwt.MapClaims
}

// IssueAccessToken generate access tokens used for auth
func IssueAccessToken(u user.User) (*TokenDetails, error) {
	expireTime := time.Now().Add(time.Hour) // 1 hour
	tokenUUID := uuid.New().String()
	// Generate encoded token
	claims := AccessClaims{
		tokenUUID,
		u.ID,
		u.Role,
		jwt.MapClaims{
			"exp": expireTime.Unix(),
			"iss": cfg.GetConfig().JWTIssuer,
		},
	}

	tokenClaims := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tk, err := tokenClaims.SignedString([]byte(cfg.GetConfig().JWTAccessSecret))

	if err != nil {
		return nil, err
	}

	return &TokenDetails{
		Token:        tk,
		TokenUUID:    tokenUUID,
		TokenExpires: expireTime.Unix(),
	}, nil
}

// IssueRefreshToken generate refresh tokens used for auth
func IssueRefreshToken(u user.User) (*TokenDetails, error) {
	expireTime := time.Now().Add((24 * time.Hour) * 14) // 14 days
	tokenUUID := uuid.New().String()

	// Generate encoded token
	claims := RefreshClaims{
		tokenUUID,
		u.ID,
		u.Role,
		jwt.MapClaims{
			"exp": expireTime.Unix(),
			"iss": cfg.GetConfig().JWTIssuer,
		},
	}

	tokenClaims := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tk, err := tokenClaims.SignedString([]byte(cfg.GetConfig().JWTRefreshSecret))

	if err != nil {
		return nil, err
	}

	return &TokenDetails{
		Token:        tk,
		TokenUUID:    uuid.New().String(),
		TokenExpires: expireTime.Unix(),
	}, nil
}
