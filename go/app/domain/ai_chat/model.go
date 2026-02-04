package ai_chat

import (
  "time"

  "github.com/google/uuid"
)

type ConversationListItem struct {
  ID		uuid.UUID  
  UserID	uuid.UUID 
  Title		string	 
  CreatedAt	time.Time 
  UpdatedAt	time.Time
}

type ConversationById struct {
  ID		uuid.UUID
  UserID	uuid.UUID
  Title		string
  Messages	[]Message
  CreatedAt	time.Time
  UpdatedAt	time.Time
}

type MessageRole string

const (
  RoleUser	      MessageRole = "USER"
  RoleAssistant	      MessageRole = "ASSISTANT"
  RoleSystem	      MessageRole = "SYSTEM"
)

type Message struct {
  ID		    uuid.UUID	   
  ConversationID    uuid.UUID	  
  Role		    MessageRole	 
  Content	    string

  Model		    string
  PromptTokens	    int
  CompletionTokens  int
  CreatedAt	    time.Time
}
