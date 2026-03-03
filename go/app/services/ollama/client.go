package ollama

import (
  "net/http"
  "os"
  "time"
  "encoding/json"
  "bytes"
  "fmt"
  "io"
)

type Client struct {
  BaseURL   string
  AiModel   string
  Client    *http.Client
}


func NewClient() *Client {
  baseURL := os.Getenv("AI_CHAT_BASE_URL") 
  aiModel := os.Getenv("AI_CHAT_MODEL")

  return &Client{
    BaseURL: baseURL,
    AiModel: aiModel,
    Client: &http.Client{
      Timeout: 60*time.Second,
    },
  }
}

func (c *Client) Prompt (prompt string) (string, error){
  reqBody := PromptRequest{
    Model:	c.AiModel,
    Prompt:	prompt,
    Stream:	false,	
  }
  jsonData, err := json.Marshal(reqBody)
  if err != nil {
    return "", err
  }
  req, err := http.NewRequest("POST", c.BaseURL+"/api/generate", bytes.NewBuffer(jsonData))
  req.Header.Set("Content-Type", "application/json")
  resp, err := c.Client.Do(req)
  if err != nil {
    return "", err
  }
  defer resp.Body.Close()

  if resp.StatusCode != http.StatusOK {
    return "", fmt.Errorf("ollama returned status %d", resp.StatusCode)
  }

  var result PromptResponse
  if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
    return "", nil
  }
  return result.Response, err
}

func (c *Client) ChatStream(messages []ChatMessage, cb ChatStreamCallback) error {
  reqBody := ChatRequest{
    Model: c.AiModel,
    Messages: messages,
    Stream: true,
  }
  jsonData, err := json.Marshal(reqBody)
  if err != nil {
    return err
  }

  req, err := http.NewRequest(
    "POST",
    c.BaseURL+"/api/chat",
    bytes.NewBuffer(jsonData),
  )
  if err != nil {
    return err
  }
  req.Header.Set("Content-Type", "application/json")
  resp, err := c.Client.Do(req)
  if err != nil {
    return err
  }
  defer resp.Body.Close()

  if resp.StatusCode != http.StatusOK{
    return fmt.Errorf("ollama returned status %d", resp.StatusCode)
  }

  dec := json.NewDecoder(resp.Body)
  for {
    var chunk ChatResponseChunk
    if err := dec.Decode(&chunk); err != nil {
      if err == io.EOF{
	break
      }
      return err
    }

    done := chunk.Done
    if err := cb(chunk.ChunkMessage.Content, done); err != nil{
      return err
    }
    if done {
      break
    }
  }
  return nil 
}
