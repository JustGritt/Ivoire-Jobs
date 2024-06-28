package rating

import (
	"gorm.io/gorm"
)

// Ban domain model
type Rating struct {
	gorm.Model
	ID        string `gorm:"type:uuid;default:gen_random_uuid();unique"`
	UserID    string `gorm:"NOT NULL;type:uuid"`
	Comment   string `gorm:"size:255"`
	Rating    int    `gorm:"NOT NULL;size:255"`
	ServiceId string `gorm:"NOT NULL;type:uuid"`
	Status    bool   `gorm:"NOT NULL;DEFAULT:false"`
}
