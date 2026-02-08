package user 

import (
  "context"
)

type Service struct {
  repo Repository
}

func NewService (repo Repository) *Service {
  return &Service{repo: repo}
}

func (s *Service) AuthUser(ctx context.Context, email string) (*MainUser, error){
  c, err := s.repo.AuthUser(ctx, email) 
  if err != nil {
    return nil, err
  }
  depts := make([]Department, 0)
  heads := make([]Head, 0)

  for _, i := range c.DeptList {
    d := Department{
      ID: i.ID,
      Name: i.Name,
      Parent: i.Parent,
      Head: i.Head,
    }
    depts = append(depts, d)
  }

  for _, val := range c.HeadList {
    h := Head{
      ID: val.ID,
      FIO: val.FIO,
    }
    heads = append(heads, h)
  }
  return &MainUser{
	ID:	      c.ID,
  	FirstName:    c.FirstName, 
  	LastName:     c.LastName, 
  	SecondName:   c.SecondName,
  	Email:	      c.Email,	 
  	Birthday:     c.Birthday, 
  	PhotoURL:     c.PhotoURL,
  	Mobile:	      c.Mobile, 
  	Position:     c.Position, 
  	Inner:	      c.Inner,	
	DeptList:     depts,
	HeadList:     heads,
    }, nil
} 

