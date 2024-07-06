package message

import (
	// user model
	"barassage/api/models/message"

	// db
	db "barassage/api/database"
	// "gorm.io/gorm"
)

func Create(message *message.Message) error {
	return db.PgDB.Create(message).Error
}

func GetAll() ([]message.Message, error) {
	var messages []message.Message
	if err := db.PgDB.Find(&messages).Error; err != nil {
		return nil, err
	}
	return messages, nil
}

func GetByRoomID(roomID string) ([]message.Message, error) {
	var messages []message.Message
	if err := db.PgDB.Where("room_id = ?", roomID).Find(&messages).Error; err != nil {
		return nil, err
	}
	return messages, nil
}

func GetErrors() error {
	return db.PgDB.Error
}
