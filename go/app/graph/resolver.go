package graph

import (
  "konsin1988/rt-app/auth/jwt"
  "context"
  "errors"
)

type Resolver struct{}

func NewResolver() *Resolver{
  return &Resolver{}
}

func userFromContext(ctx context.Context) (*jwt.User, error){
  user, ok := jwt.FromContext(ctx)
  if !ok {
    return nil, errors.New("unauthorized")
  }
  return user, nil
}
