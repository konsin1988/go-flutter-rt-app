package ai

import (
  "context"
  "konsin1988/rt-app/db/models"
)

type Repository interface {
  GetConversationsList(ctx context.Context, id int) ([]models.ConversationListItem, error)
  GetConversationById(ctx context.Context, conversation_id int)(*models.ConversationById, error)
}

type Service struct {
  repo Repository
}

func NewService (repo Repository) *Service {
  return &Service{repo: repo}
}

func (s *Service) GetConversationsList (ctx context.Context, id int) ([]models.ConversationListItem, error){
  c, err := s.repo.GetConversationsList(ctx, id) 
  if err != nil {
    return nil, err
  }
  return c, nil
} 

func (s *Service) GetConversationById(ctx context.Context, conversation_id int)(*models.ConversationById, error){
  c, err := s.repo.GetConversationById(ctx, conversation_id)
  if err != nil {
    return nil, err
  }
  return c, nil
}
