package controllers

import (
	validator "barassage/api/common/validator"
	"barassage/api/models/service"
	serviceRepo "barassage/api/repositories/service"
	"fmt"
	"net/http"

	"github.com/form3tech-oss/jwt-go"
	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type ServiceObject struct {
	ServiceID   string  `json:"-"`
	UserID      string  `json:"userId"`
	Name        string  `json:"name" validate:"required,min=2,max=30"`
	Description string  `json:"description" validate:"required,min=2,max=30"`
	Price       float64 `json:"price" validate:"required"`
	Status      bool    `json:"status"`
	Duration    int     `json:"duration" validate:"required"`
	IsBanned    bool    `json:"isBanned"`
	Thumbnail   string  `json:"thumbnail"`
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

	s := mapInputToServiceObject(serviceInput)

	// Check if the service already exists for the given user
	if _, err := serviceRepo.GetServiceByNameForUser(s.Name, s.UserID); err == nil {
		response := HTTPResponse(http.StatusForbidden, "Service Already Exist", nil)
		return c.Status(http.StatusForbidden).JSON(response)
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

	s.UserID = userID.(string)

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
