package ollama

type ChatStreamChunk struct {
        Message struct {
                Content string `json:"content"`
        } `json:"message"`
        Done bool `json:"done"`
}

type OllamaGenerateResponse struct {
  Response	string	  `json:"response"`
}

type OllamaAbsenceData struct {
  TimestampStart      string	`json:"timestamp_start"`
  TimestampEnd	      string	`json:"timestamp_end"`
  TypeOfAbsence	      string	`json:"type_of_absence"`
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

type GenerateRequest struct {
  Model	    string	  `json:"model"`
  Prompt    string	  `json:"prompt"`
  Stream    bool	  `json:"stream"`
}

type BaseJob struct {
  Type string `json:"type"`
}

type ChatJob struct {
  BaseJob
  MessageID  int `json:"messageId"`
  Messages []ChatMessage `json:"messages"`
}

type AbsenceJob struct {
  BaseJob
  JobID	    string  `json:"job_id"`
  Prompt    string  `json:"prompt"`
}

type ConversationTitleJob struct {
  BaseJob
  JobID	    string  `json:"job_id"`
  Prompt    string  `json:"prompt"`
}

type ConversationTitle struct {
  Title	  string    `json:"title"`
}
