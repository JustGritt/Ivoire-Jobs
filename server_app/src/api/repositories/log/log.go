package log

import (
	db "barassage/api/database"
	"barassage/api/models/log"
)

// Create Log
func Create(log *log.Log) error {
	return db.PgDB.Create(log).Error
}

// GetAll Logs
func GetAll() ([]log.Log, error) {
	var logs []log.Log
	if err := db.PgDB.Find(&logs).Error; err != nil {
		return nil, err
	}
	return logs, nil
}

// Get by query params
func GetByQueryParams(queryParams map[string]interface{}) ([]log.Log, error) {
	var logs []log.Log
	if err := db.PgDB.Where(queryParams).Find(&logs).Error; err != nil {
		return nil, err
	}
	return logs, nil
}

// Update Log
func Update(log *log.Log) error {
	return db.PgDB.Save(log).Error
}

// Delete Log
func Delete(log *log.Log) error {
	return db.PgDB.Delete(log).Error
}

// GetErrors returns the last error
func GetErrors() error {
	return db.PgDB.Error
}
