class Post {
  final String DocumentId;
  final String Title;
  final String Link;
  final String PublishedAt;
  final String PreviewImage;
  final String PostText;

  Post ({
    required this.DocumentId,
    required this.Title,
    required this.Link,	
    required this.PublishedAt,
    required this.PreviewImage,
    required this.PostText,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      DocumentId: json['DocumentId'] as String,
      Title: json['Title'] as String,
      Link: json['Link'] as String,
      PublishedAt: json['PublishedAt'] as String,
      PreviewImage: json['PreviewImage'] as String,
      PostText: json['PostText'] as String,
    );
  }
}
