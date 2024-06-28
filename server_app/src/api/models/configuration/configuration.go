package configuration

import (
	"database/sql/driver"
	"encoding/json"
	"errors"

	"gorm.io/gorm"
)

// Configuration domain model
type Configuration struct {
	gorm.Model
	ID    string `gorm:"type:uuid;default:gen_random_uuid();primaryKey"`
	Key   string `gorm:"size:255;not null"`
	Value JSONB  `gorm:"type:jsonb;not null"`
}

// JSONB custom type for handling JSONB data in PostgreSQL
type JSONB []string

// Value implements the driver.Valuer interface for JSONB
func (j JSONB) Value() (driver.Value, error) {
	return json.Marshal(j)
}

// Scan implements the sql.Scanner interface for JSONB
func (j *JSONB) Scan(value interface{}) error {
	if value == nil {
		*j = nil
		return nil
	}
	bytes, ok := value.([]byte)
	if !ok {
		return errors.New("type assertion to []byte failed")
	}
	return json.Unmarshal(bytes, j)
}
