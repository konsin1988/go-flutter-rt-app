package config 

import (
  "fmt"
  "os"
)

type KeycloakConfig struct {
  Realm		  string
  ClientID	  string
  ClientSecret	  string
  TokenURL	  string
  JWKSURL	  string
  Issuer	  string
  LogoutURL	  string
}

func LoadKeycloakConfig() KeycloakConfig {
  realm := os.Getenv("KC_REALM") 
  baseURL := os.Getenv("KC_BASEURL") 

  return KeycloakConfig{
    Realm: realm,
    ClientID: os.Getenv("KC_CLIENT_ID"),
    ClientSecret: os.Getenv("KC_CLIENT_SECRET"),
    TokenURL: fmt.Sprintf(
      "%s/realms/%s/protocol/openid-connect/token",
      baseURL, realm,
    ),
    JWKSURL:  fmt.Sprintf(
      "%s/realms/%s/protocol/openid-connect/certs",
      baseURL, realm,
    ),
    Issuer: fmt.Sprintf(
      "%s/realms/%s", baseURL, realm,
    ),
    LogoutURL:  fmt.Sprintf(
      "%s/realms/%s/protocol/openid-connect/logout",
      baseURL, realm,
    ),
  }
}
