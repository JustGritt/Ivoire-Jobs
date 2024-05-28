package user

import (
	// user model
	"barassage/api/models/user"

	// db
	db "barassage/api/database"
	// "gorm.io/gorm"
)

// Create User
func Create(user *user.User) error {
	return db.PgDB.Create(user).Error
}

// GetByEmail gets user with the given email
func GetByEmail(email string) (*user.User, error) {
	var user user.User
	if err := db.PgDB.Where("email = ?", email).First(&user).Error; err != nil {
		return nil, err
	}
	return &user, nil
}

// GetByEmail gets user with the given email
func GetById(id string) (*user.User, error) {
	var user user.User
	if err := db.PgDB.Where("id = ?", id).First(&user).Error; err != nil {
		return nil, err
	}
	return &user, nil
}

func GetErrors() error {
	return db.PgDB.Error
}
