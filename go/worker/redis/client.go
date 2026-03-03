package redis

import (
  "context"
  "fmt"
  "time"
  "os"

  "github.com/redis/go-redis/v9"

)

type RedisClient struct {
  Client *redis.Client
}

func NewRedisClient()(*RedisClient, error) {
    rdAddr := os.Getenv("REDIS_ADDRESS")
    rdPass := os.Getenv("REDIS_PASSWORD")

    rdb := redis.NewClient(&redis.Options{
      Addr:	rdAddr,
      Password:	rdPass,
      DB:	0,
    })

    ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
    defer cancel()

    if _, err := rdb.Ping(ctx).Result(); err != nil {
      return nil, fmt.Errorf("failed to connect to redis: %w", err)
    }
    
    return &RedisClient{Client: rdb}, nil
}
