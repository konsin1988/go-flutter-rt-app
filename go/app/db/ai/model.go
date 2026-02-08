package ai

import (
  "time"
)

type ConversationListItemDTO struct {
  ID		int	      `json:"id"` 
  UserID	int	      `json:"user_id"` 
  Title		string	      `json:"title"` 
  CreatedAt	time.Time     `json:"created_at"` 
  UpdatedAt	time.Time     `json:"updated_at"`
}

type ConversationByIdDTO struct {
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
  ID		    int		  `json:"id"`
  ConversationID    int		  `json:"conversation_id"`
  Role		    MessageRole	  `json:"message_role"`
  Content	    string	  `json:"content"`

  //Model		    string
  //PromptTokens	    int
  //CompletionTokens  int
  CreatedAt	    time.Time	  `json:"created_at"`
}
