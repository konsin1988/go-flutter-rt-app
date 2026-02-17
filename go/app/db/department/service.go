package department

import (
  "context"

  models "konsin1988/rt-app/db/models"
)


type Repository interface {
  GetDeptById(ctx context.Context, dept_id, user_id int32) (*models.DeptById, error)
}

type Service struct {
  repo Repository
}

func NewService (repo Repository) *Service {
  return &Service{repo: repo}
}

func (s *Service) GetDeptById (ctx context.Context, dept_id, user_id int32) (*models.DeptById, error) {
  d, err := s.repo.GetDeptById(ctx, dept_id, user_id)
  if err != nil {
    return nil, err
  }
  return d, nil
} 
