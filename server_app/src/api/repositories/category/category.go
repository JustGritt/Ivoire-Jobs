package category

import (
	// user model
	"barassage/api/models/category"

	// db
	db "barassage/api/database"
	// "gorm.io/gorm"
)

func Create(category *category.Category) error {
	return db.PgDB.Create(category).Error
}

func GetByID(id string) (*category.Category, error) {
	var category category.Category
	//find the category by id, that is active and not banned
	if err := db.PgDB.Where("id = ? AND status =  ?", id, true).First(&category).Error; err != nil {
		return nil, err
	}
	return &category, nil
}

func GetAllCategories() ([]category.Category, error) {
	var categories []category.Category
	///find all category that are not banned and are active
	if err := db.PgDB.Where("status = ?", true).Find(&categories).Error; err != nil {
		return nil, err
	}
	return categories, nil
}

// GetErrors gets the errors
func GetErrors() error {
	return db.PgDB.Error
}

