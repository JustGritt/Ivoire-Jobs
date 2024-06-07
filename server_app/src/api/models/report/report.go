package report

import (
	"gorm.io/gorm"
	"time"
)

// Report domain model
type Report struct {
	gorm.Model
	ID        string    `gorm:"type:uuid;default:gen_random_uuid();unique"`
	UserID    string    `gorm:"type:uuid;NOT NULL"`
	ServiceID string    `gorm:"type:uuid;NOT NULL"`
	Reason    string    `gorm:"size:255"`
	Status    bool      `gorm:"NOT NULL;DEFAULT:false"`
	CreatedAt time.Time `gorm:"NOT NULL;DEFAULT:false"`
}
