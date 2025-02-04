package controllers

import (
	validator "barassage/api/common/validator"
	"barassage/api/models/category"
	"barassage/api/models/image"
	"barassage/api/models/service"
	"math"

	categoryRepo "barassage/api/repositories/category"
	serviceRepo "barassage/api/repositories/service"
	userRepo "barassage/api/repositories/user"
	"barassage/api/services/bucket"
	"regexp"
	"strconv"
	"strings"

	"fmt"
	"mime/multipart"
	"net/http"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

// ServiceObject represents the service data structure.
type ServiceObject struct {
	ServiceID   string                  `json:"-"`
	UserID      string                  `json:"-"`
	Name        string                  `json:"name" validate:"required,min=2,max=30"`
	Description string                  `json:"description" validate:"required,min=2,max=30"`
	Price       float64                 `json:"price" validate:"required,min=1000,max=1000000"`
	Status      bool                    `json:"status" default:"false"`
	Duration    int                     `json:"duration" validate:"required,min=30,max=1440,step=30" message:"Duration must be a multiple of 30 and it should be beetween 30 and 1440"`
	IsBanned    bool                    `json:"-"`
	Latitude    float64                 `json:"latitude" validate:"required"`
	Longitude   float64                 `json:"longitude" validate:"required"`
	Address     string                  `json:"address" validate:"required"`
	City        string                  `json:"city" validate:"required"`
	PostalCode  string                  `json:"postalCode"`
	Country     string                  `json:"country" validate:"required"`
	Images      []*multipart.FileHeader `json:"images" form:"images" swaggertype:"string"`
	CategoryIDs []string                `json:"categoryIds" validate:"required"`
}

type ServiceUpdateObject struct {
	Name        string                  `json:"name" validate:"required,min=2,max=30"`
	Description string                  `json:"description" validate:"required,min=2,max=30"`
	Price       float64                 `json:"price" validate:"required,min=5,max=1000000"`
	Status      bool                    `json:"status" default:"false"`
	Duration    int                     `json:"duration" validate:"required,min=30,max=1440,step=30" message:"Duration must be a multiple of 30 and it should be beetween 30 and 1440"`
	IsBanned    bool                    `json:"isBanned"`
	Latitude    float64                 `json:"latitude"`
	Longitude   float64                 `json:"longitude"`
	Address     string                  `json:"address"`
	City        string                  `json:"city"`
	PostalCode  string                  `json:"postalCode"`
	Country     string                  `json:"country"`
	Images      []*multipart.FileHeader `json:"images"`
	DeleteImage []string                `json:"deleteImage"`
}

type ServiceOutput struct {
	ServiceID   string          `json:"id"`
	UserID      string          `json:"userId"`
	Name        string          `json:"name"`
	Description string          `json:"description"`
	Price       float64         `json:"price"`
	Status      bool            `json:"status"`
	Duration    int             `json:"duration"`
	IsBanned    bool            `json:"isBanned"`
	Latitude    float64         `json:"latitude"`
	Longitude   float64         `json:"longitude"`
	Address     string          `json:"address"`
	City        string          `json:"city"`
	PostalCode  string          `json:"postalCode"`
	Country     string          `json:"country"`
	Images      []string        `json:"images"`
	CreatedAt   string          `json:"createdAt"`
	Category    []string        `json:"category"`
	User        CustomUser      `json:"user"`
	Bookings    []CustomBooking `json:"bookings"`
}

type CustomBooking struct {
	BookingID string `json:"id"`
	StartAt   string `json:"startAt"`
	EndAt     string `json:"endAt"`
}

type CustomUser struct {
	ID        string `json:"id"`
	Email     string `json:"email"`
	FristName string `json:"firstname"`
	LastName  string `json:"lastname"`
	Bio       string `json:"bio"`
	Member    string `json:"member"`
	CreateAt  string `json:"createdAt"`
}

// CreateService Godoc
// @Summary Create Service
// @Description Create a service
// @Tags Service
// @Produce json
// @Param payload body ServiceObject true "Service Body"
// @Success 201 {object} Response
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /service [post]
// @Security Bearer
func CreateService(c *fiber.Ctx) error {
	var errorList []*fiber.Error
	var serviceInput ServiceObject
	if err := validator.ParseBodyAndValidate(c, &serviceInput); err != nil {
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(err))
	}

	user := c.Locals("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)
	userID := claims["userID"]
	// Validate Input
	if userID == nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "can't extract user info from request",
			},
		)
		return c.Status(fiber.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	dbUser, err := userRepo.GetById(userID.(string))
	if err != nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "user not found",
			},
		)
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	if dbUser.Member == nil || len(dbUser.Member) == 0 {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "You are not authorized to create a service, you are not a member",
			},
		)
		_ = CreateLog(&LogObject{
			Level:      "warn",
			Type:       "Service",
			Message:    "User is not a member",
			RequestURI: c.OriginalURL(),
		})

		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	Member := dbUser.Member[len(dbUser.Member)-1]
	if Member.ID == "" || Member.Status == "processing" {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "You are not authorized to create a service, your membership request is still pending",
			},
		)
		_ = CreateLog(&LogObject{
			Level:      "warn",
			Type:       "Service",
			Message:    "User membership request is still pending" + dbUser.ID,
			RequestURI: c.OriginalURL(),
		})

		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	//map the input to service model
	s := service.Service{
		UserID:      userID.(string),
		Name:        serviceInput.Name,
		Description: serviceInput.Description,
		Price:       serviceInput.Price,
		Status:      serviceInput.Status,
		Duration:    serviceInput.Duration,
		IsBanned:    serviceInput.IsBanned,
		Latitude:    serviceInput.Latitude,
		Longitude:   serviceInput.Longitude,
		Address:     serviceInput.Address,
		City:        serviceInput.City,
		PostalCode:  serviceInput.PostalCode,
		Country:     serviceInput.Country,
		ID:          uuid.New().String(),
	}

	if _, err := serviceRepo.GetServiceByNameForUser(s.Name, s.UserID); err == nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusForbidden,
				Message: "Service Already Exist",
			},
		)
		_ = CreateLog(&LogObject{
			Level:      "warn",
			Type:       "Service",
			Message:    "Service Already Exist",
			RequestURI: c.OriginalURL(),
		})
		return c.Status(http.StatusForbidden).JSON(HTTPFiberErrorResponse(errorList))
	}

	// Handle images upload
	form, err := c.MultipartForm()
	var images []image.Image
	if err == nil {
		formImages := form.File["images"]
		allowedMimeTypes := []string{"jpeg", "png", "jpg"}
		maxFileSize := "4MB"
		fileCount := len(formImages)
		totalSize := 0
		maxTotalSize := 15 * 1024 * 1024 // 15MB

		for _, imageFile := range formImages {
			totalSize += int(imageFile.Size)
		}

		if totalSize > maxTotalSize {
			errorList = append(
				errorList,
				&fiber.Error{
					Code:    fiber.StatusBadRequest,
					Message: "total size of images should not exceed 15MB",
				},
			)
			_ = CreateLog(&LogObject{
				Level:      "warn",
				Type:       "Service",
				Message:    "total size of images should not exceed 15MB",
				RequestURI: c.OriginalURL(),
			})
			return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
		}

		if fileCount > 3 {
			errorList = append(
				errorList,
				&fiber.Error{
					Code:    fiber.StatusBadRequest,
					Message: "maximum of 3 images allowed",
				},
			)
			_ = CreateLog(&LogObject{
				Level:      "warn",
				Type:       "Service",
				Message:    "maximum of 3 images allowed",
				RequestURI: c.OriginalURL(),
			})
			return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
		}

		for _, imageFile := range formImages {
			if err := validator.ValidateFile(imageFile, maxFileSize, allowedMimeTypes); err != nil {
				return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(err))
			}

			// Upload each image to S3
			imageURL, err := bucket.UploadFile(imageFile)
			if err != nil {
				errorList = append(
					errorList,
					&fiber.Error{
						Code:    fiber.StatusBadRequest,
						Message: "unable to upload images to S3",
					},
				)
				_ = CreateLog(&LogObject{
					Level:      "warn",
					Type:       "Service",
					Message:    "unable to upload images to S3",
					RequestURI: c.OriginalURL(),
				})
				return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
			}
			images = append(images, image.Image{
				URL:       imageURL,
				ServiceID: s.ID,
			})
		}
	}

	// Check if the category ids are valid
	var categories []category.Category
	for _, catID := range serviceInput.CategoryIDs {
		cat, err := categoryRepo.GetByID(catID)
		if err != nil {
			errorList = append(
				errorList,
				&fiber.Error{
					Code:    fiber.StatusBadRequest,
					Message: "invalid category id",
				},
			)
			_ = CreateLog(&LogObject{
				Level:      "warn",
				Type:       "Service",
				Message:    "invalid category id",
				RequestURI: c.OriginalURL(),
			})
			return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
		}
		categories = append(categories, *cat)
	}

	s.UserID = userID.(string)
	s.Images = images
	s.Categories = categories

	// Save Service to DB
	if err := serviceRepo.Create(&s); err != nil {
		// Check if the error is a validation error
		if err == gorm.ErrInvalidField {
			// Print a custom error message for the validation error
			fmt.Println("Validation error:", err.Error())
		} else {
			// Print other types of errors
			fmt.Println("Database error:", err.Error())
		}

		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusConflict,
				Message: "this service already exist",
			},
		)

		_ = CreateLog(&LogObject{
			Level:      "warn",
			Type:       "Service",
			Message:    "this service already exist",
			RequestURI: c.OriginalURL(),
		})

		return c.Status(http.StatusConflict).JSON(HTTPFiberErrorResponse(errorList))
	}

	serviceOutput := mapServiceToOutPut(&s)
	response := HTTPResponse(http.StatusCreated, "Service Created", serviceOutput)
	return c.Status(http.StatusCreated).JSON(response)
}

// GetAll Godoc
// @Summary Get all services
// @Description Get all services
// @Tags Service
// @Produce json
// @Success 200 {array} ServiceOutput
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /service/collection [get]
func GetAll(c *fiber.Ctx) error {
	var services []service.Service
	var errorList []*fiber.Error
	services, err := serviceRepo.GetAllServices()
	if err != nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusInternalServerError,
				Message: "error getting services",
			},
		)
		_ = CreateLog(&LogObject{
			Level:      "warn",
			Type:       "Service",
			Message:    "error getting services",
			RequestURI: c.OriginalURL(),
		})
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	// Map services to ServiceOutput
	var ouput []ServiceOutput
	for _, s := range services {
		ouput = append(ouput, *mapServiceToOutPut(&s))
	}

	//if the services are empty send and empty array
	if len(ouput) == 0 {
		return c.Status(http.StatusOK).JSON([]ServiceOutput{})
	}

	_ = CreateLog(&LogObject{
		Level:      "info",
		Type:       "Service",
		Message:    "services fetched successfully",
		RequestURI: c.OriginalURL(),
	})

	return c.Status(http.StatusOK).JSON(ouput)
}

// GetServiceByUserId Godoc
// @Summary Get all services by user id
// @Description Get all services by user id
// @Tags Service
// @Produce json
// @Param id path string true "User ID"
// @Success 200 {array} ServiceOutput
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /user/{id}/service [get]
func GetServiceByUserId(c *fiber.Ctx) error {
	//get the user id from the request
	userID := c.Params("id")
	var errorList []*fiber.Error

	services, err := serviceRepo.GetServicesByUserID(userID)
	if err != nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusInternalServerError,
				Message: "error getting services",
			},
		)

		_ = CreateLog(&LogObject{
			Level:      "warn",
			Type:       "Service",
			Message:    "error getting services",
			RequestURI: c.OriginalURL(),
		})

		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	//for each service create the customBooking

	// Map services to ServiceOutput
	var ouput []ServiceOutput
	for _, s := range services {
		ouput = append(ouput, *mapServiceToOutPut(&s))
	}

	_ = CreateLog(&LogObject{
		Level:      "info",
		Type:       "Service",
		Message:    "services fetched successfully",
		RequestURI: c.OriginalURL(),
	})

	return c.Status(http.StatusOK).JSON(ouput)
}

// GetServiceById Godoc
// @Summary Get service by id
// @Description Get service by id
// @Tags Service
// @Produce json
// @Param id path string true "Service ID"
// @Success 200 {object} ServiceOutput
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 404 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /service/{id} [get]
func GetServiceById(c *fiber.Ctx) error {
	serviceID := c.Params("id")
	var errorList []*fiber.Error
	if serviceID == "" {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "service id is required",
			},
		)

		_ = CreateLog(&LogObject{
			Level:      "warn",
			Type:       "Service",
			Message:    "service id is required",
			RequestURI: c.OriginalURL(),
		})

		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	service, err := serviceRepo.GetByID(serviceID)
	if err != nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "error getting service",
			},
		)

		_ = CreateLog(&LogObject{
			Level:      "warn",
			Type:       "Service",
			Message:    "error getting service",
			RequestURI: c.OriginalURL(),
		})
		return c.Status(http.StatusNotFound).JSON(HTTPFiberErrorResponse(errorList))
	}

	_ = CreateLog(&LogObject{
		Level:      "info",
		Type:       "Service",
		Message:    "service fetched successfully",
		RequestURI: c.OriginalURL(),
	})

	return c.Status(http.StatusOK).JSON(service)
}

// UpdateService Godoc
// @Summary Update Service
// @Description Update a service
// @Tags Service
// @Produce json
// @Param id path string true "Service ID"
// @Param payload body ServiceObject true "Service Body"
// @Success 200 {object} Response
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 403 {array} ErrorResponse
// @Failure 404 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /service/{id} [put]
// @Security Bearer
func UpdateService(c *fiber.Ctx) error {
	var errorList []*fiber.Error
	serviceID := c.Params("id")
	if serviceID == "" {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "service id is required",
			},
		)

		_ = CreateLog(&LogObject{
			Level:      "warn",
			Type:       "Service",
			Message:    "service id is required",
			RequestURI: c.OriginalURL(),
		})

		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	var updateInput ServiceUpdateObject
	//check from the body if the admin only field is set  isBanned
	if err := validator.ParseBodyAndValidate(c, &updateInput); err != nil {
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(err))
	}

	user := c.Locals("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)
	userID := claims["userID"]
	role := claims["role"].(string)
	// Validate Input
	if userID == nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusInternalServerError,
				Message: "An error occurred while extracting user info from request",
			},
		)
		_ = CreateLog(&LogObject{
			Level:      "warn",
			Message:    "An error occurred while extracting user info from request",
			RequestURI: c.OriginalURL(),
		})
		return c.Status(fiber.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	// Check if the service exists and the user is the owner
	var existingService *service.Service
	var err error
	existingService, err = serviceRepo.GetByIDUnscoped(serviceID)
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			errorList = append(
				errorList,
				&fiber.Error{
					Code:    fiber.StatusNotFound,
					Message: "Unable to find service with the given ID",
				},
			)
			_ = CreateLog(&LogObject{
				Level:      "warn",
				Type:       "Service",
				Message:    "Unable to find service with the given ID",
				RequestURI: c.OriginalURL(),
			})
			return c.Status(http.StatusNotFound).JSON(HTTPFiberErrorResponse(errorList))
		}
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusForbidden,
				Message: "An error occurred while updating service",
			},
		)
		_ = CreateLog(&LogObject{
			Level:      "warn",
			Type:       "Service",
			Message:    "An error occurred while updating service",
			RequestURI: c.OriginalURL(),
		})
		return c.Status(http.StatusForbidden).JSON(HTTPFiberErrorResponse(errorList))
	}

	if existingService.UserID != userID && role != "admin" {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusForbidden,
				Message: "you are not authorized to update this service",
			},
		)
		return c.Status(fiber.StatusForbidden).JSON(HTTPFiberErrorResponse(errorList))
	}

	fmt.Println("input", updateInput)
	if role == "admin" {
		if updateInput.IsBanned || !updateInput.IsBanned {
			existingService.IsBanned = updateInput.IsBanned
		}
	}

	// Update the service model
	existingService.Name = updateInput.Name
	existingService.Description = updateInput.Description
	existingService.Price = updateInput.Price
	existingService.Status = updateInput.Status
	existingService.Duration = updateInput.Duration

	if updateInput.Latitude != 0 {
		existingService.Latitude = updateInput.Latitude
	}
	if updateInput.Longitude != 0 {
		existingService.Longitude = updateInput.Longitude
	}
	if updateInput.Address != "" {
		existingService.Address = updateInput.Address
	}
	if updateInput.City != "" {
		existingService.City = updateInput.City
	}
	if updateInput.PostalCode != "" {
		existingService.PostalCode = updateInput.PostalCode
	}
	if updateInput.Country != "" {
		existingService.Country = updateInput.Country
	}

	// Save the updated service to the DB
	if err := serviceRepo.Update(existingService); err != nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusInternalServerError,
				Message: "unable to update service",
			},
		)
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	_ = CreateLog(&LogObject{
		Level:      "info",
		Message:    "service updated successfully",
		RequestURI: c.OriginalURL(),
	})

	return c.SendStatus(http.StatusOK)
}

// DeleteService Godoc
// @Summary Delete Service
// @Description Delete a service
// @Tags Service
// @Produce json
// @Param id path string true "Service ID"
// @Success 200 {object} Response
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 403 {array} ErrorResponse
// @Failure 404 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /service/{id} [delete]
// @Security Bearer
func DeleteService(c *fiber.Ctx) error {
	var errorList []*fiber.Error
	serviceID := c.Params("id")
	if serviceID == "" {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "service id is required",
			},
		)
		_ = CreateLog(&LogObject{
			Level:      "warn",
			Type:       "Service",
			Message:    "service id is required",
			RequestURI: c.OriginalURL(),
		})
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	user := c.Locals("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)
	userID := claims["userID"]
	// Validate Input
	if userID == nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusInternalServerError,
				Message: "An error occurred while extracting user info from request",
			},
		)
		return c.Status(fiber.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	// Check if the service exists and the user is the owner
	existingService, err := serviceRepo.GetByIDUnscoped(serviceID)
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			errorList = append(
				errorList,
				&fiber.Error{
					Code:    fiber.StatusNotFound,
					Message: "Unable to find service with the given ID",
				},
			)
			return c.Status(http.StatusNotFound).JSON(HTTPFiberErrorResponse(errorList))
		}

		if existingService.IsBanned {
			errorList = append(
				errorList,
				&fiber.Error{
					Code:    fiber.StatusForbidden,
					Message: "Cannot delete a banned service",
				},
			)
			return c.Status(fiber.StatusForbidden).JSON(HTTPFiberErrorResponse(errorList))
		}

		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusForbidden,
				Message: "An error occurred while deleting service",
			},
		)
		return c.Status(http.StatusForbidden).JSON(HTTPFiberErrorResponse(errorList))
	}

	if existingService.UserID != userID {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusForbidden,
				Message: "you are not authorized to update this service",
			},
		)
		return c.Status(fiber.StatusForbidden).JSON(HTTPFiberErrorResponse(errorList))
	}

	// Save the updated service to the DB
	if err := serviceRepo.Delete(existingService); err != nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusInternalServerError,
				Message: "unable to delete service",
			},
		)
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	response := HTTPResponse(http.StatusOK, "Service Deleted", nil)

	_ = CreateLog(&LogObject{
		Level:      "info",
		Type:       "Service",
		Message:    "service deleted successfully",
		RequestURI: c.OriginalURL(),
	})
	return c.Status(http.StatusOK).JSON(response)
}

// SearchService Godoc
// @Summary Search services
// @Description Search services by name, price, categories, city, or country
// @Tags Service
// @Produce json
// @Param name query string false "Service Name"
// @Param min_price query number false "Minimum Price"
// @Param max_price query number false "Maximum Price"
// @Param city query string false "Service City"
// @Param country query string false "Service Country"
// @Param categories query string false "Service Categories (comma separated)"
// @Param latitude query number false "Service Latitude"
// @Param longitude query number false "Service Longitude"
// @Success 200 {array} ServiceOutput
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /service/search [get]
func SearchService(c *fiber.Ctx) error {
	var errorList []*fiber.Error

	// Get query parameters
	serviceName := c.Query("name")
	minPriceStr := c.Query("min_price")
	maxPriceStr := c.Query("max_price")
	serviceCity := c.Query("city")
	serviceCountry := c.Query("country")
	latitudeStr := c.Query("latitude")
	longitudeStr := c.Query("longitude")
	radiusStr := c.Query("radius")
	categoriesStr := c.Query("categories")

	// Validate and sanitize string inputs
	if !isValidName(serviceName) {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "Invalid service name",
			},
		)
	}
	if !isValidLocation(serviceCity) {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "Invalid city name",
			},
		)
	}
	if !isValidLocation(serviceCountry) {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "Invalid country name",
			},
		)
	}

	// Split and validate categories
	var categories []string
	if categoriesStr != "" {
		categories = strings.Split(categoriesStr, ",")
		for _, cat := range categories {
			if !isValidName(cat) {
				errorList = append(
					errorList,
					&fiber.Error{
						Code:    fiber.StatusBadRequest,
						Message: fmt.Sprintf("Invalid category name: %s", cat),
					},
				)
			}
		}
	}

	// Validate and convert price parameters
	var minPrice, maxPrice float64
	var err error

	if minPriceStr != "" {
		minPrice, err = strconv.ParseFloat(minPriceStr, 64)
		if err != nil {
			errorList = append(
				errorList,
				&fiber.Error{
					Code:    fiber.StatusBadRequest,
					Message: "Invalid minimum price value",
				},
			)
		}
	}

	if maxPriceStr != "" {
		maxPrice, err = strconv.ParseFloat(maxPriceStr, 64)
		if err != nil {
			errorList = append(
				errorList,
				&fiber.Error{
					Code:    fiber.StatusBadRequest,
					Message: "Invalid maximum price value",
				},
			)
		}
	}

	// Sanitize the price parameters
	if minPrice < 0 {
		minPrice = 0
	}

	if maxPrice < 0 {
		maxPrice = 0
	}

	if minPrice > maxPrice {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "Minimum price should be less than maximum price",
			},
		)
	}

	// Validate and convert latitude and longitude
	var latitude, longitude float64
	if latitudeStr != "" {
		latitude, err = strconv.ParseFloat(latitudeStr, 64)
		if err != nil {
			errorList = append(
				errorList,
				&fiber.Error{
					Code:    fiber.StatusBadRequest,
					Message: "Invalid latitude value",
				},
			)
		}
	}

	if longitudeStr != "" {
		longitude, err = strconv.ParseFloat(longitudeStr, 64)
		if err != nil {
			errorList = append(
				errorList,
				&fiber.Error{
					Code:    fiber.StatusBadRequest,
					Message: "Invalid longitude value",
				},
			)
		}
	}

	// Validate and convert radius
	const DefaultRadius = 10.0
	var radius float64 = DefaultRadius
	if radiusStr != "" {
		radius, err = strconv.ParseFloat(radiusStr, 64)
		if err != nil {
			errorList = append(
				errorList,
				&fiber.Error{
					Code:    fiber.StatusBadRequest,
					Message: "Invalid radius value",
				},
			)
		}
		if radius < 0 {
			radius = DefaultRadius
		}
	}

	// Return if any validation errors occurred
	if len(errorList) > 0 {
		return c.Status(fiber.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	// Fetch services based on the query parameters
	services, err := serviceRepo.SearchServices(serviceName, minPrice, maxPrice, serviceCity, serviceCountry, categories)
	if err != nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusInternalServerError,
				Message: "Error searching services",
			},
		)
		return c.Status(fiber.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	// Filter services based on distance if latitude and longitude are provided
	if latitude != 0 && longitude != 0 {
		services = filterServicesByDistance(services, latitude, longitude, radius)
	}

	// Map services to ServiceOutput
	var serviceOutputs []ServiceOutput
	for _, s := range services {
		serviceOutputs = append(serviceOutputs, *mapServiceToOutPut(&s))
	}

	// Check if serviceOutputs is empty
	if len(serviceOutputs) == 0 {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusNotFound,
				Message: "No services found",
			},
		)
		return c.Status(fiber.StatusNotFound).JSON(HTTPFiberErrorResponse(errorList))
	}

	_ = CreateLog(&LogObject{
		Level:      "info",
		Message:    "services fetched successfully",
		RequestURI: c.OriginalURL(),
	})

	return c.Status(fiber.StatusOK).JSON(serviceOutputs)
}

// GetTrendingServices Godoc
// @Summary Get trending services
// @Description Get trending services
// @Tags Service
// @Produce json
// @Success 200 {array} ServiceOutput
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /service/trending [get]
func GetTrendingServices(c *fiber.Ctx) error {
	var errorList []*fiber.Error
	services, err := serviceRepo.GetTrendingServices()
	if err != nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusInternalServerError,
				Message: "error getting trending services",
			},
		)
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	// Map services to ServiceOutput
	var ouput []ServiceOutput
	for _, s := range services {
		ouput = append(ouput, *mapServiceToOutPut(&s))
	}

	_ = CreateLog(&LogObject{
		Level:      "info",
		Message:    "trending services fetched successfully",
		RequestURI: c.OriginalURL(),
	})

	return c.Status(http.StatusOK).JSON(ouput)
}

// GetAllBannedServices Godoc
// @Summary Get all banned services
// @Description Get all banned services
// @Tags Service
// @Produce json
// @Success 200 {array} ServiceOutput
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /service/bans [get]
func GetAllBannedServices(c *fiber.Ctx) error {
	services, err := serviceRepo.GetAllBannedServices()
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
			"error": "Error fetching banned services",
		})
	}

	var serviceOutputs []ServiceOutput
	for _, s := range services {
		serviceOutputs = append(serviceOutputs, *mapServiceToOutPut(&s))
	}

	_ = CreateLog(&LogObject{
		Level:      "info",
		Message:    "banned services fetched successfully",
		RequestURI: c.OriginalURL(),
	})

	return c.Status(http.StatusOK).JSON(serviceOutputs)
}

// ============================================================
// =================== Private Methods ========================
// ============================================================

func mapServiceToOutPut(u *service.Service) *ServiceOutput {
	imageUrls := make([]string, len(u.Images))
	for i, img := range u.Images {
		imageUrls[i] = img.URL
	}
	categoriesNames := make([]string, len(u.Categories))
	for i, cat := range u.Categories {
		categoriesNames[i] = cat.Name
	}
	user, err := userRepo.GetById(u.UserID)
	if err != nil {
		return nil
	}
	CustomUser := CustomUser{
		ID:        u.UserID,
		Email:     user.Email,
		FristName: user.Firstname,
		LastName:  user.Lastname,
		Bio:       user.Bio,
		Member:    user.Member[len(user.Member)-1].Status,
		CreateAt:  user.CreatedAt.Format("2006-01-02"),
	}

	//trim the object booking
	var customBooking []CustomBooking
	for _, booking := range u.Bookings {
		customBooking = append(customBooking, CustomBooking{
			BookingID: booking.ID,
			StartAt:   booking.StartTime.Format("2006-01-02"),
			EndAt:     booking.EndTime.Format("2006-01-02"),
		})
	}
	//if empty return []
	if len(customBooking) == 0 {
		customBooking = []CustomBooking{}
	}

	return &ServiceOutput{
		ServiceID:   u.ID,
		UserID:      u.UserID,
		Name:        u.Name,
		Description: u.Description,
		Price:       u.Price,
		Status:      u.Status,
		Duration:    u.Duration,
		IsBanned:    u.IsBanned,
		Latitude:    u.Latitude,
		Longitude:   u.Longitude,
		Address:     u.Address,
		City:        u.City,
		PostalCode:  u.PostalCode,
		Country:     u.Country,
		Images:      imageUrls,
		Category:    categoriesNames,
		User:        CustomUser,
		Bookings:    customBooking,
		CreatedAt:   u.CreatedAt.Format("2006-01-02 15:04:05"),
	}
}

// isValidName validates the service name using a regex
func isValidName(name string) bool {
	if name == "" {
		return true // If name is empty, it's considered valid (optional parameter)
	}
	re := regexp.MustCompile(`^[\p{L}\s]+$`)
	return re.MatchString(name)
}

// isValidLocation validates the city or country name using a regex
func isValidLocation(location string) bool {
	if location == "" {
		return true // If location is empty, it's considered valid (optional parameter)
	}
	re := regexp.MustCompile(`^[\p{L}\s]+$`)
	return re.MatchString(location)
}

// haversine calculates the distance between two points specified by latitude/longitude using the Haversine formula
func haversine(lat1, lon1, lat2, lon2 float64) float64 {
	const EarthRadius = 6371.0097714 // Earth's radius in kilometers
	dLat := degreesToRadians(lat2 - lat1)
	dLon := degreesToRadians(lon2 - lon1)

	lat1 = degreesToRadians(lat1)
	lat2 = degreesToRadians(lat2)

	a := math.Sin(dLat/2)*math.Sin(dLat/2) +
		math.Sin(dLon/2)*math.Sin(dLon/2)*math.Cos(lat1)*math.Cos(lat2)
	c := 2 * math.Atan2(math.Sqrt(a), math.Sqrt(1-a))

	return EarthRadius * c
}

func degreesToRadians(degrees float64) float64 {
	return degrees * math.Pi / 180
}

func filterServicesByDistance(services []service.Service, latitude, longitude float64, maxDistanceKm float64) []service.Service {
	var filteredServices []service.Service

	for _, s := range services {
		distance := haversine(latitude, longitude, s.Latitude, s.Longitude)
		fmt.Println("Distance:", distance)
		if distance <= maxDistanceKm {
			filteredServices = append(filteredServices, s)
		}
	}

	return filteredServices
}
