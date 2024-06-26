package booking

import (
	// user model
	"barassage/api/models/booking"
	"time"

	// db
	db "barassage/api/database"
	// "gorm.io/gorm"
)

func Create(booking *booking.Booking) error {
	return db.PgDB.Create(booking).Error
}

func GetAll() ([]booking.Booking, error) {
	var bookings []booking.Booking
	if err := db.PgDB.Find(&bookings).Error; err != nil {
		return nil, err
	}
	return bookings, nil
}

func GetByID(id string) (*booking.Booking, error) {
	var booking booking.Booking
	//find the booking by id
	if err := db.PgDB.Where("id = ?", id).First(&booking).Error; err != nil {
		return nil, err
	}
	return &booking, nil
}

func GetBookingsByUserID(userID string) ([]booking.Booking, error) {
	var bookings []booking.Booking
	if err := db.PgDB.Where("user_id = ?", userID).Find(&bookings).Error; err != nil {
		return nil, err
	}
	return bookings, nil
}

func Update(booking *booking.Booking) error {
	return db.PgDB.Save(booking).Error
}

func Delete(booking *booking.Booking) error {
	return db.PgDB.Delete(booking).Error
}

// CheckBookingOverlap checks if the current user already has a booking that overlaps with the new booking time
func CheckBookingOverlap(userID string, startTime time.Time, endTime time.Time) (bool, error) {
	var count int64
	// Check if the user has a booking that overlaps with the new booking time
	query := db.PgDB.Model(&booking.Booking{}).Where(
		"user_id = ? AND ((start_time < ? AND end_time > ?) OR (start_time < ? AND end_time > ?) OR (start_time >= ? AND end_time <= ?))",
		userID, endTime, startTime, endTime, startTime, startTime, endTime,
	)

	if err := query.Count(&count).Error; err != nil {
		return false, err
	}
	return count > 0, nil
}
