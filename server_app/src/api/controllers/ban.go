package controllers

import (
	"barassage/api/models/ban"
	"fmt"

	banRepo "barassage/api/repositories/ban"
	userRepo "barassage/api/repositories/user"

	validator "barassage/api/common/validator"

	"net/http"

	"github.com/gofiber/fiber/v2"
)

type BanObject struct {
	UserID string `json:"userId" validate:"required"`
	Reason string `json:"reason" validate:"required,min=2,max=255"`
}

type BanOutput struct {
	BanID     string `json:"id"`
	UserID    string `json:"userId"`
	Reason    string `json:"reason"`
	CreatedAt string `json:"createdAt"`
}

// CreateBan handles the creation of a new ban.
// @Summary Create Ban
// @Description Create a ban
// @Tags Ban
// @Produce json
// @Param payload body BanObject true "Ban Body"
// @Success 201 {object} Response
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /ban [post]
// @Security Bearer
func CreateBan(c *fiber.Ctx) error {
	var banInput BanObject
	var errorList []*fiber.Error
	if err := validator.ParseBodyAndValidate(c, &banInput); err != nil {
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(err))
	}

	newBan := ban.Ban{
		UserID: banInput.UserID,
		Reason: banInput.Reason,
	}

	//get the user by id
	userTOBan, err := userRepo.GetById(newBan.UserID)
	if err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusNotFound,
			Message: "User not found",
		})
		_ = CreateLog(&LogObject{
			Level:      "warn",
			Type:       "Ban",
			Message:    "User not found with ID: " + newBan.UserID,
			RequestURI: c.OriginalURL(),
		})
		return c.Status(http.StatusNotFound).JSON(HTTPFiberErrorResponse(errorList))
	}

	if userTOBan.Role == "admin" {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusBadRequest,
			Message: "Cannot ban an admin",
		})
		_ = CreateLog(&LogObject{
			Level:      "warn",
			Type:       "Ban",
			Message:    "Cannot ban an admin",
			RequestURI: c.OriginalURL(),
		})
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	// check if user is already banned
	ban, err := banRepo.GetByUserID(newBan.UserID)
	if err == nil && ban != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusBadRequest,
			Message: "User is already banned",
		})
		_ = CreateLog(&LogObject{
			Level:      "warn",
			Type:       "Ban",
			Message:    "User is already banned with ID: " + newBan.UserID,
			RequestURI: c.OriginalURL(),
		})
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	if err := banRepo.Create(&newBan); err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusInternalServerError,
			Message: "Failed to create ban",
		})
		_ = CreateLog(&LogObject{
			Level:      "warn",
			Type:       "Ban",
			Message:    "Failed to create ban with ID: " + newBan.UserID,
			RequestURI: c.OriginalURL(),
		})
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	// Log the ban
	if err := CreateLog(&LogObject{
		Level:   "info",
		Type:    "User",
		Message: "User banned with ID: " + newBan.UserID,
	}); err != nil {
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(err))
	}

	banOutput := mapBanToOutput(&newBan)
	return c.Status(http.StatusCreated).JSON(banOutput)
}

// GetAllBans handles the retrieval of all bans.
// @Summary Get All Bans
// @Description Get all bans
// @Tags Ban
// @Produce json
// @Success 200 {array} BanOutput
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /ban [get]
// @Security Bearer
func GetAllBans(c *fiber.Ctx) error {
	var errorList []*fiber.Error
	bans, err := banRepo.GetAllBans()
	if err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusInternalServerError,
			Message: "Failed to get bans",
		})
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	var banOutputs []*BanOutput
	for _, b := range bans {
		banOutputs = append(banOutputs, mapBanToOutput(&b))
	}
	if len(banOutputs) == 0 {
		banOutputs = []*BanOutput{}
	}

	return c.JSON(banOutputs)
}

// DeleteBan handles the deletion of a ban.
// @Summary Delete Ban
// @Description Delete a ban
// @Tags Ban
// @Param id path string true "Ban ID"
// @Produce json
// @Success 204 {object} Response
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 404 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /ban/{id} [delete]
// @Security Bearer
func DeleteBan(c *fiber.Ctx) error {
	var errorList []*fiber.Error
	banID := c.Params("id")
	fmt.Println(banID)

	if err := banRepo.Delete(banID); err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusInternalServerError,
			Message: "Failed to delete ban",
		})

		_ = CreateLog(&LogObject{
			Level:      "info",
			Type:       "Ban",
			Message:    "Failed to delete ban with ID: " + banID,
			RequestURI: c.OriginalURL(),
		})

		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	// Log the ban deletion
	if err := CreateLog(&LogObject{
		Level:   "info",
		Type:    "User",
		Message: "Ban deleted with ID: " + banID,
	}); err != nil {
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(err))
	}

	return c.SendStatus(http.StatusNoContent)
}

// ============================================================
// =================== Private Methods ========================
// ============================================================

func mapBanToOutput(b *ban.Ban) *BanOutput {
	return &BanOutput{
		BanID:     b.ID,
		UserID:    b.UserID,
		Reason:    b.Reason,
		CreatedAt: b.CreatedAt.Format("2006-01-02"),
	}
}
