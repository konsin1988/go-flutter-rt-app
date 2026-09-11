package migrate 

import (
	"log"

	"github.com/golang-migrate/migrate/v4"
	"github.com/golang-migrate/migrate/v4/database/postgres"
	_ "github.com/golang-migrate/migrate/v4/source/file"

	"konsin1988/rt-app/config"
)

func RunMigrations() {
  db, err := config.ConnectDB()
  if err != nil{
    log.Fatal(err)
  }
  defer db.Close()

	driver, err := postgres.WithInstance(
		db,
		&postgres.Config{},
	)
	if err != nil {
		log.Fatalf("Migration driver error: %v", err)
	}

	m, err := migrate.NewWithDatabaseInstance(
		"file://migrations",
		"postgres",
		driver,
	)

	if err != nil {
		log.Fatalf("Migration init failed: %v", err)
	}

	err = m.Up()

	if err != nil && err != migrate.ErrNoChange {
		log.Fatalf("Migration failed: %v", err)
	}

	log.Println("Migrations applied successfully")
}
