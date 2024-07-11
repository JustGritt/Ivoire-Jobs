package contact

import (
	"gorm.io/gorm"
)

type Contact struct {
	gorm.Model
	ID         string  `gorm:"type:uuid;default:gen_random_uuid();unique"`
	Phone      string  `gorm:"unique;not null;size:11"`
	Address    string  `gorm:"not null;"`
	City       string  `gorm:"not null;"`
	Country    string  `gorm:"not null;"`
	PostalCode string  `gorm:"not null;"`
	Latitude   float64 `gorm:"type:decimal(10,8);not null"`
	Longitude  float64 `gorm:"type:decimal(11,8);not null"`
}
