class PostQueries {
  static const String getPostsQuery = r'''
    query GetPosts {
      texxPosts {
	DocumentId
   	Title
   	Link
   	PublishedAt
   	PreviewImage
   	PostText
      }
    }
  ''';
}
