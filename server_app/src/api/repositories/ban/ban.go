package ban

import (
	// user model
	"barassage/api/models/ban"

	// db
	db "barassage/api/database"
	// "gorm.io/gorm"
)

// Create a ban
func Create(ban *ban.Ban) error {
	return db.PgDB.Create(ban).Error
}

// GetByID gets a ban by id
func GetByID(id string) (*ban.Ban, error) {
	var ban ban.Ban
	//find the ban by id
	if err := db.PgDB.Where("id = ?", id).First(&ban).Error; err != nil {
		return nil, err
	}
	return &ban, nil
}

func GetByUserID(userID string) (*ban.Ban, error) {
	var ban ban.Ban
	//find the ban by id
	if err := db.PgDB.Where("user_id = ?", userID).First(&ban).Error; err != nil {
		return nil, err
	}
	return &ban, nil
}

func IsAlreadyDeleted(userID string) bool {
	var ban ban.Ban
	return db.PgDB.Unscoped().Where("user_id = ?", userID).First(&ban).Error == nil
}

// GetAllBans gets all bans
func GetAllBans() ([]ban.Ban, error) {
	var bans []ban.Ban
	//find all bans
	if err := db.PgDB.Find(&bans).Error; err != nil {
		return nil, err
	}
	return bans, nil
}

func Unban(id string) error {
	return db.PgDB.Model(&ban.Ban{}).Where("id = ?", id).Update("is_banned", false).Error
}

func Ban(id string) error {
	return db.PgDB.Model(&ban.Ban{}).Where("id = ?", id).Update("is_banned", true).Error
}

func Delete(id string) error {
	return db.PgDB.Unscoped().Where("id = ?", id).Delete(&ban.Ban{}).Error
}

// GetErrors gets the errors
func GetErrors() error {
	return db.PgDB.Error
}
