package bucket

import (
	"bytes"
	"context"
	"fmt"
	"image"
	"image/jpeg"
	"image/png"
	"io"
	"log"
	"mime/multipart"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/credentials"
	"github.com/aws/aws-sdk-go-v2/feature/s3/manager"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/disintegration/imaging"
	"github.com/gabriel-vasile/mimetype"
	"github.com/google/uuid"
)

var s3Client *s3.Client
var uploader *manager.Uploader

// InitS3Manager initializes the S3 client and uploader
func InitS3Manager() error {
	cfg, err := config.LoadDefaultConfig(context.TODO(),
		config.WithRegion(os.Getenv("S3_REGION")),
		config.WithCredentialsProvider(credentials.NewStaticCredentialsProvider(
			os.Getenv("AWS_ACCESS_KEY_ID"),
			os.Getenv("AWS_SECRET_ACCESS_KEY"),
			"",
		)),
	)
	if err != nil {
		log.Printf("error loading AWS config: %v", err)
		return err
	}

	s3Client = s3.NewFromConfig(cfg)
	uploader = manager.NewUploader(s3Client)
	return nil
}

// GetS3Client returns the S3 client
func GetS3Client() *s3.Client {
	return s3Client
}

// UploadFile uploads a file to S3 and returns the URL
func UploadFile(file *multipart.FileHeader) (string, error) {
	bucketName := os.Getenv("S3_BUCKET")

	// Read the file content
	fileContent, err := file.Open()
	if err != nil {
		return "", fmt.Errorf("failed to open file: %w", err)
	}
	defer fileContent.Close()

	buffer := make([]byte, file.Size)
	_, err = fileContent.Read(buffer)
	if err != nil {
		return "", fmt.Errorf("failed to read file: %w", err)
	}

	// Detect the file MIME type
	mime := mimetype.Detect(buffer)
	contentType := mime.String()

	// Generate a unique file name
	//fileName := uuid.New().String() + filepath.Ext(file.Filename)

	// Prepare the file for upload
	//uploadBody := bytes.NewReader(buffer)

	//rezise image to 500x500
	// Decode the image based on its MIME type
	var img image.Image
	switch contentType {
	case "image/jpeg", "image/jpg":
		img, err = jpeg.Decode(bytes.NewReader(buffer))
		if err != nil {
			return "", fmt.Errorf("failed to decode jpeg image: %w", err)
		}
	case "image/png":
		img, err = png.Decode(bytes.NewReader(buffer))
		if err != nil {
			return "", fmt.Errorf("failed to decode png image: %w", err)
		}
	default:
		return "", fmt.Errorf("unsupported image format: %s", contentType)
	}

	// Generate a 500x500 thumbnail
	thumbnail := imaging.Resize(img, 500, 500, imaging.Lanczos)
	thumbnailBuffer := new(bytes.Buffer)
	switch contentType {
	case "image/jpeg", "image/jpg":
		err = jpeg.Encode(thumbnailBuffer, thumbnail, nil)
		if err != nil {
			return "", fmt.Errorf("failed to encode thumbnail: %w", err)
		}
	case "image/png":
		err = png.Encode(thumbnailBuffer, thumbnail)
		if err != nil {
			return "", fmt.Errorf("failed to encode thumbnail: %w", err)
		}
	default:
		return "", fmt.Errorf("unsupported image format: %s", contentType)
	}

	thumbnailFileName := fmt.Sprintf("%s_500x500%s", uuid.New().String(), filepath.Ext(file.Filename))

	// Upload the file
	result, err := uploader.Upload(context.TODO(), &s3.PutObjectInput{
		Bucket:      aws.String(bucketName),
		Key:         aws.String(thumbnailFileName),
		Body:        bytes.NewReader(thumbnailBuffer.Bytes()),
		ContentType: aws.String(contentType),
	})
	if err != nil {
		return "", fmt.Errorf("failed to upload file to S3: %w", err)
	}
	log.Println("File uploaded to", result.Location)
	// Construct the file URL using couldfront distribution url
	//fileURL := "https://d34lpad8kmnoic.cloudfront.net/" + fileName
	fileURL := "https://d34lpad8kmnoic.cloudfront.net/" + thumbnailFileName
	return fileURL, nil
}

// GetImage retrieves an image from S3
func GetImage(fileName string) ([]byte, error) {
	bucketName := os.Getenv("S3_BUCKET")

	//from the fileName trim the url "https://go-flutter.s3.amazonaws.com/33915e28-3366-40b5-9930-5cd2a84aafed.jpg"
	fileName = fileName[len("https://"+bucketName+".s3."+os.Getenv("AWS_REGION")+".amazonaws.com/"):]

	input := &s3.GetObjectInput{
		Bucket: aws.String(bucketName),
		Key:    aws.String(fileName),
	}

	result, err := s3Client.GetObject(context.TODO(), input)
	if err != nil {
		return nil, fmt.Errorf("failed to get object from S3: %w", err)
	}
	defer result.Body.Close()

	// Read the content of the file
	content, err := io.ReadAll(result.Body)
	if err != nil {
		return nil, fmt.Errorf("failed to read object content: %w", err)
	}

	return content, nil
}

// GetPresignedURL generates a pre-signed URL for the specified file in S3
func GetPresignedURL(fileName string) (string, error) {
	bucketName := os.Getenv("S3_BUCKET")

	// Log input file name for debugging
	log.Printf("Original file name: %s", fileName)

	// Split the fileName by "/" and get the last part as the key
	parts := strings.Split(fileName, "/")
	if len(parts) == 0 {
		return "", fmt.Errorf("invalid file name: %s", fileName)
	}
	objectKey := parts[len(parts)-1]

	// Log object key for debugging
	log.Printf("Object key: %s", objectKey)

	presigner := s3.NewPresignClient(s3Client)

	req, err := presigner.PresignGetObject(context.TODO(), &s3.GetObjectInput{
		Bucket: aws.String(bucketName),
		Key:    aws.String(objectKey),
	}, s3.WithPresignExpires(15*time.Hour)) // URL expires in 15 hours
	if err != nil {
		return "", fmt.Errorf("failed to sign request: %w", err)
	}

	return req.URL, nil
}

func DeleteFile(fileName string) error {
	bucketName := os.Getenv("S3_BUCKET")

	//from the fileName trim the url "https://go-flutter.s3.amazonaws.com/33915e28-3366-40b5-9930-5cd2a84aafed.jpg"
	fileName = fileName[len("https://"+bucketName+".s3."+os.Getenv("AWS_REGION")+".amazonaws.com/"):]

	input := &s3.DeleteObjectInput{
		Bucket: aws.String(bucketName),
		Key:    aws.String(fileName),
	}

	_, err := s3Client.DeleteObject(context.TODO(), input)
	if err != nil {
		return fmt.Errorf("failed to delete object from S3: %w", err)
	}

	return nil
}
