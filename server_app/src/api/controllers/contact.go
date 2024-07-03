package controllers

import (
	"barassage/api/common/validator"
	"barassage/api/models/contact"
	"barassage/api/models/user"
	contactRepo "barassage/api/repositories/contact"
	userRepo "barassage/api/repositories/user"
	"fmt"
	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
	"gorm.io/gorm"
	"net/http"
)

type ContactObject struct {
	ExternalID  string    `json:"-"`
	ID          string    `json:"id"`
	Phone       string    `json:"phone" validate:"required,numeric,len=11"`
	Address     string    `json:"address" validate:"required"`
	City        string    `json:"city" validate:"required"`
	Country     string    `json:"country" validate:"required"`
	PostalCode  string    `json:"postal_code" validate:"required"`
	Description string    `json:"description"`
	User        user.User `json:"user"`
}

type fillingContactObject struct {
	Phone       string `json:"phone" validate:"required,numeric,len=11"`
	Address     string `json:"address" validate:"required"`
	City        string `json:"city" validate:"required"`
	Country     string `json:"country" validate:"required"`
	PostalCode  string `json:"postal_code" validate:"required"`
	Description string `json:"description"`
	UserID      string `json:"user_id"`
}

// AddContactInfo Godoc
// @Summary AddContactInfo
// @Description Adding contact information to a user
// @Tags contact
// @Produce json
// @Param payload body ContactObject true "AddContactInfo body"
// @Success 201 {object} Response
// @Failure 400 {object} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /contact/create [post]
func AddContactInfo(c *fiber.Ctx) error {
	var contactInfo fillingContactObject
	if err := validator.ParseBodyAndValidate(c, &contactInfo); err != nil {
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(err))
	}
	contact := mapInputToContact(contactInfo)

	user, _ := userRepo.GetById(contactInfo.UserID)

	if user != nil {
		errorList = nil
		errorList = append(
			errorList,
			&Response{
				Code:    http.StatusNotFound,
				Message: "User Not Found",
				Data:    nil,
			},
		)
		return c.Status(http.StatusNotFound).JSON(HTTPErrorResponse(errorList))
	}

	if err := contactRepo.Create(&contact); err != nil {
		errorList = nil
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
			&Response{
				Code:    http.StatusNotFound,
				Message: "User Not Found",
				Data:    nil,
			},
		)
		response := HTTPResponse(http.StatusInternalServerError, "Contact information not saved", err.Error())
		return c.Status(http.StatusInternalServerError).JSON(response)
	}

	contactOutput := mapContactToOutput(&contact)
	response := HTTPResponse(http.StatusCreated, "Contact info added", contactOutput)
	return c.Status(http.StatusCreated).JSON(response)
}

func mapInputToContact(contactInfo fillingContactObject) contact.Contact {
	return contact.Contact{
		Phone:       contactInfo.Phone,
		Address:     contactInfo.Address,
		City:        contactInfo.City,
		Country:     contactInfo.Country,
		PostalCode:  contactInfo.PostalCode,
		Description: contactInfo.Description,
		ExternalID:  uuid.New().String(),
	}
}

func mapContactToOutput(contact *contact.Contact) *ContactObject {
	return &ContactObject{
		ID:          contact.ExternalID,
		Phone:       contact.Phone,
		Address:     contact.Address,
		City:        contact.City,
		Country:     contact.Country,
		PostalCode:  contact.PostalCode,
		Description: contact.Description,
	}
}
