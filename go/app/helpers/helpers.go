package helpers

import (
  "fmt"
  "time"
  "log"

  "konsin1988/rt-app/types"
  models "konsin1988/rt-app/db/models"
  model "konsin1988/rt-app/graph/model"
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

func GetRussianDateFromTime(date time.Time) string {
  return fmt.Sprintf("%d %s %d", date.Day(), GetMonth(date.Month()), date.Year())
}

func AbsenceDateToString(date string) (string, error) {
  t, err := time.Parse(time.RFC3339, date)
  if err != nil {
    return "", err
  }
  
  loc := time.FixedZone("MSK", 3*60*60)
  t = t.In(loc)
  day := t.Format("02")
  month := GetMonth(t.Month())
  year := t.Format("2006")
  hour := t.Format("15")
  minute := t.Format("04")
    
  return fmt.Sprintf("%s %s %s %s:%s", day, month, year, hour, minute), nil
}

func GetRussianBD(date *time.Time) *string {
  var bd string
  if date != nil {
    bd = fmt.Sprintf("%d %s", date.Day(), GetMonth(date.Month()))    
  } else { bd = "" }
  return &bd
}


var msk *time.Location

func init() {
    var err error
    msk, err = time.LoadLocation("Europe/Moscow")
    if err != nil {
        log.Println("Failed to load Moscow timezone: " + err.Error())
    }
}

func FormatRussian(tWithoutTimezone time.Time) string {
  t := tWithoutTimezone.In(msk)
  return fmt.Sprintf("%02d %s %d %02d:%02d:%02d", 
      t.Day(), 
      GetMonth(t.Month()), 
      t.Year(),
      t.Hour(),
      t.Minute(),
      t.Second(),
    )
}


func UserToGraphModel (mainUser *models.MainUser) (*model.User){
	depts := make([]*model.Department, 0)
	heads := make([]*model.Head, 0)

	for i := 0; i < len(mainUser.DeptList); i++ {
		d := model.Department{
			ID:     int32(mainUser.DeptList[i].ID),
			Name:   mainUser.DeptList[i].Name,
			Parent: int32(mainUser.DeptList[i].Parent),
			Head:   int32(mainUser.DeptList[i].Head),
		}
		depts = append(depts, &d)

		h := model.Head{
			ID:  int32(mainUser.HeadList[i].ID),
			Fio: mainUser.HeadList[i].FIO,
		}
		heads = append(heads, &h)
	}

	return &model.User{
		ID:         int32(mainUser.ID),
		FirstName:  mainUser.FirstName,
		LastName:   mainUser.LastName,
		SecondName: mainUser.SecondName,
		Email:      mainUser.Email,
		Birthday:   mainUser.Birthday,
		PhotoURL:   mainUser.PhotoURL,
		Mobile:     mainUser.Mobile,
		Inner:      mainUser.Inner,
		Position:   mainUser.Position,
		DeptList:   depts,
		HeadList:   heads,
	}
}
