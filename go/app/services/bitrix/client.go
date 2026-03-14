package bitrix

import (
  "bytes"
  "context"
  "encoding/json"
  "net/http"
  "os"
  _ "errors"
  _ "strconv"
  _ "fmt"
  "time"

  _ "konsin1988/rt-app/helpers"
)

type Client struct {
  absenceUrl	  string
}

func New() *Client {
  baseUrl := os.Getenv("BITRIX24_URL")
  return &Client{ 
    absenceUrl: baseUrl + "crm.item.add",
  }
}
// Department
func (c *Client) CreateAbsence(ctx context.Context, 
    userID int, 
    dateStart string, 
    dateEnd string, 
    typeOfAbsence int, 
  ) (*AbsenceResponse, error) {
  now := time.Now().UTC()
  nowString := now.Format(time.RFC3339)
  bitrixFields := AbsenceBitrixFields{
    CreatedBy: 1, 
    CreatedTime: nowString, 
    UpdatedTime: nowString,
    StageID: "DT169_26:NEW", 
    UfCrm14_1629993971: dateStart, 
    UfCrm14_1629994007: dateEnd,
    UfCrm14_1629994024: userID,
    UfCrm14_1629994055: typeOfAbsence,
    UfCrm14_1629994264: "",
  }
  absenceBitrix := AbsenceBitrix{
    EntityTypeID: "169",
    Fields: bitrixFields,
  }
  body, err := json.Marshal(absenceBitrix)
  if err != nil {
    return nil, err 
  }

  req, err := http.NewRequestWithContext(
    ctx, 
    http.MethodPost,
    c.absenceUrl,
    bytes.NewReader(body),
  )
  if err != nil {
    return nil, err
  }
  req.Header.Set("Content-Type", "application/json")

  resp, err := http.DefaultClient.Do(req)
  if err != nil{
    return nil, err
  }
  defer resp.Body.Close()

  var absenceResponse AbsenceResponse
  if err := json.NewDecoder(resp.Body).Decode(&absenceResponse); err != nil {
    return nil, err
  }

  return &absenceResponse, nil
}


  //func (c *Client) GetBitrixUser(ctx context.Context, email string) (*user.MainUser, error) {
//  body, _ := json.Marshal(map[string]string{"EMAIL": email})
//  req, err := http.NewRequestWithContext(
//    ctx, 
//    http.MethodPost,
//    c.userUrl,
//    bytes.NewReader(body),
//  )
//  if err != nil {
//    return nil, err
//  }
//  req.Header.Set("Content-Type", "application/json")
//  resp, err := http.DefaultClient.Do(req)
//  if err != nil{
//    return nil, err
//  }
//  defer resp.Body.Close()
//
//  var result struct {
//    Result    []BitrixUser `json:"result"`
//  }
//  if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
//    return nil, err
//  }
//
//  if len(result.Result) == 0 {
//    return nil, nil
//  }
//
//  if len(result.Result[0].UFDepartment) == 0{
//    return nil, errors.New("Department is empty")
//  }
//  bitrixUser := result.Result[0]
//  dept, err := c.GetDepartmentById(ctx, strconv.Itoa(bitrixUser.UFDepartment[0]))
//  if err != nil {
//    return nil, errors.New("Dept is not set")
//  }
//  
//  var head string
//  if dept.UFHead == bitrixUser.ID {
//    headDept, err := c.GetDepartmentById(ctx, dept.Parent)
//    if err != nil {
//      return nil, err
//    }
//    head, err = c.GetHeadById(ctx, headDept.UFHead) 
//    if err != nil { return nil, errors.New("Can't get head person")} 
//  } else {
//    head, err = c.GetHeadById(ctx, dept.UFHead) 
//    if err != nil { return nil, errors.New("Can't get head person")}
//  } 
//
//  user_id, err := strconv.Atoi(bitrixUser.ID)
//  if err != nil {return nil, err}
//
//  if bitrixUser.Birthday != "" {
//    t, err := time.Parse(time.RFC3339, bitrixUser.Birthday)
//    if err != nil {
//      return nil, errors.New("Error due Birthday parsing")
//    }
//    bitrixUser.Birthday = helpers.GetRussianBD(t)
//  }
//
//  return &user.MainUser{
//    ID: user_id, 
//    Email: bitrixUser.Email,
//    FirstName: bitrixUser.Name,
//    LastName: bitrixUser.LastName,
//    SecondName: bitrixUser.SecondName,
//    PhotoURL: bitrixUser.PersonalPhoto,
//    Birthday: bitrixUser.Birthday,
//    Wphone: bitrixUser.PhoneInner,   
//    Phone: bitrixUser.PersonalMobile,
//    Dept: dept.Name, 
//    Position: bitrixUser.WorkPosition,  
//    Head: head,
//  }, nil
//}
//
//
//// Department
//func (c *Client) GetDepartmentById(ctx context.Context, id string) (*BitrixDept, error) {
//  body, _ := json.Marshal(map[string]string{"ID": id})
//
//  req, err := http.NewRequestWithContext(
//    ctx, 
//    http.MethodPost,
//    c.deptUrl,
//    bytes.NewReader(body),
//  )
//  if err != nil {
//    return nil, err
//  }
//  req.Header.Set("Content-Type", "application/json")
//
//  resp, err := http.DefaultClient.Do(req)
//  if err != nil{
//    return nil, err
//  }
//  defer resp.Body.Close()
//
//  var result struct {
//    Result    []BitrixDept    `json:"result"`
//  }
//  if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
//    return nil, err
//  }
//  if len(result.Result) == 0 {
//    return nil, nil
//  }
//  return &result.Result[0], nil
//}
//
//// get user by id
//func (c *Client) GetHeadById(ctx context.Context, id string) (string, error) {
//  body, _ := json.Marshal(map[string]string{"ID": id})
//  req, err := http.NewRequestWithContext(
//    ctx, 
//    http.MethodPost,
//    c.userUrl,
//    bytes.NewReader(body),
//  )
//  if err != nil {
//    return "", err
//  }
//  req.Header.Set("Content-Type", "application/json")
//  resp, err := http.DefaultClient.Do(req)
//  if err != nil{
//    return "", err
//  }
//  defer resp.Body.Close()
//
//  var result struct {
//    Result    []BitrixUser `json:"result"`
//  }
//  if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
//    return "", err
//  }
//
//  if len(result.Result) == 0 {
//    return "", nil
//  }
//  head := fmt.Sprintf("%s %s %s", result.Result[0].LastName, result.Result[0].Name, result.Result[0].SecondName)
//
//  return head, nil
//}
