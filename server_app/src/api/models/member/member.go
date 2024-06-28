package member

import (
	"gorm.io/gorm"
)

// Ban domain model
type Member struct {
	gorm.Model
	ID     string `gorm:"type:uuid;default:gen_random_uuid();unique"`
	UserID string `gorm:"NOT NULL;type:uuid"`
	Reason string `gorm:"NOT NULL;size:255"`
	Status bool   `gorm:"NOT NULL;default:false"`
}
