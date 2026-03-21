package helpers

import (
  "time"
)

func GetRussianWeekday() string {
    now := time.Now()
    weekdays := map[time.Weekday]string{
        time.Monday:    "понедельник",
        time.Tuesday:   "вторник", 
        time.Wednesday: "среда",
        time.Thursday:  "четверг",
        time.Friday:    "пятница",
        time.Saturday:  "суббота",
        time.Sunday:    "воскресенье",
    }
    return weekdays[now.Weekday()]
}
