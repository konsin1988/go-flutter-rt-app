package user 

import (
  "context"
  db "konsin1988/rt-app/db/user"
)

type Repository interface {
  AuthUser(ctx context.Context, email string) (*db.MainUserDB, error)
}
