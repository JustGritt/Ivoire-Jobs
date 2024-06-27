package pushToken

import (
	"gorm.io/gorm"
)

// Image domain model
type PushToken struct {
	gorm.Model
	ID     string `gorm:"type:uuid;default:gen_random_uuid();primaryKey"`
	UserID string `gorm:"type:uuid;not null"`
	Device string `gorm:"size:255"`
	Token  string `gorm:"size:255;not null;unique"`
}
