package category

import (
	"gorm.io/gorm"
)

type Category struct {
	gorm.Model
	ID     string `gorm:"type:uuid;default:gen_random_uuid();primaryKey"`
	Name   string `gorm:"size:255;not null"`
	Status bool   `gorm:"default:true"`
}
