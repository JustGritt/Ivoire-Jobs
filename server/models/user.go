package models

import "time"

type User struct {
	ID        uint      `json:"id" gorm:"primarykey"`
	FirstName string    `json:"first_name"`
	LastName  string    `json:"last_name"`
	Email     string    `json:"email"`
	Password  string    `json:"password"`
	CreatedAt time.Time `json:"created_at"`
	LastLogin time.Time `json:"last_login"`
}

type UserLogin struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}
