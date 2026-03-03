package ollama

import (
  "sync"
  "context"
)

type StreamResponse chan *ChatResponseChunk

var (
  mu	  sync.RWMutex
  channels = map[int32]StreamResponse{}
)

// Broadcast to conversations
func BroadcastAiResponse(conversationID int32, chunk *ChatResponseChunk) bool {
  mu.RLock()
  ch, ok := channels[conversationID]
  mu.RUnlock()
  if ok {
    select {
      case ch <- chunk:
      default:
    }
    return true
  }
  return false
}

// Subscribe to a conversation stream
func SubscribeAiResponse(ctx context.Context, conversationID int32) StreamResponse {
  ch := make(StreamResponse, 100)

  mu.Lock()
  channels[conversationID] = ch
  mu.Unlock()

  go func() {
    <-ctx.Done()

    mu.Lock()
    delete(channels, conversationID)
    mu.Unlock()

    close(ch)
  }()
  return ch
}
