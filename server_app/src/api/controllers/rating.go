package controllers

import (
	"barassage/api/models/rating"
	"fmt"

	bookingRepo "barassage/api/repositories/booking"
	ratingRepo "barassage/api/repositories/rating"

	validator "barassage/api/common/validator"

	"net/http"

	"github.com/gofiber/fiber/v2"
)

type RatingObject struct {
	ServiceId string `json:"serviceId" validate:"required"`
	Rating    int    `json:"rating" validate:"required,min=1,max=5"`
	Comment   string `json:"comment" validate:"required,min=2,max=255"`
	UserID    string `json:"userId" validate:"required"`
}

type RatingPendingObject struct {
	Status bool `json:"status" validate:"required"`
}

type RatingOutput struct {
	ID        string  `json:"id"`
	ServiceID string  `json:"serviceId"`
	Rating    int     `json:"rating"`
	Comment   string  `json:"comment"`
	UserID    string  `json:"userId"`
	CreatedAt string  `json:"createdAt"`
	Status    bool    `json:"status"`
	Score     float64 `json:"score"`
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

	// Check if the user has a booking or return an error if the user has no booking
	_, err := bookingRepo.GetByServiceIDForUser(ratingInput.ServiceId, ratingInput.UserID)
	if err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusInternalServerError,
			Message: "User has no booking",
		})
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
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

// ValidateRating handles the validation of a rating by id.
// @Summary Validate Rating
// @Description Validate a rating by id
// @Tags Rating
// @Produce json
// @Param id path string true "Rating ID"
// @Param payload body RatingPendingObject true "Rating Body"
// @Success 200 {object} Response
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /rating/{id} [put]
// @Security Bearer
func ValidateRating(c *fiber.Ctx) error {
	var errorList []*fiber.Error
	id := c.Params("id")
	var ratingInput RatingPendingObject
	if err := validator.ParseBodyAndValidate(c, &ratingInput); err != nil {
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(err))
	}

	//validate the rating
	if err := ratingRepo.ValidateRating(id); err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusInternalServerError,
			Message: "Failed to validate rating",
		})
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	//send back the rating
	rating, err := ratingRepo.GetByID(id)
	if err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusInternalServerError,
			Message: "Failed to get rating",
		})
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	ratingOutput := mapRatingToOutput(rating)
	return c.Status(http.StatusOK).JSON(ratingOutput)
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

// DeleteRating handles the deletion of a rating by id.
// @Summary Delete Rating
// @Description Delete a rating by id
// @Tags Rating
// @Produce json
// @Param id path string true "Rating ID"
// @Success 200 {object} Response
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /rating/{id} [delete]
// @Security Bearer
func DeleteRating(c *fiber.Ctx) error {
	var errorList []*fiber.Error
	id := c.Params("id")

	// check if service exists
	_, err := ratingRepo.GetByID(id)
	if err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusBadRequest,
			Message: "Already deleted",
		})
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	//delete the rating
	if err := ratingRepo.DeleteRating(id); err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusInternalServerError,
			Message: "Failed to delete rating",
		})
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	// Prevent the deletion if the rating has been deleted

	//send an empty response
	return c.Status(http.StatusOK).JSON(Response{
		Code:    http.StatusOK,
		Message: "Rating deleted",
		Data:    nil,
	})
}

// GetAllRatingsFromService Return all the ratings from a service
// @Summary Get All Ratings From Service
// @Description Get all ratings from a service
// @Tags Rating
// @Produce json
// @Param id path string true "Service ID"
// @Success 200 {array} RatingOutput
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 404 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /service/{id}/rating [get]
// @Security Bearer
func GetAllRatingsFromService(c *fiber.Ctx) error {
	var errorList []*fiber.Error
	serviceID := c.Params("id")
	ratings, err := ratingRepo.GetByServiceID(serviceID)
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

	// get the score
	ratingScore, err := ratingRepo.GetRatingScore(serviceID)
	if err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusInternalServerError,
			Message: "Failed to get rating score",
		})
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	if len(ratingsOutput) == 0 {
		ratingsOutput = []*RatingOutput{}
	}

	// add the score to the output at the top level
	ratingsOutput[0].Score = float64(ratingScore)

	return c.Status(http.StatusOK).JSON(ratingsOutput)
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
		CreatedAt: r.CreatedAt.Format("2006-01-02"),
		Status:    r.Status,
	}
}
