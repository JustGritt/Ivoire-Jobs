package controllers

import (
	notificationRepo "barassage/api/repositories/notificationPreference"
	"errors"

	validator "barassage/api/common/validator"
	"barassage/api/models/notificationPreference"

	"net/http"

	"github.com/gofiber/fiber/v2"
	jwt "github.com/golang-jwt/jwt/v4"
	"gorm.io/gorm"
)

// NotificationPrefObject struct
type NotificationPrefObject struct {
	UserID              string `json:"-"`
	PushNotification    bool   `json:"pushNotification" validate:"boolean"`
	BookingNotification bool   `json:"bookingNotification" validate:"boolean"`
	MessageNotification bool   `json:"messageNotification" validate:"boolean"`
	ServiceNotification bool   `json:"serviceNotification" validate:"boolean"`
}

// CreateNotificationPreference handles the creation of a new notification preference.
// @Summary Create Notification Preference
// @Description Create a notification preference
// @Tags NotificationPreference
// @Produce json
// @Param payload body NotificationPrefObject true "Notification Preference Body"
// @Success 200 {object} NotificationPrefObject
// @Failure 400 {array} ErrorResponse
// @Router /notification-preference [put]
// @Security Bearer
func CreateOrUpdateNotificationPreference(c *fiber.Ctx) error {
	var notificationPreferenceInput NotificationPrefObject
	var errorList []*fiber.Error

	// Parse and validate the input
	if err := validator.ParseBodyAndValidate(c, &notificationPreferenceInput); err != nil {
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(err))
	}

	// Extract user information from JWT
	user := c.Locals("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)
	userID := claims["userID"]

	// Validate userID
	if userID == nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "User ID is required",
			},
		)
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	// Check if a preference already exists
	notificationPreference, err := notificationRepo.GetByUserID(userID.(string))
	if err != nil && !errors.Is(err, gorm.ErrRecordNotFound) {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusInternalServerError,
				Message: "Error retrieving notification preference",
			},
		)
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	// Create a new preference if none exists
	if notificationPreference == nil {
		notificationPreferenceInput.UserID = userID.(string)

		err = notificationRepo.Create(mapInputToPreference(notificationPreferenceInput))
		if err != nil {
			errorList = append(
				errorList,
				&fiber.Error{
					Code:    fiber.StatusInternalServerError,
					Message: "Error creating notification preference",
				},
			)
			return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
		}
	} else {
		// Update the existing preference
		notificationPreference.PushNotification = notificationPreferenceInput.PushNotification
		notificationPreference.BookingNotification = notificationPreferenceInput.BookingNotification
		notificationPreference.MessageNotification = notificationPreferenceInput.MessageNotification
		notificationPreference.ServiceNotification = notificationPreferenceInput.ServiceNotification

		err = notificationRepo.Update(notificationPreference)
		if err != nil {
			errorList = append(
				errorList,
				&fiber.Error{
					Code:    fiber.StatusInternalServerError,
					Message: "Error updating notification preference",
				},
			)
			return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
		}
	}

	return c.Status(http.StatusOK).JSON(notificationPreferenceInput)
}

// GetNotificationPreference handles the retrieval of a notification preference.
// @Summary Get Notification Preference
// @Description Get a notification preference
// @Tags NotificationPreference
// @Produce json
// @Success 200 {object} NotificationPrefObject
// @Failure 400 {array} ErrorResponse
// @Router /user/notification-preference [get]
// @Security Bearer
func GetNotificationPreference(c *fiber.Ctx) error {
	user := c.Locals("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)
	userID := claims["userID"]
	errorList := []*fiber.Error{}
	if userID == nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "User ID is required",
			},
		)
	}

	notificationPreference, err := notificationRepo.GetByUserID(userID.(string))
	if err != nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusNotFound,
				Message: "Notification preference not found",
			},
		)
		return c.Status(http.StatusNotFound).JSON(HTTPFiberErrorResponse(errorList))
	}

	return c.Status(http.StatusOK).JSON(mapPreferenceToOutput(notificationPreference))
}

// ============================================================
// =================== Private Methods ========================
// ============================================================

func mapInputToPreference(input NotificationPrefObject) *notificationPreference.NotificationPreference {
	return &notificationPreference.NotificationPreference{
		PushNotification:    input.PushNotification,
		BookingNotification: input.BookingNotification,
		MessageNotification: input.MessageNotification,
		ServiceNotification: input.ServiceNotification,
		UserID:              input.UserID,
	}
}

func mapPreferenceToOutput(preference *notificationPreference.NotificationPreference) NotificationPrefObject {
	return NotificationPrefObject{
		PushNotification:    preference.PushNotification,
		BookingNotification: preference.BookingNotification,
		MessageNotification: preference.MessageNotification,
		ServiceNotification: preference.ServiceNotification,
		UserID:              preference.UserID,
	}
}
