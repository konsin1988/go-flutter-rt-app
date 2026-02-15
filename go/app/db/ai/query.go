package ai 

import (
  "context"
  _ "database/sql"
  "errors"
  "log"

  "konsin1988/rt-app/db/models"

)

func (r *AiRepo) GetConversationsList (ctx context.Context, user_id int) ([]models.ConversationListItem, error) {
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

func (r *AiRepo) GetConversationById(ctx context.Context, conversation_id int) (*models.ConversationById, error) {
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

  var c models.ConversationById
  log.Println(c)
  
  err := r.db.QueryRow(query, conversation_id).Scan(&c.ID, &c.UserID, &c.Title, &c.CreatedAt, &c.UpdatedAt)
  if err != nil {
    return nil, errors.New("Cant get an conversation from database")
  }
  log.Println(c)

  query = `
    SELECT 
	m.id, 
	m.conversation_id, 
	mr."role", 
	m."content",
	m.created_at 
    FROM ai_message m 
    join ai_message_role mr on m.message_role_id = mr.id 
    and m.conversation_id = $1
    ORDER BY m.created_at
  `
  rows, err := r.db.QueryContext(ctx, query, conversation_id)
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
  
  c.Messages = m 
  
  return &c, nil
}
