package post

func GetPostsForMainPage() ([]GhostPost, error) {
    posts, err := FetchGhostPosts()
    if err != nil {
        return nil, err
    }

    // optional: filter, limit, sort posts
    // e.g., return only latest 10 posts
    if len(posts) > 10 {
        posts = posts[:10]
    }

    return posts, nil
}
