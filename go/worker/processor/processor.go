package processor

import (
  "context"
  "encoding/json"
  "strings"

  redis "konsin1988/rt-app-worker/redis"
)

type AIProcessor struct {
  Redis *redis.RedisClient 
}

type AIJob struct {
	ConversationID string `json:"conversation_id"`
	UserMessageID  string `json:"user_message_id"`
}

func NewAIProcessor(r *redis.RedisClient) *AIProcessor{
  return &AIProcessor{Redis: r}
}

func (p *AIProcessor) Start() {
  ctx := context.Background()

  for {
    result, err := p.Redis.BLPop(ctx, 0, "ai_jobs").Result()
    if err != nil{
      continue
    }
    var job AIJob
    json.Unmarshal([]byte(result[1]), &job)

    go p.Process(job)
  }
}

func (p *AIProcessor) Process (job AIJob){
  ctx := context.Background()
  history := loadConversationHistory(job.ConversationID)

  var full strings.Builder
}
