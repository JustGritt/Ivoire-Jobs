package report

import (
	"time"

	"gorm.io/gorm"
)

type Report struct {
	gorm.Model
	ID        string    `gorm:"type:uuid;default:gen_random_uuid();unique"`
	ServiceID string    `gorm:"NOT NULL;type:uuid"`
	UserID    string    `gorm:"NOT NULL;type:uuid"`
	Reason    string    `gorm:"NOT NULL;size:255"`
	CreatedAt time.Time `gorm:"NOT NULL"`
	Status    bool      `gorm:"NOT NULL;DEFAULT:false"`
}
