package http

import (
  "net/http"

  "github.com/99designs/gqlgen/graphql/handler"
  "github.com/99designs/gqlgen/graphql/playground"
  "github.com/99designs/gqlgen/graphql/handler/transport"
  //"github.com/gorilla/websocket"

  "konsin1988/rt-app/graph"
  jwt "konsin1988/rt-app/auth/jwt"
  user "konsin1988/rt-app/db/user"
)

func NewGraphQLHandler(
    resolver *graph.Resolver,
    jwtService *jwt.Service,
    userService *user.Service,
) http.Handler {

    srv := handler.New(
        graph.NewExecutableSchema(
            graph.Config{Resolvers: resolver},
        ),
    )

    // HTTP transports
    srv.AddTransport(transport.Options{})
    srv.AddTransport(transport.GET{})
    srv.AddTransport(transport.POST{})

    // WebSocket transport
    srv.AddTransport(NewWebsocketTransport(jwtService, userService))

    return srv
}

func PlaygroundHandler() http.Handler {
  return playground.Handler("GraphQL", "graphql")
}
