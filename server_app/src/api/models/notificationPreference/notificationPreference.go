package notificationPreference

import (
	"gorm.io/gorm"
)

// Ban domain model
type NotificationPreference struct {
	gorm.Model
	ID     string `gorm:"type:uuid;default:gen_random_uuid();unique"`
	UserID string `gorm:"NOT NULL;type:uuid"`
	PushNotification bool `gorm:"NOT NULL;default:false"`
	MessageNotification  bool `gorm:"NOT NULL;default:false"`
	ServiceNotification bool `gorm:"NOT NULL;default:false"`
	BookingNotification bool `gorm:"NOT NULL;default:false"`
}
