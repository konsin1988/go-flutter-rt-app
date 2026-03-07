package redis

import (
  "context"
  "encoding/json"
  "time"

  "github.com/redis/go-redis/v9"

  "konsin1988/rt-app/domain/cache"
)

type RedisCache struct {
  client *redis.Client
}

func NewRedisCache(client *redis.Client) *RedisCache {
    return &RedisCache{client: client}
}

var _ cache.Cache = (*RedisCache)(nil)

func (r *RedisCache) Get (ctx context.Context, key string, dest interface{}) error {
  val, err := r.client.Get(ctx, key).Result()
  if err != nil {
    return err
  }

  return json.Unmarshal([]byte(val), dest)
}

func (r *RedisCache) Set (ctx context.Context, key string, value interface{}, ttl time.Duration) error {
  bytes, err := json.Marshal(value)
  if err != nil {
    return err
  }
  return r.client.Set(ctx, key, bytes, ttl).Err()
}

func (r *RedisCache) Delete (ctx context.Context, key string) error {
  return  r.client.Del(ctx, key).Err()
}

func (c *RedisCache) DeleteMany(ctx context.Context, keys ...string) error {
    if len(keys) == 0 {
        return nil
    }
    pipe := c.client.Pipeline()
    for _, key := range keys {
        pipe.Del(ctx, key)
    }
    _, err := pipe.Exec(ctx)
    return err
}
