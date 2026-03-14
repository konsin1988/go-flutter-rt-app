package redis

import (
  "context"
  "encoding/json"
  "time"
  
  "github.com/redis/go-redis/v9"
)

type JobQueue interface {
  Enqueue(ctx context.Context, job interface{}) error
  Publish(ctx context.Context, channel string, payload interface{}) error
  Subscribe(ctx context.Context, chanel string) (<-chan *redis.Message, error)
}

type RedisQueue struct {
  client      *redis.Client
  queue	      string
}

func NewRedisQueue(client *redis.Client, queue string) *RedisQueue {
  return &RedisQueue{
    client:   client,
    queue:    queue,
  }
}

func (r *RedisQueue) Enqueue(ctx context.Context, job interface{}) error {
    bytes, err := json.Marshal(job)
    if err != nil {
        return err
    }

    return r.client.LPush(ctx, r.queue, bytes).Err()
}

func (r *RedisQueue) Publish(ctx context.Context, channel string, payload interface{}) error {
    bytes, err := json.Marshal(payload)
    if err != nil {
        return err
    }

    return r.client.Publish(ctx, channel, bytes).Err()
}

func (r *RedisQueue) Subscribe(ctx context.Context, channel string) (<-chan *redis.Message, error) {
  pubsub := r.client.Subscribe(ctx, channel)

  if _, err := pubsub.Receive(ctx); err != nil {
    return nil, err
  }

  ch := pubsub.Channel()

  out := make(chan *redis.Message, 10)

  go func() {
    defer close(out)
    defer pubsub.Close()

    for {
      select {
      case <-ctx.Done():
	return
      case msg, ok := <-ch:
	if !ok {
	  return
	}
	out <- msg
      }
    }
  }()
  return out, nil
}

// Receive one message
func (r *RedisQueue) ReceiveOnce(ctx context.Context, channel string, timeout time.Duration) (*redis.Message, error) {
    ctx, cancel := context.WithTimeout(ctx, timeout)
    defer cancel()
    
    pubsub := r.client.Subscribe(ctx, channel)
    defer pubsub.Close()
    
    if _, err := pubsub.Receive(ctx); err != nil {
        return nil, err
    }
    
    ch := pubsub.Channel()
    
    select {
    case msg := <-ch:
        return msg, nil
    case <-ctx.Done():
        return nil, ctx.Err()
    }
}

