package texx 

func GetPostsForMainPage() ([]TexxPost, error) {
    posts, err := FetchTexxPosts()
    if err != nil {
        return nil, err
    }

    // optional: filter, limit, sort posts
    // e.g., return only latest 10 posts
    if len(posts) > 20 {
        posts = posts[:20]
    }

    return posts, nil
}
