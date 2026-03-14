package main

import (
  "encoding/json"
  "fmt"
  "log"
  
  "golang.org/x/net/context"
  
  redis "konsin1988/rt-app-worker/redis"
  ollama "konsin1988/rt-app-worker/ollama"
)

var (
  jobQueue      = "ai_jobs"
  pubsubChannel = "ai_streams"
)

func dispatchJob(ctx context.Context, aiClient ollama.Client, job interface{}) {
  switch j := job.(type) {
  case ollama.ChatJob:
    if chatJob, ok := job.(ollama.ChatJob); ok {
      go aiClient.Chat(ctx, chatJob)
    }
  case ollama.AbsenceJob:
    if absenceJob, ok := job.(ollama.AbsenceJob); ok {
      go aiClient.SetAbsence(ctx, absenceJob)
    }
  default:
    fmt.Printf("unknown job type: %T\n", j)
  }
}

func main() {
  ctx := context.Background()
  
  rdb, err := redis.NewRedisClient()
  if err != nil {
    log.Printf("couldn't connect to redis, %v", err)
    return
  }
  fmt.Println("Worker started, waiting for jobs...")
  aiClient := ollama.NewClient(rdb.Client)
  
  for {
    // BRPOP blocks until a job is available
    result, err := rdb.Client.BRPop(ctx, 0, jobQueue).Result()
    if err != nil {
    	fmt.Println("Redis BRPop error:", err)
    	continue
    }
    
    if len(result) < 2 {
    	continue
    }
    
    jobData := result[1]
    
    var baseJob ollama.BaseJob
    if err := json.Unmarshal([]byte(jobData), &baseJob); err != nil {
    	fmt.Println("Invalid job JSON:", err)
    	continue
    }
    
    var job interface{}
    switch baseJob.Type {
      case "chat":
        var chatJob ollama.ChatJob
        if err := json.Unmarshal([]byte(jobData), &chatJob); err != nil {
          fmt.Println("Chat job unmarshal error:", err)
          continue
        }
        job = chatJob

      case "absence":
	var absenceJob ollama.AbsenceJob
	if err := json.Unmarshal([]byte(jobData), &absenceJob); err != nil {
	  fmt.Println("Absence job unmarshal error: ", err)
	  continue
	}
	job = absenceJob
      default:
        fmt.Println("Unknown job type:", baseJob.Type)
        continue
    }
    
    dispatchJob(ctx, *aiClient, job)
  }
}

