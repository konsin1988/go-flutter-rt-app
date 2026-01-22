package jwt

import (
  "crypto/rsa"
  "encoding/base64"
  "errors"
  "math/big"
  _ "log"

  "github.com/golang-jwt/jwt/v5"
)

type Validator struct {
  jwks	    *JWKS
  issuer    string
  aud	    string
}

func NewValidator (jwks *JWKS, issuer, aud string) *Validator {
  return &Validator{jwks: jwks, issuer: issuer, aud: aud}
}

func (v *Validator) Validate(tokenStr string) (*Claims, error){
  token, err := jwt.Parse(tokenStr, func(t *jwt.Token)(any, error) {
    kid, ok := t.Header["kid"].(string)
    if !ok {
      return nil, errors.New("missing kid in header")
    }

    key := v.findKey(kid)
    if key == nil {
      return nil, errors.New("unknown kid")
    }
    return key, nil
  })
  if err != nil || !token.Valid{
    return nil, errors.New("invalid Token")
  }

  claimsMap, ok := token.Claims.(jwt.MapClaims)
  if !ok {
    return nil, errors.New("invalid claims")
  }

  if claimsMap["iss"] != v.issuer {
    return nil, errors.New("invalid issuer")
  }

  user := &Claims{
    Sub:	claimsMap["sub"].(string),
    Email:	claimsMap["email"].(string),
    Username:	claimsMap["preferred_username"].(string),
  }

  if realmAccess, ok := claimsMap["realm_access"].(map[string]any); ok {
    if roles, ok := realmAccess["roles"].([]any); ok {
      for _, r := range roles {
	user.Roles = append(user.Roles, r.(string))
      }
    }
  }
  return user, nil
}

func (v *Validator) findKey(kid string) *rsa.PublicKey {
  for _, k := range v.jwks.Keys {
    if k.KID == kid {
      return rsaPublicKey(k)
    }
  }
  return nil
}

func rsaPublicKey(jwk JWK) *rsa.PublicKey {
  nBytes, _ := base64.RawURLEncoding.DecodeString(jwk.N)
  eBytes, _ := base64.RawURLEncoding.DecodeString(jwk.E)

  n := new(big.Int).SetBytes(nBytes)
  e := new(big.Int).SetBytes(eBytes).Int64()

  return &rsa.PublicKey{
    N: n,
    E: int(e),
  }
}


