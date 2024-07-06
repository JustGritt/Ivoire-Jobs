package refreshtoken

import (
	"gorm.io/gorm"
)

// RefreshToken domain model
type RefreshToken struct {
	gorm.Model
	ID        string `gorm:"type:uuid;default:gen_random_uuid();unique"`
	UserID    string `gorm:"NOT NULL;type:uuid;index"`
	TokenID   string `gorm:"NOT NULL;type:uuid;index"`
	ExpiresAt int64  `gorm:"NOT NULL"`
}
