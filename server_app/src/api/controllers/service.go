package controllers

import (
	validator "barassage/api/common/validator"
	"barassage/api/models/service"
	serviceRepo "barassage/api/repositories/service"
	"barassage/api/services/bucket"
	"strconv"

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
	ServiceID   string                `json:"-"`
	UserID      string                `json:"-"`
	Name        string                `json:"name" validate:"required,min=2,max=30"`
	Description string                `json:"description" validate:"required,min=2,max=30"`
	Price       float64               `json:"price" validate:"required,min=5,max=1000000"`
	Status      bool                  `json:"status" default:"false"`
	Duration    int                   `json:"duration" validate:"required,min=30,max=1440,step=30" message:"Duration must be a multiple of 30 and it should be beetween 30 and 1440"`
	IsBanned    bool                  `json:"-"`
	Thumbnail   *multipart.FileHeader `json:"thumbnail" form:"thumbnail" swaggertype:"string"`
}

type ServiceUpdateObject struct {
	Name        string  `json:"name" validate:"required,min=2,max=30"`
	Description string  `json:"description" validate:"required,min=2,max=30"`
	Price       float64 `json:"price" validate:"required,min=5,max=1000000"`
	Status      bool    `json:"status" default:"false"`
	Duration    int     `json:"duration" validate:"required,min=30,max=1440,step=30" message:"Duration must be a multiple of 30 and it should be beetween 30 and 1440"`
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

	// Handle file upload
	file, err := c.FormFile("thumbnail")
	var s3URL string
	if err == nil {
		allowedMimeTypes := []string{"jpeg", "png", "jpg"}
		maxFileSize := "4MB"

		if err := validator.ValidateFile(file, maxFileSize, allowedMimeTypes); err != nil {
			return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(err))
		}

		// Upload the file to S3
		s3URL, err = bucket.UploadFile(file)
		if err != nil {
			errorList = append(
				errorList,
				&fiber.Error{
					Code:    fiber.StatusBadRequest,
					Message: "unable to upload thumbnail to S3",
				},
			)
			return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
		}
	}

	/*
		//get the presigned url
		mytest, err := bucket.GetPresignedURL(s3URL)
		if err != nil {
			return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
				"msg": "unable to get presigned url",
			})
		}

		log.Println("Presigned URL: ", mytest)
	*/

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

		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusConflict,
				Message: "this service already exist",
			},
		)

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
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
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
	var errorList []*fiber.Error
	if userID == nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "An error occurred while extracting user info from request",
			},
		)
		return c.Status(fiber.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	services, err := serviceRepo.GetServicesByUserID(userID.(string))
	if err != nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusInternalServerError,
				Message: "error getting services",
			},
		)
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
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
	var errorList []*fiber.Error
	if serviceID == "" {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "service id is required",
			},
		)
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
		return c.Status(http.StatusNotFound).JSON(HTTPFiberErrorResponse(errorList))
	}

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
	existingService, err := serviceRepo.GetByID(serviceID)
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
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusForbidden,
				Message: "An error occurred while updating service",
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

	if updateInput.IsBanned && existingService.IsBanned != updateInput.IsBanned {
		role := claims["role"].(string)
		if role != "admin" {
			errorList = append(
				errorList,
				&fiber.Error{
					Code:    fiber.StatusForbidden,
					Message: "You must be an admin to edit isBanned",
				},
			)
			return c.Status(http.StatusForbidden).JSON(HTTPFiberErrorResponse(errorList))
		}

		existingService.IsBanned = updateInput.IsBanned

	}

	// Handle file upload if a new thumbnail is provided
	file, err := c.FormFile("thumbnail")
	var s3URL string
	if err == nil {
		allowedMimeTypes := []string{"jpeg", "webp", "png", "jpg"}
		maxFileSize := "4MB"

		if err := validator.ValidateFile(file, maxFileSize, allowedMimeTypes); err != nil {
			return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(err))
		}

		// Upload the file to S3
		s3URL, err = bucket.UploadFile(file)
		if err != nil {
			errorList = append(
				errorList,
				&fiber.Error{
					Code:    fiber.StatusInternalServerError,
					Message: "unable to upload thumbnail to S3",
				},
			)

			return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
		}
	}

	// Update the service model
	existingService.Name = updateInput.Name
	existingService.Description = updateInput.Description
	existingService.Price = updateInput.Price
	existingService.Status = updateInput.Status
	existingService.Duration = updateInput.Duration

	if s3URL != "" {
		existingService.Thumbnail = s3URL
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

	serviceOutput := mapServiceToOutPut(existingService)
	response := HTTPResponse(http.StatusOK, "Service Updated", serviceOutput)
	return c.Status(http.StatusOK).JSON(response)
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
	existingService, err := serviceRepo.GetByID(serviceID)
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
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusForbidden,
				Message: "An error occurred while updating service",
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
	return c.Status(http.StatusOK).JSON(response)
}

// SearchService Godoc
// @Summary Search services
// @Description Search services by name, price, or both
// @Tags Service
// @Produce json
// @Param name query string false "Service Name"
// @Param min_price query float false "Minimum Price"
// @Param max_price query float false "Maximum Price"
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
			return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
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
			return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
		}
	}

	// Fetch services based on the query parameters
	services, err := serviceRepo.SearchServices(serviceName, minPrice, maxPrice)
	if err != nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusInternalServerError,
				Message: "Error searching services",
			},
		)
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	// Map services to ServiceOutput
	var serviceOutputs []ServiceOutput
	for _, s := range services {
		serviceOutputs = append(serviceOutputs, *mapServiceToOutPut(&s))
	}

	//check if the serviceOuputs is empty
	if len(serviceOutputs) == 0 {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusNotFound,
				Message: "No services found",
			},
		)
		return c.Status(http.StatusNotFound).JSON(HTTPFiberErrorResponse(errorList))
	}

	return c.Status(http.StatusOK).JSON(serviceOutputs)
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
