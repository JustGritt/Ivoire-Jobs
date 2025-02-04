package controllers

import (
	validator "barassage/api/common/validator"
	"barassage/api/models/booking"
	"barassage/api/models/contact"
	bookingRepo "barassage/api/repositories/booking"
	contactRepo "barassage/api/repositories/contact"
	serviceRepo "barassage/api/repositories/service"
	userRepo "barassage/api/repositories/user"
	"barassage/api/services/notification"
	"barassage/api/services/stripe"
	"log"
	"net/http"
	"time"

	"github.com/gofiber/fiber/v2"
	jwt "github.com/golang-jwt/jwt/v4"
	"github.com/google/uuid"
)

// BookingObject is the structure of the booking
type BookingObject struct {
	BookingID string    `json:"-"`
	UserID    string    `json:"-"`
	ServiceID uuid.UUID `json:"serviceID" validate:"required" message:"serviceID is required"`
	Status    string    `json:"-" `
	CreatorID string    `json:"-"`
	StartTime time.Time `json:"startTime" validate:"required" message:"startTime is required"`
	Contact   Contact   `json:"contact" validate:"required"`
	EndTime   time.Time `json:"-"`
}

type Contact struct {
	Phone      string  `json:"phone" validate:"required,phone"`
	Address    string  `json:"address" validate:"required"`
	City       string  `json:"city" validate:"required"`
	Country    string  `json:"country" validate:"required"`
	PostalCode string  `json:"postalCode" validate:"required"`
	Latitude   float64 `json:"latitude" validate:"required"`
	Longitude  float64 `json:"longitude" validate:"required"`
}

type UpdateBookingObject struct {
	Status string `json:"status" validate:"required,oneof=confirmed canceled" message:"status is required and must be one of confirmed, canceled"`
}

// BookingOutput is the output format of the booking
type BookingOutput struct {
	BookingID string    `json:"ID"`
	UserID    string    `json:"userID"`
	Status    string    `json:"status"`
	StartTime time.Time `json:"startTime"`
	EndTime   time.Time `json:"endTime"`
	Contact   Author    `json:"contact"`
	Service   Service   `json:"service"`
}

type Service struct {
	ID          string    `json:"ID"`
	UserID      string    `json:"userID"`
	Title       string    `json:"title"`
	Description string    `json:"description"`
	Price       float64   `json:"price"`
	Duration    int       `json:"duration"`
	Images      []Image   `json:"image"`
	CreatedAt   time.Time `json:"createdAt"`
}
type Image struct {
	URL string `json:"url"`
}

type Author struct {
	ID        string    `json:"ID"`
	FirstName string    `json:"firstName"`
	LastName  string    `json:"lastName"`
	Email     string    `json:"email"`
	Address   string    `json:"address"`
	City      string    `json:"city"`
	CreatedAt time.Time `json:"createdAt"`
}

type ServiceBookingOutput struct {
	BookingID string    `json:"ID"`
	UserID    string    `json:"userID"`
	ServiceID string    `json:"serviceID"`
	Status    string    `json:"status"`
	StartTime time.Time `json:"startTime"`
	EndTime   time.Time `json:"endTime"`
	Contact   Contact   `json:"contact"`
}

// CreateBooking Godoc
// @Summary CreateBooking
// @Description Creates a booking
// @Tags Booking
// @Produce json
// @Param payload body BookingObject true "CreateBooking Body"
// @Success 201 {object} Response
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /booking [post]
func CreateBooking(c *fiber.Ctx) error {
	var bookingObj BookingObject
	var errorList []*fiber.Error

	// Parse the request body
	if err := validator.ParseBodyAndValidate(c, &bookingObj); err != nil {
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
		//create log
		_ = CreateLog(&LogObject{
			Level:      "warn",
			Type:       "User",
			Message:    "Error while extracting user info from request",
			RequestURI: c.OriginalURL(),
		})

		return c.Status(fiber.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	// Retrieve the service
	service, err := serviceRepo.GetByID(bookingObj.ServiceID.String())
	if err != nil {
		errorList = append(errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "Error while fetching service",
			},
		)
		_ = CreateLog(&LogObject{
			Level:      "warn",
			Type:       "Booking",
			Message:    "Error while fetching service",
			RequestURI: c.OriginalURL(),
		})
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	//check if the user is booking is own service
	if service.UserID == userID {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "You can't book your own service",
			},
		)
		_ = CreateLog(&LogObject{
			Level:      "info",
			Type:       "Booking",
			Message:    "You can't book your own service",
			RequestURI: c.OriginalURL(),
		})
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	// Convert datatypes.Date to time.Time for calculation
	startTime := time.Time(bookingObj.StartTime)

	// Calculate the EndTime based on service duration in minutes
	serviceDuration := time.Duration(service.Duration) * time.Minute
	serviceEndTime := startTime.Add(serviceDuration)

	// Convert the booking object to a booking model
	bookingModel := bookingModelFromObject(&bookingObj)
	bookingModel.UserID = userID.(string)
	bookingModel.EndTime = serviceEndTime
	bookingModel.CreatorID = service.UserID

	//check if the user if member
	dbUser, err := userRepo.GetById(bookingModel.UserID)
	if err != nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusInternalServerError,
				Message: "Error while fetching user",
			},
		)
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	// Check for overlapping Booking
	overlap, err := bookingRepo.CheckBookingOverlap(bookingModel.UserID, startTime, serviceEndTime)
	if err != nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "Error while checking booking overlap",
			},
		)
		_ = CreateLog(&LogObject{
			Level:      "warn",
			Type:       "Booking",
			Message:    "Error while checking booking overlap",
			RequestURI: c.OriginalURL(),
		})
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}
	if overlap {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "Booking overlap. Please select another time slot.",
			},
		)
		_ = CreateLog(&LogObject{
			Level:      "info",
			Type:       "Booking",
			Message:    "Booking overlap. Please select another time slot.",
			RequestURI: c.OriginalURL(),
		})
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	// Create the contact and associate it with the booking
	contactModel := contact.Contact{
		ID:         uuid.New().String(),
		Phone:      bookingObj.Contact.Phone,
		Address:    bookingObj.Contact.Address,
		City:       bookingObj.Contact.City,
		Country:    bookingObj.Contact.Country,
		PostalCode: bookingObj.Contact.PostalCode,
		Latitude:   bookingObj.Contact.Latitude,
		Longitude:  bookingObj.Contact.Longitude,
	}

	// Create the contact
	contact := contactRepo.Create(&contactModel)
	if contact != nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusInternalServerError,
				Message: "Error while creating contact",
			},
		)
		_ = CreateLog(&LogObject{
			Level:      "warn",
			Type:       "Booking",
			Message:    "Error while creating contact",
			RequestURI: c.OriginalURL(),
		})
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	bookingModel.ContactID = contactModel.ID
	// Create the booking
	err = bookingRepo.Create(bookingModel)
	if err != nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusInternalServerError,
				Message: "Error while creating booking and contact",
			},
		)
		_ = CreateLog(&LogObject{
			Level:      "warn",
			Type:       "Booking",
			Message:    "Error while creating booking and contact",
			RequestURI: c.OriginalURL(),
		})
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	// create the stripe intent
	pi, err := stripe.CreatePaymentIntent(bookingModel)
	if err != nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusInternalServerError,
				Message: "Error while creating payment intent",
			},
		)
		_ = CreateLog(&LogObject{
			Level:      "warn",
			Type:       "Booking",
			Message:    "Error while creating payment intent",
			RequestURI: c.OriginalURL(),
		})
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	// Send FCM notification
	message := map[string]string{
		"Title": "Booking created!",
		"Body":  "Your booking has been created successfully",
	}

	if dbUser.NotificationPreference != nil {
		domain := notification.BookingDomain
		resp, err := notification.Send(c.Context(), message, dbUser, domain)
		if err != nil {
			log.Printf("error sending message: %v", err)
		} else {
			log.Printf("%d messages were sent successfully\n", resp.SuccessCount)
		}
	}

	return c.Status(http.StatusCreated).JSON(fiber.Map{
		"booking":       bookingOutputFromModel(bookingModel),
		"paymentIntent": &pi.ClientSecret,
	})
}

// GetBookingService Godoc
// @Summary GetBookingService
// @Description Get all bookings for a service
// @Tags Booking
// @Produce json
// @Param serviceID path string true "Service ID"
// @Success 200 {array} BookingOutput
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /service/{serviceID}/booking [get]
func GetBookingService(c *fiber.Ctx) error {
	var errorList []*fiber.Error

	serviceID := c.Params("id")
	if serviceID == "" {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "Service ID is required",
			},
		)
		_ = CreateLog(&LogObject{
			Level:      "warn",
			Type:       "Booking",
			Message:    "Service ID is required",
			RequestURI: c.OriginalURL(),
		})
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}
	//get the service
	service, err := serviceRepo.GetByID(serviceID)
	if err != nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "Error while fetching service",
			},
		)
		_ = CreateLog(&LogObject{
			Level:      "info",
			Type:       "Booking",
			Message:    "Error while fetching service",
			RequestURI: c.OriginalURL(),
		})
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	//check if the service is for the current user
	user := c.Locals("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)
	userID := claims["userID"]
	if userID == nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusInternalServerError,
				Message: "An error occurred while extracting user info from request",
			},
		)
		_ = CreateLog(&LogObject{
			Level:      "info",
			Type:       "Booking",
			Message:    "Error while extracting user info from request",
			RequestURI: c.OriginalURL(),
		})
		return c.Status(fiber.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	if service.UserID != userID {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "Unauthorized",
			},
		)
		_ = CreateLog(&LogObject{
			Level:      "info",
			Type:       "Booking",
			Message:    "Unauthorized access",
			RequestURI: c.OriginalURL(),
		})

		return c.Status(fiber.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	// get the bookings
	bookings, err := bookingRepo.GetBookingsByServiceID(serviceID)
	if err != nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "Error while fetching bookings",
			},
		)
		_ = CreateLog(&LogObject{
			Level:      "info",
			Type:       "Booking",
			Message:    "Error while fetching bookings",
			RequestURI: c.OriginalURL(),
		})
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	//map the bookings to the output
	var bookingsOutput []ServiceBookingOutput

	for _, booking := range bookings {
		bookingsOutput = append(bookingsOutput, *serviceBookingOuputFromModel(&booking))
	}

	if len(bookingsOutput) == 0 {
		return c.Status(http.StatusOK).JSON([]ServiceBookingOutput{})
	}

	_ = CreateLog(&LogObject{
		Level:      "info",
		Type:       "Booking",
		Message:    "Bookings fetched",
		RequestURI: c.OriginalURL(),
	})

	// Return the bookings
	return c.Status(http.StatusOK).JSON(bookingsOutput)
}

// GetBookings Godoc
// @Summary GetBookings
// @Description Get all bookings
// @Tags Booking
// @Produce json
// @Success 200 {array} BookingOutput
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /booking/collection [get]
func GetBookings(c *fiber.Ctx) error {
	var bookings []booking.Booking
	var errorList []*fiber.Error

	user := c.Locals("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)
	userID := claims["userID"]
	role := claims["role"]
	// Validate Input
	if userID == nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "can't extract user info from request",
			},
		)
		_ = CreateLog(&LogObject{
			Level:      "info",
			Type:       "User",
			Message:    "Error while extracting user info from request",
			RequestURI: c.OriginalURL(),
		})
		return c.Status(fiber.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	// get the user
	var err error
	if role == "admin" {
		bookings, err = bookingRepo.GetAll()
	} else {
		bookings, err = bookingRepo.GetBookingsByUserID(userID.(string))
	}
	if err != nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "Error while fetching bookings",
			},
		)
		_ = CreateLog(&LogObject{
			Level:      "info",
			Type:       "Booking",
			Message:    "Error while fetching bookings",
			RequestURI: c.OriginalURL(),
		})
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	//if bookings is empty return empty array
	if len(bookings) == 0 {
		return c.Status(http.StatusOK).JSON([]BookingOutput{})
	}

	_ = CreateLog(&LogObject{
		Level:      "info",
		Type:       "Booking",
		Message:    "Bookings fetched",
		RequestURI: c.OriginalURL(),
	})

	//map the bookings to the output
	var bookingsOutput []BookingOutput
	for _, booking := range bookings {
		service, err := serviceRepo.GetByID(booking.ServiceID)
		if err != nil {
			errorList = append(
				errorList,
				&fiber.Error{
					Code:    fiber.StatusBadRequest,
					Message: "Error while fetching service",
				},
			)
			return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
		}
		user, err := userRepo.GetById(booking.UserID)
		if err != nil {
			errorList = append(
				errorList,
				&fiber.Error{
					Code:    fiber.StatusBadRequest,
					Message: "Error while fetching contact user",
				},
			)
			return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
		}
		var images []Image
		for _, image := range service.Images {
			images = append(images, Image{
				URL: image.URL,
			})
		}
		if len(images) == 0 {
			images = []Image{}
		}

		contactUser, err := contactRepo.GetByID(booking.ContactID)
		if err != nil {
			errorList = append(
				errorList,
				&fiber.Error{
					Code:    fiber.StatusBadRequest,
					Message: "Error while fetching contact user",
				},
			)
			return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
		}

		bookingsOutput = append(bookingsOutput, BookingOutput{
			BookingID: booking.ID,
			UserID:    booking.UserID,
			Service: Service{
				ID:          service.ID,
				UserID:      service.UserID,
				Title:       service.Name,
				Description: service.Description,
				Price:       service.Price,
				Images:      images,
				Duration:    service.Duration,
				CreatedAt:   service.CreatedAt,
			},
			Status:    booking.Status,
			StartTime: booking.StartTime,
			EndTime:   booking.EndTime,
			Contact: Author{
				ID:        user.ID,
				FirstName: user.Firstname,
				LastName:  user.Lastname,
				Email:     user.Email,
				Address:   contactUser.Address,
				City:      contactUser.City,
				CreatedAt: user.CreatedAt,
			},
		})
	}

	// Return the bookings
	return c.Status(http.StatusOK).JSON(bookingsOutput)
}

// UpdateBooking Godoc
// @Summary UpdateBooking
// @Description Updates a booking
// @Tags Booking
// @Produce json
// @Param bookingID path string true "Booking ID"
// @Param payload body BookingObject true "UpdateBooking Body"
// @Success 200 {object} Response
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /booking/{bookingID} [put]
func UpdateBooking(c *fiber.Ctx) error {
	var booking UpdateBookingObject
	var errorList []*fiber.Error

	// Parse the request body
	if err := validator.ParseBodyAndValidate(c, &booking); err != nil {
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(err))
	}

	// Retrieve the booking ID
	bookingID := c.Params("id")

	// Retrieve the booking
	bookingModel, err := bookingRepo.GetByID(bookingID)
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	//check if the booking is for the current user
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

	if bookingModel.UserID != userID {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "Unauthorized",
			},
		)
		return c.Status(fiber.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	// Convert the booking object to a booking model
	bookingModel.Status = booking.Status

	// Update the booking
	if err := bookingRepo.Update(bookingModel); err != nil {
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	// Switch case to handle the status
	switch booking.Status {
	case "confirmed":
		pi, err := stripe.CreatePaymentIntent(bookingModel)
		if err != nil {
			return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
				"error": err.Error(),
			})
		}
		log.Println("Handle confirmation of booking")
		//create an object with the payment intent and the booking
		//send the object to the client
		return c.Status(http.StatusOK).JSON(fiber.Map{
			"booking":       bookingOutputFromModel(bookingModel),
			"paymentIntent": &pi,
		})

	case "canceled":
		log.Println("Handle cancellation of booking")
		return c.Status(http.StatusOK).JSON(bookingOutputFromModel(bookingModel))
	default:
		log.Println("Invalid status")
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "Sorry unable to process the request",
			},
		)

		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

}

// GetBooking Godoc
// @Summary GetAllBookingsForUser
// @Description Get all bookings for a user
// @Tags Booking
// @Produce json
// @Success 200 {array} BookingOutput
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /booking/user [get]
func GetAllBookingsForUser(c *fiber.Ctx) error {
	var errorList []*fiber.Error
	user := c.Locals("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)
	userID := claims["userID"]
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
	// get the bookings
	bookings, err := bookingRepo.GetBookingsByUserID(userID.(string))
	if err != nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "Error while fetching bookings",
			},
		)
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	//if bookings is empty return empty array
	if len(bookings) == 0 {
		return c.Status(http.StatusOK).JSON([]BookingOutput{})
	}

	// Return the bookings
	return c.Status(http.StatusOK).JSON(bookings)
}

// ============================================================
// =================== Private Methods ========================
// ============================================================

func bookingModelFromObject(u *BookingObject) *booking.Booking {
	return &booking.Booking{
		ID:        uuid.New().String(),
		UserID:    u.UserID,
		ServiceID: u.ServiceID.String(),
		Status:    u.Status,
		StartTime: u.StartTime,
		EndTime:   u.EndTime,
	}
}

func serviceBookingOuputFromModel(u *booking.Booking) *ServiceBookingOutput {
	return &ServiceBookingOutput{
		BookingID: u.ID,
		UserID:    u.UserID,
		ServiceID: u.ServiceID,
		Status:    u.Status,
		StartTime: u.StartTime,
		EndTime:   u.EndTime,
		Contact: Contact{
			Phone:      u.Contact.Phone,
			Address:    u.Contact.Address,
			City:       u.Contact.City,
			Country:    u.Contact.Country,
			PostalCode: u.Contact.PostalCode,
			Latitude:   u.Contact.Latitude,
			Longitude:  u.Contact.Longitude,
		},
	}
}

func bookingOutputFromModel(u *booking.Booking) *BookingOutput {
	return &BookingOutput{
		BookingID: u.ID,
		UserID:    u.UserID,
		Status:    u.Status,
		StartTime: u.StartTime,
		EndTime:   u.EndTime,
	}
}
