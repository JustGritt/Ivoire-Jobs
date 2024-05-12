package validations

import (
	"github.com/JustGritt/Ivoire-Jobs/database"
	"github.com/JustGritt/Ivoire-Jobs/models"
	"github.com/golang-jwt/jwt/v4"
)

func validateToken(t *jwt.Token) models.User {
	claims := t.Claims.(jwt.MapClaims)
	uid := int(claims["user_id"].(float64))
	var user models.User
	database.Database.Db.Find(&user, uid)
	return user
}
