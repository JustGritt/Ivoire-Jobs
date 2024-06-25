package controllers

import (
	"net/http"

	validator "barassage/api/common/validator"
	"barassage/api/models/category"
	categorieRepo "barassage/api/repositories/category"

	"github.com/gofiber/fiber/v2"
	jwt "github.com/golang-jwt/jwt/v4"
)

type CategoryObject struct {
	Name   string `json:"name" validate:"required,min=2,max=255"`
	Status bool   `json:"status" default:"true"`
}

type CategoryOutput struct {
	ID     string `json:"id"`
	Name   string `json:"name"`
	Status bool   `json:"status"`
}

// GetAllCategories fetches all categories
// @Summary Get All Categories
// @Description Get all categories
// @Tags Category
// @Produce json
// @Success 200 {array} CategoryOutput
// @Failure 500 {array} ErrorResponse
// @Router /categories/collection [get]
func GetAllCategories(c *fiber.Ctx) error {
	categories, err := categorieRepo.GetAllCategories()
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	var output []*CategoryOutput
	for _, category := range categories {
		output = append(output, mapCategoryToOutput(&category))
	}

	return c.JSON(output)
}

// CreateCategory creates a new category
// @Summary Create Category
// @Description Create a new category
// @Tags Category
// @Produce json
// @Param payload body CategoryObject true "Category Body"
// @Success 201 {object} CategoryOutput
// @Failure 400 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /category [post]
// @Security Bearer
func CreateCategory(c *fiber.Ctx) error {
	var errorList []*fiber.Error
	var categoryInput CategoryObject
	if err := validator.ParseBodyAndValidate(c, &categoryInput); err != nil {
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

	category := &category.Category{
		Name:   categoryInput.Name,
		Status: categoryInput.Status,
	}

	if err := categorieRepo.Create(category); err != nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusInternalServerError,
				Message: err.Error(),
			},
		)
		return c.Status(fiber.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	return c.Status(http.StatusCreated).JSON(mapCategoryToOutput(category))
}

// ============================================================
// =================== Private Methods ========================
// ============================================================

func mapCategoryToOutput(c *category.Category) *CategoryOutput {
	return &CategoryOutput{
		ID:     c.ID,
		Name:   c.Name,
		Status: c.Status,
	}
}
