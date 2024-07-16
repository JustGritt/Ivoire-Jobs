package contact

import (
	db "barassage/api/database"
	"barassage/api/models/contact"
)

// Create Contact
func Create(contact *contact.Contact) error {

	return db.PgDB.Create(contact).Error
}

func Update(contact *contact.Contact) error {
	return db.PgDB.Save(contact).Error
}

func GetErrors() error {
	return db.PgDB.Error
}

func GetByID(id string) (*contact.Contact, error) {
	var contact contact.Contact
	err := db.PgDB.Where("id = ?", id).First(&contact).Error
	return &contact, err
}
