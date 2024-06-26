package report

import (
	// user model
	"barassage/api/models/report"

	// db
	db "barassage/api/database"
	// "gorm.io/gorm"
)

func Create(report *report.Report) error {
	return db.PgDB.Create(report).Error
}

func GetByID(id string) (*report.Report, error) {
	var report report.Report
	//find the report by id, that is active and not banned
	if err := db.PgDB.Where("id = ?", id).First(&report).Error; err != nil {
		return nil, err
	}
	return &report, nil
}

func GetReportsByUserForService(userID string, serviceID string) ([]report.Report, error) {
	var reports []report.Report
	if err := db.PgDB.Where("user_id = ? AND service_id = ?", userID, serviceID).Find(&reports).Error; err != nil {
		return nil, err
	}
	return reports, nil
}

func GetReportsByUserID(userID string) ([]report.Report, error) {
	var reports []report.Report
	if err := db.PgDB.Where("user_id = ?", userID).Find(&reports).Error; err != nil {
		return nil, err
	}
	return reports, nil
}

func GetAllReports() ([]report.Report, error) {
	var reports []report.Report
	///find all report
	if err := db.PgDB.Find(&reports).Error; err != nil {
		return nil, err
	}
	return reports, nil
}

func GetReportCount(serviceId string) (int64, error) {
	var count int64
	if err := db.PgDB.Model(&report.Report{}).Where("service_id = ?", serviceId).Count(&count).Error; err != nil {
		return 0, err
	}
	return count, nil
}

func GetErrors() error {
	return db.PgDB.Error
}

func Update(report *report.Report) error {
	return db.PgDB.Save(report).Error
}

func Delete(report *report.Report) error {
	return db.PgDB.Delete(report).Error
}
