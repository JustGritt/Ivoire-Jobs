package rating

import (
	db "barassage/api/database"
	"barassage/api/models/rating"
)

// Create a rating
func Create(r *rating.Rating) error {
	return db.PgDB.Create(r).Error
}

// GetByID gets a rating by id
func GetByID(id string) (*rating.Rating, error) {
	var r rating.Rating
	if err := db.PgDB.Where("id = ?", id).First(&r).Error; err != nil {
		return nil, err
	}
	return &r, nil
}

// GetByUserID gets a rating by user id
func GetByUserID(userID string) ([]rating.Rating, error) {
	var ratings []rating.Rating
	if err := db.PgDB.Where("user_id = ?", userID).Find(&ratings).Error; err != nil {
		return nil, err
	}
	return ratings, nil
}

// GetAllRatings gets all ratings
func GetAllRatings() ([]rating.Rating, error) {
	var ratings []rating.Rating
	if err := db.PgDB.Where("status = ?", true).Find(&ratings).Error; err != nil {
		return nil, err
	}
	return ratings, nil
}

// PendingRatings gets all pending ratings
func PendingRatings() ([]rating.Rating, error) {
	var ratings []rating.Rating
	if err := db.PgDB.Where("status = ?", false).Find(&ratings).Error; err != nil {
		return nil, err
	}
	return ratings, nil
}

// GetByServiceID gets all ratings by service id
func GetByServiceID(serviceID string) ([]rating.Rating, error) {
	var ratings []rating.Rating
	if err := db.PgDB.Where("service_id = ? AND status = ?", serviceID, true).Find(&ratings).Error; err != nil {
		return nil, err
	}
	return ratings, nil
}

// GetRatingScore calculates the average rating score for a service
func GetRatingScore(serviceID string) (float64, error) {
	var ratings []rating.Rating
	if err := db.PgDB.Where("service_id = ? AND status = ?", serviceID, true).Find(&ratings).Error; err != nil {
		return 0, err
	}

	if len(ratings) == 0 {
		return 0, nil
	}

	var score float64
	for _, r := range ratings {
		score += float64(r.Rating)
	}
	return score / float64(len(ratings)), nil
}

// ValidateRating updates the status of a rating
func ValidateRating(id string, status bool) error {
	return db.PgDB.Model(&rating.Rating{}).Where("id = ?", id).Update("status", status).Error
}

// DeleteRating deletes a rating by id
func DeleteRating(id string) error {
	return db.PgDB.Where("id = ?", id).Delete(&rating.Rating{}).Error
}

// IsAlreadyDeleted checks if a rating is already deleted
func IsAlreadyDeleted(id string) (bool, error) {
	var r rating.Rating
	if err := db.PgDB.Unscoped().Where("id = ?", id).First(&r).Error; err != nil {
		return false, err
	}
	return true, nil
}

// GetErrors gets the database errors
func GetErrors() error {
	return db.PgDB.Error
}
