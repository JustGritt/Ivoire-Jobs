package log

import (
	db "barassage/api/database"
	"barassage/api/models/log"

	"github.com/gofiber/fiber/v2"
	"github.com/morkid/paginate"
)

// Create Log
func Create(log *log.Log) error {
	return db.PgDB.Create(log).Error
}

// GetAll Logs
func GetAll() ([]log.Log, error) {
	var logs []log.Log
	if err := db.PgDB.Find(&logs).Error; err != nil {
		return nil, err
	}
	return logs, nil
}

// Get by query params
func GetByQueryParams(queryParams map[string]interface{}, c *fiber.Ctx) paginate.Page {
	pg := paginate.New(&paginate.Config{
		PageStart:   1,
		DefaultSize: 20,
	})
	stmt := db.PgDB.Where(queryParams).Find(&[]log.Log{})
	page := pg.With(stmt).Request(c.Request()).Response(&[]log.Log{})
	return page
}

// Update Log
func Update(log *log.Log) error {
	return db.PgDB.Save(log).Error
}

// Delete Log
func Delete(log *log.Log) error {
	return db.PgDB.Delete(log).Error
}

// GetErrors returns the last error
func GetErrors() error {
	return db.PgDB.Error
}
