package controllers

import (
	"barassage/api/bucket"
	validator "barassage/api/common/validator"
	"barassage/api/models/service"
	serviceRepo "barassage/api/repositories/service"
	"fmt"
	"log"
	"mime/multipart"
	"net/http"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type ServiceObject struct {
	ServiceID   string                `json:"-"`
	UserID      string                `json:"-"`
	Name        string                `json:"name" validate:"required,min=2,max=30"`
	Description string                `json:"description" validate:"required,min=2,max=30"`
	Price       float64               `json:"price" validate:"required,min=5,max=1000000"`
	Status      bool                  `json:"status" default:"false"`
	Duration    int                   `json:"duration" validate:"required,min=30,max=1440" message:"Duration must be between 30 and 1440 minutes"`
	IsBanned    bool                  `json:"-"`
	Thumbnail   *multipart.FileHeader `json:"thumbnail"`
}

type ServiceOutput struct {
	ServiceID   string  `json:"id"`
	UserID      string  `json:"userId"`
	Name        string  `json:"name"`
	Description string  `json:"description"`
	Price       float64 `json:"price"`
	Status      bool    `json:"status"`
	Duration    int     `json:"duration"`
	IsBanned    bool    `json:"isBanned"`
	Thumbnail   string  `json:"thumbnail"`
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
// @Router /service/create [post]
// @Security Bearer
func CreateService(c *fiber.Ctx) error {
	var serviceInput ServiceObject
	if err := validator.ParseBodyAndValidate(c, &serviceInput); err != nil {
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(err))
	}

	user := c.Locals("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)
	userID := claims["userID"]
	// Validate Input
	if userID == nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"msg": "can't extract user info from request",
		})
	}

	// Handle file upload
	file, err := c.FormFile("thumbnail")
	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{
			"msg": "thumbnail file is required",
		})
	}

	allowedMimeTypes := []string{"jpeg", "webp", "png", "jpg"}
	maxFileSize := "100KB"

	if err := validator.ValidateFile(file, maxFileSize, allowedMimeTypes); err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{
			"msg": err.Error(),
		})
	}

	//store in s3 Bucket
	// Upload the file to S3
	s3URL, err := bucket.UploadFile(file)
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
			"msg": "unable to upload thumbnail to S3",
		})
	}

	//get the presigned url
	mytest, err := bucket.GetPresignedURL(s3URL)
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
			"msg": "unable to get presigned url",
		})
	}

	log.Println("Presigned URL: ", mytest)

	//map the input to service model
	s := service.Service{
		UserID:      serviceInput.UserID,
		Name:        serviceInput.Name,
		Description: serviceInput.Description,
		Price:       serviceInput.Price,
		Status:      serviceInput.Status,
		Duration:    serviceInput.Duration,
		IsBanned:    serviceInput.IsBanned,
		Thumbnail:   s3URL,
		ID:          uuid.New().String(),
	}

	s.UserID = userID.(string)

	// Check if the service already exists for the given user
	if _, err := serviceRepo.GetServiceByNameForUser(s.Name, s.UserID); err == nil {
		response := HTTPResponse(http.StatusForbidden, "Service Already Exist", nil)
		return c.Status(http.StatusForbidden).JSON(response)
	}

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

		errorList := []*Response{
			{
				Code:    http.StatusConflict,
				Message: "Service Already Exist",
				Data:    nil,
			},
		}
		response := HTTPResponse(http.StatusInternalServerError, "Service Not Registered", errorList)
		return c.Status(http.StatusInternalServerError).JSON(response)
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
	services, err := serviceRepo.GetAllServices()
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
			"msg": "error getting services",
		})
	}

	return c.Status(http.StatusOK).JSON(services)
}

// GetServiceByUserId Godoc
// @Summary Get all services by user id
// @Description Get all services by user id
// @Tags Service
// @Produce json
// @Success 200 {array} ServiceOutput
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /service/collection/user [get]
func GetServiceByUserId(c *fiber.Ctx) error {
	user := c.Locals("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)
	userID := claims["userID"]
	// Validate Input
	if userID == nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"msg": "can't extract user info from request",
		})
	}

	services, err := serviceRepo.GetServicesByUserID(userID.(string))
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
			"msg": "error getting services",
		})
	}

	return c.Status(http.StatusOK).JSON(services)
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
	if serviceID == "" {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{
			"msg": "service id is required",
		})
	}

	service, err := serviceRepo.GetByID(serviceID)
	if err != nil {
		return c.Status(http.StatusNotFound).JSON(fiber.Map{
			"msg": "service not found",
		})
	}

	return c.Status(http.StatusOK).JSON(service)
}

// ============================================================
// =================== Private Methods ========================
// ============================================================

/*
func mapInputToServiceObject(service ServiceObject) service.Service {
	return service.Service{
		UserID:    service.UserID,
		Name:      service.Name,
		ServiceID: uuid.New().String(),
		Price:     service.Price,
		Status:    service.Status,
		Duration:  service.Duration,
		Thumbnail: service.Thumbnail,
	}
}
*/

func mapServiceToOutPut(u *service.Service) *ServiceOutput {
	return &ServiceOutput{
		ServiceID:   u.ID,
		UserID:      u.UserID,
		Name:        u.Name,
		Description: u.Description,
		Price:       u.Price,
		Status:      u.Status,
		Duration:    u.Duration,
		IsBanned:    u.IsBanned,
		Thumbnail:   u.Thumbnail,
	}
}
