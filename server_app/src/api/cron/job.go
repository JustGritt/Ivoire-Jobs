package cron

import (
	"log"
	"time"

	bookingRepo "barassage/api/repositories/booking"

	"github.com/robfig/cron/v3"
)

// StartCronJobs initializes and starts the cron jobs
func StartCronJobs() {
	c := cron.New()
	_, err := c.AddFunc("@every 15m", func() {
		checkAndCancelBookings()
	})
	if err != nil {
		log.Println("Failed to add cron job:", err)
	}
	c.Start()
}

// checkAndCancelBookings checks for bookings in the last 15 minutes and cancels them
func checkAndCancelBookings() {
	log.Println("Checking for bookings to cancel...")
	now := time.Now()
	fifteenMinutesAgo := now.Add(-15 * time.Minute)

	// Fetch bookings within with more than 15 minutes old
	bookings, err := bookingRepo.GetBookingsOlderThan(fifteenMinutesAgo)
	if err != nil {
		log.Println("Failed to fetch bookings:", err)
		return
	}

	// Cancel the bookings
	for _, booking := range bookings {
		booking.Status = "cancelled"
		if err := bookingRepo.Update(&booking); err != nil {
			log.Printf("Failed to cancel booking ID %s: %v\n", booking.ID, err)
			continue
		}
		log.Printf("Canceled booking ID %s\n", booking.ID)
	}

	log.Println("Finished checking for bookings to cancel")
}
