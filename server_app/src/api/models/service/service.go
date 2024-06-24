package service

import (
	"gorm.io/gorm"
)

// Service domain model
type Service struct {
	gorm.Model
	ID          string  `gorm:"type:uuid;default:gen_random_uuid();primaryKey"`
	UserID      string  `gorm:"type:uuid;not null"`
	Name        string  `gorm:"not null;size:255"`
	Description string  `gorm:"size:255"`
	Price       float64 `gorm:"type:decimal(10,2);not null"`
	Status      bool    `gorm:"not null;default:false"`
	Duration    int     `gorm:"not null;default:30"`
	IsBanned    bool    `gorm:"not null;default:false"`
	Thumbnail   string  `gorm:"size:255"`
	Latitude    float64 `gorm:"type:decimal(10,8);not null"`
	Longitude   float64 `gorm:"type:decimal(11,8);not null"`
	Address     string  `gorm:"size:255;not null"`
	City        string  `gorm:"size:255;not null"`
	PostalCode  string  `gorm:"size:255;not null"`
	Country     string  `gorm:"size:255;not null"`
}
