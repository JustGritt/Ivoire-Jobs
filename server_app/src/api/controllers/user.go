package controllers

import (
	passwordUtil "barassage/api/common/passwordutil"
	validator "barassage/api/common/validator"
	cfg "barassage/api/configs"
	notificationPreference "barassage/api/models/notificationPreference"
	"barassage/api/models/pushToken"
	refreshtoken "barassage/api/models/refreshToken"
	"barassage/api/models/user"
	banRepo "barassage/api/repositories/ban"
	notificationPreferenceRepo "barassage/api/repositories/notificationPreference"
	refreshTokenRepo "barassage/api/repositories/refreshToken"
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
	Password       string `json:"password" validate:"required,password" message:"Password must be at least 8 characters, contain at least 1 uppercase letter, 1 lowercase letter, 1 number and 1 special character"`
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
	Password string `json:"password"`
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
	verificationLink := fmt.Sprintf("%s/#/auth/verify-email?token=%s", cfg.GetConfig().FrontendURL, tokenString)
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

// Register Admin Godoc
// @Summary Register
// @Description Registers an admin
// @Tags Auth
// @Produce json
// @Param payload body UserObject true "Register Body"
// @Success 201 {object} Response
// @Failure 400 {array} ErrorResponse
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /auth/register-admin [post]
func RegisterAdmin(c *fiber.Ctx) error {
	var userInput UserObject
	var errorList []*fiber.Error

	// Validate Input
	if err := validator.ParseBodyAndValidate(c, &userInput); err != nil {
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(err))
	}

	u := mapInputToUser(userInput)

	// Hash Password
	hashedPass, _ := passwordUtil.HashPassword(userInput.Password)
	u.Password = hashedPass
	u.Role = "admin"

	user, _ := userRepo.GetByEmail(userInput.Email)
	if user != nil {
		errorList = nil
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    http.StatusConflict,
				Message: "User Already Exist",
			},
		)
		return c.Status(http.StatusConflict).JSON(HTTPFiberErrorResponse(errorList))
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
			&fiber.Error{
				Code:    http.StatusConflict,
				Message: "User Already Exist",
			},
		)
		return c.Status(http.StatusConflict).JSON(HTTPFiberErrorResponse(errorList))
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
	verificationLink := fmt.Sprintf("%s/#/auth/verify-email?token=%s", cfg.GetConfig().FrontendURL, tokenString)
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

	// Check if the user has a refresh token
	dbRefreshToken, _ := refreshTokenRepo.GetRefreshTokenForUser(user.ID)
	var tokenDetails *auth.TokenDetails

	if dbRefreshToken == nil {
		// Create a new refresh token
		expireTime := time.Now().Add(14 * 24 * time.Hour).Unix()
		tokenID := uuid.New().String()

		tokenDetails, err = auth.IssueRefreshToken(*user, tokenID, expireTime)
		if err != nil {
			return c.Status(http.StatusInternalServerError).JSON(HTTPErrorResponse([]*Response{
				{
					Code:    http.StatusInternalServerError,
					Message: "Something Went Wrong: Could Not Issue Token",
					Data:    err.Error(),
				},
			}))
		}

		dbRefreshToken = &refreshtoken.RefreshToken{
			TokenID:   tokenDetails.TokenUUID,
			UserID:    user.ID,
			ExpiresAt: tokenDetails.TokenExpires,
		}

		if err := refreshTokenRepo.Create(dbRefreshToken); err != nil {
			return c.Status(http.StatusInternalServerError).JSON(HTTPErrorResponse([]*Response{
				{
					Code:    http.StatusInternalServerError,
					Message: "Something Went Wrong: Could Not Save Token",
					Data:    err.Error(),
				},
			}))
		}
	}

	expireTime := time.Now().Add(14 * 24 * time.Hour).Unix()
	tokenDetails, err = auth.IssueRefreshToken(*user, dbRefreshToken.TokenID, expireTime)
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(HTTPErrorResponse([]*Response{
			{
				Code:    http.StatusInternalServerError,
				Message: "Something Went Wrong: Could Not Issue Token",
				Data:    err.Error(),
			},
		}))
	}
	if time.Until(time.Unix(dbRefreshToken.ExpiresAt, 0)) < 7*24*time.Hour {
		dbRefreshToken.TokenID = tokenDetails.TokenUUID
		dbRefreshToken.ExpiresAt = tokenDetails.TokenExpires

		if err := refreshTokenRepo.Update(dbRefreshToken); err != nil {
			return c.Status(http.StatusInternalServerError).JSON(HTTPErrorResponse([]*Response{
				{
					Code:    http.StatusInternalServerError,
					Message: "Something Went Wrong: Could Not Update Token",
					Data:    err.Error(),
				},
			}))
		}
	}

	// Issue Access Token
	accessToken, err := auth.IssueAccessToken(*user)
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(HTTPErrorResponse([]*Response{
			{
				Code:    http.StatusInternalServerError,
				Message: "Something Went Wrong: Could Not Issue Access Token",
				Data:    err.Error(),
			},
		}))
	}

	// Return User and Tokens
	return c.Status(http.StatusOK).JSON(HTTPResponse(http.StatusOK, "Login Success", fiber.Map{
		"user":          mapUserToOutPut(user),
		"access_token":  accessToken.Token,
		"refresh_token": tokenDetails.Token,
	}))
}

// Admin Login Godoc
// @Summary Admin Login
// @Description Logs in a user
// @Tags Auth
// @Produce json
// @Param payload body UserLogin true "Login Body"
// @Success 200 {object} Response
// @Failure 400 {array} ErrorResponse
// @Router /auth/admin-login [post]
func AdminLogin(c *fiber.Ctx) error {
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

	//check if the user is an admin
	if user.Role != "admin" {
		errorList = nil
		errorList = append(
			errorList,
			&Response{
				Code:    http.StatusUnauthorized,
				Message: "You are not authorized to access this route",
			},
		)
		return c.Status(http.StatusUnauthorized).JSON(HTTPErrorResponse(errorList))
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

	// Check if the user has a refresh token
	dbRefreshToken, _ := refreshTokenRepo.GetRefreshTokenForUser(user.ID)
	var tokenDetails *auth.TokenDetails

	if dbRefreshToken == nil {
		// Create a new refresh token
		expireTime := time.Now().Add(14 * 24 * time.Hour).Unix()
		tokenID := uuid.New().String()

		tokenDetails, err = auth.IssueRefreshToken(*user, tokenID, expireTime)
		if err != nil {
			return c.Status(http.StatusInternalServerError).JSON(HTTPErrorResponse([]*Response{
				{
					Code:    http.StatusInternalServerError,
					Message: "Something Went Wrong: Could Not Issue Token",
					Data:    err.Error(),
				},
			}))
		}

		dbRefreshToken = &refreshtoken.RefreshToken{
			TokenID:   tokenDetails.TokenUUID,
			UserID:    user.ID,
			ExpiresAt: tokenDetails.TokenExpires,
		}

		if err := refreshTokenRepo.Create(dbRefreshToken); err != nil {
			return c.Status(http.StatusInternalServerError).JSON(HTTPErrorResponse([]*Response{
				{
					Code:    http.StatusInternalServerError,
					Message: "Something Went Wrong: Could Not Save Token",
					Data:    err.Error(),
				},
			}))
		}
	}

	expireTime := time.Now().Add(14 * 24 * time.Hour).Unix()
	tokenDetails, err = auth.IssueRefreshToken(*user, dbRefreshToken.TokenID, expireTime)
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(HTTPErrorResponse([]*Response{
			{
				Code:    http.StatusInternalServerError,
				Message: "Something Went Wrong: Could Not Issue Token",
				Data:    err.Error(),
			},
		}))
	}
	if time.Until(time.Unix(dbRefreshToken.ExpiresAt, 0)) < 7*24*time.Hour {
		dbRefreshToken.TokenID = tokenDetails.TokenUUID
		dbRefreshToken.ExpiresAt = tokenDetails.TokenExpires

		if err := refreshTokenRepo.Update(dbRefreshToken); err != nil {
			return c.Status(http.StatusInternalServerError).JSON(HTTPErrorResponse([]*Response{
				{
					Code:    http.StatusInternalServerError,
					Message: "Something Went Wrong: Could Not Update Token",
					Data:    err.Error(),
				},
			}))
		}
	}

	// Issue Access Token
	accessToken, err := auth.IssueAccessToken(*user)
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(HTTPErrorResponse([]*Response{
			{
				Code:    http.StatusInternalServerError,
				Message: "Something Went Wrong: Could Not Issue Access Token",
				Data:    err.Error(),
			},
		}))
	}

	// Return User and Tokens
	return c.Status(http.StatusOK).JSON(HTTPResponse(http.StatusOK, "Login Success", fiber.Map{
		"user":          mapUserToOutPut(user),
		"access_token":  accessToken.Token,
		"refresh_token": tokenDetails.Token,
	}))
}

// GetAllUsers Godoc
// @Summary Get all users
// @Description Get the list of all users
// @Tags Auth
// @Produce json
// @Success 200 {object} Response "List of users"
// @Failure 400 {array} ErrorResponse "Validation error or users not found"
// @Failure 401 {array} ErrorResponse "Unauthorized"
// @Failure 500 {array} ErrorResponse "Token issuing error"
// @Router /auth/users [get]
// @Security Bearer
func GetAllUsers(c *fiber.Ctx) error {
	var users []user.User
	var errorList []*fiber.Error

	// get the query param name type and check if empty
	userType := c.Query("type")
	if userType == "" {
		userType = "users"
	}
	fmt.Println(userType)
	//check if the type is users or admin
	if userType != "users" && userType != "admin" {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusBadRequest,
				Message: "Invalid user type",
			},
		)
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	users, err := userRepo.GetAllUsers(userType)
	if err != nil {
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusInternalServerError,
				Message: "error getting users",
			},
		)
		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	// Map users to UserOutput
	var ouput []UserOutput
	for _, s := range users {
		ouput = append(ouput, *mapUserToOutPut(&s))
	}

	//if the users are empty send and empty array
	if len(ouput) == 0 {
		return c.Status(http.StatusOK).JSON([]UserOutput{})
	}

	return c.Status(http.StatusOK).JSON(ouput)
}

// GetMyProfile Godoc
// @Summary Get My Profile
// @Description Get details of the logged-in user
// @Tags Auth
// @Produce json
// @Success 200 {object} Response "User profile data along with access and refresh tokens"
// @Failure 400 {array} ErrorResponse "Validation error or user not found"
// @Failure 401 {array} ErrorResponse "Incorrect email or password"
// @Failure 500 {array} ErrorResponse "Token issuing error"
// @Router /auth/me [get]
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

	// Return User and Token
	return c.Status(http.StatusOK).JSON(HTTPResponse(http.StatusOK, "This is your profile", fiber.Map{"user": mapUserToOutPut(dbUser)}))
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

	//check if the token is already registered
	for _, token := range dbUser.PushToken {
		if token.Token == userInput.Token {
			return c.SendStatus(http.StatusOK)
		}
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

	//create the notification preference
	if err := notificationPreferenceRepo.Create(&notificationPreference.NotificationPreference{
		UserID: dbUser.ID,
	}); err != nil {
		errorList = append(
			[]*Response{},
			&Response{
				Code:    http.StatusInternalServerError,
				Message: "Could not create notification preference",
				Data:    nil,
			},
		)
		return c.Status(http.StatusInternalServerError).JSON(HTTPErrorResponse(errorList))
	}

	return c.SendStatus(http.StatusOK)
}

// GetUserDetail Godoc
// @Summary Get User Detail
// @Description Get the detail of a user
// @Tags Auth
// @Produce json
// @Param id path string true "User ID"
// @Success 200 {object} Response "User detail"
// @Failure 400 {array} ErrorResponse "Validation error or user not found"
// @Failure 401 {array} ErrorResponse "Incorrect email or password"
// @Failure 500 {array} ErrorResponse "Token issuing error"
// @Router /user/detail/{id} [get]
// @Security Bearer
func GetUserDetail(c *fiber.Ctx) error {
	userID := c.Params("id")
	// Check If User Exists
	dbUser, err := userRepo.GetById(userID)
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

	// Return User and Token
	return c.Status(http.StatusOK).JSON(HTTPResponse(http.StatusOK, "This is your profile", fiber.Map{"user": mapUserToOutPut(dbUser)}))
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
	if u.Member == nil || len(u.Member) == 0 {
		memberStatus = "not-member"
	} else {
		member := u.Member[len(u.Member)-1]
		memberStatus = member.Status
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
