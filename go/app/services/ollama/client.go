package ollama

import (
  "net/http"
  "os"
  "time"
  "encoding/json"
  "bytes"
  "fmt"
)

type Client struct {
  BaseURL   string
  Client    *http.Client
}


func NewClient() *Client {
  baseURL := os.Getenv("AI_CHAT_BASE_URL") 

  return &Client{
    BaseURL: baseURL,
    Client: &http.Client{
      Timeout: 60*time.Second,
    },
  }
}

func (c *Client) Prompt (prompt string) (string, error){
  aiModel := os.Getenv("AI_CHAT_MODEL")
  reqBody := PromptRequest{
    Model:	aiModel,
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
