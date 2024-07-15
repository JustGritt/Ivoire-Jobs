package main

import (
	app "barassage/api"
	"barassage/api/services/logger"
)

func main() {
	logger.Sugar.Info("Starting the app...")

	app.Run()
}
