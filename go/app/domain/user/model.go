package user 

import (
  "time"
  _ "konsin1988/rt-app/types"
)

type User struct {
  ID	      int
  Email	      string
  FIO	      string
  Birthday    time.Time 
  Wphone      string
  Phone	      string
  Dept	      string 
  Head	      string
}

type MainUser struct {
  ID	      int
  Email	      string
  FirstName   string
  LastName    string
  SecondName  string
  PhotoURL    string
  Birthday    string 
  Wphone      string
  Phone	      string
  Dept	      string
  Position    string
  Head	      string
}
