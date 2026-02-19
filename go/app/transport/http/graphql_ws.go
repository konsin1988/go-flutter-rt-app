package http

import (
    "context"
    "errors"
    "net/http"
    "strings"
    "time"

    "github.com/99designs/gqlgen/graphql/handler/transport"
    "github.com/gorilla/websocket"

    jwt "konsin1988/rt-app/auth/jwt"
    user "konsin1988/rt-app/db/user"
)

func NewWebsocketTransport(
    jwtService *jwt.Service,
    userService *user.Service,
) transport.Websocket {

    return transport.Websocket{
        Upgrader: websocket.Upgrader{
            CheckOrigin: func(r *http.Request) bool {
                return true // restrict in production
            },
        },
        KeepAlivePingInterval: 15 * time.Second,
  	  InitFunc: transport.WebsocketInitFunc(
	    func(ctx context.Context, initPayload transport.InitPayload) (context.Context, *transport.InitPayload, error) {
    	        authHeader, ok := initPayload["Authorization"].(string)
    	        if !ok {
    	            return ctx, nil, errors.New("missing Authorization token")
    	        }

    	        token := strings.TrimPrefix(authHeader, "Bearer ")

    	        authUser, err := jwtService.Authenticate(ctx, token)
    	        if err != nil {
    	            return ctx, nil, err
    	        }

    	        mainUser, err := userService.AuthUser(ctx, authUser.Email)
    	        if err != nil {
    	            return ctx, nil, err
    	        }

    	        ctx = context.WithValue(ctx, jwt.AuthUserContextKey, authUser)
    	        ctx = context.WithValue(ctx, jwt.MainUserContextKey, mainUser)

    	        return ctx, nil, nil
    	    },
	),
    }
}

