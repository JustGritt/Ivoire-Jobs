package refreshToken

import (
	// user model
	refreshtoken "barassage/api/models/refreshToken"

	// db
	db "barassage/api/database"
	// "gorm.io/gorm"
)

func Create(refreshToken *refreshtoken.RefreshToken) error {
	if err := db.PgDB.Create(&refreshToken).Error; err != nil {
		return err
	}
	return nil
}

func Update(refreshToken *refreshtoken.RefreshToken) error {
	if err := db.PgDB.Save(&refreshToken).Error; err != nil {
		return err
	}
	return nil
}

func GetRefreshTokenForUser(userId string) (*refreshtoken.RefreshToken, error) {
	// get the refreshToken
	var refreshToken *refreshtoken.RefreshToken
	if err := db.PgDB.Where("user_id = ?", userId).First(&refreshToken).Error; err != nil {
		return nil, err
	}

	return refreshToken, nil
}

func GetRefreshTokenByToken(token string) (*refreshtoken.RefreshToken, error) {
	// get the refreshToken
	var refreshToken *refreshtoken.RefreshToken
	if err := db.PgDB.Where("token = ?", token).First(&refreshToken).Error; err != nil {
		return nil, err
	}

	return refreshToken, nil
}

func GetErrors() error {
	return db.PgDB.Error
}
