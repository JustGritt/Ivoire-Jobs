package tag

import (
	db "barassage/api/database"
	"barassage/api/models/tag"
)

// Create tag
func Create(tag *tag.Tag) error { return db.PgDB.Create(tag).Error }

func Update(tag *tag.Tag) error { return db.PgDB.Save(tag).Error }

func getErrors() error { return db.PgDB.Error }
