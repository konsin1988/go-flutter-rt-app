package main

import (
    "net/http"
    "log"
    _ "os"

    "konsin1988/rt-app/config"
    health "konsin1988/rt-app/db/health"
    transport "konsin1988/rt-app/transport/http"
    keycloak "konsin1988/rt-app/auth/keycloak"
    _ "konsin1988/rt-app/services/bitrix"
    jwt "konsin1988/rt-app/auth/jwt"
    graph "konsin1988/rt-app/graph"
    user "konsin1988/rt-app/db/user"
    ai "konsin1988/rt-app/db/ai"
    dept "konsin1988/rt-app/db/department"
    redis "konsin1988/rt-app/db/redis"
    
    _ "github.com/99designs/gqlgen/graphql/handler"
    "github.com/99designs/gqlgen/graphql/playground"

)

func main() {
  db, err := config.ConnectDB()
  if err != nil{
    log.Fatal(err)
  }
  defer db.Close()

  redisClient, err := redis.NewRedisClient()
  if err != nil {
    log.Fatal(err)
  }
  redisCache := redis.NewRedisCache(redisClient.Client)
  
  kc := config.LoadKeycloakConfig()
  jwks, err := jwt.LoadJWKS(kc.JWKSURL)
  if err != nil {
    log.Fatalf("Failed  to load JWKS: %v", err)
  }

  //bitrixURL := os.Getenv("BITRIX24_URL")
  //bitrixClient := bitrix.New(bitrixURL)

  // repos
  authRepo := keycloak.NewAuthRepository(
    kc.TokenURL,
    kc.ClientID,
    kc.ClientSecret,
    kc.LogoutURL,
  )
  healthRepo := health.NewHealthRepository(db)
  userRepo := user.NewUserRepo(db)
  aiRepo := ai.NewAiRepo(db)
  deptRepo := dept.NewDeptRepo(db)

  // svc
  authService := keycloak.NewService(authRepo)
  healthService := health.NewService(healthRepo) 
  userService := user.NewService(userRepo) 
  aiService := ai.NewService(aiRepo, redisCache)
  deptService := dept.NewService(deptRepo)
  

  validator := jwt.NewValidator(jwks, kc.Issuer, kc.ClientID)
  jwtService := jwt.NewService(validator)
  jwtMiddleware := jwt.Middleware(jwtService, userService)
  

  // GraphQL
  resolver := graph.NewResolver(userService, aiService, deptService)
  //schema := graph.NewExecutableSchema(graph.Config{Resolvers: resolver})
  //graphqlHandler := handler.NewDefaultServer(schema)
  graphqlHandler := transport.NewGraphQLHandler(
    resolver,
    jwtService,
    userService,
  )


  authHandler := transport.NewAuthHandler(authService)
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

