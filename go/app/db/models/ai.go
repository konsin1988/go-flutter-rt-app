package models 

import (
  "time"
)

type ConversationListItem struct {
  ID		int	      `json:"id"` 
  UserID	int	      `json:"user_id"` 
  Title		string	      `json:"title"` 
  CreatedAt	time.Time     `json:"created_at"` 
  UpdatedAt	time.Time     `json:"updated_at"`
}

type ConversationMeta struct {
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
  Messages	[]*Message
  CreatedAt	time.Time     `json:"created_at"`
  UpdatedAt	time.Time     `json:"updated_at"`
}

type MessageRole string

const (
  RoleUser	      MessageRole = "USER"
  RoleAssistant	      MessageRole = "ASSISTANT"
  RoleSystem	      MessageRole = "SYSTEM"
)

func (r MessageRole) RoleID() int {
    switch r {
    case RoleUser:
        return 1
    case RoleAssistant:
        return 2
    case RoleSystem:
        return 3
    default:
      return 0 
    }
}

func FromRoleID(id int) MessageRole {
    switch id {
    case 1:
        return RoleUser
    case 2:
        return RoleAssistant
    case 3:
        return RoleSystem
    default: 
	return RoleUser 
    }
}

type Message struct {
  ID		    int		  `json:"id"`
  ConversationID    int		  `json:"conversation_id"`
  Role		    MessageRole	  `json:"message_role"`
  Content	    string	  `json:"content"`

  Model		    string
  //PromptTokens	    int
  //CompletionTokens  int
  CreatedAt	    time.Time	  `json:"created_at"`
}

type ChatMessage struct {
  Role        string      `json:"role"`
  Content     string      `json:"content"`
}


type ChatJob struct {
	Type	  string  `json:"type"`
        MessageID  int `json:"messageId"`
        Messages []ChatMessage `json:"messages"`
}

type AbsenceJob struct {
	Type	  string  `json:"type"`
	JobID	  string  `json:"job_id"`
	Prompt	  string  `json:"prompt"`
}

type ChatStreamChunk struct {
        Message struct {
                Content string `json:"content"`
        } `json:"message"`
        Done bool `json:"done"`
}

type OllamaAbsenceData struct {
  TimestampStart      string    `json:"timestamp_start"`
  TimestampEnd        string    `json:"timestamp_end"`
  TypeOfAbsence       string    `json:"type_of_absence"`
}

type AbsenceType int
const (
    Meeting AbsenceType = 703
    Health  AbsenceType = 704
    Boss    AbsenceType = 705
    Other   AbsenceType = 1032
    Remote  AbsenceType = 1511
    Pass    AbsenceType = 2332
)
var absenceNames = map[AbsenceType]string{
    Meeting: "Встреча",
    Health:  "По состоянию здоровья", 
    Boss:    "По поручению руководителя",
    Other:   "Другое",
    Remote:  "Удаленная работа",
    Pass:    "Забытый пропуск",
}
func (at AbsenceType) GetName() string {
    if name, ok := absenceNames[at]; ok {
        return name
    }
    return "Unknown"
}
