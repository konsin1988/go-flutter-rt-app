package ai

import (
  "context"
  "fmt"
  "log"
  "time"

  "konsin1988/rt-app/db/models"
  "konsin1988/rt-app/domain/cache"
)

type Repository interface {
  GetConversationList(ctx context.Context, id int) ([]models.ConversationListItem, error)
  GetConversationMeta(ctx context.Context, conversation_id int)(*models.ConversationMeta, error)
  GetConversationMessages(ctx context.Context, conversation_id int, limit int, before *time.Time)([]models.Message, error) 
  CreateConversation(ctx context.Context, userID int, title string)(*models.ConversationListItem, error)
  CreateMessage(ctx context.Context, conversationId int, messageRole models.MessageRole, content string) (*models.Message, error)
}

type Service struct {
  repo Repository
  cache  cache.Cache
}

func NewService (repo Repository, cache  cache.Cache) *Service {
  return &Service{
    repo: repo,
    cache: cache,
  }
}

func (s *Service) GetConversationList (ctx context.Context, id int) ([]models.ConversationListItem, error){
  key := fmt.Sprintf("user:%d:conversations", id)
  var conversations []models.ConversationListItem

  // Try cache
  err :=  s.cache.Get(ctx, key, &conversations)
  if err == nil {
    return conversations, nil
  }
  //db
  c, err := s.repo.GetConversationList(ctx, id) 
  if err != nil {
    return nil, err
  }

  const maxRetries = 3
  for i := 0; i < maxRetries; i++ {
    if err := s.cache.Set(ctx, key, conversations, 10*time.Minute); err != nil {
      log.Printf("cache set failed attempt %d for user %d: %v", i+1, id, err)
      time.Sleep(50 * time.Millisecond) 
      continue
    }
    break
  }
  return c, nil
} 

// Conversation by ID
func (s *Service) GetConversationMeta(ctx context.Context, conversation_id int)(*models.ConversationMeta, error){
  metaKey := fmt.Sprintf("conversation:%d:meta", conversation_id)

  var meta models.ConversationMeta
  if err := s.cache.Get(ctx, metaKey, &meta); err != nil {
    m, err := s.repo.GetConversationMeta(ctx, conversation_id)
    if err != nil {
      return nil, err
    }
    meta = *m
    // Write to cache
    for i := 0; i < 3; i++ {
      if err := s.cache.Set(ctx, metaKey, meta, 10*time.Minute); err != nil {
        log.Printf("cache set failed attempt %d for conversation %d meta: %v", i+1, conversation_id, err)
        time.Sleep(50 * time.Millisecond)
        continue
      }
      break
    }
    _ = s.cache.Set(ctx, metaKey, meta, 10*time.Minute)
  }
  return &meta, nil
}

// GetConversationMessages
func (s *Service) GetConversationMessages(
  ctx context.Context, 
  conversation_id int, 
  limit int, 
  before *time.Time) ([]models.Message, error){ 
    cursorPart := "latest"
    if before != nil {
        cursorPart = before.Format(time.RFC3339Nano)
    }

    key := fmt.Sprintf(
        "conversation:%d:messages:%s:%d",
        conversation_id,
        cursorPart,
        limit,
    )
    var messages []models.Message
    if err := s.cache.Get(ctx, key, &messages); err == nil {
      return messages, nil
    }
    msgs, err := s.repo.GetConversationMessages(ctx, conversation_id, limit, before)
    if err != nil {
        return nil, err
    }
    if err := s.cache.Set(ctx, key, msgs, 2*time.Minute); err != nil {
        log.Printf("cache set failed: %v", err)
    }

    return msgs, nil
}


func (s *Service) CreateConversation(
  ctx context.Context, 
  userID int, 
  title string,
) (*models.ConversationListItem, error) {
    conv, err := s.repo.CreateConversation(ctx, userID, title) 
    if err != nil {
        return nil, err
    }

    key := fmt.Sprintf("user:%d:conversations", userID)
    if err := s.cache.Delete(ctx, key); err != nil {
      log.Printf("failed to invalidate conversation list cache for user %d: %v", userID, err)
    }
    _ = s.cache.Delete(ctx, key)

    return conv, nil
}

func (s *Service) CreateMessage(
  ctx context.Context,
  userID int,
  conversationID int,
  messageRole models.MessageRole,
  content string,
) (*models.Message, error) {
  m, err := s.repo.CreateMessage(ctx, conversationID, messageRole, content)
  if err != nil {
    return nil, err
  }

  keys := []string{
    fmt.Sprintf("user:%d:conversations", userID),
    fmt.Sprintf("conversation:%d:meta", conversationID),
    fmt.Sprintf("conversation:%d:messages:latest:%d", conversationID, 20),
  }
  err = s.cache.DeleteMany(ctx, keys...)
  if err != nil {
    return nil, fmt.Errorf("Error due caching: %v", err)
  }
  return m, nil
}
