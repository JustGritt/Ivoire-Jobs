package controllers

import (
	"barassage/api/common/validator"
	"barassage/api/models/tag"
	tagRepo "barassage/api/repositories/tag"
	"errors"
	"fmt"
	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
	"gorm.io/gorm"
	"net/http"
)

type TagObject struct {
	ID          string `json:"id"`
	Name        string `json:"name" validate:"required"`
	Description string `json:"description" validate:"required"`
	IsActive    bool   `json:"isActive" validate:"required"`
	Duration    int    `json:"duration" validate:"required"`
}

type fillingTagObject struct {
	Name        string `json:"name" validate:"required"`
	Description string `json:"description" validate:"required"`
	IsActive    bool   `json:"isActive" validate:"required"`
	Duration    int    `json:"duration" validate:"required"`
}

// AddTagInfo Godoc
// @Summary AddTagInfo
// @Description Adding Tag information
// @Tags tag
// @Produce json
// @Param payload body ContactObject true "AddTagInfo body"
// @Success 201 {object} Response
// @Failure 400 {object} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /tag/create [post]
func AddTagInfo(c *fiber.Ctx) error {
	var tagInfo fillingTagObject
	if err := validator.ParseBodyAndValidate(c, &tagInfo); err != nil {
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(err))
	}
	tag := mapInputToTag(tagInfo)

	if err := tagRepo.Create(&tag); err != nil {
		errorList = nil
		if errors.Is(err, gorm.ErrInvalidField) {
			fmt.Println("Validation error:", err.Error())
		} else {
			fmt.Println("Validation error:", err.Error())
		}

		errorList = append(
			errorList,
			&Response{
				Code:    http.StatusBadRequest,
				Message: "Validation error",
				Data:    nil,
			},
		)
		response := HTTPResponse(http.StatusInternalServerError, "Tag information not saved", err.Error())
		return c.Status(http.StatusInternalServerError).JSON(response)
	}
	tagOutput := mapTagToOutput(&tag)
	response := HTTPResponse(http.StatusCreated, "Tag info added", tagOutput)
	return c.Status(http.StatusCreated).JSON(response)
}

func mapInputToTag(tagInfo fillingTagObject) tag.Tag {
	return tag.Tag{
		ID:          uuid.New().String(),
		Name:        tagInfo.Name,
		Description: tagInfo.Description,
		IsActive:    tagInfo.IsActive,
		Duration:    tagInfo.Duration,
	}
}

func mapTagToOutput(tag *tag.Tag) TagObject {
	return TagObject{
		ID:          tag.ID,
		Name:        tag.Name,
		Description: tag.Description,
		IsActive:    tag.IsActive,
		Duration:    tag.Duration,
	}
}
