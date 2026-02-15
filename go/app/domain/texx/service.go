package texx 

func GetPostsForMainPage() ([]TexxPost, error) {
    posts, err := FetchTexxPosts()
    if err != nil {
        return nil, err
    }
    if len(posts) > 20 {
        posts = posts[:20]
    }

    return posts, nil
}
