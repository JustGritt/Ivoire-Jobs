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
)

// ReportObject represents the report data structure.
type ReportObject struct {
	ServiceID string `json:"serviceId" validate:"required"`
	Reason    string `json:"reason" validate:"required,min=2,max=255"`
}

// ReportOutput represents the output data structure for a report.
type ReportOutput struct {
	ReportID  string    `json:"id"`
	UserID    string    `json:"userId"`
	ServiceID string    `json:"serviceId"`
	Reason    string    `json:"reason"`
	Status    bool      `json:"status"`
	CreatedAt time.Time `json:"createdAt"`
}

// CreateReport handles the creation of a new report.
// @Summary Create Report
// @Description Create a report
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
	var reportInput ReportObject
	if err := validator.ParseBodyAndValidate(c, &reportInput); err != nil {
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(err))
	}

	user := c.Locals("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)
	userID := claims["userID"].(string)

	// Map the input to report model
	newReport := report.Report{
		UserID:    userID,
		ServiceID: reportInput.ServiceID,
		Reason:    reportInput.Reason,
		Status:    false,
		ID:        uuid.New().String(),
		CreatedAt: time.Now(),
	}

	// Check if the report already exists for the given user and service
	existingReports, err := reportRepo.GetReportsByUserForService(userID, reportInput.ServiceID)
	if err == nil && len(existingReports) > 0 {
		return c.Status(http.StatusForbidden).JSON(HTTPResponse(http.StatusForbidden, "Report Already Exists", nil))
	}

	// Save the report to the database
	if err := reportRepo.Create(&newReport); err != nil {
		fmt.Printf("Database error: %v\n", err) // Add detailed logging
		return c.Status(http.StatusInternalServerError).JSON(HTTPResponse(http.StatusInternalServerError, "Report Not Registered", err.Error()))
	}

	reportOutput := mapReportToOutput(&newReport)
	return c.Status(http.StatusCreated).JSON(HTTPResponse(http.StatusCreated, "Report Created", reportOutput))
}

// GetAllReports retrieves all reports from the database.
// @Summary Get all reports
// @Description Get all reports
// @Tags Report
// @Produce json
// @Success 200 {array} ReportOutput
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /report/collection [get]
func GetAllReports(c *fiber.Ctx) error {
	reports, err := reportRepo.GetAllReports()
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse([]*fiber.Error{{Code: fiber.StatusInternalServerError, Message: "error getting reports"}}))
	}

	var reportOutputs []ReportOutput
	for _, r := range reports {
		reportOutputs = append(reportOutputs, *mapReportToOutput(&r))
	}

	return c.Status(http.StatusOK).JSON(reportOutputs)
}

// ============================================================
// =================== Private Methods ========================
// ============================================================

func mapReportToOutput(r *report.Report) *ReportOutput {
	return &ReportOutput{
		ReportID:  r.ID,
		UserID:    r.UserID,
		ServiceID: r.ServiceID,
		Reason:    r.Reason,
		Status:    r.Status,
		CreatedAt: r.CreatedAt,
	}
}
