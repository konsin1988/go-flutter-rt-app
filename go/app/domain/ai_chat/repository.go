package ai_chat

import (
  "context"
)

type Repository interface {
  GetConversationsList(ctx context.Context, id int) ([]ConversationListItem, error)
}
