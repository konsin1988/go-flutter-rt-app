class PostQueries {
  static const String getPostsQuery = r'''
    query GetPosts {
      posts {
	id 
	title 
	html
	slug
	feature_image
      }
    }
  ''';
}
