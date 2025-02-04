package rating

import (
	"gorm.io/gorm"
)

// Rating model
type Rating struct {
	gorm.Model
	ID        string `gorm:"type:uuid;default:gen_random_uuid();unique"`
	UserID    string `gorm:"NOT NULL;type:uuid"`
	ServiceID string `gorm:"NOT NULL;type:uuid"`
	Comment   string `gorm:"size:255"`
	Rating    int    `gorm:"NOT NULL"`
	Status    bool   `gorm:"NOT NULL;default:false"`
}
