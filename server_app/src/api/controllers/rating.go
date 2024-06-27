package controllers

import (
	"barassage/api/models/rating"

	ratingRepo "barassage/api/repositories/rating"
	serviceRepo "barassage/api/repositories/service"

	validator "barassage/api/common/validator"

	"net/http"
	"time"

	"github.com/gofiber/fiber/v2"
)

type RatingObject struct {
	ServiceId string `json:"serviceId" validate:"required"`
	Rating    int    `json:"rating" validate:"required,min=1,max=5"`
	Comment   string `json:"comment" validate:"required,min=2,max=255"`
	UserID    string `json:"userId" validate:"required"`
}

type RatingOutput struct {
	ID        string    `json:"id"`
	ServiceID string    `json:"serviceId"`
	Rating    int       `json:"rating"`
	Comment   string    `json:"comment"`
	UserID    string    `json:"userId"`
	CreatedAt time.Time `json:"createdAt"`
}

// CreateRating handles the creation of a new rating.
// @Summary Create Rating
// @Description Create a rating
// @Tags Rating
// @Produce json
// @Param payload body RatingObject true "Rating Body"
// @Success 201 {object} Response
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /rating [post]
// @Security Bearer
func CreateRating(c *fiber.Ctx) error {
	var ratingInput RatingObject
	var errorList []*fiber.Error
	if err := validator.ParseBodyAndValidate(c, &ratingInput); err != nil {
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(err))
	}

	//get the service by id
	service, err := serviceRepo.GetByID(ratingInput.ServiceId)
	if err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusInternalServerError,
			Message: "Failed to create ban",
		})
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}
	if service == nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusNotFound,
			Message: "Service not found",
		})
		return c.Status(http.StatusNotFound).JSON(HTTPFiberErrorResponse(errorList))
	}

	newRating := rating.Rating{
		ServiceId: ratingInput.ServiceId,
		Rating:    ratingInput.Rating,
		Comment:   ratingInput.Comment,
		UserID:    ratingInput.UserID,
	}

	//create the rating
	if err := ratingRepo.Create(&newRating); err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusInternalServerError,
			Message: "Failed to create ban",
		})
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	ratingOutput := mapRatingToOutput(&newRating)
	return c.Status(http.StatusCreated).JSON(ratingOutput)

}

// GetAllRatings handles the retrieval of all ratings.
// @Summary Get All Ratings
// @Description Get all ratings
// @Tags Rating
// @Produce json
// @Success 200 {array} RatingOutput
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /rating [get]
// @Security Bearer
func GetAllRatings(c *fiber.Ctx) error {
	var errorList []*fiber.Error
	ratings, err := ratingRepo.GetAllRatings()
	if err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusInternalServerError,
			Message: "Failed to get ratings",
		})
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	var ratingsOutput []*RatingOutput
	for _, r := range ratings {
		ratingsOutput = append(ratingsOutput, mapRatingToOutput(&r))
	}

	if len(ratingsOutput) == 0 {
		ratingsOutput = []*RatingOutput{}
	}

	return c.Status(http.StatusOK).JSON(ratingsOutput)
}

// GetPendingRatings handles the retrieval of all pending ratings.
// @Summary Get Pending Ratings
// @Description Get all pending ratings
// @Tags Rating
// @Produce json
// @Success 200 {array} RatingOutput
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /rating/pending [get]
// @Security Bearer
func GetPendingRatings(c *fiber.Ctx) error {
	var errorList []*fiber.Error
	ratings, err := ratingRepo.PendingRatings()
	if err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusInternalServerError,
			Message: "Failed to get ratings",
		})
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	var ratingsOutput []*RatingOutput
	for _, r := range ratings {
		ratingsOutput = append(ratingsOutput, mapRatingToOutput(&r))
	}

	return c.Status(http.StatusOK).JSON(ratingsOutput)
}

// GetRatingByID handles the retrieval of a rating by id.
// @Summary Get Rating By ID
// @Description Get a rating by id
// @Tags Rating
// @Produce json
// @Param id path string true "Rating ID"
// @Success 200 {object} RatingOutput
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 404 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /rating/{id} [get]
// @Security Bearer
func GetRatingByID(c *fiber.Ctx) error {
	var errorList []*fiber.Error
	id := c.Params("id")
	rating, err := ratingRepo.GetByID(id)
	if err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusInternalServerError,
			Message: "Failed to get rating",
		})
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	if rating == nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusNotFound,
			Message: "Rating not found",
		})
		return c.Status(http.StatusNotFound).JSON(HTTPFiberErrorResponse(errorList))
	}

	ratingOutput := mapRatingToOutput(rating)
	return c.Status(http.StatusOK).JSON(ratingOutput)
}

// ============================================================
// =================== Private Methods ========================
// ============================================================

func mapRatingToOutput(r *rating.Rating) *RatingOutput {
	return &RatingOutput{
		ID:        r.ID,
		ServiceID: r.ServiceId,
		Rating:    r.Rating,
		Comment:   r.Comment,
		UserID:    r.UserID,
		CreatedAt: r.CreatedAt,
	}
}
