package config

import (
    "database/sql"
    "fmt"
    "log"
    "os"
    
    _ "github.com/lib/pq"
)

func ConnectDB()(*sql.DB, error) {

    dbHost := os.Getenv("DB_HOST")
    dbPort := os.Getenv("DB_PORT")
    dbUser := os.Getenv("DB_USER")
    dbPass := os.Getenv("DB_PASSWORD")
    dbName := os.Getenv("DB_NAME")
    
    connStr := fmt.Sprintf(
        "host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
        dbHost, dbPort, dbUser, dbPass, dbName,
    )

    db, err := sql.Open("postgres", connStr)
    if err != nil {
	log.Fatalf("Connection error: %v", err)
	return nil, err
    }

    if err := db.Ping(); err != nil {
	log.Fatalf("Database not allowed: %v", err)
	return nil, err
    }

    log.Println("Successfully connected to database")
    return db, nil

}
