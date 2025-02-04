package pushToken

import (
	// user model
	"barassage/api/models/pushToken"

	// db
	db "barassage/api/database"
	// "gorm.io/gorm"
)

// GetPushToken gets a pushToken
func GetPushTokenForUser(token string, userId string) (*pushToken.PushToken, error) {
	// get the pushToken
	var pushToken *pushToken.PushToken
	if err := db.PgDB.Where("user_id = ? and token = ?", userId, token).First(&pushToken).Error; err != nil {
		return nil, err
	}

	return pushToken, nil
}

// GetErrors gets the errors
func GetErrors() error {
	return db.PgDB.Error
}
