package service

import (
	// user model

	"barassage/api/models/service"
	"strings"

	// db
	db "barassage/api/database"
	// "gorm.io/gorm"
)

func Create(service *service.Service) error {
	return db.PgDB.Create(service).Error
}

func GetByID(id string) (*service.Service, error) {
	var service service.Service
	//find the service by id, that is active and not banned
	if err := db.PgDB.Preload("Images").Where("id = ? AND status = ? AND is_banned = ?", id, true, false).First(&service).Error; err != nil {
		return nil, err
	}
	return &service, nil
}

func GetServiceByNameForUser(name string, userID string) (*service.Service, error) {
	var service service.Service
	if err := db.PgDB.Preload("Images").Where("name = ? AND user_id = ?", name, userID).First(&service).Error; err != nil {
		return nil, err
	}
	return &service, nil
}

func GetServicesByUserID(userID string) ([]service.Service, error) {
	var services []service.Service
	if err := db.PgDB.Preload("Images").Where("user_id = ?", userID).Find(&services).Error; err != nil {
		return nil, err
	}
	return services, nil
}

func GetAllServices() ([]service.Service, error) {
	var services []service.Service
	///find all service that are not banned and are active
	if err := db.PgDB.Preload("Images").Where("status = ? AND is_banned = ?", true, false).Find(&services).Error; err != nil {
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

func Delete(service *service.Service) error {
	return db.PgDB.Select("Images").Delete(service).Error
}

// SearchServices searches for services by name, price, or both using dynamic query construction
func SearchServices(name string, minPrice float64, maxPrice float64) ([]service.Service, error) {
	var services []service.Service
	query := db.PgDB.Model(&service.Service{})

	// Construct the query based on the provided parameters
	if name != "" {
		query = query.Where("LOWER(name) LIKE ?", "%"+strings.ToLower(name)+"%")
	}
	if minPrice > 0 {
		query = query.Where("price >= ?", minPrice)
	}
	if maxPrice > 0 {
		query = query.Where("price <= ?", maxPrice)
	}

	//check if the service is active and not banned
	query = query.Where("status = ? AND is_banned = ?", true, false)

	// Execute the query and preload the images
	if err := query.Preload("Images").Find(&services).Error; err != nil {
		return nil, err
	}
	return services, nil
}

// delete the image from the service
func DeleteImage(service *service.Service, imageURL string) error {
	// Find the image
	for i, image := range service.Images {
		if image.URL == imageURL {
			// Delete the image from the database
			if err := db.PgDB.Delete(&image).Error; err != nil {
				return err
			}
			// Remove the image from the service
			service.Images = append(service.Images[:i], service.Images[i+1:]...)
			return nil
		}
	}
	return nil
}
