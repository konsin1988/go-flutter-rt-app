package jwt

type Claims struct {
  Sub	    string    `json:"sub"`
  Email	    string    `json:"email"`
  Username  string    `json:"preferred_username"`
  Roles	    []string  `json:"roles"`
  Issuer    string    `json:"iss"`
  Audience  string    `json:"aud"`
  Exp	    int64     `json:"exp"`
}

type User struct {
  ID	    string
  Email	    string
  Username  string
  Roles	    []string
}
