package user

import (
)

type MainUserDB struct {
  ID	      int	    `json:"id"`
  FirstName   string	    `json:"first_name"`
  LastName    string	    `json:"last_name"`
  SecondName  string	    `json:"second_name,omitempty"`
  Email	      string	    `json:"email"`
  Birthday    string	    
  PhotoURL    string	    `json:"photo,omitempty"`
  Mobile      string	    `json:"mobile,omitempty"`
  Position    string	    `json:"position"`
  Inner	      string	    `json:"phone_inner"`
  DeptList    []DepartmentDB
  HeadList    []HeadDB
}

type DepartmentDB struct {
  ID	    int		`json:"id"`
  Name	    string	`json:"name"`
  Parent    int		`json:"parent,omitempty"`
  Head	    int		`json:"head,omitempty"`
}

type HeadDB struct {
  ID	    int		`json:"id"`
  FIO	    string	`json:"fio"`
}
