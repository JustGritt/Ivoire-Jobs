package booking

import (
	"barassage/api/models/contact"
	"time"

	"gorm.io/gorm"
)

// Booking domain model
type Booking struct {
	gorm.Model
	ID        string          `gorm:"type:uuid;default:gen_random_uuid();unique"`
	UserID    string          `gorm:"type:uuid;NOT NULL"`
	ServiceID string          `gorm:"type:uuid;NOT NULL"`
	CreatorID string          `gorm:"type:uuid;NOT NULL"`
	Status    string          `gorm:"NOT NULL;DEFAULT:'created'"` // created, completed, cancelled
	StartTime time.Time       `gorm:"NOT NULL"`
	EndTime   time.Time       `gorm:"NOT NULL"`
	ContactID string          `gorm:"type:uuid;not null"` // Foreign key
	Contact   contact.Contact `gorm:"foreignKey:ContactID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
}
