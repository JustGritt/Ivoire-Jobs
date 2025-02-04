package configs

import (
	"fmt"
	"log"
	"os"
	"path/filepath"

	"github.com/joho/godotenv"
)

const (
	prod = "production"
)

// Config object
type Config struct {
	Env      string         `env:"ENV"`
	Postgres PostgresConfig `json:"postgres"`
	Postmark PostmarkConfig `json:"postmark"`
	// Mailgun   MailgunConfig  `json:"mailgun"`
	JWTAccessSecret  string       `env:"JWT_ACCESS_SIGN_KEY"`
	JWTRefreshSecret string       `env:"JWT_REFRESH_SIGN_KEY"`
	JWTIssuer        string       `env:"JWT_ISSUER"`
	Host             string       `env:"APP_HOST"`
	Port             string       `env:"APP_PORT"`
	FromEmail        string       `env:"EMAIL_FROM"`
	FrontendURL      string       `env:"FRONTEND_URL"`
	S3               S3Config     `json:"s3"`
	Stripe           StripeConfig `json:"stripe"`
	FCM              FCMConfig    `json:"fcm"`
	Google           string       `env:"GOOGLE_CONTENT"`
}

// IsProd Checks if env is production
func (c Config) IsProd() bool {
	return c.Env == prod
}

// LoadConfig gets config from .env
func LoadConfig() {
	currentPath, err := os.Getwd()
	if err != nil {
		log.Println(err)
	}
	environmentPath := filepath.Join(currentPath, ".env")
	fmt.Println("Loading .env file from ", environmentPath)

	if err := godotenv.Load(environmentPath); err != nil {
		log.Fatal("Error loading .env file")
		log.Fatal(err)
	}
}

// GetConfig gets all config for the application
func GetConfig() Config {
	postgresStrategy := AutoDetectConfigStrategy{}
	postgresConfig := NewPostgresConfig(postgresStrategy)

	return Config{
		Env:      os.Getenv("ENV"),
		Postgres: postgresConfig,
		// Mailgun:   GetMailgunConfig(),
		Postmark:         GetPostMakrConfig(),
		JWTAccessSecret:  os.Getenv("JWT_ACCESS_SIGN_KEY"),
		JWTRefreshSecret: os.Getenv("JWT_REFRESH_SIGN_KEY"),
		JWTIssuer:        os.Getenv("JWT_ISSUER"),
		Host:             os.Getenv("APP_HOST"),
		Port:             os.Getenv("APP_PORT"),
		FromEmail:        os.Getenv("EMAIL_FROM"),
		FrontendURL:      os.Getenv("FRONTEND_URL"),
		S3:               GetS3Config(),
		Stripe:           GetStripeConfig(),
		FCM:              GetFCMConfig(),
		Google:           os.Getenv("GOOGLE_CONTENT"),
	}
}
