package booking

import (
	"time"

	"gorm.io/gorm"
)

// Booking domain model
type Booking struct {
	gorm.Model
	ID        string    `gorm:"type:uuid;default:gen_random_uuid();unique"`
	UserID    string    `gorm:"type:uuid;NOT NULL"`
	ServiceID string    `gorm:"type:uuid;NOT NULL"`
	Status    string    `gorm:"NOT NULL;DEFAULT:'created'"` // created, confirmed, completed, cancelled
	StartTime time.Time `gorm:"NOT NULL"`
	EndTime   time.Time `gorm:"NOT NULL"`
}
