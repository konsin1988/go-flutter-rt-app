package ai 

import (
  "context"
  "database/sql"
  "fmt"
  "time"
  "os"

  "konsin1988/rt-app/db/models"

)

func (r *AiRepo) GetConversationList (ctx context.Context, user_id int) ([]models.ConversationListItem, error) {
  const query = `
    select 
      id,
      user_id,
      title,
      created_at,
      updated_at,
      case 
        when pinned_at <> 'epoch' then 1 
        else 0 
      end as is_pinned
    from ai.conversation
    where user_id = $1
    order by pinned_at desc, updated_at desc
  ` 

  rows, err := r.db.QueryContext(ctx, query, user_id)
  if err != nil {
    return nil, err
  }
  defer rows.Close()

  conversations := make([]models.ConversationListItem, 0)

  for rows.Next() {
    var c models.ConversationListItem

    if err := rows.Scan(
      &c.ID,
      &c.UserID,
      &c.Title,
      &c.CreatedAt,
      &c.UpdatedAt,
      &c.IsPinned,
    ); err != nil {
      return nil, err
    }

    conversations = append(conversations, c)
  }
  if err := rows.Err(); err != nil {
    return nil, err
  }
  return conversations, nil
}

func (r *AiRepo) GetConversationMeta(ctx context.Context, conversation_id int) (*models.ConversationMeta, error) {
  query := `
    SELECT 
	c.id, 
	c.user_id, 
	c.title, 
	c.created_at, 
	c.updated_at
    FROM ai.conversation c
    WHERE c.id = $1
  `

  var c models.ConversationMeta
  
  err := r.db.QueryRow(query, conversation_id).Scan(&c.ID, &c.UserID, &c.Title, &c.CreatedAt, &c.UpdatedAt)
  if err != nil {
    return nil, fmt.Errorf("Cant get an conversation from database: %w", err)
  }

  return &c, nil
}

func (r *AiRepo) GetConversationMessages(ctx context.Context, conversation_id int, limit int, before *time.Time) ([]models.Message, error) {
  baseQuery := `
    SELECT 
	m.id, 
	m.conversation_id, 
	mr."role", 
	m."content",
	m.created_at 
    FROM ai.message m 
    join ai.message_role mr on m.message_role_id = mr.id 
    and m.conversation_id = $1
  `
  var rows *sql.Rows
  var err error
  if before != nil {
    baseQuery += `
        AND m.created_at < $2
        ORDER BY m.created_at DESC 
        LIMIT $3
    `
    rows, err = r.db.QueryContext(ctx, baseQuery, conversation_id, *before, limit)
  } else {
    baseQuery += `
        ORDER BY m.created_at DESC 
        LIMIT $2
    `
    rows, err = r.db.QueryContext(ctx, baseQuery, conversation_id, limit)
  }

  if err != nil {
    return nil, err
  }
  defer rows.Close()

  m := make([]models.Message, 0)
  for rows.Next() {
    var i models.Message 
    if err := rows.Scan(&i.ID, &i.ConversationID, &i.Role, &i.Content, &i.CreatedAt); err != nil {
      return nil, err
    }
    m = append(m, i)
  }
  
  return m, nil
}

func (r *AiRepo) CreateConversation(
    ctx context.Context,
    userID int,
    title string,
) (*models.ConversationListItem, error) {
  query := `
    INSERT INTO ai.conversation (user_id, title)
    VALUES ($1, $2)
    RETURNING id, user_id, title, created_at, updated_at
  ` 
  var c models.ConversationListItem
  err := r.db.QueryRowContext(ctx, query, userID, title).
      Scan(&c.ID, &c.UserID, &c.Title, &c.CreatedAt, &c.UpdatedAt)

  if err != nil {
    return nil, err
  }
  return &c, nil
}

func (r *AiRepo) CreateMessage(
  ctx context.Context,
  conversationId int,
  messageRole models.MessageRole,
  content string,
) (*models.Message, error){
  modelName := os.Getenv("AI_CHAT_MODEL")

  query := `
    INSERT INTO ai.message(conversation_id, message_role_id, content, model)
    VALUES ($1, $2, $3, $4)
    RETURNING id, created_at
  `
  var m models.Message
  err := r.db.QueryRowContext(ctx, query, conversationId, messageRole.RoleID(), content, modelName).
    Scan(&m.ID, &m.CreatedAt)
  if err != nil {
    return nil, err
  }

  query = `
    UPDATE ai.conversation
    SET updated_at = now()
    WHERE id = $1;
  `
  result, err := r.db.ExecContext(ctx, query, conversationId)
  if err != nil {
      return nil, err
  }
  
  _, err = result.RowsAffected()
  if err != nil {
    return nil, err
  }
  m.ConversationID = conversationId
  m.Role = messageRole
  m.Content = content
  return &m, nil
}

func (r *AiRepo) DeleteConversation(ctx context.Context, conversationId int) error {
  query := `
    DELETE FROM ai.conversation
    WHERE id = $1
  `
  result, err := r.db.ExecContext(ctx, query, conversationId)
  if err != nil {
    return err
  }
  rowAffected, _ := result.RowsAffected()
  if rowAffected == 0 { return err }

  query = `
    DELETE FROM ai.message
    WHERE conversation_id = $1
  `
  result, err = r.db.ExecContext(ctx, query, conversationId)
  if err != nil {
    return err
  }
  rowAffected, _ = result.RowsAffected()
  if rowAffected == 0 { return err }

  return nil
}

func (r *AiRepo) TogglePinnedConversation(ctx context.Context, conversationId int, isPinned int) error {
  query := `
    UPDATE ai.conversation
    SET pinned_at = 'epoch'
    WHERE id = $1
  `
  if isPinned == 0 {
    query = `
      UPDATE ai.conversation
      SET pinned_at = now()
      WHERE id = $1
    `
  }
  result, err := r.db.ExecContext(ctx, query, conversationId)
  if err != nil {
    return err
  }
  rowAffected, _ := result.RowsAffected()
  if rowAffected == 0 { return err }

  return nil
}

func (r *AiRepo) RenameConversation(ctx context.Context, conversationId int, newTitle string) (*models.ConversationListItem, error){
  query := `
    update ai.conversation ac 
    set title = $1 
    where id = $2
    returning id, user_id, title, created_at, updated_at,
    case
    	when pinned_at = 'epoch' then 0
    	else 1
    end as is_pinned;
  `
  var c models.ConversationListItem
  err := r.db.QueryRowContext(ctx, query,  newTitle, conversationId).
    Scan(&c.ID, &c.UserID, &c.Title, &c.CreatedAt, &c.UpdatedAt, &c.IsPinned)
  if err != nil {
    return nil, err
  }
  return &c, nil
} 
