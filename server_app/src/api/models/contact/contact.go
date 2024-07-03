package contact

import (
	"barassage/api/models/user"
	"gorm.io/gorm"
)

type Contact struct {
	gorm.Model
	ID          int
	ExternalID  string    `gorm:"unique, not null"`
	Phone       string    `gorm:"unique;not null;size:11"`
	Address     string    `gorm:"not null;"`
	City        string    `gorm:"not null;"`
	Country     string    `gorm:"not null;"`
	PostalCode  string    `gorm:"not null;"`
	Description string    `gorm:"not null;"`
	User        user.User `gorm:"constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
}
