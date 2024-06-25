package image

import (
	"gorm.io/gorm"
)

// Image domain model
type Image struct {
	gorm.Model
	ID        string `gorm:"type:uuid;default:gen_random_uuid();primaryKey"`
	ServiceID string `gorm:"type:uuid;not null"`
	URL       string `gorm:"size:255;not null"`
}
