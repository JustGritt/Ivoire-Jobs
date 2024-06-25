package room

import (
	// user model
	"barassage/api/models/room"

	// db
	db "barassage/api/database"
	// "gorm.io/gorm"
)

func Create(room *room.Room) error {
	return db.PgDB.Create(room).Error
}

func GetAll() ([]room.Room, error) {
	var rooms []room.Room
	if err := db.PgDB.Find(&rooms).Error; err != nil {
		return nil, err
	}
	return rooms, nil
}

func GetByID(id string) (*room.Room, error) {
	var room room.Room
	//find the room by id
	if err := db.PgDB.Where("id = ?", id).First(&room).Error; err != nil {
		return nil, err
	}
	return &room, nil
}
