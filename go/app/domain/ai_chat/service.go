package ai_chat

import (
  "context"
)

type Service struct {
  repo Repository
}

func NewService (repo Repository) *Service {
  return &Service{repo: repo}
}

func (s *Service) GetConversationsList (ctx context.Context, id int) ([]ConversationListItem, error){
  c, err := s.repo.GetConversationsList(ctx, id) 

  if err != nil {
    return nil, err
  }

  return c, nil
} 

