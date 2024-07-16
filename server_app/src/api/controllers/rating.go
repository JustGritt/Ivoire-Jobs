package controllers

import (
	validator "barassage/api/common/validator"
	"barassage/api/models/rating"
	"barassage/api/models/user"
	bookingRepo "barassage/api/repositories/booking"
	ratingRepo "barassage/api/repositories/rating"
	userRepo "barassage/api/repositories/user"
	"net/http"

	"github.com/gofiber/fiber/v2"
)

// Structs for API request and response
type RatingObject struct {
	ServiceID string `json:"serviceId" validate:"required"`
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
	Firstname string  `json:"firstname"`
	CreatedAt string  `json:"createdAt"`
	Status    bool    `json:"status"`
	Score     float64 `json:"score,omitempty"` // Omits empty value
}

// CreateRating handles the creation of a new rating.
// @Summary Create Rating
// @Description Create a new rating
// @Tags Rating
// @Accept json
// @Produce json
// @Param rating body RatingObject true "Rating Object"
// @Success 201 {array} RatingOutput
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /rating [post]
// @Security Bearer
func CreateRating(c *fiber.Ctx) error {
	var ratingInput RatingObject
	if err := validator.ParseBodyAndValidate(c, &ratingInput); err != nil {
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(err))
	}

	// Check if the user has a booking for the service
	if _, err := bookingRepo.GetByServiceIDForUser(ratingInput.ServiceID, ratingInput.UserID); err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{
			"error": "User has no booking for this service",
		})
	}

	newRating := rating.Rating{
		ServiceID: ratingInput.ServiceID,
		Rating:    ratingInput.Rating,
		Comment:   ratingInput.Comment,
		UserID:    ratingInput.UserID,
	}

	// Create the rating
	if err := ratingRepo.Create(&newRating); err != nil {
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to create rating",
		})
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
	ratings, err := ratingRepo.GetAllRatings()
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to get ratings",
		})
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
	ratings, err := ratingRepo.PendingRatings()
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to get pending ratings",
		})
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

// ValidateRating handles the validation of a rating by id.
// @Summary Validate Rating
// @Description Validate a rating by id
// @Tags Rating
// @Produce json
// @Param id path string true "Rating ID"
// @Success 200
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /rating/{id} [put]
// @Security Bearer
func ValidateRating(c *fiber.Ctx) error {
	id := c.Params("id")
	var ratingInput RatingPendingObject
	if err := validator.ParseBodyAndValidate(c, &ratingInput); err != nil {
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(err))
	}

	if err := ratingRepo.ValidateRating(id, ratingInput.Status); err != nil {
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to validate rating",
		})
	}

	return c.SendStatus(http.StatusOK)
}

// GetRatingByID handles the retrieval of a rating by id.
// @Summary Get Rating By ID
// @Description Get a rating by id
// @Tags Rating
// @Produce json
// @Param id path string true "Rating ID"
// @Success 200 {array} RatingOutput
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 404 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /rating/{id} [get]
// @Security Bearer
func GetRatingByID(c *fiber.Ctx) error {
	id := c.Params("id")
	rating, err := ratingRepo.GetByID(id)
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to get rating",
		})
	}

	if rating == nil {
		return c.Status(http.StatusNotFound).JSON(fiber.Map{
			"error": "Rating not found",
		})
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
// @Success 200 {array} RatingOutput
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 404 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /rating/{id} [delete]
// @Security Bearer
func DeleteRating(c *fiber.Ctx) error {
	id := c.Params("id")

	// Check if the rating exists
	exists, err := ratingRepo.IsAlreadyDeleted(id)
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to check if rating is deleted",
		})
	}
	if exists {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{
			"error": "Rating already deleted",
		})
	}

	// Delete the rating
	if err := ratingRepo.DeleteRating(id); err != nil {
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to delete rating",
		})
	}

	return c.SendStatus(http.StatusOK)
}

// GetAllRatingsFromService returns all the ratings from a service
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
	serviceID := c.Params("id")
	var errorList []*fiber.Error
	ratings, err := ratingRepo.GetByServiceID(serviceID)
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to get ratings",
		})
	}

	var ratingsOutput []*RatingOutput
	for _, r := range ratings {
		user, err := userRepo.GetById(r.UserID)
		if err != nil {
			errorList = append(errorList, &fiber.Error{
				Code:    http.StatusNotFound,
				Message: "User not found",
			})
			return c.Status(http.StatusNotFound).JSON(HTTPFiberErrorResponse(errorList))
		}
		ratingsOutput = append(ratingsOutput, mapRatingToOutputWithFirstname(&r, user))
	}

	// Get the score
	ratingScore, err := ratingRepo.GetRatingScore(serviceID)
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to get rating score",
		})
	}

	if len(ratingsOutput) == 0 {
		ratingsOutput = []*RatingOutput{}
	}

	for _, r := range ratingsOutput {
		r.Score = ratingScore
	}

	return c.Status(http.StatusOK).JSON(ratingsOutput)
}

// Private method to map Rating to RatingOutput
func mapRatingToOutput(r *rating.Rating) *RatingOutput {
	return &RatingOutput{
		ID:        r.ID,
		ServiceID: r.ServiceID,
		Rating:    r.Rating,
		Comment:   r.Comment,
		CreatedAt: r.CreatedAt.Format("2006-01-02"),
		Status:    r.Status,
	}
}

func mapRatingToOutputWithFirstname(r *rating.Rating, user *user.User) *RatingOutput {
	return &RatingOutput{
		ID:        r.ID,
		ServiceID: r.ServiceID,
		Rating:    r.Rating,
		Comment:   r.Comment,
		Firstname: user.Firstname,
		CreatedAt: r.CreatedAt.Format("2006-01-02"),
		Status:    r.Status,
	}
}
