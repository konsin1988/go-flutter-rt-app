package graph

import (
  "konsin1988/rt-app/auth/jwt"
  "context"
  "errors"
  user "konsin1988/rt-app/domain/user"
  ai_chat "konsin1988/rt-app/domain/ai_chat"
)

type Resolver struct{
  UserService *user.Service
  ChatService *ai_chat.Service
}

func NewResolver(userService *user.Service, chatService *ai_chat.Service) *Resolver{
  return &Resolver{
    UserService: userService,
    ChatService: chatService,
  }
}

func userFromContext(ctx context.Context) (*jwt.User, error){
  user, ok := jwt.FromContext(ctx)
  if !ok {
    return nil, errors.New("unauthorized")
  }
  return user, nil
}
