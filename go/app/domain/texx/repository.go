package texx 

import (
    "encoding/json"
    "io/ioutil"
    "net/http"
    "os"
)

func FetchTexxPosts() ([]TexxPost, error) {
    TEXX_URL := os.Getenv("TEXX_URL")

    resp, err := http.Get(TEXX_URL)
    if err != nil {
        return nil, err
    }
    defer resp.Body.Close()

    body, _ := ioutil.ReadAll(resp.Body)
    var texxResp TexxPostResponse
    if err := json.Unmarshal(body, &texxResp); err != nil {
        return nil, err
    }
    return texxResp.Posts, nil
}

