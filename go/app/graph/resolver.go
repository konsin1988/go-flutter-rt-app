package graph

import (
  "konsin1988/rt-app/auth/jwt"
  "context"
  "errors"
  user "konsin1988/rt-app/db/user"
  ai "konsin1988/rt-app/db/ai"
  dept "konsin1988/rt-app/db/department"
  ollama "konsin1988/rt-app/services/ollama"
)

type Resolver struct{
  UserService *user.Service
  AiService *ai.Service
  DeptService *dept.Service
  OllamaClient *ollama.Client 
}

func NewResolver(userService *user.Service, 
		  aiService *ai.Service,
		  deptService *dept.Service,
		  ollamaClient *ollama.Client,
		) *Resolver{
  return &Resolver{
    UserService: userService,
    AiService: aiService,
    DeptService: deptService,
    OllamaClient: ollamaClient,
  }
}

func userFromContext(ctx context.Context) (*jwt.User, error){
  user, ok := jwt.FromContext(ctx)
  if !ok {
    return nil, errors.New("unauthorized")
  }
  return user, nil
}
