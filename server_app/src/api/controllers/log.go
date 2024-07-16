package controllers

import (
	clog "barassage/api/models/log"
	myLogRepo "barassage/api/repositories/log"

	"net/http"

	"github.com/gofiber/fiber/v2"
)

type LogObject struct {
	Level      string `json:"level" validate:"required,oneof=info warn error"`
	Type       string `json:"type" validate:"required,min=2,max=66"`
	Message    string `json:"message" validate:"required,min=2,max=255"`
	RequestURI string `json:"requestURI"`
}

type LogOutput struct {
	LogID      string `json:"id"`
	Level      string `json:"level"`
	Type       string `json:"type"`
	Message    string `json:"message"`
	RequestURI string `json:"requestURI"`
	CreatedAt  string `json:"createdAt"`
}

// search via query params
// @Summary Get Logs
// @Description Get all logs
// @Tags Log
// @Produce json
// @Param level query string false "Log Level"
// @Param type query string false "Log Type"
// @Param message query string false "Log Message"
// @Success 200 {array} LogOutput
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /log/collection [get]
// @Security Bearer
func GetLogs(c *fiber.Ctx) error {
	queryParams := make(map[string]interface{})
	//var errorList []*fiber.Error

	if level := c.Query("level"); level != "" {
		queryParams["level"] = level
	}
	if logType := c.Query("type"); logType != "" {
		queryParams["type"] = logType
	}
	if message := c.Query("message"); message != "" {
		queryParams["message"] = message
	}

	logs := myLogRepo.GetByQueryParams(queryParams, c)
	return c.JSON(logs)

}

// create a helper function to create log
// CreateLog creates a log entry in the database and handles errors internally
func CreateLog(logObject *LogObject) []*fiber.Error {
	var errorList []*fiber.Error

	newLog := &clog.Log{
		Level:      clog.LogLevel(logObject.Level),
		Type:       logObject.Type,
		Message:    logObject.Message,
		RequestURI: logObject.RequestURI,
	}

	if err := myLogRepo.Create(newLog); err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusInternalServerError,
			Message: "Failed to create log",
		})
		return errorList
	}

	return nil
}

// ============================================================
// =================== Private Methods ========================
// ============================================================

func mapLogToOutput(b *clog.Log) *LogOutput {
	return &LogOutput{
		LogID:      b.ID,
		Level:      string(b.Level),
		Type:       b.Type,
		Message:    b.Message,
		RequestURI: b.RequestURI,
		CreatedAt:  b.CreatedAt.String(),
	}
}
