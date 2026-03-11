package ollama

import (
  "net/http"
  "os"
  "encoding/json"
  "bytes"
  "fmt"
  "log"
  "io"
  "bufio"
  "context"

  redis "github.com/redis/go-redis/v9"
)

type Client struct {
  BaseURL	string
  AiModel	string
  RedisClient	*redis.Client
  Client	*http.Client
}


func NewClient(redisClient *redis.Client) *Client {
  baseURL := os.Getenv("AI_CHAT_BASE_URL") 
  aiModel := os.Getenv("AI_CHAT_MODEL")

  return &Client{
    BaseURL: baseURL,
    AiModel: aiModel,
    RedisClient: redisClient,
    Client: &http.Client{},
  }
}

func (c *Client) Chat(ctx context.Context, job Job) {
  reqBody := ChatRequest{
    Model:      c.AiModel,
    Messages: append([]ChatMessage{
      {
        Role:    "system",
        Content: `You are a helpful assistant. 
        RESPOND ONLY to the LAST user message. 
        Previous messages are conversation history for context only.
        Do not answer previous questions. Do not repeat history.`,
      },
    },
      job.Messages...), 
    Stream:     true,  
  }
  jsonData, err := json.Marshal(reqBody)
  if err != nil {
    log.Println(err)
    return
  }
  req, err := http.NewRequest("POST", c.BaseURL+"/api/chat", bytes.NewBuffer(jsonData))
  req.Header.Set("Content-Type", "application/json")
  resp, err := c.Client.Do(req)
  if err != nil {
    log.Println(err)
    return
  }
  defer resp.Body.Close()

  if resp.StatusCode != http.StatusOK {
    err = fmt.Errorf("ollama returned status %d", resp.StatusCode)
    log.Println(err)
    return
  }
  reader := bufio.NewReader(resp.Body)
  jobChannel := fmt.Sprintf("ai_streams:%d", job.MessageID)

  for {
    line, err := reader.ReadBytes('\n')
    if err != nil {
    	if err == io.EOF {
    		break
    	}
    	fmt.Println("Stream read error:", err)
    	break
    }
    // Skip empty lines
    if len(bytes.TrimSpace(line)) == 0 {
        continue
    }
    var chunk ChatStreamChunk 
    if err := json.Unmarshal(line, &chunk); err != nil{
      fmt.Println("Failed to unmarshal string: ", err)
      continue
    }
    

    message, err := json.Marshal(chunk)
    if err != nil {
      log.Println("error due json Marshal")
      continue
    }
    
    // Publish chunk to Redis Pub/Sub on the job-specific channel
    if err := c.RedisClient.Publish(ctx, jobChannel, message).Err(); err != nil {
    	fmt.Println("Redis publish error:", err)
    }
  }

  fmt.Println("Job completed:", job.MessageID)
}
