package service

import (
	// user model
	"barassage/api/models/service"

	// db
	db "barassage/api/database"
	// "gorm.io/gorm"
)

func Create(service *service.Service) error {
	return db.PgDB.Create(service).Error
}

func GetByID(id string) (*service.Service, error) {
	var service service.Service
	if err := db.PgDB.Where("id = ?", id).First(&service).Error; err != nil {
		return nil, err
	}
	return &service, nil
}

func GetServiceByNameForUser(name string, userID string) (*service.Service, error) {
	var service service.Service
	if err := db.PgDB.Where("name = ? AND user_id = ?", name, userID).First(&service).Error; err != nil {
		return nil, err
	}
	return &service, nil
}

func GetServicesByUserID(userID string) ([]service.Service, error) {
	var services []service.Service
	if err := db.PgDB.Where("user_id = ?", userID).Find(&services).Error; err != nil {
		return nil, err
	}
	return services, nil
}

func GetAllServices() ([]service.Service, error) {
	var services []service.Service
	if err := db.PgDB.Find(&services).Error; err != nil {
		return nil, err
	}
	return services, nil
}

func GetErrors() error {
	return db.PgDB.Error
}

func Update(service *service.Service) error {
	return db.PgDB.Save(service).Error
}
