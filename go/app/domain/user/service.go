package user 

import (
  "context"
)

type Bitrix interface {
  GetBitrixUser(ctx context.Context, email string) (*MainUser, error)
}

type Service struct {
  bitrix    Bitrix
}

func NewService (bitrix Bitrix) *Service {
  return &Service{
    bitrix: bitrix,
  }
}

func (s *Service) GetUser(ctx context.Context , email string) (*MainUser, error) {
    mainUser, err := s.bitrix.GetBitrixUser(ctx, email)
    if err != nil {
      return nil, err
    }

    return mainUser, nil
}
