package rating

import (
	// user model
	"barassage/api/models/rating"

	// db
	db "barassage/api/database"
	// "gorm.io/gorm"
)

// Create a rating
func Create(rating *rating.Rating) error {
	return db.PgDB.Create(rating).Error
}

// GetByID gets a rating by id
func GetByID(id string) (*rating.Rating, error) {
	var rating rating.Rating
	//find the rating by id
	if err := db.PgDB.Where("id = ?", id).First(&rating).Error; err != nil {
		return nil, err
	}
	return &rating, nil
}

func GetByUserID(userID string) (*rating.Rating, error) {
	var rating rating.Rating
	//find the rating by id
	if err := db.PgDB.Where("user_id = ?", userID).First(&rating).Error; err != nil {
		return nil, err
	}
	return &rating, nil
}

// GetAllRatings gets all ratings
func GetAllRatings() ([]rating.Rating, error) {
	var ratings []rating.Rating
	//find all ratings
	if err := db.PgDB.Where("status = ?", true).Find(&ratings).Error; err != nil {
		return nil, err
	}
	return ratings, nil
}

func PendingRatings() ([]rating.Rating, error) {
	var ratings []rating.Rating
	//find all ratings
	if err := db.PgDB.Where("status = ?", false).Find(&ratings).Error; err != nil {
		return nil, err
	}
	return ratings, nil
}

func GetByServiceID(serviceID string) ([]rating.Rating, error) {
	var ratings []rating.Rating
	//find all ratings
	if err := db.PgDB.Where("service_id = ? AND status = ?", serviceID, true).Find(&ratings).Error; err != nil {
		return nil, err
	}
	return ratings, nil
}

// Validate a rating by id
func ValidateRating(id string) error {
	return db.PgDB.Model(&rating.Rating{}).Where("id = ?", id).Update("status", true).Error
}

func DeleteRating(id string) error {
	return db.PgDB.Where("id = ?", id).Delete(&rating.Rating{}).Error
}

// GetErrors gets the errors
func GetErrors() error {
	return db.PgDB.Error
}
