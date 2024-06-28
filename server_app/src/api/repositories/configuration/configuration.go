package configuration

import (
	// configuration model
	"barassage/api/models/configuration"

	// db
	db "barassage/api/database"
	// "gorm.io/gorm"
)

// Create function creates a new configuration
func Create(configuration *configuration.Configuration) error {
	return db.PgDB.Create(configuration).Error
}

// GetByKey function gets a configuration by key
func GetByKey(key string) (*configuration.Configuration, error) {
	var configuration configuration.Configuration
	//find the configuration by key
	if err := db.PgDB.Where("key = ?", key).First(&configuration).Error; err != nil {
		return nil, err
	}
	return &configuration, nil
}

// Update function updates a configuration
func Update(configuration *configuration.Configuration) error {
	return db.PgDB.Save(configuration).Error
}

// GetAllConfigurations function gets all configurations
func GetAllConfigurations() ([]configuration.Configuration, error) {
	var configurations []configuration.Configuration
	//find all configurations
	if err := db.PgDB.Find(&configurations).Error; err != nil {
		return nil, err
	}
	return configurations, nil
}

// Delete function deletes a configuration
func Delete(configuration *configuration.Configuration) error {
	return db.PgDB.Delete(configuration).Error
}

// GetErrors gets the errors
func GetErrors() error {
	return db.PgDB.Error
}
