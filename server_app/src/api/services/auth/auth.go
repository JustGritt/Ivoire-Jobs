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
	jwt.RegisteredClaims
}

// AccessClaims represents access token JWT claims
type AccessClaims struct {
	AccessTokenID string `json:"accessTokenID"`
	UserID        string `json:"userID"`
	Role          string `json:"role"`
	jwt.RegisteredClaims
}

// IssueAccessToken generate access tokens used for auth
func IssueAccessToken(u user.User) (*TokenDetails, error) {
	expireTime := time.Now().Add(time.Hour * 4) // 4 hour
	tokenUUID := uuid.New().String()
	if u.Role == "" {
		u.Role = "user"
	}
	// Generate encoded token
	claims := AccessClaims{
		tokenUUID,
		u.ID,
		u.Role,
		jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(expireTime),
			Issuer:    cfg.GetConfig().JWTIssuer,
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
func IssueRefreshToken(u user.User, tokenID string, expireTime int64) (*TokenDetails, error) {

	// Generate encoded token
	claims := RefreshClaims{
		tokenID,
		u.ID,
		u.Role,
		jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Unix(expireTime, 0)),
			Issuer:    cfg.GetConfig().JWTIssuer,
		},
	}

	tokenClaims := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tk, err := tokenClaims.SignedString([]byte(cfg.GetConfig().JWTRefreshSecret))

	if err != nil {
		return nil, err
	}

	return &TokenDetails{
		Token:        tk,
		TokenUUID:    tokenID,
		TokenExpires: expireTime,
	}, nil
}
