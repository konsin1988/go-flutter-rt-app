package db 

import (
  "context"
  "database/sql"
  "errors"

  user "konsin1988/rt-app/domain/user"
  ai_chat "konsin1988/rt-app/domain/ai_chat"
)

type PostgresRepo struct {
  db *sql.DB
}

func NewPostgresRepo(db *sql.DB) *PostgresRepo{
  return &PostgresRepo{db: db}
}

func (r *PostgresRepo) FindByEmail(ctx context.Context, email string) (*user.User, error) {
  const query = `
    select 
	ud.id, ud.email, ud.fio, ud.birthday, ud.wphone, 
	ud.phone, d.dept_name, ud2.fio                                                                                                 
    from user_data ud
    join departments d on ud.dept_id = d.id 
    left join user_data ud2 on ud.head_id = ud2.id
    where ud.email = $1`
  u := &user.User{}
  err := r.db.QueryRowContext(ctx, query, email).
	      Scan(&u.ID, &u.Email, &u.FIO, &u.Birthday, 
		&u.Wphone, &u.Phone, &u.Dept, &u.Head)
  if errors.Is(err, sql.ErrNoRows) {
    return nil, errors.New("user not found")
  }
  if err != nil {
    return nil, err
  }
  return u, nil
}


func (r *PostgresRepo) GetConversationsList (ctx context.Context, id int) ([]ai_chat.ConversationListItem, error) {
  const query = `
    select * 
    from conversation
    where user_id = $1
    order by updated_at desc
  ` 

  rows, err := r.db.QueryContext(ctx, query, id)
  if err != nil {
    return nil, err
  }
  defer rows.Close()

  conversations := make([]ai_chat.ConversationListItem, 0)

  for rows.Next() {
    var c ai_chat.ConversationListItem

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





























