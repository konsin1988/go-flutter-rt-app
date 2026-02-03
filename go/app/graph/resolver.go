package graph

import (
  "konsin1988/rt-app/auth/jwt"
  "context"
  "errors"
  user "konsin1988/rt-app/domain/user"
)

type Resolver struct{
  UserService *user.Service
}

func NewResolver(userService *user.Service) *Resolver{
  return &Resolver{
    UserService: userService,
  }
}

func userFromContext(ctx context.Context) (*jwt.User, error){
  user, ok := jwt.FromContext(ctx)
  if !ok {
    return nil, errors.New("unauthorized")
  }
  return user, nil
}
