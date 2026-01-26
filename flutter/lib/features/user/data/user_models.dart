class User {
  final String login;
  final String email;
  final String? about;
  final String? avatarImageUrl;
  final String? displayName;

  User({
    required this.login,
    required this.email,
    this.about,
    this.avatarImageUrl,
    this.displayName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      login: json['login'] as String,
      email: json['email'] as String,
      about: json['about'] as String?,
      avatarImageUrl: json['avatarImageUrl'] as String?,
      displayName: json['displayName'] as String?,
    );
  }
}

