class Post {
  final String id;
  final String title;
  final String html;
  final String slug;
  final String featureImage;

  Post ({
    required this.id,
    required this.title,
    required this.html,
    required this.slug,
    required this.featureImage,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      title: json['title'] as String,
      html: json['html'] as String,
      slug: json['slug'] as String,
      featureImage: json['feature_image'] as String,
    );
  }
}
