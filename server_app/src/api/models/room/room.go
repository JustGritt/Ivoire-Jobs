package room

import (
	"gorm.io/gorm"
)

// Room domain model
type Room struct {
	gorm.Model
	ID        string `gorm:"type:uuid;default:gen_random_uuid();unique"`
	CreatorID string `gorm:"type:uuid;NOT NULL"`
	ClientID  string `gorm:"type:uuid;NOT NULL"`
}
