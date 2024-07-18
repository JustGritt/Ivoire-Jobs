package room

import (
	// user model
	"barassage/api/models/message"
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

func GetRoomForClientAndMember(clientID string, memberID string, serviceID string) (*room.Room, error) {
	var room room.Room
	//find the room by client and member preload with messages
	if err := db.PgDB.Preload("Messages").Where("client_id = ? AND creator_id = ? AND service_id = ?", clientID, memberID, serviceID).First(&room).Error; err != nil {
		return nil, err
	}
	return &room, nil
}

func CreateOrGetRoom(u room.Room) (*room.Room, error) {
	//check if the room already exists
	room, err := GetRoomForClientAndMember(u.ClientID, u.CreatorID, u.ServiceID)
	if err != nil {
		//create the room
		if err := Create(&u); err != nil {
			return nil, err
		}
		return &u, nil
	}
	return room, nil
}

func GetRoomsForUser(userID string) ([]room.Room, error) {
	var rooms []room.Room

	// Find the rooms where the user is either the creator or the client
	if err := db.PgDB.
		Where("creator_id = ? OR client_id = ?", userID, userID).
		Find(&rooms).Error; err != nil {
		return nil, err
	}

	// Preload messages for these rooms
	for i := range rooms {
		var messages []message.Message
		if err := db.PgDB.
			Where("room_id = ?", rooms[i].ID).
			Find(&messages).Error; err != nil {
			return nil, err
		}
		if len(messages) > 0 {
			rooms[i].Messages = messages
		} else {
			rooms[i].Messages = nil
		}
	}

	return rooms, nil
}

func GetErrors() error {
	return db.PgDB.Error
}
