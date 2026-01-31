package http

import (
  "net/http"
  "path/filepath"
)

func ImageHandler(w http.ResponseWriter, r *http.Request) {
  name := filepath.Base(r.URL.Path) 

  if name == "." || name == "/" {
    http.NotFound(w, r)
    return
  }

  matches, err := filepath.Glob(filepath.Join("/app/uploads/users", name+".*"))
  if err != nil{
    http.NotFound(w, r)
    return 
  }
	
  http.ServeFile(w, r, matches[0])
}
