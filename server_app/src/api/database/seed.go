package database

import (
	"log"
	"math/rand"
	"time"

	"barassage/api/models/service"
	"barassage/api/models/user"

	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

func SeedDatabase(db *gorm.DB) {
	log.Println("Starting database seeding...")

	// Standard
	if err := seedUser(db, "John", "Doe", "john@doe.com", "password", "standard"); err != nil {
		log.Printf("Failed to seed user: %v", err)
	}
	if err := seedUser(db, "Jane", "Doe", "jane@doe.com", "password", "standard"); err != nil {
		log.Printf("Failed to seed user: %v", err)
	}
	if err := seedUser(db, "John", "Wick", "john@wick.com", "password", "standard"); err != nil {
		log.Printf("Failed to seed user: %v", err)
	}

	// Admin
	if err := seedUser(db, "Admin", "User", "admin@admin.com", "turtle", "admin"); err != nil {
		log.Printf("Failed to seed admin user: %v", err)
	}

	log.Println("Database seeding completed.")
}

// seedUser seeds a user and their services
func seedUser(db *gorm.DB, firstName, lastName, email, password, role string) error {
	log.Printf("Seeding user %s...", email)

	var existingUser user.User
	err := db.Where("email = ?", email).First(&existingUser).Error
	if err == gorm.ErrRecordNotFound {
		hashedPassword, hashErr := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
		if hashErr != nil {
			log.Printf("Failed to hash password for user %s: %v", email, hashErr)
			return hashErr
		}

		// Create a new user
		newUser := user.User{
			ID:             uuid.New().String(),
			Firstname:      firstName,
			Lastname:       lastName,
			ProfilePicture: "string",
			Bio:            "I am a cool user from ESGI",
			Email:          email,
			Password:       string(hashedPassword),
			Role:           role,
			Active:         true,
		}

		err = db.Create(&newUser).Error
		if err != nil {
			log.Printf("Failed to create user %s: %v", email, err)
			return err
		}
		log.Printf("User created successfully: %s", email)
		existingUser = newUser
	} else if err != nil {
		log.Printf("Failed to check if user exists %s: %v", email, err)
		return err
	} else {
		log.Printf("User already exists: %s", email)
	}

	rand.Seed(time.Now().UnixNano())
	serviceNames := []string{
		"Gura", "Kiara", "Ina", "Calli", "Watson", "Irys", "Fauna", "Kroni", "Mumei", "Bae",
	}

	// Shuffle service names
	rand.Shuffle(len(serviceNames), func(i, j int) {
		serviceNames[i], serviceNames[j] = serviceNames[j], serviceNames[i]
	})

	// Create sample services for the user
	services := []service.Service{
		{
			ID:          uuid.New().String(),
			UserID:      existingUser.ID,
			Name:        firstName + "'s Service " + serviceNames[0],
			Description: "Description of " + firstName + "'s service " + serviceNames[0],
			Price:       rand.Float64() * 1000,
			Status:      true,
			Duration:    30,
			IsBanned:    false,
			Thumbnail:   "string",
		},
		{
			ID:          uuid.New().String(),
			UserID:      existingUser.ID,
			Name:        firstName + "'s Service " + serviceNames[1],
			Description: "This is a description for " + firstName + "'s service " + serviceNames[1],
			Price:       rand.Float64() * 1000, // Random price between 0 and 1000
			Status:      true,
			Duration:    60,
			IsBanned:    false,
			Thumbnail:   "string",
		},
	}

	for _, s := range services {
		err = db.Create(&s).Error
		if err != nil {
			log.Printf("Failed to create service %s: %v", s.Name, err)
			return err
		} else {
			log.Printf("Service created successfully: %s", s.Name)
		}
	}

	return nil
}
