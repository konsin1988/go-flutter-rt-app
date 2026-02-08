package ai 

import (
  "database/sql"
)

type AiRepo struct {
  db *sql.DB
}

func NewAiRepo(db *sql.DB) *AiRepo{
  return &AiRepo{db: db}
}
