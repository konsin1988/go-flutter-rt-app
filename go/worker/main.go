package main

import (
	_ "bufio"
	_ "bytes"
	"encoding/json"
	"fmt"
	_ "io"
	_ "net/http"
	_ "os"
	"log"

	"golang.org/x/net/context"

	redis "konsin1988/rt-app-worker/redis"
	ollama "konsin1988/rt-app-worker/ollama"
)

var (
	jobQueue      = "ai_jobs"
	pubsubChannel = "ai_streams"
)

func main() {
	ctx := context.Background()

	// Connect to Redis
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
		var job ollama.Job
		if err := json.Unmarshal([]byte(jobData), &job); err != nil {
			fmt.Println("Invalid job JSON:", err)
			continue
		}

		go aiClient.Chat(ctx, job)
	}
}

//func processJob(ctx context.Context, rdb *redis.RedisClient, job ollama.Job) {
//	fmt.Println("Processing job:", job.JobID)
//	baseURL := os.Getenv("AI_CHAT_BASE_URL") 
//	aiModel := os.Getenv("AI_CHAT_MODEL")
//
//
//	// Prepare request to Ollama
//	reqBody := ollama.ChatRequest{
//	  Model: aiModel,
//  	  Messages: job.Messages,
//  	  Stream: true,
//  	}
//  	jsonData, err := json.Marshal(reqBody)
//  	if err != nil {
//	  log.Println("error while json.Marshal")
//  	  return
//  	}
//
//	req, err := http.NewRequest("POST", baseURL+"/api/chat", bytes.NewBuffer(jsonData))
//	if err != nil {
//		fmt.Println("Request creation error:", err)
//		return
//	}
//
//	req.Header.Set("Content-Type", "application/json")
//
//	resp, err := http.DefaultClient.Do(req)
//	if err != nil {
//		fmt.Println("Ollama API request error:", err)
//		return
//	}
//	defer resp.Body.Close()
//
//	if resp.StatusCode != http.StatusOK {
//		fmt.Println("Ollama API returned:", resp.Status)
//		return
//	}
//
//	// Stream response
//	reader := bufio.NewReader(resp.Body)
//	jobChannel := fmt.Sprintf("ai_streams:%s", job.JobID)
//
//	for {
//		line, err := reader.ReadBytes('\n')
//		if err != nil {
//			if err == io.EOF {
//				break
//			}
//			fmt.Println("Stream read error:", err)
//			break
//		}
//
//		chunk := string(line)
//		message, _ := json.Marshal(map[string]string{
//			"jobId": job.JobID,
//			"chunk": chunk,
//		})
//
//		// Publish chunk to Redis Pub/Sub
//		if err := rdb.Client.Publish(ctx, jobChannel, message).Err(); err != nil {
//			fmt.Println("Redis publish error:", err)
//		}
//	}
//
//	fmt.Println("Job completed:", job.JobID)
//}
