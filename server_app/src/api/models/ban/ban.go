package user

import (
	"barassage/api/models/service"

	"gorm.io/gorm"
)

// Ban domain model
type Ban struct {
	gorm.Model
	ID             string            `gorm:"type:uuid;default:gen_random_uuid();unique"`
	Firstname      string            `gorm:"NOT NULL;size:255"`
	Lastname       string            `gorm:"NOT NULL;size:255"`
	ProfilePicture string            `gorm:"size:255"`
	Bio            string            `gorm:"size:255"`
	Email          string            `gorm:"NOT NULL;UNIQUE"`
	Password       string            `gorm:"NOT NULL"`
	Role           string            `gorm:"NOT NULL;size:255;DEFAULT:'standard'"`
	Active         bool              `gorm:"NOT NULL;DEFAULT:false"`
	Services       []service.Service `gorm:"foreignKey:UserID"`
}
