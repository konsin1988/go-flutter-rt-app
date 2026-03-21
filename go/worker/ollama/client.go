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
  "time"

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

func (c *Client) Chat(ctx context.Context, job ChatJob) {
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

func (c *Client) SetAbsence(ctx context.Context, job AbsenceJob) {
  now := time.Now().UTC()
  nowString := now.Format(time.RFC3339)
  prompt := fmt.Sprintf("По тексту определи дату и время начала отстутствия, дату и время конца отсутствия, причину отстутствия. Возможные причины отсутствия: Встреча: 703,  По состоянию здоровья: 704, По поручению руководителя: 705, Другое: 1032, Удаленная работа: 1511, Забытый пропуск: 2332. Дата и время сегодня: %s . Если не указано время начала отсутствия, - то ставь 09:00. Если не указано время окончания отсутствия, - то ставь 18:00. Дата может быть указана в следующих форматах: завтра, послезавтра (day after tommorow), 18.05 (число, месяц), 16 марта (число и месяц на русском языке), следующий понедельник (смотришь, какой сегодня день недели и высчитываешь, какое число будет в следующий понедельник). В ответ пришли следующую структуру, один вариант, без рассуждений: {timestapm_start: 2026-02-25T18:00:00+03:00, timestamp_end: 2026-02-25T18:00:00+03:00, type_of_absence: номер отсутствия (в формате строки)}. Ответ возвращай в формате json. Текст, в котором это нужно определить: %s", nowString, job.Prompt)
  reqBody := GenerateRequest{
    Model:      c.AiModel,
    Prompt:	prompt,
    Stream:     false,  
  }
  jsonData, err := json.Marshal(reqBody)
  if err != nil {
    log.Println(err)
    return
  }
  req, err := http.NewRequest("POST", c.BaseURL+"/api/generate", bytes.NewBuffer(jsonData))
  req.Header.Set("Content-Type", "application/json")
  resp, err := c.Client.Do(req)
  if err != nil {
    log.Println(err)
    return
  }
  body, err := io.ReadAll(resp.Body)
  if err != nil {
      return
  }
  defer resp.Body.Close()

  if resp.StatusCode != http.StatusOK {
    err = fmt.Errorf("ollama returned status %d", resp.StatusCode)
    log.Println(err)
    return
  }

  var ollamaResp  OllamaGenerateResponse
  if err := json.Unmarshal([]byte(body), &ollamaResp); err != nil {
    log.Println(err)
    return
  }
  var absenceData OllamaAbsenceData
  if err := json.Unmarshal([]byte(ollamaResp.Response), &absenceData); err != nil {
    log.Println(err)
    return
  }

  jobChannel := fmt.Sprintf("absence:%s", job.JobID)

  // Publish chunk to Redis Pub/Sub on the job-specific channel
  message, err := json.Marshal(absenceData)
  if err := c.RedisClient.Publish(ctx, jobChannel, string(message)).Err(); err != nil {
  	fmt.Println("Redis publish error:", err)
  }

  fmt.Println("Job completed:", job.JobID)
}

func (c *Client) CreateTitle(ctx context.Context, job ConversationTitleJob){
  prompt := fmt.Sprintf("Придумай название (на русском) в 3-5 словах для следующего текста, в ответе пришли только название(один вариант), без рассуждений, без кавычек: %s", job.Prompt)

  log.Println(prompt)
  reqBody := GenerateRequest{
    Model:      c.AiModel,
    Prompt:	prompt,
    Stream:     false,  
  }
  jsonData, err := json.Marshal(reqBody)
  if err != nil {
    log.Println(err)
    return
  }
  req, err := http.NewRequest("POST", c.BaseURL+"/api/generate", bytes.NewBuffer(jsonData))
  req.Header.Set("Content-Type", "application/json")
  resp, err := c.Client.Do(req)
  if err != nil {
    log.Println(err)
    return
  }
  body, err := io.ReadAll(resp.Body)
  if err != nil {
      return
  }
  defer resp.Body.Close()

  if resp.StatusCode != http.StatusOK {
    err = fmt.Errorf("ollama returned status %d", resp.StatusCode)
    log.Println(err)
    return
  }
  var ollamaResp  OllamaGenerateResponse
  if err := json.Unmarshal([]byte(body), &ollamaResp); err != nil {
    log.Println(err)
    return
  }

  convTitle := ConversationTitle{
    Title: ollamaResp.Response,
  }

  jobChannel := fmt.Sprintf("title:%s", job.JobID)
  message, err := json.Marshal(convTitle)
  if err := c.RedisClient.Publish(ctx, jobChannel, string(message)).Err(); err != nil {
  	fmt.Println("Redis publish error:", err)
  }

  fmt.Println("Job completed:", job.JobID)
} 
