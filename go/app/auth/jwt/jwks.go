package jwt 

import (
  "encoding/json"
  "net/http"
)

type JWK struct {
  KID	  string    `json:"kid"`
  KTY	  string    `json:"kty"`
  ALG	  string    `json:"alg"`
  Use	  string    `json:"use"`
  N	  string    `json:"n"`
  E	  string    `json:"e"`
}

type JWKS struct {
  Keys []JWK  `json:"keys"`
}

func LoadJWKS(jwksURL string) (*JWKS, error) {
  resp, err := http.Get(jwksURL)
  if err != nil {
    return nil, err
  }
  defer resp.Body.Close()

  var jwks JWKS 
  if err := json.NewDecoder(resp.Body).Decode(&jwks); err != nil {
    return nil, err
  }

  return &jwks, nil
}
