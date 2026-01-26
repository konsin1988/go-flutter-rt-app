class UserQueries {
  static const String me = r'''
    query Me {
      me {
        login
        email
        about
        avatarImageUrl
        displayName
      }
    }
  ''';
}

