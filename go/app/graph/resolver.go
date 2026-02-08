package graph

import (
  "konsin1988/rt-app/auth/jwt"
  "context"
  "errors"
  user "konsin1988/rt-app/domain/user"
  ai "konsin1988/rt-app/domain/ai"
)

type Resolver struct{
  UserService *user.Service
  AiService *ai.Service
}

func NewResolver(userService *user.Service, aiService *ai.Service) *Resolver{
  return &Resolver{
    UserService: userService,
    AiService: aiService,
  }
}

func userFromContext(ctx context.Context) (*jwt.User, error){
  user, ok := jwt.FromContext(ctx)
  if !ok {
    return nil, errors.New("unauthorized")
  }
  return user, nil
}
