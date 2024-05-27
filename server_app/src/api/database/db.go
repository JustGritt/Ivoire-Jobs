package database

import (
	"log"
	"strings"

	// Configs
	cfg "barassage/api/configs"

	// Gorm
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var (
	// PgDB is the postgress connection handle
	PgDB *gorm.DB
)

// ConnectPostgres Returns the Pg DB Instance
func ConnectPostgres() {
	dsn := cfg.GetConfig().Postgres.GetPostgresConnectionInfo()
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})

	if err != nil {
		log.Println(strings.Repeat("!", 40))
		log.Println("☹️  Could Not Establish Postgres DB Connection")
		log.Println(strings.Repeat("!", 40))
		log.Fatal(err)
	}

	log.Println(strings.Repeat("-", 40))
	log.Println("😀 Connected To Postgres DB")
	log.Println(strings.Repeat("-", 40))

	PgDB = db
}
