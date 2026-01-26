package post

import (
    "encoding/json"
    "io/ioutil"
    "net/http"
    "os"
    "fmt"
)

func FetchGhostPosts() ([]GhostPost, error) {
    GHOST_URL := os.Getenv("GHOST_URL")
    GHOST_CONTENT_API_KEY := os.Getenv("GHOST_CONTENT_API_KEY")

    url := fmt.Sprintf(`%s/ghost/api/content/posts/?key=%s`, GHOST_URL, GHOST_CONTENT_API_KEY)
    resp, err := http.Get(url)
    if err != nil {
        return nil, err
    }
    defer resp.Body.Close()

    body, _ := ioutil.ReadAll(resp.Body)
    var ghostResp GhostPostResponse
    if err := json.Unmarshal(body, &ghostResp); err != nil {
        return nil, err
    }
    return ghostResp.Posts, nil
}

