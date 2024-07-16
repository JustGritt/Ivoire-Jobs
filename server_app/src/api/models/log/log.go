package log

import (
	"database/sql/driver"
	"errors"

	"gorm.io/gorm"
)

// LogLevel represents the level of the log
type LogLevel string

const (
	Info  LogLevel = "info"
	Warn  LogLevel = "warn"
	Error LogLevel = "error"
)

// Scan implements the Scanner interface for LogLevel
func (l *LogLevel) Scan(value interface{}) error {
	if value == nil {
		*l = ""
		return nil
	}
	switch v := value.(type) {
	case []byte:
		*l = LogLevel(string(v))
	case string:
		*l = LogLevel(v)
	default:
		return errors.New("unsupported data type for LogLevel")
	}
	return nil
}

// Value implements the Valuer interface for LogLevel
func (l LogLevel) Value() (driver.Value, error) {
	return string(l), nil
}

// Log represents the log model
type Log struct {
	gorm.Model
	ID         string   `gorm:"type:uuid;default:gen_random_uuid();unique"`
	Level      LogLevel `gorm:"type:log_level;not null"`
	Type       string   `gorm:"not null;size:66"`
	Message    string   `gorm:"not null;"`
	RequestURI string   `gorm:"size:255"`
}
