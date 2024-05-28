package mailer

import (
	"fmt"
	"html/template"
	"log"
	"os"
	"path"
)

var templates map[string]*template.Template

// LoadTemplates loads all email templates from the specified directory.
func LoadTemplates(dir string) error {
	templates = make(map[string]*template.Template)

	dirs, err := os.ReadDir(dir)
	if err != nil {
		log.Println("☹️  Could Not Load Email Templates", err)
		return fmt.Errorf("failed to read email template directory: %w", err)
	}

	for _, d := range dirs {
		if d.IsDir() {
			emailType := d.Name()
			htmlFile := path.Join(dir, emailType, emailType+".html")
			txtFile := path.Join(dir, emailType, emailType+".txt")

			// Load HTML template if exists
			htmlTmpl, err := template.ParseFiles(htmlFile)
			if err == nil {
				templates[emailType+".html"] = htmlTmpl
				log.Println("😀 Loaded HTML template for", emailType)
			} else if os.IsNotExist(err) {
				log.Println("😕 HTML template does not exist", emailType)
			} else {
				return fmt.Errorf("failed to parse HTML template %s: %w", htmlFile, err)
			}

			// Load text template if exists
			txtTmpl, err := template.ParseFiles(txtFile)
			if err == nil {
				templates[emailType+".txt"] = txtTmpl
				log.Println("😀 Loaded text template for", emailType)
			} else if os.IsNotExist(err) {
				log.Println("😕 Text template does not exist", emailType)
			} else {
				return fmt.Errorf("failed to parse text template %s: %w", txtFile, err)
			}
		}
	}

	log.Println("📧 Email templates loaded successfully")
	return nil
}

// GetTemplate retrieves a parsed template by name.
func GetTemplate(name string) (*template.Template, bool) {
	tmpl, found := templates[name]
	fmt.Printf("Retrieving template %s: found=%v\n", name, found)
	return tmpl, found
}
