import 'package:rt_app/features/department/data/dept_models.dart';

class User {
  final int id;
  final String lastName;
  final String firstName;
  final String secondName;
  final String email;
  final String? mobile;
  final String? inner;
  final String? position;
  final String? birthday;
  final String? photoURL;
  
  final List<Department> deptList;
  final List<Head> headList;

  User({
    required this.id,
    required this.email,
    required this.lastName,
    required this.firstName,
    required this.secondName,
    required this.deptList,
    required this.headList,
    this.position,
    this.mobile,
    this.inner,
    this.birthday,
    this.photoURL,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      lastName: json['lastName'] as String,
      firstName: json['firstName'] as String,
      secondName: json['secondName'] as String,
      mobile: json['mobile'] as String?,
      inner: json['inner'] as String?,
      birthday: json['birthday'] as String?,
      position: json['position'] as String?,
      photoURL: json['photoURL'] as String?,
      deptList: (json['deptList'] as List?)
	  ?.map((e) => Department.fromJson(e as Map<String, dynamic>))
	  .toList() ?? <Department>[],
      headList: (json['headList'] as List?)
	?.map((e) => Head.fromJson(e as Map<String, dynamic>))
	.toList() ?? <Head>[],
    );
  }
}


class Head {
  final int id;
  final String fio;

  Head({
    required this.id,
    required this.fio,
  });

  factory Head.fromJson(Map<String, dynamic> json) {
    return Head(
      id: json['id'] as int,
      fio: json['fio'] as String,
    );
  }
}

