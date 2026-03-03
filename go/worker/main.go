package main

import (
	"log"
	redis "konsin1988/rt-app-worker/redis"
)

func main(){
  
  redisClient, err := redis.NewRedisClient()
  if err != nil {
    log.Fatal(err)
  }
}
