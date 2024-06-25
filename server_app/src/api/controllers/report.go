package controllers

import (
	validator "barassage/api/common/validator"
	"barassage/api/models/report"
	reportRepo "barassage/api/repositories/report"

	"fmt"
	"net/http"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

// ReportObject represents the report data structure.
type ReportObject struct {
	ReportID  string    `json:"-"`
	UserID    string    `json:"-"`
	ServiceID string    `json:"serviceId" validate:"required"`
	Reason    string    `json:"reason" validate:"required,min=2,max=255"`
	Status    bool      `json:"-" default:"false"`
	CreatedAt time.Time `json:"-"`
}

type ReportUpdateObject struct {
	Reason string `json:"reason" validate:"required,min=2,max=255"`
}

type ReportOutput struct {
	ReportID  string    `json:"id"`
	UserID    string    `json:"userId"`
	ServiceID string    `json:"serviceId"`
	Reason    string    `json:"reason"`
	Status    bool      `json:"status"`
	CreatedAt time.Time `json:"createdAt"`
}

// CreateReport Godoc
// @Summary Create Report
// @Reason Create a report
// @Tags Report
// @Produce json
// @Param payload body ReportObject true "Report Body"
// @Success 201 {object} Response
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /report [post]
// @Security Bearer
func CreateReport(c *fiber.Ctx) error {
	var errorList []*fiber.Error
	var reportInput ReportObject
	if err := validator.ParseBodyAndValidate(c, &reportInput); err != nil {
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

	//map the input to report model
	s := report.Report{
		UserID: reportInput.UserID,
		Reason: reportInput.Reason,
		Status: reportInput.Status,
		ID:     uuid.New().String(),
	}

	s.UserID = userID.(string)

	// Check if the report already exists for the given user
	if _, err := reportRepo.GetReportsByUserForService(s.UserID, s.ServiceID); err == nil {
		response := HTTPResponse(http.StatusForbidden, "Report Already Exist", nil)
		return c.Status(http.StatusForbidden).JSON(response)
	}

	// Save Report to DB
	if err := reportRepo.Create(&s); err != nil {
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
				Message: "Report Already Exist",
				Data:    nil,
			},
		}
		response := HTTPResponse(http.StatusInternalServerError, "Report Not Registered", errorList)
		return c.Status(http.StatusInternalServerError).JSON(response)
	}

	reportOutput := mapReportToOutPut(&s)
	response := HTTPResponse(http.StatusCreated, "Report Created", reportOutput)
	return c.Status(http.StatusCreated).JSON(response)
}

// GetAll Godoc
// @Summary Get all reports
// @Reason Get all reports
// @Tags Report
// @Produce json
// @Success 200 {array} ReportOutput
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /report/collection [get]
func GetAllReports(c *fiber.Ctx) error {
	var reports []report.Report
	var errorList []*fiber.Error
	reports, err := reportRepo.GetAllReports()
	if err != nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusInternalServerError,
				Message: "error getting reports",
			},
		)
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	if len(reports) == 0 {
		return c.Status(http.StatusOK).JSON([]ReportOutput{})
	}

	return c.Status(http.StatusOK).JSON(reports)
}

// ============================================================
// =================== Private Methods ========================
// ============================================================

func mapReportToOutPut(u *report.Report) *ReportOutput {
	return &ReportOutput{
		UserID:    u.UserID,
		ServiceID: u.ID,
		Reason:    u.Reason,
		Status:    u.Status,
		CreatedAt: u.CreatedAt,
	}
}
