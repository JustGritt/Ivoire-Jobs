package user

import (
	"time"

	"barassage/api/database"
	"barassage/api/models/ban"
	"barassage/api/models/report"
	"barassage/api/models/service" // Import the correct package for Service model
	"barassage/api/models/user"
)

// Create User
func Create(user *user.User) error {
	return database.PgDB.Create(user).Error
}

// GetByEmail gets user with the given email
func GetByEmail(email string) (*user.User, error) {
	var user user.User
	if err := database.PgDB.Where("email = ?", email).First(&user).Error; err != nil {
		return nil, err
	}
	return &user, nil
}

// GetByEmail gets user with the given email check if active is true, banned is false
func GetById(id string) (*user.User, error) {
	var user user.User
	if err := database.PgDB.Preload("Member").Preload("NotificationPreference").Preload("PushToken").Where("id = ? AND active = ?", id, true).First(&user).Error; err != nil {
		return nil, err
	}
	return &user, nil
}

func PendingActivateUser(id string) (*user.User, error) {
	var user user.User
	if err := database.PgDB.Where("id = ?", id).First(&user).Error; err != nil {
		return nil, err
	}
	return &user, nil
}

func GetErrors() error {
	return database.PgDB.Error
}

func Update(user *user.User) error {
	return database.PgDB.Save(user).Error
}

// Insert Report
func InsertReport(serviceID, userID, reason string) error {
	report := report.Report{
		ServiceID: serviceID,
		UserID:    userID,
		Reason:    reason,
		CreatedAt: time.Now(),
		Status:    false,
	}

	return database.PgDB.Create(&report).Error
}

// Get Reports by Service ID
func GetReportsByServiceID(serviceID string) ([]report.Report, error) {
	var reports []report.Report
	err := database.PgDB.Where("service_id = ?", serviceID).Find(&reports).Error
	return reports, err
}

// Hide Service
func HideService(serviceID string) error {
	return database.PgDB.Model(&service.Service{}).Where("id = ?", serviceID).Update("is_hidden", true).Error
}

// Get All Reports
func GetAllReports() ([]report.Report, error) {
	var reports []report.Report
	err := database.PgDB.Find(&reports).Error
	return reports, err
}

// Set User Ban Status
func SetUserBanStatus(userID string, isBanned bool) error {
	return database.PgDB.Model(&user.User{}).Where("id = ?", userID).Update("active", !isBanned).Error
}

// Get all users
func GetAllUsers(userType string) ([]user.User, error) {
	var users []user.User

	// Build the query
	query := database.PgDB.Table("users").Select("users.*").
		Joins("left join bans on users.id = bans.user_id").
		Where("bans.user_id is null")

	// Add role filtering based on userType
	if userType == "users" {
		query = query.Where("users.role = ?", "standard")
	} else if userType == "admin" {
		query = query.Where("users.role = ?", "admin")
	}

	// Execute the query
	err := query.Find(&users).Error
	return users, err
}

func CountAll() (int64, error) {
	//get all user active and not banned, banned is bans table
	var count int64
	err := database.PgDB.Model(&user.User{}).
		Where("active = ?", true).
		Not("id IN (?)", database.PgDB.Model(&ban.Ban{}).Select("user_id")).
		Count(&count).Error
	if err != nil {
		return 0, err
	}
	return count, nil
}
