package controllers

import (
	"barassage/api/models/configuration"

	validator "barassage/api/common/validator"
	configRepo "barassage/api/repositories/configuration"

	"net/http"

	"github.com/gofiber/fiber/v2"
)

type ConfigurationObject struct {
	Key   string   `json:"key" validate:"required"`
	Value []string `json:"value" validate:"required"`
}

type ConfigurationPutObject struct {
	Key   string   `json:"key"`
	Value []string `json:"value" validate:"required"`
}

type ConfigurationOutput struct {
	Key   string   `json:"key"`
	Value []string `json:"value"`
}

// CreateConfiguration handles the creation of a new configuration.
// @Summary Create Configuration
// @Description Create a new configuration
// @Tags Configuration
// @Produce json
// @Param payload body ConfigurationObject true "Configuration Body"
// @Success 201 {object} Response
// @Failure 400 {array} ErrorResponse
// @Router /configuration [post]
// @Security Bearer
func CreateConfiguration(c *fiber.Ctx) error {
	var configurationInput ConfigurationObject
	var errorList []*fiber.Error
	if err := validator.ParseBodyAndValidate(c, &configurationInput); err != nil {
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(err))
	}

	configuration := &configuration.Configuration{
		Key:   configurationInput.Key,
		Value: configurationInput.Value,
	}

	// check if the configuration already exists
	if _, err := configRepo.GetByKey(configuration.Key); err == nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusBadRequest,
			Message: "Sorry, this configuration already exists",
		})
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	// Create the configuration
	if err := configRepo.Create(configuration); err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusInternalServerError,
			Message: "Sorry, we could not create the configuration",
		})

		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	var output ConfigurationOutput = *mapConfigurationToOutput(configuration)
	return c.Status(http.StatusCreated).JSON(HTTPResponse(http.StatusCreated, "Success", output))
}

// GetConfigurationByKey handles the retrieval of a configuration by key.
// @Summary Get Configuration by Key
// @Description Get a configuration by key
// @Tags Configuration
// @Produce json
// @Param key path string true "Configuration Key"
// @Success 200 {object} Response
// @Failure 400 {array} ErrorResponse
// @Router /configuration/{key} [get]
// @Security Bearer
func GetConfigurationByKey(c *fiber.Ctx) error {
	key := c.Params("key")
	var errorList []*fiber.Error

	// Get the configuration
	configuration, err := configRepo.GetByKey(key)
	if err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusNotFound,
			Message: "Sorry, this configuration does not exist",
		})

		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	var output ConfigurationOutput = *mapConfigurationToOutput(configuration)
	return c.Status(http.StatusOK).JSON(HTTPResponse(http.StatusOK, "Success", output))
}

// UpdateConfiguration handles the update of a configuration.
// @Summary Update Configuration
// @Description Update a configuration
// @Tags Configuration
// @Produce json
// @Param key path string true "Configuration Key"
// @Param payload body ConfigurationObject true "Configuration Body"
// @Success 200 {object} Response
// @Failure 400 {array} ErrorResponse
// @Router /configuration [put]
// @Security Bearer
func UpdateConfiguration(c *fiber.Ctx) error {
	var configurationInput ConfigurationOutput
	var errorList []*fiber.Error

	if err := validator.ParseBodyAndValidate(c, &configurationInput); err != nil {
		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(err))
	}

	configuration, err := configRepo.GetByKey(configurationInput.Key)
	if err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusNotFound,
			Message: "Sorry, this configuration does not exist",
		})

		return c.Status(http.StatusBadRequest).JSON(HTTPFiberErrorResponse(errorList))
	}

	//replace the name of key if change
	if configurationInput.Key !=  configuration.Key {
		configuration.Key = configurationInput.Key
	}

	if configurationInput.Value != nil {
		configuration.Value = configurationInput.Value
	}

	if err := configRepo.Update(configuration); err != nil {
		errorList = append(errorList, &fiber.Error{
			Code:    http.StatusInternalServerError,
			Message: "Sorry, we could not update the configuration",
		})

		return c.Status(http.StatusInternalServerError).JSON(HTTPFiberErrorResponse(errorList))
	}

	var output ConfigurationOutput = *mapConfigurationToOutput(configuration)
	return c.Status(http.StatusOK).JSON(HTTPResponse(http.StatusOK, "Success", output))
}

// ============================================================
// =================== Private Methods ========================
// ============================================================

func mapConfigurationToOutput(c *configuration.Configuration) *ConfigurationOutput {
	return &ConfigurationOutput{
		Key:   c.Key,
		Value: c.Value,
	}
}
