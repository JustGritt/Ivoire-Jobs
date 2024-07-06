package room

import (
	"barassage/api/models/message"

	"gorm.io/gorm"
)

// Room domain model
type Room struct {
	gorm.Model
	ID        string            `gorm:"type:uuid;default:gen_random_uuid();unique"`
	ServiceID string            `gorm:"type:uuid;NOT NULL"`
	CreatorID string            `gorm:"type:uuid;NOT NULL"`
	ClientID  string            `gorm:"type:uuid;NOT NULL"`
	Messages  []message.Message `gorm:"foreignKey:RoomID"`
}
