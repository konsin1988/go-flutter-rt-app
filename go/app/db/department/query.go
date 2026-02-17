package department

import (
  "database/sql"
  "context"
  "errors"

  models "konsin1988/rt-app/db/models"
)

func (r *DeptRepo) GetDeptById (ctx context.Context, dept_id, user_id int32) (*models.DeptById, error) {
  d := &models.DeptById{}
  query := `
    select 
	bd.id,
	bd."name" as name,
	bd.parent,
	bd_head."name",
	bd.head,
	concat_ws(' ', bu.last_name, bu.first_name, bu.second_name) as head_fio
      from b_department bd
      join b_department bd_head on bd.parent = bd_head.id
      join b_user bu on bd.head = bu.id
      where bd.id = $1 
  `
  err := r.db.QueryRowContext(ctx, query, dept_id).Scan(&d.ID, &d.Name, &d.Parent, 
	&d.ParentName, &d.Head, &d.HeadFIO)

  if errors.Is(err, sql.ErrNoRows) {
    return nil, errors.New("user not found")
  }

  users := make([]models.DeptUser, 0)
  query = `
    select 
	bu.id,
	concat_ws(' ', bu.last_name, bu.first_name, bu.second_name) as fio,
	coalesce(bu."position", ''),
	coalesce(bu.photo, '')
    from b_user bu
    JOIN LATERAL jsonb_array_elements_text(bu.dept::jsonb) AS dept_id(id) ON true
    JOIN b_department d ON d.id = dept_id.id::int and d.id = $1 and bu.id <> $2
  `

  rows, err := r.db.QueryContext(ctx, query, dept_id, user_id)
  if err != nil {
    return nil, err
  }
  defer rows.Close()
  
  for rows.Next() {
    var u models.DeptUser

    if err := rows.Scan(
      &u.ID,
      &u.FIO,
      &u.Position,
      &u.PhotoURL,
    ); err != nil {
      return nil, err
    }

    users = append(users, u)
  }
  d.DeptUserList = users

  return d, nil
}
