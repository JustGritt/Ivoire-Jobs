package database

import (
	"log"
	"math/rand"

	"barassage/api/models/category"
	"barassage/api/models/member"
	"barassage/api/models/service"
	"barassage/api/models/user"

	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

func SeedDatabase(db *gorm.DB) {
	log.Println("Starting database seeding...")

	// Configuration
	//excute raw query to insert data
	db.Exec(`INSERT INTO configurations (key, value) VALUES ('mode_maintenance', '["false"]')`)

	// Categories
	if err := seedCategory(db); err != nil {
		log.Printf("Failed to seed categories: %v", err)
	}

	// Standard User
	if err := seedUser(db, "John", "Doe", "john@doe.com", "password", "standard"); err != nil {
		log.Printf("Failed to seed user: %v", err)
	}
	if err := seedUser(db, "Jane", "Doe", "jane@doe.com", "password", "standard"); err != nil {
		log.Printf("Failed to seed user: %v", err)
	}

	// Member User With Services
	if err := seedMemberUser(db, "John", "Wick", "john@wick.com", "password", "standard"); err != nil {
		log.Printf("Failed to seed user: %v", err)
	}
	if err := seedMemberUser(db, "Jane", "Wick", "jane@wick.com", "password", "standard"); err != nil {
		log.Printf("Failed to seed user: %v", err)
	}
	if err := seedMemberUser(db, "Alexis", "Doe", "alexis@doe.com", "password", "standard"); err != nil {
		log.Printf("Failed to seed user: %v", err)
	}

	// Admin
	if err := seedUser(db, "Admin", "User", "admin@admin.com", "turtle", "admin"); err != nil {
		log.Printf("Failed to seed admin user: %v", err)
	}

	log.Println("Database seeding completed.")
}

// seedUser seeds a user
func seedUser(db *gorm.DB, firstName, lastName, email, password, role string) error {
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return err
	}

	user := user.User{
		ID:        uuid.New().String(),
		Firstname: firstName,
		Lastname:  lastName,
		Email:     email,
		Password:  string(hashedPassword),
		Role:      role,
	}

	err = db.Create(&user).Error
	if err != nil {
		log.Printf("Failed to create user %s %s: %v", firstName, lastName, err)
		return err
	} else {
		log.Printf("User created successfully: %s %s", firstName, lastName)
	}

	return nil
}

// seedUser seeds a user and their services
func seedMemberUser(db *gorm.DB, firstName, lastName, email, password, role string) error {
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

	//for the user create the member
	newMember := member.Member{
		UserID: existingUser.ID,
		Reason: "I am a cool user from ESGI",
		Status: "member",
	}

	err = db.Create(&newMember).Error
	if err != nil {
		log.Printf("Failed to create member %s: %v", existingUser.Email, err)
		return err
	} else {
		log.Printf("Member created successfully: %s", existingUser.Email)
	}

	serviceNames := []string{
		"Gura", "Kiara", "Ina", "Calli", "Watson", "Irys", "Fauna", "Kroni", "Mumei", "Bae",
	}

	// Shuffle service names
	rand.Shuffle(len(serviceNames), func(i, j int) {
		serviceNames[i], serviceNames[j] = serviceNames[j], serviceNames[i]
	})

	// get all categories
	var categories []category.Category
	err = db.Find(&categories).Error
	if err != nil {
		log.Printf("Failed to get categories: %v", err)
		return err
	}

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
			Categories:  []category.Category{categories[rand.Intn(len(categories))], categories[rand.Intn(len(categories))]},
			City:        "Paris",
			Country:     "France",
			Address:     "1 rue de la paix",
			PostalCode:  "75000",
			Latitude:    48.8566,
			Longitude:   2.3522,
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
			Categories:  []category.Category{categories[rand.Intn(len(categories))], categories[rand.Intn(len(categories))]},
			City:        "Paris",
			Country:     "France",
			Address:     "1 rue de la paix",
			PostalCode:  "75000",
			Latitude:    48.8566,
			Longitude:   2.3522,
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

// seedCategory seeds a category
func seedCategory(db *gorm.DB) error {

	// Create sample categories, the name should be on service that could be performed in house outside the house, something like that jardinage, ménage, etc
	categories := []category.Category{
		{ID: uuid.New().String(), Name: "Jardinage"},
		{ID: uuid.New().String(), Name: "Ménage"},
		{ID: uuid.New().String(), Name: "Cuisine"},
		{ID: uuid.New().String(), Name: "Réparation"},
		{ID: uuid.New().String(), Name: "Déménagement"},
		{ID: uuid.New().String(), Name: "Peinture"},
		{ID: uuid.New().String(), Name: "Plomberie"},
		{ID: uuid.New().String(), Name: "Électricité"},
		{ID: uuid.New().String(), Name: "Nettoyage de vitres"},
		{ID: uuid.New().String(), Name: "Entretien des sols"},
		{ID: uuid.New().String(), Name: "Blanchisserie"},
		{ID: uuid.New().String(), Name: "Garde d'enfants"},
		{ID: uuid.New().String(), Name: "Soutien scolaire"},
		{ID: uuid.New().String(), Name: "Coiffure"},
		{ID: uuid.New().String(), Name: "Soins esthétiques"},
		{ID: uuid.New().String(), Name: "Massage"},
		{ID: uuid.New().String(), Name: "Toilettage pour animaux"},
		{ID: uuid.New().String(), Name: "Promenade de chiens"},
		{ID: uuid.New().String(), Name: "Courses"},
		{ID: uuid.New().String(), Name: "Livraison de repas"},
		{ID: uuid.New().String(), Name: "Décoration"},
		{ID: uuid.New().String(), Name: "Serrurerie"},
		{ID: uuid.New().String(), Name: "Menuiserie"},
		{ID: uuid.New().String(), Name: "Montage de meubles"},
		{ID: uuid.New().String(), Name: "Réparation d'appareils électroménagers"},
		{ID: uuid.New().String(), Name: "Garde de maison"},
		{ID: uuid.New().String(), Name: "Nettoyage de voitures"},
		{ID: uuid.New().String(), Name: "Réparation de vélo"},
		{ID: uuid.New().String(), Name: "Aménagement paysager"},
		{ID: uuid.New().String(), Name: "Maintenance informatique"},
	}

	for _, c := range categories {
		err := db.Create(&c).Error
		if err != nil {
			log.Printf("Failed to create category %s: %v", c.Name, err)
			return err
		} else {
			log.Printf("Category created successfully: %s", c.Name)
		}
	}

	return nil
}
