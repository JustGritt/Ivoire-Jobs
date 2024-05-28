package category

import "time"

type Category struct {
	ID          int
	Name        string    `gorm:"unique"`
	Description string    `gorm:"type:text"`
	IsActive    bool      `gorm:"default:false"`
	CreatedAt   time.Time `gorm:"default:CURRENT_TIMESTAMP()"`
	UpdatedAt   time.Time `gorm:"default:CURRENT_TIMESTAMP()"`
}
