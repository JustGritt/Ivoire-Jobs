package middlewares

import (
	"net/http"

	cfg "barassage/api/configs"

	jwtware "github.com/gofiber/jwt/v2"
	jwt "github.com/golang-jwt/jwt/v4"

	configRepo "barassage/api/repositories/configuration"

	fiber "github.com/gofiber/fiber/v2"
)

func CheckAppStatus() fiber.Handler {
	return func(c *fiber.Ctx) error {
		var errorList []*fiber.Error
		modeMaintenance, err := configRepo.GetByKey("mode_maintenance")
		/*
			c.Request().Header.VisitAll(func(key, value []byte) {
				fmt.Printf("%s: %s\n", key, value)
			})
		*/
		if err != nil {
			errorList = append(
				errorList,
				&fiber.Error{
					Code:    http.StatusBadRequest,
					Message: "Error fetching maintenance mode status",
				},
			)
			return c.Status(http.StatusBadRequest).JSON(fiber.Map{"errors": errorList})
		}

		if modeMaintenance.Value[0] == "true" {
			errorList = append(
				errorList,
				&fiber.Error{
					Code:    http.StatusServiceUnavailable,
					Message: "SERVICE_CURRENTLY_UNDER_MAINTENANCE",
				},
			)
			whiteList, err := configRepo.GetByKey("whitelist")
			if err != nil {
				errorList = append(
					errorList,
					&fiber.Error{
						Code:    http.StatusBadRequest,
						Message: "Error fetching whitelist",
					},
				)
				return c.Status(http.StatusBadRequest).JSON(fiber.Map{"errors": errorList})
			}

			//check if the current request IP is in the whitelist
			for _, ip := range whiteList.Value {
				//get form request header the IP address
				requestIP := c.Get("X-Original-Forwarded-For")
				cloudFlareRealIP := c.Get("CF-Connecting-IP")
				//get the all request hed
				if requestIP == "" {
					requestIP = c.IP()
				}
				if requestIP == ip || cloudFlareRealIP == ip {
					return c.Next()
				}
			}

			return c.Status(http.StatusServiceUnavailable).JSON(fiber.Map{"errors": errorList})
		}

		return c.Next()
	}
}

// RequireLoggedIn ensures access only to logged in users by checking for token presence and validity
func RequireLoggedIn() fiber.Handler {
	return jwtware.New(jwtware.Config{
		SigningKey:   []byte(cfg.GetConfig().JWTAccessSecret),
		ErrorHandler: jwtError,
	})
}

// TODO, Research how fiber checks for expired token?
func jwtError(c *fiber.Ctx, err error) error {
	if err.Error() == "Missing or malformed JWT" {
		var errorList []*fiber.Error
		errorList = append(
			errorList,
			&fiber.Error{
				Code:    fiber.StatusUnauthorized,
				Message: "Missing or Malformed Authentication Token",
			},
		)
		return c.Status(http.StatusUnauthorized).JSON(fiber.Map{"errors": errorList})

	}

	var errorList []*fiber.Error
	errorList = append(
		errorList,
		&fiber.Error{
			Code:    fiber.StatusUnauthorized,
			Message: "Expired Authentication Token",
		},
	)
	return c.Status(http.StatusUnauthorized).JSON(fiber.Map{"errors": errorList})
}

// RequireAdmin Ensures a route can only be accessed by an admin user
func RequireAdmin() fiber.Handler {
	return func(c *fiber.Ctx) error {
		token := c.Get("Authorization")
		var errorList []*fiber.Error
		if token == "" {
			errorList = append(
				errorList,
				&fiber.Error{
					Code:    fiber.StatusUnauthorized,
					Message: "Missing Authorization Token",
				},
			)
			return c.Status(http.StatusUnauthorized).JSON(fiber.Map{"errors": errorList})
		}
		token = token[7:]
		if token == "" {
			errorList = append(
				errorList,
				&fiber.Error{
					Code:    fiber.StatusUnauthorized,
					Message: "Missing Authorization Token",
				},
			)
			return c.Status(http.StatusUnauthorized).JSON(fiber.Map{"errors": errorList})
		}

		claims := jwt.MapClaims{}
		_, err := jwt.ParseWithClaims(token, claims, func(token *jwt.Token) (interface{}, error) {
			return []byte(cfg.GetConfig().JWTAccessSecret), nil
		})

		if err != nil {
			errorList = append(
				errorList,
				&fiber.Error{
					Code:    fiber.StatusUnauthorized,
					Message: "Invalid or Expired Token",
				},
			)
			return c.Status(http.StatusUnauthorized).JSON(fiber.Map{"errors": errorList})
		}

		if claims["role"] != "admin" {
			errorList = append(
				errorList,
				&fiber.Error{
					Code:    fiber.StatusForbidden,
					Message: "Unauthorized Access",
				},
			)
			return c.Status(http.StatusForbidden).JSON(fiber.Map{"errors": errorList})
		}

		return c.Next()
	}
}
