package ollama

type ChatStreamChunk struct {
        Message struct {
                Content string `json:"content"`
        } `json:"message"`
        Done bool `json:"done"`
}

type WorkerResponseChunk struct {
    Chunk     string	`json:"chunk"`
    Done      bool	`json:"done"`
}

type ChatMessage struct {
  Role        string      `json:"role"`
  Content     string      `json:"content"`
}

type ChatRequest  struct {
  Model     string          `json:"model"`
  Messages  []ChatMessage   `json:"messages"`
  Stream    bool            `json:"stream"`
}

type Job struct {
	MessageID  int `json:"messageId"`
	Messages []ChatMessage `json:"messages"`
}
