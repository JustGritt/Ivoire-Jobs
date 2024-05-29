package configs

import "os"

// S3Config holds the configuration for the S3 service
type S3Config struct {
	Region string
	Bucket string
}

// GetS3Config returns the S3 configuration
func GetS3Config() S3Config {
	return S3Config{
		Region: os.Getenv("S3_REGION"),
		Bucket: os.Getenv("S3_BUCKET"),
	}
}
