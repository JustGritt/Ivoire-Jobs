package database

import (
	"github.com/JustGritt/Ivoire-Jobs/models"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

type DbInstance struct {
	Db *gorm.DB
}

var Database DbInstance

func Connect() {
	dsn := "postgres://pg:pass@localhost:5432/ivoirejob"
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})

	if err != nil {
		panic("failed to connect database")
	}

	db.AutoMigrate(&models.User{})
	Database = DbInstance{Db: db}
}
