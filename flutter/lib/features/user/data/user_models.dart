class User {
  final String email;
  final String lastName;
  final String firstName;
  final String secondName;
  final String? wphone;
  final String? phone;
  final String? birthday;
  final String? dept;
  final String? head;
  final String? imageURL;

  User({
    required this.email,
    required this.lastName,
    required this.firstName,
    required this.secondName,
    this.wphone,
    this.phone,
    this.birthday,
    this.dept,
    this.head,
    this.imageURL,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String,
      lastName: json['lastName'] as String,
      firstName: json['firstName'] as String,
      secondName: json['secondName'] as String,
      wphone: json['wphone'] as String?,
      phone: json['phone'] as String?,
      birthday: json['birthday'] as String?,
      dept: json['dept'] as String?,
      head: json['head'] as String?,
      imageURL: json['imageURL'] as String?,
    );
  }
}

