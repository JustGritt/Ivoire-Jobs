package message

import (
	"gorm.io/gorm"
)

// Message domain model
type Message struct {
	gorm.Model
	ID         string `gorm:"type:uuid;default:gen_random_uuid();unique"`
	RoomID     string `gorm:"type:uuid;NOT NULL"`
	SenderID   string `gorm:"type:uuid;NOT NULL"`
	ReceiverID string `gorm:"type:uuid;NOT NULL"`
	Content    string `gorm:"type:text;NOT NULL"`
	Seen       bool   `gorm:"type:boolean;default:false"`
}
