package graph

import (
  "konsin1988/rt-app/auth/jwt"
  "context"
  "errors"
  user "konsin1988/rt-app/domain/user"
)

type Resolver struct{
  UserRepo user.Repository
}

func NewResolver(userRepo user.Repository) *Resolver{
  return &Resolver{
    UserRepo: userRepo,
  }
}

func userFromContext(ctx context.Context) (*jwt.User, error){
  user, ok := jwt.FromContext(ctx)
  if !ok {
    return nil, errors.New("unauthorized")
  }
  return user, nil
}
