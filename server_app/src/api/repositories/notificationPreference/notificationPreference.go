package notificationPreference

import (
	// configuration model
	"barassage/api/models/notificationPreference"

	// db
	db "barassage/api/database"
	// "gorm.io/gorm"
)

// Create function creates a new configuration
func Create(notificationPreference *notificationPreference.NotificationPreference) error {
	return db.PgDB.Create(notificationPreference).Error
}

// GetByUserID function gets a notificationPreference by user id
func GetByUserID(userID string) (*notificationPreference.NotificationPreference, error) {
	// get the notificationPreference
	var notificationPreference *notificationPreference.NotificationPreference
	if err := db.PgDB.Where("user_id = ?", userID).First(&notificationPreference).Error; err != nil {
		return nil, err
	}

	return notificationPreference, nil
}

func GetAll() ([]notificationPreference.NotificationPreference, error) {
	var notificationPreferences []notificationPreference.NotificationPreference
	if err := db.PgDB.Find(&notificationPreferences).Error; err != nil {
		return nil, err
	}

	return notificationPreferences, nil
}

// Update function updates a notificationPreference
func Update(notificationPreference *notificationPreference.NotificationPreference) error {
	return db.PgDB.Save(notificationPreference).Error
}

// Delete function deletes a notificationPreference
func Delete(notificationPreference *notificationPreference.NotificationPreference) error {
	return db.PgDB.Delete(notificationPreference).Error
}

// GetErrors gets the errors
func GetErrors() error {
	return db.PgDB.Error
}
