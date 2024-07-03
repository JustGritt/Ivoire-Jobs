package tag

type Tag struct {
	ID          string `gorm:"type:uuid;default:gen_random_uuid();unique"`
	Name        string `gorm:"unique"`
	Description string `gorm:"type:text"`
	IsActive    bool   `gorm:"default:false"`
	Duration    int    `gorm:"type:int"`
}
