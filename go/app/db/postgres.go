package db 

import (
  _ "context"
  "database/sql"
  _ "errors"
  _ "log"

  _ "konsin1988/rt-app/domain/ai"
)

type PostgresRepo struct {
  db *sql.DB
}

func NewPostgresRepo(db *sql.DB) *PostgresRepo{
  return &PostgresRepo{db: db}
}

