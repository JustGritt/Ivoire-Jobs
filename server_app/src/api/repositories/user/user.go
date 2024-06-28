package user

import (
	"time"

	"barassage/api/database"
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
	if err := database.PgDB.Where("id = ? AND active = ?", id, true).First(&user).Error; err != nil {
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
func GetAllUsers() ([]user.User, error) {
	var users []user.User
	err := database.PgDB.Find(&users).Error
	return users, err
}
