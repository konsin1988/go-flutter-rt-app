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
