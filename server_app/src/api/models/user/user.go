package user

import (
	"barassage/api/models/booking"
	"barassage/api/models/member"
	"barassage/api/models/notificationPreference"
	"barassage/api/models/pushToken"
	"barassage/api/models/service"

	"gorm.io/gorm"
)

// User domain model
type User struct {
	gorm.Model
	ID                     string                                        `gorm:"type:uuid;default:gen_random_uuid();unique"`
	Firstname              string                                        `gorm:"NOT NULL;size:255"`
	Lastname               string                                        `gorm:"NOT NULL;size:255"`
	ProfilePicture         string                                        `gorm:"size:255"`
	Bio                    string                                        `gorm:"size:255"`
	Email                  string                                        `gorm:"NOT NULL;UNIQUE"`
	Password               string                                        `gorm:"NOT NULL"`
	Role                   string                                        `gorm:"NOT NULL;size:255;DEFAULT:'standard'"`
	Active                 bool                                          `gorm:"NOT NULL;DEFAULT:false"`
	Services               []service.Service                             `gorm:"foreignKey:UserID"`
	Bookings               []booking.Booking                             `gorm:"foreignKey:UserID"`
	PushToken              []pushToken.PushToken                         `gorm:"foreignKey:UserID"`
	NotificationPreference notificationPreference.NotificationPreference `gorm:"foreignKey:UserID"`
	Member                 []member.Member                               `gorm:"foreignKey:UserID"`
}
