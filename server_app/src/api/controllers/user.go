package controllers

import (
	"fmt"
	"net/http"

	passwordUtil "barassage/api/common/passwordutil"
	validator "barassage/api/common/validator"
	"barassage/api/models/user"
	userRepo "barassage/api/repositories/user"
	"barassage/api/services/auth"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

// UserObject is the structure of the user
type UserObject struct {
	ExternalID     string `json:"-"`
	FirstName      string `json:"firstname" validate:"required,min=2,max=30"`
	LastName       string `json:"lastname" validate:"required,min=2,max=30"`
	Email          string `json:"email" validate:"required,min=5,max=100,email"`
	Password       string `json:"password" validate:"required"`
	ProfilePicture string `json:"profilePicture"`
	Bio            string `json:"bio"`
	Role           string `json:"role"`
}

// UserLogin is the login format expected
type UserLogin struct {
	Email    string `json:"email" validate:"required,min=5,max=100,email"`
	Password string `json:"password" validate:"password"`
}

// UserOutput is the output format of the user
type UserOutput struct {
	FirstName      string `json:"firstName"`
	LastName       string `json:"lastName"`
	Email          string `json:"email"`
	ProfilePicture string `json:"profilePicture"`
	Bio            string `json:"bio"`
	ID             string `json:"id"`
}

// Register Godoc
// @Summary Register
// @Description Registers a user
// @Tags Auth
// @Produce json
// @Param payload body UserObject true "Register Body"
// @Success 201 {object} Response
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /auth/register [post]
func Register(c *fiber.Ctx) error {
	var userInput UserObject
	// Validate Input
	if err := validator.ParseBodyAndValidate(c, &userInput); err != nil {
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(err))
	}

	u := mapInputToUser(userInput)

	// Hash Password
	hashedPass, _ := passwordUtil.HashPassword(userInput.Password)
	u.Password = hashedPass

	user, _ := userRepo.GetByEmail(userInput.Email)
	if user != nil {
		errorList = nil
		errorList = append(
			errorList,
			&Response{
				Code:    http.StatusConflict,
				Message: "User Already Exist",
				Data:    nil,
			},
		)
		return c.Status(http.StatusNotFound).JSON(HTTPErrorResponse(errorList))
	}

	// Save User To DB
	if err := userRepo.Create(&u); err != nil {
		errorList = nil
		// Check if the error is a validation error
		if err == gorm.ErrInvalidField {
			// Print a custom error message for the validation error
			fmt.Println("Validation error:", err.Error())
		} else {
			// Print other types of errors
			fmt.Println("Database error:", err.Error())
		}

		errorList = append(
			errorList,
			&Response{
				Code:    http.StatusConflict,
				Message: "User Already Exist",
				Data:    nil,
			},
		)
		response := HTTPResponse(http.StatusInternalServerError, "User Not Registered", err.Error())
		return c.Status(http.StatusInternalServerError).JSON(response)
	}

	userOutput := mapUserToOutPut(&u)
	response := HTTPResponse(http.StatusCreated, "User Registered", userOutput)
	return c.Status(http.StatusCreated).JSON(response)

}

// Login Godoc
// @Summary Login
// @Description Logs in a user
// @Tags Auth
// @Produce json
// @Param payload body UserLogin true "Login Body"
// @Success 200 {object} Response
// @Failure 400 {array} ErrorResponse
// @Router /auth/login [post]
func Login(c *fiber.Ctx) error {
	var userInput UserLogin
	fmt.Println("Hello,", &userInput)
	// Validate Input
	if err := validator.ParseBodyAndValidate(c, &userInput); err != nil {
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(err))

	}

	// Check If User Exists
	user, err := userRepo.GetByEmail(userInput.Email)
	if err != nil {
		errorList = nil
		errorList = append(
			errorList,
			&Response{
				Code:    http.StatusNotFound,
				Message: "User Doesn't Exist",
				Data:    err.Error(),
			},
		)
		return c.Status(http.StatusNotFound).JSON(HTTPErrorResponse(errorList))
	}
	fmt.Println("Validation error:", err)

	// Check if Password is Correct (Hash and Compare DB Hash)
	passwordIsCorrect := passwordUtil.CheckPasswordHash(userInput.Password, user.Password)
	if !passwordIsCorrect {
		errorList = nil
		errorList = append(
			errorList,
			&Response{
				Code:    http.StatusUnauthorized,
				Message: "Email or Password is Incorrect",
				Data:    err,
			},
		)
		return c.Status(http.StatusUnauthorized).JSON(HTTPErrorResponse(errorList))
	}

	// Issue Token
	accessToken, _ := auth.IssueAccessToken(*user)
	refreshToken, err := auth.IssueRefreshToken(*user)

	if err != nil {
		errorList = nil
		errorList = append(
			errorList,
			&Response{
				Code:    http.StatusInternalServerError,
				Message: "Something Went Wrong: Could Not Issue Token",
				Data:    err.Error(),
			},
		)
		return c.Status(http.StatusInternalServerError).JSON(HTTPErrorResponse(errorList))
	}
	// Return User and Token
	return c.Status(http.StatusOK).JSON(HTTPResponse(http.StatusOK, "Login Success", fiber.Map{"user": mapUserToOutPut(user), "access_token": accessToken.Token, "refresh_token": refreshToken.Token}))

}

// Logout Godoc
// @Summary Login
// @Description Logs in a user
// @Tags Auth
// @Produce json
// @Success 200 {object} Response
// @Failure 500 {array} ErrorResponse
// @Router /auth/logout [post]
func Logout(c *fiber.Ctx) error {
	// Here We get the token meta from access and refresh token passed from header
	// We delete the refresh
	return c.SendString("Logout Endpoint")
}

// ============================================================
// =================== Private Methods ========================
// ============================================================

func mapInputToUser(userInput UserObject) user.User {
	return user.User{
		Firstname:  userInput.FirstName,
		Lastname:   userInput.LastName,
		Email:      userInput.Email,
		Password:   userInput.Password,
		ExternalID: uuid.New().String(),
	}
}

func mapUserToOutPut(u *user.User) *UserOutput {
	return &UserOutput{
		ID:             u.ExternalID,
		FirstName:      u.Firstname,
		LastName:       u.Lastname,
		Email:          u.Email,
		ProfilePicture: u.ProfilePicture,
		Bio:            u.Bio,
	}
}
