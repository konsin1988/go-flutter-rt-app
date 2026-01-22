package http

import (
  "net/http"

  "github.com/99designs/gqlgen/graphql/handler"
  "github.com/99designs/gqlgen/graphql/playground"

  "konsin1988/rt-app/graph"
)

func NewGraphQLHandler(resolver *graph.Resolver) http.Handler{
  srv := handler.NewDefaultServer(
    graph.NewExecutableSchema(
      graph.Config{Resolvers: resolver},
    ),
  )
  return srv
}

func PlaygroundHandler() http.Handler {
  return playground.Handler("GraphQL", "graphql")
}
