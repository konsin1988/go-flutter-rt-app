package ai

import (
  "context"
)

type Repository interface {
  GetConversationsList(ctx context.Context, id int) ([]ConversationListItem, error)
  GetConversationById(ctx context.Context, conversation_id int)(*ConversationById, error)
}
