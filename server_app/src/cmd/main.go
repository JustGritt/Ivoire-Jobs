package main

import (
	"fmt"

	// Configs
	cfg "barassage/api/configs"

	// models

	"barassage/api/models/booking"
	"barassage/api/models/category"
	"barassage/api/models/image"
	"barassage/api/models/report"
	"barassage/api/models/service"
	myUser "barassage/api/models/user"

	// database
	db "barassage/api/database"
)

func main() {

	// load config
	cfg.LoadConfig()

	// Connect to Postgres
	db.ConnectPostgres()

	// Drop all tables
	db.PgDB.Migrator().DropTable(&myUser.User{}, &category.Category{}, &service.Service{}, &booking.Booking{}, &image.Image{}, &report.Report{})

	// Migration
	db.PgDB.AutoMigrate(&myUser.User{}, &category.Category{}, &service.Service{}, &booking.Booking{}, &image.Image{}, &report.Report{})

	// Seed the database
	db.SeedDatabase(db.PgDB)
	fmt.Println("Database seeding completed.")
}
