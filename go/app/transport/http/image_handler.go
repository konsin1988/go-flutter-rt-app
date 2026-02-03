package http

import (
  "net/http"
  "context"
  "encoding/json"
  "time"
  "bytes"
  "os"
)

type bitrixResponse struct {
  Result []struct {
    Photo string `json:"PERSONAL_PHOTO"`
  } `json:"result"`
}

func ImageHandler(w http.ResponseWriter, r *http.Request) {
  bitrixURL := os.Getenv("BITRIX24_URL")
  const emailDomain = "@rt-techpriemka.ru"
  prefix := r.PathValue("email")
  if prefix == "" {
    http.Error(w, "missing email", http.StatusBadRequest)
    return
  }

  email := prefix + emailDomain

  reqBody := map[string]string{
    "EMAIL": email,
  }
  body, _ := json.Marshal(reqBody)
  ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
  defer cancel()

  req, err := http.NewRequestWithContext(
    ctx, 
    http.MethodPost,
    bitrixURL,
    bytes.NewReader(body),
  )

  if err != nil {
    http.Error(w, err.Error(), 500)
    return
  }
  req.Header.Set("Content-Type", "application/json")

  resp, err := http.DefaultClient.Do(req)
  if err != nil {
    http.Error(w, err.Error(), 502)
    return
  }
  defer resp.Body.Close()

  var br bitrixResponse
  if err := json.NewDecoder(resp.Body).Decode(&br); err	!= nil {
    http.Error(w, "bad bitrix response", 502)
    return 
  }

  if len(br.Result) == 0 || br.Result[0].Photo == "" {
    http.NotFound(w, r)
    return
  }
  w.Header().Set("Content-Type", "text/plain; charset=utf-8")
  w.WriteHeader(http.StatusOK)
  w.Write([]byte(br.Result[0].Photo))

















  
  

  //name := filepath.Base(r.URL.Path) 
  //if name == "." || name == "/" {
  //  http.NotFound(w, r)
  //  return
  //}
  //matches, err := filepath.Glob(filepath.Join("/app/uploads/users", name+".*"))
  //if err != nil{
  //  http.NotFound(w, r)
  //  return 
  //}
  //      
  //http.ServeFile(w, r, matches[0])
}
