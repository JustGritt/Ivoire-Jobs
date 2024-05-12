package routes

import (
	"github.com/JustGritt/Ivoire-Jobs/database"
	"github.com/JustGritt/Ivoire-Jobs/models"
	"github.com/JustGritt/Ivoire-Jobs/validations"
	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
	"golang.org/x/crypto/bcrypt"
)

func validToken(t *jwt.Token, id int) bool {
	n := id
	claims := t.Claims.(jwt.MapClaims)
	uid := int(claims["user_id"].(float64))
	return uid == n
}

type User struct {
	ID        uint   `json:"id"`
	FirstName string `json:"first_name"`
	LastName  string `json:"last_name"`
	Password  string `json:"password"`
}

func CreateResponseUser(user models.User) User {
	return User{
		ID:        user.ID,
		FirstName: user.FirstName,
		LastName:  user.LastName,
	}
}

// Create user godoc
// @Summary Create user
// @Description Create user
// @Tags users
// @Accept  json
// @Produce  json
// @Param user body User true "User"
// @Success 201 {object} User
// @Failure 400 {string} string "Invalid request"
// @Failure 500 {string} string "Error encrypting password"
// @Router /api/users [post]
func CreateUser(c *fiber.Ctx) error {
	var user models.User
	if err := c.BodyParser(&user); err != nil {
		return c.Status(400).JSON(fiber.Map{
			"message": "Invalid request",
		})
	}

	// encrypt password with bcrypt
	pass, err := bcrypt.GenerateFromPassword([]byte(user.Password), 14)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{
			"message": "Error encrypting password",
		})
	}

	user.Password = string(pass)

	database.Database.Db.Create(&user)

	return c.Status(201).JSON(CreateResponseUser(user))
}

func GetUserId(id int, user *models.User) error {
	database.Database.Db.Find(&user, id)
	if user.ID == 0 {
		return fiber.NewError(404, "User not found")
	}

	return nil
}

// Get users godoc
// @Summary Get users
// @Description Get users
// @Tags users
// @Accept  json
// @Produce  json
// @Success 200 {object} User
// @Failure 404 {string} string "User not found"
// @Router /api/users [get]
func GetUsers(c *fiber.Ctx) error {
	token := c.Locals("user").(*jwt.Token)
	if !validateToken(token) {
		return c.Status(500).JSON(fiber.Map{"status": "error", "message": "Invalid Token Given", "data": nil})
	}
	var users []models.User
	database.Database.Db.Find(&users)

	var responseUsers []User
	for _, user := range users {
		responseUsers = append(responseUsers, CreateResponseUser(user))
	}

	return c.Status(200).JSON(responseUsers)
}

// Get user godoc
// @Summary Get user
// @Description Get user
// @Tags users
// @Accept  json
// @Produce  json
// @Param id path int true "User ID"
// @Success 200 {object} User
// @Failure 404 {string} string "User not found"
// @Router /api/users/{id} [get]
// @Security BearerAuth
func GetUser(c *fiber.Ctx) error {
	id := c.Params("id")
	var user models.User
	database.Database.Db.Find(&user, id)

	if user.ID == 0 {
		return c.Status(404).JSON(fiber.Map{
			"message": "User not found",
		})
	}

	return c.Status(200).JSON(CreateResponseUser(user))
}

// Update user godoc
// @Summary Update user
// @Description Update user
// @Tags users
// @Accept  json
// @Produce  json
// @Param id path int true "User ID"
// @Param user body User true "User"
// @Success 200 {object} User
// @Failure 400 {string} string "Invalid request"
// @Failure 404 {string} string "User not found"
// @Failure 500 {string} string "Error encrypting password"
// @Router /api/users/{id} [put]
func UpdateUser(c *fiber.Ctx) error {
	id, err := c.ParamsInt("id")

	var user models.User

	if err != nil {
		return c.Status(400).JSON("Please ensure that :id is an integer")
	}

	err = GetUserId(id, &user)

	token := c.Locals("user").(*jwt.Token)

	if !validToken(token, id) {
		return c.Status(500).JSON(fiber.Map{"status": "error", "message": "Invalid token id", "data": nil})
	}

	if err != nil {
		return c.Status(400).JSON(err.Error())
	}

	type UpdateUser struct {
		FirstName string `json:"first_name"`
		LastName  string `json:"last_name"`
		Password  string `json:"password"`
	}

	var updateData UpdateUser

	if err := c.BodyParser(&updateData); err != nil {
		return c.Status(500).JSON(err.Error())
	}

	// encrypt password with bcrypt
	pass, err := bcrypt.GenerateFromPassword([]byte(updateData.Password), 14)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{
			"message": "Error encrypting password",
		})
	}

	user.FirstName = updateData.FirstName
	user.LastName = updateData.LastName
	user.Password = string(pass)

	database.Database.Db.Save(&user)

	responseUser := CreateResponseUser(user)

	return c.Status(200).JSON(responseUser)
}

// Delete user godoc
// @Summary Delete user
// @Description Delete user
// @Tags users
// @Accept  json
// @Produce  json
// @Param id path int true "User ID"
// @Success 200 {string} string "User deleted"
// @Failure 400 {string} string "Invalid request"
// @Failure 404 {string} string "User not found"
// @Router /api/users/{id} [delete]
func DeleteUser(c *fiber.Ctx) error {
	id, err := c.ParamsInt("id")

	var user models.User

	if err != nil {
		return c.Status(400).JSON("Please ensure that :id is an integer")
	}

	err = GetUserId(id, &user)

	if err != nil {
		return c.Status(400).JSON(err.Error())
	}

	database.Database.Db.Delete(&user)

	return c.Status(200).JSON(fiber.Map{
		"message": "User deleted",
	})
}
