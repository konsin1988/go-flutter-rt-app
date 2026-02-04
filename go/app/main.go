package main

import (
    "net/http"
    "log"
    "os"

    "konsin1988/rt-app/config"
    infraDB "konsin1988/rt-app/infrastructure/db"
    "konsin1988/rt-app/health"
    transport "konsin1988/rt-app/transport/http"
    keycloak "konsin1988/rt-app/auth/keycloak"
    keycloak_repo "konsin1988/rt-app/infrastructure/keycloak"
    jwt "konsin1988/rt-app/auth/jwt"
    graph "konsin1988/rt-app/graph"
    repos "konsin1988/rt-app/infrastructure/db"
    bitrix "konsin1988/rt-app/bitrix"
    user "konsin1988/rt-app/domain/user"
    ai_chat "konsin1988/rt-app/domain/ai_chat"
    
    "github.com/99designs/gqlgen/graphql/handler"
    "github.com/99designs/gqlgen/graphql/playground"

)

func main() {
  db, err := config.ConnectDB()
  if err != nil{
    log.Fatal(err)
  }
  defer db.Close()

  bitrixURL := os.Getenv("BITRIX24_URL")

  userRepo := repos.NewPostgresRepo(db)
  bitrixClient := bitrix.New(bitrixURL)
  userService := user.NewService(userRepo, bitrixClient) 
  chatService := ai_chat.NewService(userRepo)
  

  kc := config.LoadKeycloakConfig()
  jwks, err := jwt.LoadJWKS(kc.JWKSURL)
  if err != nil {
    log.Fatalf("Failed  to load JWKS: %v", err)
  }

  validator := jwt.NewValidator(jwks, kc.Issuer, kc.ClientID)
  jwtService := jwt.NewService(validator)
  jwtMiddleware := jwt.Middleware(jwtService, userService)

  resolver := graph.NewResolver(userService, chatService)
  schema := graph.NewExecutableSchema(graph.Config{Resolvers: resolver})
  graphqlHandler := handler.NewDefaultServer(schema)



  authRepo := keycloak_repo.NewAuthRepository(
    kc.TokenURL,
    kc.ClientID,
    kc.ClientSecret,
    kc.LogoutURL,
  )

  authService := keycloak.NewService(authRepo)
  authHandler := transport.NewAuthHandler(authService)


  healthRepo := infraDB.NewHealthRepository(db)
  healthService := health.NewService(healthRepo) 
  healthHandler := transport.NewHealthHandler(healthService)

  mux := http.NewServeMux()
  mux.Handle("/health", healthHandler)
  mux.Handle("/playground", playground.Handler("GraphQL", "/graphql"))
  mux.HandleFunc("/auth/login", authHandler.Login)
  mux.HandleFunc("/auth/refresh", authHandler.Refresh)
  mux.HandleFunc("/auth/logout", authHandler.Logout)
  mux.Handle("/graphql", jwtMiddleware(graphqlHandler))

  log.Println("Server started on :8000")
  log.Fatal(http.ListenAndServe(":8000", mux))
}

