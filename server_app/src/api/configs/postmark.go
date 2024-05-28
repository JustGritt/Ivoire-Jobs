package configs

import (
	"os"
)

// PostmarkConfig object
type PostmarkConfig struct {
	ServerToken  string
	AccountToken string
}

func GetPostMakrConfig() PostmarkConfig {
	return PostmarkConfig{
		ServerToken:  os.Getenv("POSTMARK_SERVER_TOKEN"),
		AccountToken: os.Getenv("POSTMARK_ACCOUNT_TOKEN"),
	}
}
