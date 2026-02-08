package bitrix

//import (
//  "bytes"
//  "context"
//  "encoding/json"
//  "net/http"
//  "errors"
//  "strconv"
//  "fmt"
//  "time"
//
//  user "konsin1988/rt-app/domain/user"
//  "konsin1988/rt-app/helpers"
//)
//
//type Client struct {
//  userUrl     string
//  deptUrl     string
//}
//
//func New(baseUrl string) *Client {
//  return &Client{userUrl: baseUrl + "user.search", deptUrl: baseUrl + "department.get"}
//}
//
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



















