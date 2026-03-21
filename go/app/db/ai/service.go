package ai

import (
  "context"
  "fmt"
  "log"
  "time"
  "encoding/json"
  "strings"

  "konsin1988/rt-app/db/models"
  "konsin1988/rt-app/domain/cache"
  "konsin1988/rt-app/db/redis"
)

type Repository interface {
  GetConversationList(ctx context.Context, id int) ([]models.ConversationListItem, error)
  GetConversationMeta(ctx context.Context, conversation_id int)(*models.ConversationMeta, error)
  GetConversationMessages(ctx context.Context, conversation_id int, limit int, before *time.Time)([]models.Message, error) 
  CreateConversation(ctx context.Context, userID int, title string)(*models.ConversationListItem, error)
  CreateMessage(ctx context.Context, conversationId int, messageRole models.MessageRole, content string) (*models.Message, error)
  DeleteConversation(ctx context.Context, conversationId int)(error)
  TogglePinnedConversation(ctx context.Context, conversationId int, isPinned int)(error)
}

type Service struct {
  repo Repository
  cache  cache.Cache
  queue	 redis.RedisQueue 
}

func NewService (repo Repository, cache  cache.Cache, queue redis.RedisQueue) *Service {
  return &Service{
    repo: repo,
    cache: cache,
    queue: queue,
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
  // db
  c, err := s.repo.GetConversationList(ctx, id) 
  if err != nil {
    return nil, err
  }

  const maxRetries = 3
  for i := 0; i < maxRetries; i++ {
    if err := s.cache.Set(ctx, key, c, 10*time.Minute); err != nil {
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

// create Conversation
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

// Create Message
func (s *Service) CreateMessage(
  ctx context.Context,
  userID int,
  conversationID int,
  messageRole models.MessageRole,
  content string,
) (*models.Message, error) {
  messages, err := s.GetConversationMessages(ctx, conversationID, 7, nil)
  if err != nil {
    return nil, err
  }
  m, err := s.repo.CreateMessage(ctx, conversationID, messageRole, content)
  if err != nil {
    return nil, err
  }
  for i, j := 0, len(messages)-1; i < j; i, j = i+1, j-1 {
    messages[i], messages[j] = messages[j], messages[i]
  }
  messages = append(messages, *m)
  
  chatMessages := make([]models.ChatMessage, len(messages))
  for _, val := range messages {
    m := models.ChatMessage{
      Role: string(val.Role),
      Content: val.Content,
    }
    chatMessages = append(chatMessages, m)
  }
  job := models.ChatJob{
    Type: "chat",
    MessageID: m.ID,
    Messages: chatMessages,
  }
  err = s.queue.Enqueue(ctx, job)
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

// subscribe to string
func (s *Service) SubscribeToStream (
  ctx context.Context,
  messageID int,
  conversationID int,
) (<-chan *models.ChatStreamChunk, error){

  channel := fmt.Sprintf("ai_streams:%d", messageID)
  redisCh, err := s.queue.Subscribe(ctx, channel)
  if err != nil{
    return nil, err
  }

  out := make(chan *models.ChatStreamChunk, 10)

  go func() {
    defer close(out)

    var fullAssistantMessage strings.Builder

    for {
      select {
      case <-ctx.Done():
	return
      case msg, ok := <-redisCh:
	if !ok {
	  return
	}
	var chunk models.ChatStreamChunk 
	if err := json.Unmarshal([]byte(msg.Payload), &chunk); err != nil{
	  continue
	}

	fullAssistantMessage.WriteString(chunk.Message.Content)

	select {
	case out <- &chunk:
	case <-ctx.Done():
	  return
	}

	if chunk.Done {
	  if fullAssistantMessage.Len() > 0 {
	    _, err := s.repo.CreateMessage(
	      ctx, 
	      conversationID,
	      models.FromRoleID(2),
	      fullAssistantMessage.String(),
	    )
	    if err != nil {
	      log.Printf("failed to save assistant message: %v", err )
	    }
	  }
	  return 
	}
      }
    }
  }()
  return out, nil
}

// Delete conversation
func (s *Service) DeleteConversation(ctx context.Context, userID int, conversationId int) error {
  err := s.repo.DeleteConversation(ctx, conversationId)
  if err != nil {
    return err
  }
  keys := []string{
    fmt.Sprintf("user:%d:conversations", userID),
    fmt.Sprintf("conversation:%d:meta", conversationId),
    fmt.Sprintf("conversation:%d:messages:latest:%d", conversationId, 20),
  }
  err = s.cache.DeleteMany(ctx, keys...)
  if err != nil {
    return fmt.Errorf("Error due caching: %v", err)
  }
  return nil
}

// TogglePinnedConversation
func (s *Service) TogglePinnedConversation(ctx context.Context, userID int, conversationId int, isPinned int) error {
  err := s.repo.TogglePinnedConversation(ctx, conversationId, isPinned)
  if err != nil {
    return err
  }
  keys := []string{
    fmt.Sprintf("user:%d:conversations", userID),
    fmt.Sprintf("conversation:%d:meta", conversationId),
    fmt.Sprintf("conversation:%d:messages:latest:%d", conversationId, 20),
  }
  err = s.cache.DeleteMany(ctx, keys...)
  if err != nil {
    return fmt.Errorf("Error due caching: %v", err)
  }
  return nil
}

// Create Absence
func (s *Service) CreateAbsence(ctx context.Context, userID int, prompt string)(*models.OllamaAbsenceData, error){
  epoch := time.Now().Unix()
  jobID := fmt.Sprintf("%d:%d", userID, epoch)
  job := models.PromptJob{
    Type: "absence",
    JobID: jobID,
    Prompt: prompt,
  }
  err := s.queue.Enqueue(ctx, job)
  if err != nil {
    return nil, err
  }

  channel := fmt.Sprintf("absence:%s", jobID)
  msg, err := s.queue.ReceiveOnce(ctx, channel, 60*time.Second)
  if err != nil{
    return nil, err
  }

  var ollamaAbsenceData models.OllamaAbsenceData
  if err := json.Unmarshal([]byte(msg.Payload), &ollamaAbsenceData); err != nil {
    return nil, err 
  }
  return &ollamaAbsenceData, nil
} 

// Create Title
func (s *Service) CreateTitle(ctx context.Context, userID int, prompt string) (*models.ConversationTitle, error){
  epoch := time.Now().Unix()
  jobID := fmt.Sprintf("%d:%d", userID, epoch)
  job := models.PromptJob{
    Type: "title",
    JobID: jobID,
    Prompt: prompt,
  }
  err := s.queue.Enqueue(ctx, job)
  if err != nil {
    return nil, err
  }

  channel := fmt.Sprintf("title:%s", jobID)
  msg, err := s.queue.ReceiveOnce(ctx, channel, 120*time.Second)
  if err != nil{
    return nil, err
  }

  var convTitle models.ConversationTitle
  if err := json.Unmarshal([]byte(msg.Payload), &convTitle); err != nil {
    return nil, err 
  }
  return &convTitle, nil
}
