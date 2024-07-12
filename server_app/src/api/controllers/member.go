package controllers

import (
	"barassage/api/models/member"
	"barassage/api/services/notification"
	"log"

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

type MemberInput struct {
	Status string `json:"status" validate:"required"`
}

type MemberOutput struct {
	ID        string `json:"id"`
	UserID    string `json:"userId"`
	Reason    string `json:"reason"`
	Status    string `json:"status"`
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

	// check if the user is already a member
	if memberRepo.CheckIfMemberExists(newMember.UserID) {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusBadRequest,
			Message: "User is already a member",
		})
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	//check if the user has a pending request
	if member, _ := memberRepo.GetPendingRequest(newMember.UserID); member != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusBadRequest,
			Message: "User has a pending request",
		})
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
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

// GetAll pending requests
// @Summary Get All pending requests
// @Description Get all pending requests
// @Tags Member
// @Produce json
// @Param status query string false "Status of the requests" Enums(processing, member, rejected, all)
// @Success 200 {object} Response
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /member [get]
// @Security Bearer
func GetAllRequests(c *fiber.Ctx) error {
	var errorList []*fiber.Error

	//get query params
	status := c.Query("status")
	if status == "" {
		status = "processing"
	}

	// Validate status
	if status != "processing" && status != "member" && status != "rejected" && status != "all" {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "status must be 'processing', 'member', 'rejected', or 'all'",
			},
		)
		return c.Status(fiber.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	// Get all pending requests
	members, err := memberRepo.GetAllRequests(status)
	if err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusInternalServerError,
			Message: "Error getting pending requests",
		})
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	//map the members to output
	var memberOutputs []*MemberOutput
	for _, member := range members {
		memberOutputs = append(memberOutputs, mapMemberToOutput(&member))
	}
	if len(memberOutputs) == 0 {
		//return empty array
		return c.Status(http.StatusOK).JSON([]MemberOutput{})
	}

	return c.Status(http.StatusOK).JSON(memberOutputs)
}

// ValidateMember handles the validation of a member.
// @Summary Validate Member
// @Description Validate a member
// @Tags Member
// @Produce json
// @Param id path string true "Member ID"
// @Param payload body MemberInput true "Member Body"
// @Success 200 {object} Response
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /member/{id}/validate [put]
// @Security Bearer
func ValidateMember(c *fiber.Ctx) error {
	var errorList []*fiber.Error
	memberID := c.Params("id")

	var memberInput MemberInput
	if err := validator.ParseBodyAndValidate(c, &memberInput); err != nil {
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(err))
	}

	//the status could be only "accepted" or "rejected"
	if memberInput.Status != "accepted" && memberInput.Status != "rejected" {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "status must be 'accepted' or 'rejected'",
			},
		)
		return c.Status(fiber.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	if memberInput.Status == "accepted" {
		memberInput.Status = "member"
	}

	// Validate the member
	if err := memberRepo.ValidateMember(memberID, memberInput.Status); err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusInternalServerError,
			Message: err.Error(),
		})
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	//get USerid via memberid
	member, err := memberRepo.GetByID(memberID)
	if err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusNotFound,
			Message: "Member not found",
		})
		return c.Status(http.StatusNotFound).JSON(HTTPFiberErrorResponse(errorList))
	}
	// get the user
	user, err := userRepo.GetById(member.UserID)
	if err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusNotFound,
			Message: "User not found",
		})
		return c.Status(http.StatusNotFound).JSON(HTTPFiberErrorResponse(errorList))
	}

	//create the accurate message
	var message map[string]string
	if memberInput.Status == "member" {
		message = map[string]string{
			"Title": "Membership Update !",
			"Body":  "Hey! We are happy to announce that you are now a member!",
		}
	} else {
		message = map[string]string{
			"Title": "Membership Update !",
			"Body":  "Hey! We are sorry to announce that your membership request has been rejected!",
		}

	}

	// Send FCM notification
	domain := notification.ServiceDomain
	resp, err := notification.Send(
		c.Context(),
		message,
		user,
		domain,
	)
	if err != nil {
		log.Printf("error sending message: %v", err)
		return c.Status(http.StatusInternalServerError).JSON(HTTPResponse(http.StatusInternalServerError, "Error", err.Error()))
	}
	log.Printf("%d messages were sent successfully\n", resp.SuccessCount)

	return c.SendStatus(http.StatusOK)
}

// GetUserMemberStatus handles the retrieval of a member status.
// @Summary Get User Member Status
// @Description Get a user member status
// @Tags Member
// @Produce json
// @Success 200 {object} Response
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 404 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /user/member/status [get]
// @Security Bearer
func GetUserMemberStatus(c *fiber.Ctx) error {
	var errorList []*fiber.Error
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

	// Get the member by user id
	member, err := memberRepo.GetByUserID(userID.(string))
	if err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusNotFound,
			Message: "Member not found",
		})
		return c.Status(http.StatusNotFound).JSON(HTTPFiberErrorResponse(errorList))
	}

	//map the member to output
	memberOutput := mapMemberToOutput(member)

	return c.Status(http.StatusOK).JSON(memberOutput)
}

// ============================================================
// =================== Private Methods ========================
// ============================================================

func mapMemberToOutput(b *member.Member) *MemberOutput {
	return &MemberOutput{
		ID:        b.ID,
		UserID:    b.UserID,
		Reason:    b.Reason,
		Status:    b.Status,
		CreatedAt: b.CreatedAt.Format("2006-01-02"),
	}
}
