package bitrix

import (
  "bytes"
  "context"
  "encoding/json"
  "net/http"
)

type Client struct {
  url string
}

func New(url string) *Client {
  return &Client{url: url}
}

func (c *Client) UserPhotoURL(ctx context.Context, email string) (string, error) {
  body, _ := json.Marshal(map[string]string{"EMAIL": email})

  req, err := http.NewRequestWithContext(
    ctx, 
    http.MethodPost,
    c.url,
    bytes.NewReader(body),
  )
  if err != nil {
    return "", err
  }

  req.Header.Set("Content-Type", "application/json")

  resp, err := http.DefaultClient.Do(req)
  if err != nil{
    return "", err
  }
  defer resp.Body.Close()

  var result struct {
    Result []struct {
      Photo string `json:"PERSONAL_PHOTO"`
    } `json:"result"`
  }

  if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
    return "", err
  }

  if len(result.Result) == 0 {
    return "", nil
  }

  return result.Result[0].Photo, nil
}























