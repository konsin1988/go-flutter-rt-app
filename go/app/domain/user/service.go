package user 

import (
  "context"
)

type Bitrix interface {
  UserPhotoURL(ctx context.Context, email string) (string, error)
}

type Service struct {
  repo	    Repository
  bitrix    Bitrix
}

func NewService (repo Repository, bitrix Bitrix) *Service {
  return &Service{
    repo: repo,
    bitrix: bitrix,
  }
}

func (s *Service) GetUserWithPhoto (ctx context.Context , email string) (*User, string, error) {
    u, err := s.repo.FindByEmail(ctx, email)
    if err != nil{
      return nil, "", err
    }

    photoURL, err := s.bitrix.UserPhotoURL(ctx, email)
    if err != nil {
      return nil, "", err
    }

    return u, photoURL, nil
}
