package models

type MainUser struct {
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
  DeptList    []Department
  HeadList    []Head
}


type Head struct {
  ID	    int		`json:"id"`
  FIO	    string	`json:"fio"`
}

type DeptUser struct {
  ID	      int	`json:"id"`
  FIO	      string    `json:"fio"`
  Position    string    `json:"position"`
  PhotoURL    string	`json:"photo"`
}
