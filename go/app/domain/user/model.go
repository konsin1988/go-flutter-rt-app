package user 

import (
  _ "konsin1988/rt-app/types"
)

type MainUser struct {
  ID	      int	
  FirstName   string
  LastName    string
  SecondName  string
  Email	      string
  Birthday    string
  PhotoURL    string
  Mobile      string
  Position    string
  Inner	      string
  DeptList    []Department
  HeadList    []Head
}

type Department struct {
  ID	    int		`json:"id"`
  Name	    string	`json:"name"`
  Parent    int		`json:"parent,omitempty"`
  Head	    int		`json:"head,omitempty"`
}

type Head struct {
  ID	    int		`json:"id"`
  FIO	    string	`json:"fio"`
}
