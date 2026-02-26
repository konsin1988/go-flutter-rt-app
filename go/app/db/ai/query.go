package ai 

import (
  "context"
  "database/sql"
  "fmt"
  "time"

  "konsin1988/rt-app/db/models"

)

func (r *AiRepo) GetConversationList (ctx context.Context, user_id int) ([]models.ConversationListItem, error) {
  const query = `
    select * 
    from ai_conversation
    where user_id = $1
    order by updated_at desc
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
    FROM ai_conversation c
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
    FROM ai_message m 
    join ai_message_role mr on m.message_role_id = mr.id 
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
    INSERT INTO ai_conversation (user_id, title)
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
  query := `
    INSERT INTO ai_message(conversation_id, message_role_id, content)
    VALUES ($1, $2, $3)
    RETURNING id, created_at
  `
  var m models.Message
  err := r.db.QueryRowContext(ctx, query, conversationId, messageRole.RoleID(), content).
    Scan(&m.ID, &m.CreatedAt)
  if err != nil {
    return nil, err
  }
  m.ConversationID = conversationId
  m.Role = messageRole
  m.Content = content
  return &m, nil
}
