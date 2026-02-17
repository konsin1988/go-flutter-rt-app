package user 

import (
  "context"
  "errors"
  "database/sql"
  "encoding/json"
  "time"

  "konsin1988/rt-app/helpers"
  models "konsin1988/rt-app/db/models"
)


func parseIntList(s string) ([]int, error) {
    var result []int
    err := json.Unmarshal([]byte(s), &result)
    return result, err
}

func (r *UserRepo) AuthUser(ctx context.Context, email string) (*models.MainUser, error) {
  const query = `
    SELECT
        u.id,
        u.first_name,
        u.last_name,
        u.second_name,
        u.email,
        u.birthday,
        u.photo,
        u.mobile,
        u.position,
        u.phone_inner,
	u.dept as dept_id
    FROM b_user u
    where u.email = $1 
    `

  u := &models.MainUser{}
  var deptString string
  var birthdayTime sql.NullTime 

  err := r.db.QueryRowContext(ctx, query, email).
	      Scan(&u.ID, &u.FirstName, &u.LastName, &u.SecondName,
	      &u.Email, &birthdayTime, &u.PhotoURL, &u.Mobile, &u.Position, &u.Inner,
	      &deptString)
  if errors.Is(err, sql.ErrNoRows) {
    return nil, errors.New("user not found")
  }
  if birthdayTime.Valid{
    u.Birthday = helpers.GetRussianBD(&birthdayTime.Time)
  }

  deptList, err := parseIntList(deptString)
  if err != nil {
    return nil, errors.New("cannot convert string to int list")
  }

  depts := make([]models.Department, 0)
  heads := make([]models.Head, 0)

  for _, i := range deptList {
    d, err := r.getDept(ctx, i)
    if err != nil {
      return nil, err
    }
    depts = append(depts, *d)

    h, err := r.getHeadData(ctx, u.ID, d)
    if err != nil {
      return nil, err
    }
    heads = append(heads, *h)
  }
  u.DeptList = depts
  u.HeadList = heads

  return u, nil
}


func (r *UserRepo) UserById (ctx context.Context, user_id int) (*models.MainUser, error) {
  const query = `
    SELECT
        u.id,
        u.first_name,
        u.last_name,
        u.second_name,
        u.email,
        u.birthday,
        u.photo,
        u.mobile,
        u.position,
        u.phone_inner,
	u.dept as dept_id
    FROM b_user u
    where u.id = $1 
    `

  u := &models.MainUser{}
  var deptString string
  var birthdayTime *time.Time

  err := r.db.QueryRowContext(ctx, query, user_id).
	      Scan(&u.ID, &u.FirstName, &u.LastName, &u.SecondName,
	      &u.Email, &birthdayTime, &u.PhotoURL, &u.Mobile, &u.Position, &u.Inner,
	      &deptString)
  if errors.Is(err, sql.ErrNoRows) {
    return nil, errors.New("user not found")
  }
  if birthdayTime != nil {
    u.Birthday = helpers.GetRussianBD(birthdayTime)
  } 
  

  deptList, err := parseIntList(deptString)
  if err != nil {
    return nil, errors.New("cannot convert string to int list")
  }

  depts := make([]models.Department, 0)
  heads := make([]models.Head, 0)

  for _, i := range deptList {
    d, err := r.getDept(ctx, i)
    if err != nil {
      return nil, err
    }
    depts = append(depts, *d)

    h, err := r.getHeadData(ctx, u.ID, d)
    if err != nil {
      return nil, err
    }
    heads = append(heads, *h)
  }
  u.DeptList = depts
  u.HeadList = heads

  return u, nil
}



func (r *UserRepo) getDept(ctx context.Context, id int) (*models.Department, error) {
  const query = `
    SELECT
      d.id,
      d.name,
      coalesce(d.parent, 0) as parent,
      coalesce(d.head, 0) as head
    from b_department d
    where d.id = $1
  `
  d := models.Department{}
  err := r.db.QueryRowContext(ctx, query, id).
	  Scan(&d.ID, &d.Name, &d.Parent, &d.Head)
  if err != nil {
    return nil, errors.New("Cannot get department by id")
  }
  return &d, nil
}

func (r *UserRepo) getHeadData(ctx context.Context, user_id int, d *models.Department) (*models.Head, error) {
  const head_query = `
    SELECT 
      u.id as id,
      concat_ws(' ', u.last_name, u.first_name, u.second_name) as fio
    FROM b_user u
    WHERE u.id = $1
  `
  const next_head_query = `
    SELECT 
      u.id,
      concat_ws(' ', u.last_name, u.first_name, u.second_name) as fio
    FROM b_user u
    join b_department d on d.head = u.id
    where d.id = $1
  `
  h := models.Head{}
  if d.Head != 0 && (user_id != d.Head || d.Parent == 0 ) {
    err := r.db.QueryRowContext(ctx, head_query, d.Head).
	  Scan(&h.ID, &h.FIO)
    if err != nil {
      return nil, errors.New("Cannot get head by id part 1")
    }
  } else {
    err := r.db.QueryRowContext(ctx, next_head_query, d.Parent).
	  Scan(&h.ID, &h.FIO)
    if err != nil {
      return nil, errors.New("Cannot get head by id part 2")
    }
  }
  return &h, nil
}

