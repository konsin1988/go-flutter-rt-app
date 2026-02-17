package department

import (
  "database/sql"
)

type DeptRepo struct {
  db *sql.DB
} 

func NewDeptRepo (db *sql.DB) *DeptRepo {
  return &DeptRepo{db: db}
} 


