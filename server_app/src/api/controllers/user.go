package controllers

import (
	passwordUtil "barassage/api/common/passwordutil"
	validator "barassage/api/common/validator"
	cfg "barassage/api/configs"
	"barassage/api/models/pushToken"
	"barassage/api/models/user"
	banRepo "barassage/api/repositories/ban"
	userRepo "barassage/api/repositories/user"
	"barassage/api/services/auth"
	"barassage/api/services/mailer"
	"fmt"
	"net/http"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

// UserObject is the structure of the user
type UserObject struct {
	UserID         string `json:"-"`
	FirstName      string `json:"firstname" validate:"required,min=2,max=30"`
	LastName       string `json:"lastname" validate:"required,min=2,max=30"`
	Email          string `json:"email" validate:"required,min=5,max=100,email"`
	Password       string `json:"password" validate:"required"`
	ProfilePicture string `json:"profilePicture"`
	Bio            string `json:"bio"`
	Role           string `json:"role"`
}

type PushTokenObject struct {
	UserID string `json:"-"`
	Token  string `json:"token"`
	Device string `json:"device"`
}

type UpdateUserObject struct {
	UserID    string `json:"-"`
	FirstName string `json:"firstname" validate:"min=2,max=30"`
	LastName  string `json:"lastname" validate:"min=2,max=30"`
	Bio       string `json:"bio"`
}

// UserLogin is the login format expected
type UserLogin struct {
	Email    string `json:"email" validate:"required,min=5,max=100,email"`
	Password string `json:"password" validate:"password"`
}

// UserOutput is the output format of the user
type UserOutput struct {
	FirstName              string           `json:"firstName"`
	LastName               string           `json:"lastName"`
	Email                  string           `json:"email"`
	ProfilePicture         string           `json:"profilePicture"`
	Bio                    string           `json:"bio"`
	ID                     string           `json:"id"`
	Member                 string           `json:"member"`
	NotificationPreference NotificationPref `json:"notificationPreferences"`
	CreatedAt              string           `json:"createdAt"`
	UpdatedAt              string           `json:"updatedAt"`
}

type NotificationPref struct {
	PushNotification    bool `json:"pushNotification"`
	MessageNotification bool `json:"messageNotification"`
	ServiceNotification bool `json:"serviceNotification"`
	BookingNotification bool `json:"bookingNotification"`
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
		return c.Status(http.StatusConflict).JSON(HTTPErrorResponse(errorList))
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

	// Generate email verification token
	expireTime := time.Now().Add(1 * time.Hour) // Token expires in 1 hour
	verificationToken := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"user_id": u.ID,
		"exp":     expireTime.Unix(),
	})
	tokenString, err := verificationToken.SignedString([]byte(cfg.GetConfig().JWTAccessSecret))
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{"error": "Could not generate verification token"})
	}

	// Send verification email
	verificationLink := fmt.Sprintf("%s/verify-email?token=%s", cfg.GetConfig().FrontendURL, tokenString)
	emailData := map[string]interface{}{
		"action_url": verificationLink,
		"email":      u.Email,
	}

	_, err = mailer.SendEmail("welcome", u.Email, "Email Verification", emailData)
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(fiber.Map{"error": "Could not send verification email"})
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

	// Check if User is Active
	if !user.Active {
		errorList = nil
		errorList = append(
			errorList,
			&Response{
				Code:    http.StatusUnauthorized,
				Message: "Please Activate Your Account first",
				Data:    err,
			},
		)
		return c.Status(http.StatusUnauthorized).JSON(HTTPErrorResponse(errorList))
	}

	// Check if User is Banned
	ban, err := banRepo.GetByUserID(user.ID)
	if err == nil && ban.UserID == user.ID {
		errorList = nil
		errorList = append(
			errorList,
			&Response{
				Code:    http.StatusUnauthorized,
				Message: "Can't login to your account, you are banned",
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

// GetMyProfile Godoc
// @Summary Get My Profile
// @Description Get details of the logged-in user
// @Tags Auth
// @Produce json
// @Param payload body UserLogin true "Login Body"
// @Success 200 {object} Response "User profile data along with access and refresh tokens"
// @Failure 400 {array} ErrorResponse "Validation error or user not found"
// @Failure 401 {array} ErrorResponse "Incorrect email or password"
// @Failure 500 {array} ErrorResponse "Token issuing error"
// @Router /auth/me [post]
// @Security Bearer
func GetMyProfile(c *fiber.Ctx) error {
	user := c.Locals("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)
	userID := claims["userID"]
	// Validate Input
	if userID == nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"msg": "can't extract user info from request",
		})
	}
	// Check If User Exists
	dbUser, err := userRepo.GetById(userID.(string))
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

	// Issue Token
	accessToken, _ := auth.IssueAccessToken(*dbUser)
	refreshToken, err := auth.IssueRefreshToken(*dbUser)

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
	return c.Status(http.StatusOK).JSON(HTTPResponse(http.StatusOK, "This is your profile", fiber.Map{"user": mapUserToOutPut(dbUser), "access_token": accessToken.Token, "refresh_token": refreshToken.Token}))
}

// Logout Godoc
// @Summary Login
// @Description Logs in a user
// @Tags Auth
// @Produce json
// @Success 200 {object} Response
// @Failure 500 {array} ErrorResponse
// @Router /auth/logout [post]
// @Security Bearer
func Logout(c *fiber.Ctx) error {
	// Here We get the token meta from access and refresh token passed from header
	// We delete the refresh
	return c.SendString("Logout Endpoint")
}

// UpdateProfile Godoc
// @Summary Update Profile
// @Description Update the profile of the logged-in user
// @Tags Auth
// @Produce json
// @Param payload body UpdateUserObject true "Update Profile Body"
// @Success 200 {object} Response "Updated user profile data"
// @Failure 400 {array} ErrorResponse "Validation error or user not found"
// @Failure 401 {array} ErrorResponse "Incorrect email or password"
// @Failure 500 {array} ErrorResponse "Token issuing error"
// @Router /auth/update-profile [put]
// @Security Bearer
func UpdateProfile(c *fiber.Ctx) error {
	var userInput UpdateUserObject
	// Validate Input
	if err := validator.ParseBodyAndValidate(c, &userInput); err != nil {
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(err))
	}

	user := c.Locals("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)
	userID := claims["userID"]
	// Validate Input
	if userID == nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"msg": "can't extract user info from request",
		})
	}

	dbUser, err := userRepo.GetById(userID.(string))
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
	//updateONly the fields that are not empty
	if userInput.FirstName != "" {
		dbUser.Firstname = userInput.FirstName
	}
	if userInput.LastName != "" {
		dbUser.Lastname = userInput.LastName
	}
	if userInput.Bio != "" {
		dbUser.Bio = userInput.Bio
	}

	// Save User To DB
	if err := userRepo.Update(dbUser); err != nil {
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

	userOutput := mapUserToOutPut(dbUser)
	response := HTTPResponse(http.StatusOK, "User Updated", userOutput)
	return c.Status(http.StatusOK).JSON(response)
}

// PatchToken Godoc
// @Summary Patch Token
// @Description Patch the token of the logged-in user
// @Tags Auth
// @Produce json
// @Param payload body PushTokenObject true "Patch Token Body"
// @Success 200 {object} Response "Updated user token data"
// @Failure 400 {array} ErrorResponse "Validation error or user not found"
// @Failure 401 {array} ErrorResponse "Incorrect email or password"
// @Failure 500 {array} ErrorResponse "Token issuing error"
// @Router /auth/update-token [patch]
// @Security Bearer
func PatchToken(c *fiber.Ctx) error {
	var userInput PushTokenObject
	// Validate Input
	if err := validator.ParseBodyAndValidate(c, &userInput); err != nil {
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(err))
	}

	user := c.Locals("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)
	userID := claims["userID"]
	// Validate Input
	if userID == nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"msg": "can't extract user info from request",
		})
	}

	dbUser, err := userRepo.GetById(userID.(string))
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

	if userInput.Device == "" {
		userInput.Device = "unknown"
	}

	dbUser.PushToken = append(dbUser.PushToken, pushToken.PushToken{
		UserID: dbUser.ID,
		Token:  userInput.Token,
		Device: userInput.Device,
	})

	// Save User To DB
	if err := userRepo.Update(dbUser); err != nil {
		errorList = append(
			[]*Response{},
			&Response{
				Code:    http.StatusBadRequest,
				Message: "The token is already registered",
				Data:    nil,
			},
		)
		return c.Status(http.StatusBadRequest).JSON(HTTPErrorResponse(errorList))
	}

	return c.SendStatus(http.StatusOK)
}

// ============================================================
// =================== Private Methods ========================
// ============================================================

func mapInputToUser(userInput UserObject) user.User {
	return user.User{
		Firstname: userInput.FirstName,
		Lastname:  userInput.LastName,
		Email:     userInput.Email,
		Password:  userInput.Password,
		ID:        uuid.New().String(),
	}
}

func mapUserToOutPut(u *user.User) *UserOutput {
	//from the member get the member status if empty return not-member
	var memberStatus string
	if len(u.Member) == 0 {
		memberStatus = "not-member"
	} else {
		memberStatus = u.Member[0].Status
	}

	//notificationPreference := mapNotificationPreferenceToOutput(u.NotificationPreference)

	return &UserOutput{
		ID:             u.ID,
		FirstName:      u.Firstname,
		LastName:       u.Lastname,
		Email:          u.Email,
		ProfilePicture: u.ProfilePicture,
		Bio:            u.Bio,
		Member:         memberStatus,
		CreatedAt:      u.CreatedAt.Format("2006-01-02"),
		UpdatedAt:      u.UpdatedAt.Format("2006-01-02"),
	}
}
