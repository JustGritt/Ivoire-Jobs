package user

import (
	"gorm.io/gorm"
)

// User domain model
type User struct {
	gorm.Model
	ID             string `gorm:"type:uuid;default:gen_random_uuid();unique"`
	Firstname      string `gorm:"NOT NULL;size:255"`
	Lastname       string `gorm:"NOT NULL;size:255"`
	ProfilePicture string `gorm:"size:255"`
	Bio            string `gorm:"size:255"`
	Email          string `gorm:"NOT NULL;UNIQUE"`
	Password       string `gorm:"NOT NULL"`
	Role           string `gorm:"NOT NULL;size:255;DEFAULT:'standard'"`
	Active         bool   `gorm:"NOT NULL;DEFAULT:true"`
}
