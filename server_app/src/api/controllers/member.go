package controllers

import (
	"barassage/api/models/member"

	memberRepo "barassage/api/repositories/member"
	userRepo "barassage/api/repositories/user"

	validator "barassage/api/common/validator"

	"net/http"

	"github.com/gofiber/fiber/v2"
	jwt "github.com/golang-jwt/jwt/v4"
)

type MemberObject struct {
	Reason string `json:"reason" validate:"required,min=2,max=255"`
}

type MemberOutput struct {
	UserID    string `json:"userId"`
	Reason    string `json:"reason"`
	CreatedAt string `json:"createdAt"`
}

// CreateMember handles the creation of a new member.
// @Summary Create Member
// @Description Create a member
// @Tags Member
// @Produce json
// @Param payload body MemberObject true "Member Body"
// @Success 201 {object} Response
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /member [post]
// @Security Bearer
func CreateMember(c *fiber.Ctx) error {
	var memberInput MemberObject
	var errorList []*fiber.Error
	if err := validator.ParseBodyAndValidate(c, &memberInput); err != nil {
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

	if claims["role"] == "admin" {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "Admins can't be members",
			},
		)
		return c.Status(fiber.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	newMember := member.Member{
		UserID: userID.(string),
		Reason: memberInput.Reason,
	}

	// Get the user by id
	_, err := userRepo.GetById(newMember.UserID)
	if err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusNotFound,
			Message: "User not found",
		})
		return c.Status(http.StatusNotFound).JSON(HTTPFiberErrorResponse(errorList))
	}

	// Create the member
	if err := memberRepo.Create(&newMember); err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusInternalServerError,
			Message: "Error creating member",
		})
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	//map the member to output
	memberOutput := mapMemberToOutput(&newMember)

	return c.Status(http.StatusCreated).JSON(memberOutput)
}

// ValidateMember handles the validation of a member.
// @Summary Validate Member
// @Description Validate a member
// @Tags Member
// @Produce json
// @Param memberID path string true "Member ID"
// @Success 200 {object} Response
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /member/{id}/validate [put]
// @Security Bearer
func ValidateMember(c *fiber.Ctx) error {
	var errorList []*fiber.Error
	memberID := c.Params("id")

	// Validate the member
	if err := memberRepo.ValidateMember(memberID); err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusInternalServerError,
			Message: err.Error(),
		})
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	return c.SendStatus(http.StatusOK)
}

// ============================================================
// =================== Private Methods ========================
// ============================================================

func mapMemberToOutput(b *member.Member) *MemberOutput {
	return &MemberOutput{
		UserID:    b.UserID,
		Reason:    b.Reason,
		CreatedAt: b.CreatedAt.Format("2006-01-02"),
	}
}
