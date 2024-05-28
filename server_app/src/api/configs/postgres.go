package configs

import (
	"fmt"
	"os"
	"strconv"
)

type PostgreSQLStrategy interface {
	GetPostgresConnectionInfo() string
	Name() string
}

type EnvironmentConfigStrategy struct{}

func (s EnvironmentConfigStrategy) GetPostgresConnectionInfo() string {
	host := os.Getenv("DB_HOST")
	port, _ := strconv.Atoi(os.Getenv("DB_PORT"))
	user := os.Getenv("DB_USER")
	password := os.Getenv("DB_PASSWORD")
	dbName := os.Getenv("DB_NAME")

	return generatePostgresConnectionString(host, port, user, password, dbName)
}

func (s EnvironmentConfigStrategy) Name() string {
	return "EnvironmentConfigStrategy"
}

type URLConfigStrategy struct {
	URL string
}

func (s URLConfigStrategy) GetPostgresConnectionInfo() string {
	return s.URL
}

func (s URLConfigStrategy) Name() string {
	return "URLConfigStrategy"
}

type AutoDetectConfigStrategy struct{}

func (s AutoDetectConfigStrategy) GetPostgresConnectionInfo() string {
	url := os.Getenv("DB_URL")
	if url != "" {
		return url
	}

	return EnvironmentConfigStrategy{}.GetPostgresConnectionInfo()
}

func (s AutoDetectConfigStrategy) Name() string {
	return "AutoDetectConfigStrategy"
}

type PostgresConfig struct {
	Strategy PostgreSQLStrategy
}

func NewPostgresConfig(strategy PostgreSQLStrategy) PostgresConfig {
	return PostgresConfig{
		Strategy: strategy,
	}
}

func (c PostgresConfig) GetPostgresConnectionInfo() string {
	return c.Strategy.GetPostgresConnectionInfo()
}

func generatePostgresConnectionString(host string, port int, user string, password string, dbName string) string {
	if password == "" {
		return fmt.Sprintf("host=%s port=%d user=%s dbname=%s sslmode=disable", host, port, user, dbName)
	}
	return fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable", host, port, user, password, dbName)
}
