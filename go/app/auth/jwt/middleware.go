package jwt

import (
  "net/http"
  "strings"
  "bytes"
  "io"
  "context"
  "os"
  _ "log"

  user "konsin1988/rt-app/domain/user"
)

type ContextKey string

const (
  AuthUserContextKey ContextKey = "auth_user"
  DomainUserContextKey ContextKey = "domain_user"
)

func Middleware(authService *Service, userService *user.Service) func(http.Handler) http.Handler {
  return func(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request){
      
      // in playground in dev mode, use "prod" in .env for block
      if r.URL.Path == "/playground" && os.Getenv("APP_ENV") != "prod" {
	next.ServeHTTP(w, r)
	return
      }

      if r.URL.Path == "/graphql" && isIntrospectionQuery(r){
	next.ServeHTTP(w,r)
	return
      }

      authHeader := r.Header.Get("Authorization")
      if !strings.HasPrefix(authHeader, "Bearer ") {
	http.Error(w, "unauthorized", http.StatusUnauthorized)
	return 
      }

      token := strings.TrimPrefix(authHeader, "Bearer ")

      user, err := authService.Authenticate(r.Context(), token)
      if err != nil {
	unauthorized(w)
	return 
      }

      domainUser, _, err :=  userService.GetUserWithPhoto(r.Context(), user.Email)
      if err != nil {
	unauthorized(w)
	return
      }

      ctx := r.Context()
      ctx = context.WithValue(ctx, AuthUserContextKey, user)
      ctx = context.WithValue(ctx, DomainUserContextKey, domainUser)
      next.ServeHTTP(w, r.WithContext(ctx))
    })
  }
}

func FromContext(ctx context.Context) (*User, bool){
  user, ok := ctx.Value(AuthUserContextKey).(*User)
  return user, ok
}

func unauthorized(w http.ResponseWriter){
  w.Header().Set("Content-Type", "application/json")
  w.WriteHeader(http.StatusUnauthorized)
  w.Write([]byte(`{"errors":[{"message": "unauthorized"}]}`))
}

func isIntrospectionQuery(r *http.Request) bool {
  if r.Method != http.MethodPost {
    return false
  }

  if !strings.Contains(r.Header.Get("Content-Type"), "application/json"){
    return false
  }

  body, err := io.ReadAll(r.Body)
  if err != nil {
    return false
  }

  r.Body = io.NopCloser(bytes.NewBuffer(body))

  return bytes.Contains(body, []byte("IntrospectionQuery"))
}

















