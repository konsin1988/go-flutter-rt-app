package http 

import (
  "encoding/json"
  "net/http"
  "context"

  auth "konsin1988/rt-app/auth/keycloak"
)

type AuthService interface {
  Login(ctx context.Context, email, password string)(*auth.Token, error)
  Refresh(ctx context.Context, refreshToken string)(*auth.Token, error)
  Logout(ctx context.Context, refreshToken string) error
}

type LoginRequest struct {
  Email	    string    `json:"email"`
  Password  string    `json:"password"`
}

type RefreshRequest struct {
  RefreshToken	string	`json:"refresh_token"`
}

type AuthHandler struct {
  service AuthService
}

func NewAuthHandler(service AuthService) *AuthHandler {
  return &AuthHandler{service: service}
}

// Login via email and password
func (h *AuthHandler) Login(w http.ResponseWriter, r *http.Request){
  var req LoginRequest
  if err := json.NewDecoder(r.Body).Decode(&req); err != nil{
    http.Error(w, "invalid request body", http.StatusBadRequest)
    return
  }
  if req.Email == "" || req.Password == "" {
    http.Error(w, "Email and password is required", http.StatusUnauthorized)
  }
  token, err := h.service.Login(
    r.Context(),
    req.Email,
    req.Password,
  )
  if err != nil {
    http.Error(w, "unauthorized", http.StatusUnauthorized)
    return 
  }

  w.Header().Set("Content-Type", "application/json")
  json.NewEncoder(w).Encode(token)
}

// Refresh token
func (h *AuthHandler) Refresh(w http.ResponseWriter, r *http.Request){
  var req RefreshRequest
  if err := json.NewDecoder(r.Body).Decode(&req); err != nil{
    http.Error(w, "invalid request body", http.StatusBadRequest)
  }
  if req.RefreshToken == "" {
    http.Error(w, "refresh_token is required", http.StatusUnauthorized)
  }

  token, err := h.service.Refresh(
    r.Context(),
    req.RefreshToken,
  )
  if err != nil {
    http.Error(w, "invalid refresh_token", http.StatusUnauthorized)
    return 
  }

  w.Header().Set("Content-Type", "application/json")
  json.NewEncoder(w).Encode(token)
}


// Logout 
func (h *AuthHandler) Logout(w http.ResponseWriter, r *http.Request){
  var req RefreshRequest
  if err := json.NewDecoder(r.Body).Decode(&req); err != nil{
    http.Error(w, "invalid request body", http.StatusBadRequest)
  }
  if req.RefreshToken == "" {
    http.Error(w, "refresh_token is required", http.StatusUnauthorized)
  }

  err := h.service.Logout(
    r.Context(),
    req.RefreshToken,
  )
  if err != nil {
    http.Error(w, "logout failed", http.StatusBadGateway)
    return 
  }

  w.WriteHeader(http.StatusOK)
  //w.Header().Set("Content-Type", "application/json")
  //json.NewEncoder(w).Encode(token)
}
