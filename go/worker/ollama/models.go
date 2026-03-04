package ollama

type ChatResponseChunk struct {
        ChunkMessage struct {
                Content string `json:"content"`
        } `json:"message"`
        Done bool `json:"done"`
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
	JobID  string `json:"jobId"`
	Messages []ChatMessage `json:"messages"`
}
