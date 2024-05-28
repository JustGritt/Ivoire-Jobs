package mailer

import (
	"bytes"
	"context"
	"fmt"
	"log"
	"os"

	// Configs
	cfg "barassage/api/configs"

	"github.com/mrz1836/postmark"
)

var mail *postmark.Client

// InitMailer initializes the Postmark client and loads the email templates.
func InitMailer() error {
	postmarkCreds := cfg.GetConfig().Postmark
	mail = postmark.NewClient(postmarkCreds.ServerToken, postmarkCreds.AccountToken)
	if mail == nil {
		log.Println("Failed to initialize Postmark client")
		return fmt.Errorf("failed to initialize Postmark client")
	}

	//get from env the app_host

	host := cfg.GetConfig().Host
	var path string

	if host == "localhost" {
		path = "/opt/gofiber-app/src/api/templates/email"
	} else {
		path = "/opt/gofiber-app/api/templates/email"
	}

	// Adjust the path according to your project structure
	err := LoadTemplates(path)
	if err != nil {
		log.Println("Failed to load email templates:", err)
		return fmt.Errorf("failed to load email templates: %w", err)
	}

	return nil
}

// SendEmail constructs and sends an email using the Postmark client and the specified template.
func SendEmail(templateName, to, subject string, data interface{}) (postmark.EmailResponse, error) {
	if mail == nil {
		log.Println("Postmark client not initialized")
		return postmark.EmailResponse{}, fmt.Errorf("postmark client not initialized")
	}

	emailFrom := os.Getenv("EMAIL_FROM")
	if emailFrom == "" {
		log.Println("Invalid EMAIL_FROM environment variable not set")
		return postmark.EmailResponse{}, fmt.Errorf("invalid EMAIL_FROM environment variable not set")
	}

	htmlTmpl, htmlFound := GetTemplate(templateName + ".html")
	txtTmpl, txtFound := GetTemplate(templateName + ".txt")

	if !htmlFound && !txtFound {
		log.Println("Email templates not found:", templateName)
		return postmark.EmailResponse{}, fmt.Errorf("email templates not found: %s", templateName)
	}

	var htmlBody, textBody bytes.Buffer

	if htmlFound {
		err := htmlTmpl.Execute(&htmlBody, data)
		if err != nil {
			log.Println("Failed to execute HTML email template:", err)
			return postmark.EmailResponse{}, fmt.Errorf("failed to execute HTML email template: %v", err)
		}
	}

	if txtFound {
		err := txtTmpl.Execute(&textBody, data)
		if err != nil {
			log.Println("Failed to execute plain text email template:", err)
			return postmark.EmailResponse{}, fmt.Errorf("failed to execute plain text email template: %v", err)
		}
	} else {
		// If text template is not found, use the HTML content stripped of HTML tags
		textBody.WriteString(stripHTML(htmlBody.String()))
		log.Println("Text template not found, using stripped HTML content")
	}

	email := postmark.Email{
		From:     emailFrom,
		To:       to,
		Subject:  subject,
		HTMLBody: htmlBody.String(),
		TextBody: textBody.String(),
	}

	return mail.SendEmail(context.Background(), email)
}

// stripHTML removes HTML tags from a string
func stripHTML(input string) string {
	output := ""
	inTag := false
	for _, c := range input {
		switch {
		case c == '<':
			inTag = true
		case c == '>':
			inTag = false
		case !inTag:
			output += string(c)
		}
	}
	return output
}
