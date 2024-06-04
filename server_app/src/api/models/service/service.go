package service

import (
	"gorm.io/gorm"
)

// Service domain model
type Service struct {
	gorm.Model
	ID          string  `gorm:"type:uuid;default:gen_random_uuid();unique"`
	UserID      string  `gorm:"type:uuid;NOT NULL"`
	Name        string  `gorm:"NOT NULL;size:255"`
	Description string  `gorm:"size:255"`
	Price       float64 `gorm:"type:decimal;NOT NULL"`
	Status      bool    `gorm:"NOT NULL;DEFAULT:false"`
	Duration    int     `gorm:"NOT NULL;DEFAULT:30"`
	IsBanned    bool    `gorm:"NOT NULL;DEFAULT:false"`
	Thumbnail   string  `gorm:"size:255"`
}
