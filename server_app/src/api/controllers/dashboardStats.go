package controllers

import (
	"net/http"
	"time"

	bookingRepo "barassage/api/repositories/booking"
	memberRepo "barassage/api/repositories/member"
	serviceRepo "barassage/api/repositories/service"
	userRepo "barassage/api/repositories/user"

	"github.com/gofiber/fiber/v2"
)

type BookingStats struct {
	Today int   `json:"today"`
	Month int   `json:"month"`
	Year  int   `json:"year"`
	All   int64 `json:"all"`
}

type DashboardStats struct {
	TotalUsers     int64        `json:"totalUsers"`
	TotalMembers   int64        `json:"totalMembers"`
	TotalLiveUsers int          `json:"totalLiveUsers"`
	TotalServices  int64        `json:"totalServices"`
	Bookings       BookingStats `json:"bookings"`
}

// GetDashboardStats Godoc
// @Summary GetDashboardStats
// @Description GetDashboardStats
// @Tags dashboard
// @Produce json
// @Success 200 {object} DashboardStats
// @Failure 401 {array} ErrorResponse
// @Failure 500 {array} ErrorResponse
// @Router /dashboard/stats [get]
func GetDashboardStats(c *fiber.Ctx) error {
	totalUsers, _ := userRepo.CountAll()
	totalMembers, _ := memberRepo.CountAll()
	totalLiveUsers := GetClientCount() // GetClientCount is from notification.go
	totalServices, _ := serviceRepo.CountAll()

	now := time.Now()
	todayStart := now.Truncate(24 * time.Hour)
	todayEnd := todayStart.Add(24 * time.Hour)
	monthStart := time.Date(now.Year(), now.Month(), 1, 0, 0, 0, 0, now.Location())
	monthEnd := monthStart.AddDate(0, 1, 0)
	yearStart := time.Date(now.Year(), 1, 1, 0, 0, 0, 0, now.Location())
	yearEnd := yearStart.AddDate(1, 0, 0)

	bookingsToday, _ := bookingRepo.CountBookingsInRange(todayStart, todayEnd)
	bookingsThisMonth, _ := bookingRepo.CountBookingsInRange(monthStart, monthEnd)
	bookingsThisYear, _ := bookingRepo.CountBookingsInRange(yearStart, yearEnd)
	totalBookings, _ := bookingRepo.CountAll()

	stats := DashboardStats{
		TotalUsers:     totalUsers,
		TotalMembers:   totalMembers,
		TotalLiveUsers: totalLiveUsers,
		TotalServices:  totalServices,
		Bookings: BookingStats{
			Today: bookingsToday,
			Month: bookingsThisMonth,
			Year:  bookingsThisYear,
			All:   totalBookings,
		},
	}

	return c.Status(http.StatusOK).JSON(stats)
}
