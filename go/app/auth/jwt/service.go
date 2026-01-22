package jwt

import (
  "context"
  _ "log"
)

type Service struct{
  validator  *Validator
}

func NewService(validator *Validator) *Service {
  return &Service{validator: validator}
}

func (s *Service) Authenticate(ctx context.Context, token string) (*User, error){

  claims, err := s.validator.Validate(token)
  if err != nil {
    return nil, err
  }

  user := &User{
    ID:		claims.Sub,
    Email:	claims.Email,
    Username:	claims.Username,
    Roles:	claims.Roles,
  }
  return user, nil
}

