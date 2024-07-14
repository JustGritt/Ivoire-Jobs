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
	if err := db.PgDB.Preload("Images").Preload("Categories").Where("id = ? AND status = ? AND is_banned = ?", id, true, false).First(&service).Error; err != nil {
		return nil, err
	}
	return &service, nil
}

func GetByIDUnscoped(id string) (*service.Service, error) {
	var service service.Service
	//find the service by id, that is active and not banned
	if err := db.PgDB.Preload("Images").Preload("Categories").Unscoped().Where("id = ?", id).First(&service).Error; err != nil {
		return nil, err
	}
	return &service, nil
}

func IsBannedService(id string) (bool, error) {
	var service service.Service
	if err := db.PgDB.Where("id = ?", id).First(&service).Error; err != nil {
		return false, err
	}
	return service.IsBanned, nil
}

func GetServiceByNameForUser(name string, userID string) (*service.Service, error) {
	var service service.Service
	if err := db.PgDB.Preload("Images").Preload("Categories").Where("name = ? AND user_id = ?", name, userID).First(&service).Error; err != nil {
		return nil, err
	}
	return &service, nil
}

func GetServicesByUserID(userID string) ([]service.Service, error) {
	var services []service.Service
	if err := db.PgDB.Preload("Images").Preload("Categories").Preload("Bookings").Where("user_id = ?", userID).Find(&services).Error; err != nil {
		return nil, err
	}
	return services, nil
}

// Get all banned services
func GetAllBannedServices() ([]service.Service, error) {
	var services []service.Service
	if err := db.PgDB.Where("is_banned = ?", true).Find(&services).Error; err != nil {
		return nil, err
	}
	return services, nil
}

func GetAllServices() ([]service.Service, error) {
	var services []service.Service
	// Find all services that are not banned and are active, preload with their categories and images and left join raw queri on userID to get the user
	if err := db.PgDB.Preload("Images").Preload("Categories").Where("status = ? AND is_banned = ?", true, false).Find(&services).Error; err != nil {
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
	return db.PgDB.Select("Images").Preload("Categories").Delete(service).Error
}

// SearchServices searches for services by name, price, or both using dynamic query construction
func SearchServices(name string, minPrice float64, maxPrice float64, city string, country string, categories []string) ([]service.Service, error) {
	var services []service.Service
	query := db.PgDB.Model(&service.Service{})

	// Construct the query based on the provided parameters
	if name != "" {
		query = query.Where("LOWER(services.name) LIKE ?", "%"+strings.ToLower(name)+"%")
	}
	if minPrice > 0 {
		query = query.Where("services.price >= ?", minPrice)
	}
	if maxPrice > 0 {
		query = query.Where("services.price <= ?", maxPrice)
	}
	if city != "" {
		query = query.Where("LOWER(services.city) LIKE ?", "%"+strings.ToLower(city)+"%")
	}
	if country != "" {
		query = query.Where("LOWER(services.country) LIKE ?", "%"+strings.ToLower(country)+"%")
	}
	if len(categories) > 0 {
		query = query.Joins("JOIN service_categories ON services.id = service_categories.service_id").
			Joins("JOIN categories ON service_categories.category_id = categories.id").
			Where("categories.name IN (?)", categories)
	}

	// Check if the service is active and not banned
	query = query.Where("services.status = ? AND services.is_banned = ?", true, false)

	// Execute the query and preload the images and categories
	if err := query.Preload("Images").Preload("Categories").Find(&services).Error; err != nil {
		return nil, err
	}
	return services, nil
}

// GetTrendingServices returns the top 5 services with the most views
func GetTrendingServices() ([]service.Service, error) {
	var services []service.Service
	// Find the top 5 services with the most bookings form bookings table
	query := db.PgDB.Model(&service.Service{}).
		Select("services.*").
		Joins("JOIN bookings ON services.id = bookings.service_id").
		Group("services.id").
		Order("COUNT(bookings.id) DESC").
		Limit(5).
		Preload("Images").
		Preload("Categories")

	if err := query.Find(&services).Error; err != nil {
		return nil, err
	}

	// If less than 5 services are found, add remaining services from the service table
	if len(services) < 5 {
		var remainingServices []service.Service
		// Add the remaining services from the service table
		subQuery := db.PgDB.Model(&service.Service{}).
			Select("services.id").
			Joins("JOIN bookings ON services.id = bookings.service_id").
			Group("services.id").
			Order("COUNT(bookings.id) DESC").
			Limit(5)

		if err := db.PgDB.Model(&service.Service{}).
			Where("services.id NOT IN (?)", subQuery).
			Limit(5 - len(services)).
			Preload("Images").
			Preload("Categories").
			Find(&remainingServices).Error; err != nil {
			return nil, err
		}

		// Combine the two lists
		services = append(services, remainingServices...)
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

func CountAll() (int64, error) {
	//get all services that are active and not banned
	var count int64
	query := db.PgDB.Model(&service.Service{}).Where("status = ? AND is_banned = ?", true, false)
	err := query.Count(&count).Error
	return count, err
}
