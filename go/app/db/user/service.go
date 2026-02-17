package user

import (
  "context"

  models "konsin1988/rt-app/db/models"
)

type Repository interface {
  AuthUser(ctx context.Context, email string) (*models.MainUser, error)
  UserById (ctx context.Context, user_id int) (*models.MainUser, error)
}

type Service struct {
  repo Repository
}

func NewService (repo Repository) *Service {
  return &Service{repo: repo}
}


func (s *Service) AuthUser(ctx context.Context, email string) (*models.MainUser, error){
  user, err := s.repo.AuthUser(ctx, email)
  if err != nil{
    return nil, err
  }
  return user, nil
}

func (s *Service) UserById(ctx context.Context, user_id int)(*models.MainUser, error){
  user, err := s.repo.UserById(ctx, user_id)
  if err != nil{
    return nil, err
  }
  return user, nil
}
