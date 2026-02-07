package ai_chat

import (
  "time"

  _ "github.com/google/uuid"
)

type ConversationListItem struct {
  ID		int	      `json:"id"` 
  UserID	int	      `json:"user_id"` 
  Title		string	      `json:"title"` 
  CreatedAt	time.Time     `json:"created_at"` 
  UpdatedAt	time.Time     `json:"updated_at"`
}

type ConversationById struct {
  ID		int	      `json:"id"`	
  UserID	int	      `json:"user_id"`	
  Title		string	      `json:"title"`
  Messages	[]Message
  CreatedAt	time.Time     `json:"created_at"`
  UpdatedAt	time.Time     `json:"updated_at"`
}

type MessageRole string

const (
  RoleUser	      MessageRole = "USER"
  RoleAssistant	      MessageRole = "ASSISTANT"
  RoleSystem	      MessageRole = "SYSTEM"
)

type Message struct {
  ID		    int 
  ConversationID    int 
  Role		    MessageRole	 
  Content	    string

  //Model		    string
  //PromptTokens	    int
  //CompletionTokens  int
  CreatedAt	    time.Time
}
