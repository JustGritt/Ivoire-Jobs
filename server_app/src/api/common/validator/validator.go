package validator

import (
	"fmt"
	"log"
	"mime/multipart"
	"path/filepath"
	"reflect"
	"strconv"
	"strings"

	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

var validate = validator.New()

// GetCustomMessage extracts the custom message from the struct tag if it exists
func GetCustomMessage(payload interface{}, field string, tag string) string {
	fieldStruct, ok := reflect.TypeOf(payload).Elem().FieldByName(field)
	if !ok {
		return ""
	}

	// Check for a custom message for the specific validation tag
	if message, ok := fieldStruct.Tag.Lookup("message"); ok {
		return message
	}

	return ""
}

// Validate validates the input struct and returns a list of fiber errors
func Validate(payload interface{}) []*fiber.Error {
	err := validate.Struct(payload)
	if err != nil {
		// Empty errors slice to store the errors
		var errorList []*fiber.Error
		for _, err := range err.(validator.ValidationErrors) {
			// Get custom message from struct tag if it exists
			message := GetCustomMessage(payload, err.StructField(), err.Tag())

			// Use custom message if set, otherwise use default message
			if message == "" {
				switch err.Tag() {
				case "required":
					message = fmt.Sprintf("%s is required", err.StructField())
				case "email":
					message = fmt.Sprintf("%s must be a valid email address", err.StructField())
				case "min":
					message = fmt.Sprintf("%s must be at least %s min", err.StructField(), err.Param())
				case "max":
					message = fmt.Sprintf("%s must be at most %s min", err.StructField(), err.Param())
				case "size":
					message = fmt.Sprintf("%s must be less than %s", err.StructField(), err.Param())
				case "ext":
					message = fmt.Sprintf("%s must be a valid file with one of the extensions: %s", err.StructField(), err.Param())
				case "step":
					message = fmt.Sprintf("%s must be a multiple of %s min", err.StructField(), err.Param())
				case "datetime":
					message = fmt.Sprintf("%s must be a valid date and time", err.StructField())
				default:
					message = fmt.Sprintf("%s is not valid", err.StructField())
				}
			}

			errorList = append(
				errorList,
				&fiber.Error{
					Code:    fiber.StatusBadRequest,
					Message: message,
				},
			)
		}
		return errorList
	}

	return nil
}

// ParseBody is a helper function for parsing the body.
// If any error occurs it will return the error list.
// It's just a helper function to avoid writing if conditions again and again.
func ParseBody(c *fiber.Ctx, body interface{}) []*fiber.Error {
	if err := c.BodyParser(body); err != nil {
		var errorList []*fiber.Error
		errorList = append(
			errorList,
			fiber.ErrBadRequest,
		)

		return errorList
	}

	return nil
}

// ParseBodyAndValidate is a helper function for parsing the body.
// If any error occurs it will return the error list.
// It's just a helper function to avoid writing if conditions again and again.
func ParseBodyAndValidate(c *fiber.Ctx, body interface{}) []*fiber.Error {

	// First We Parse
	if err := ParseBody(c, body); err != nil {
		return err
	}

	/*
		// Check for the admin field and validate if present
		v := reflect.ValueOf(body).Elem()
		t := v.Type()

		for i := 0; i < v.NumField(); i++ {
			field := t.Field(i)
			if field.Tag.Get("validate") == "admin" {
				if !ValidateAdmin(c) {
					var errorList []*fiber.Error
					errorList = append(
						errorList,
						&fiber.Error{
							Code:    fiber.StatusForbidden,
							Message: fmt.Sprintf("You must be an admin to edit : %s", field.Name),
						},
					)
					return errorList
				}

			}
		}
	*/

	// Then We Validate
	return Validate(body)
}

// ParseSize converts a human-readable size like "5MB" to bytes
func ParseSize(sizeStr string) (int64, error) {
	var size int64
	var unit string
	_, err := fmt.Sscanf(sizeStr, "%d%s", &size, &unit)
	if err != nil {
		return 0, err
	}

	switch strings.ToUpper(unit) {
	case "KB":
		size *= 1024
	case "MB":
		size *= 1024 * 1024
	case "GB":
		size *= 1024 * 1024 * 1024
	default:
		return 0, fmt.Errorf("unknown size unit: %s", unit)
	}

	return size, nil
}

// Custom validation rule for file size
func fileSizeValidator(fl validator.FieldLevel) bool {
	param := fl.Param()
	log.Panic(param)
	sizeLimit, err := ParseSize(param)
	log.Println("Size limit:", sizeLimit, "Error:", err)
	if err != nil {
		return false
	}

	field := fl.Field()
	if field.Kind() == reflect.Ptr && !field.IsNil() {
		fileHeader, ok := field.Interface().(*multipart.FileHeader)
		if !ok {
			return false
		}
		// Get the file size from the FileHeader
		fileSize := fileHeader.Size
		return fileSize <= sizeLimit
	}

	return false
}

// Custom validation rule for file extension
func fileExtensionValidator(fl validator.FieldLevel) bool {
	param := strings.Trim(fl.Param(), "'") // Remove the surrounding quotes
	allowedExts := strings.Split(param, ":")
	field := fl.Field()
	if field.Kind() == reflect.String {
		fileName := field.String()
		fileExt := strings.ToLower(strings.TrimPrefix(filepath.Ext(fileName), "."))
		for _, ext := range allowedExts {
			if fileExt == ext {
				return true
			}
		}
	}
	return false
}

func init() {
	// Register custom validation functions
	validate.RegisterValidation("size", fileSizeValidator)
	validate.RegisterValidation("ext", fileExtensionValidator)
	validate.RegisterValidation("admin", adminValidator)
}

// ValidateFile checks the file size and extension
func ValidateFile(file *multipart.FileHeader, maxSize string, allowedExts []string) []*fiber.Error {
	var errorList []*fiber.Error
	sizeLimit, err := ParseSize(maxSize)
	if err != nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: fmt.Sprintf("invalid size format: %v", err),
			},
		)
		return errorList
	}

	if file.Size > sizeLimit {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: fmt.Sprintf("file size must be less than %s", maxSize),
			},
		)
		return errorList
	}

	fileExt := strings.ToLower(strings.TrimPrefix(filepath.Ext(file.Filename), "."))
	log.Println("File extension:", fileExt, "Allowed extensions:", allowedExts)
	for _, ext := range allowedExts {
		if fileExt == ext {
			return nil
		}
	}

	errorList = append(
		errorList,
		&fiber.Error{
			Code:    fiber.StatusBadRequest,
			Message: fmt.Sprintf("file extension must be one of: %s", strings.Join(allowedExts, ", ")),
		},
	)

	return errorList
}

var _ = validate.RegisterValidation("password", func(fl validator.FieldLevel) bool {
	l := len(fl.Field().String())

	return l >= 6 && l < 100
})

// take a int and check if it is a multiple of the argument
var _ = validate.RegisterValidation("step", func(fl validator.FieldLevel) bool {
	param := fl.Param()
	intParam, err := strconv.ParseInt(param, 10, 64)
	if err != nil {
		return false
	}
	field := fl.Field()
	if field.Kind() == reflect.Int {
		value := field.Int()
		return value%intParam == 0
	}
	return false
})

// ValidateAdmin checks if the current user is an admin based on the JWT token in the context
func ValidateAdmin(c *fiber.Ctx) bool {
	user := c.Locals("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)
	role, ok := claims["role"].(string)
	if !ok {
		return false
	}
	return role == "admin"
}

// Custom validation rule for admin
func adminValidator(fl validator.FieldLevel) bool {
	ctx := fl.Parent().Interface().(*fiber.Ctx)
	return ValidateAdmin(ctx)
}
