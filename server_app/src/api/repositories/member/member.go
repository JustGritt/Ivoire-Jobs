package member

import (
	// user model
	"barassage/api/models/member"

	// db
	db "barassage/api/database"
	// "gorm.io/gorm"
)

// Create a member
func Create(ban *member.Member) error {
	return db.PgDB.Create(ban).Error
}

// GetByID gets a member by id
func GetByID(id string) (*member.Member, error) {
	var ban member.Member
	//find the ban by id
	if err := db.PgDB.Where("id = ?", id).First(&ban).Error; err != nil {
		return nil, err
	}
	return &ban, nil
}

func GetByUserID(userID string) (*member.Member, error) {
	var ban member.Member
	//get the last member record
	if err := db.PgDB.Where("user_id = ?", userID).First(&ban).Error; err != nil {
		return nil, err
	}
	return &ban, nil
}

func CheckIfMemberExists(userID string) bool {
	var ban member.Member
	//find the ban by id
	if err := db.PgDB.Where("user_id = ? AND status = ?", userID, "member").First(&ban).Error; err != nil {
		return false
	}
	return true
}

func GetPendingRequest(userID string) (*member.Member, error) {
	var ban member.Member
	//find the ban by id
	if err := db.PgDB.Where("user_id = ? AND status = ?", userID, "processing").First(&ban).Error; err != nil {
		return nil, err
	}
	return &ban, nil
}

func GetAllRequests(status string) ([]member.Member, error) {
	var bans []member.Member
	query := db.PgDB.Model(&member.Member{})

	if status != "all" {
		query = query.Where("status = ?", status)
	}

	err := query.Find(&bans).Error
	if err != nil {
		return nil, err
	}
	return bans, nil
}

// GetAllMembers gets all members
func GetAllMembers() ([]member.Member, error) {
	var bans []member.Member
	//find all bans
	if err := db.PgDB.Find(&bans).Error; err != nil {
		return nil, err
	}
	return bans, nil
}

// ValidateMember validates a member
func ValidateMember(id string, status string) error {
	return db.PgDB.Model(&member.Member{}).Where("id = ?", id).Update("status", status).Error
}

// GetErrors gets the errors
func GetErrors() error {
	return db.PgDB.Error
}

func CountAll() (int64, error) {
	var count int64
	if err := db.PgDB.Model(&member.Member{}).Where("status =  ?", "member").Count(&count).Error; err != nil {
		return 0, err
	}
	return count, nil
}
