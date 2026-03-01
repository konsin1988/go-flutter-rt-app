package ollama

type ChatMessage struct {
  Role	      string	  `json:"role"`
  Content     string	  `json:"content"`
}

type ChatRequest  struct {
  Model	    string	    `json:"model"`
  Messages  []ChatMessage   `json:"messages"`
  Stream    bool	    `json:"stream"`
}

type PromptRequest struct {
  Model	    string	`json:"model"`
  Prompt    string	`json:"prompt"`
  Stream    bool	`json:"stream"`
}

type PromptResponse struct {
  Model	      string	`json:"model"`
  CreatedAt   string	`json:"created_at"`
  Response    string	`json:"response"`
  Done	      bool	`json:"done"`
}
