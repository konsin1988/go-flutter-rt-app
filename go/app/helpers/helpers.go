package helpers

import (
  "fmt"
  "time"
  "konsin1988/rt-app/types"
)

func GetMonth (num time.Month) string {
  months := map[time.Month]string{
    time.January:   "января",
    time.February:  "февраля",
    time.March:     "марта",
    time.April:     "апреля",
    time.May:       "мая",
    time.June:      "июня",
    time.July:      "июля",
    time.August:    "августа",
    time.September: "сентября",
    time.October:   "октября",
    time.November:  "ноября",
    time.December:  "декабря",
  }
  return months[num]
}

func GetRussianDate(date types.DateOnly) string {
  return fmt.Sprintf("%d %s %d", date.Day(), GetMonth(date.Month()), date.Year())
}

func GetRussianBD(date time.Time) string {
  return fmt.Sprintf("%d %s", date.Day(), GetMonth(date.Month()))    
}
