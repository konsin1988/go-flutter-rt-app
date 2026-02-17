import 'package:rt_app/features/user/data/user_models.dart';

class Department {
  final int id;
  final String name;
  final int parent;
  final int head;

  Department({
    required this.id,
    required this.name,
    required this.parent,
    required this.head,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] as int,
      name: json['name'] as String,
      parent: json['parent'] as int,
      head: json['head'] as int,
    );
  }
}


class DeptUser {
  final int id;
  final String fio;
  final String? position;
  final String? photoURL;
  
  DeptUser({
    required this.id,
    required this.fio,
    this.position,
    this.photoURL,
  });
  
  factory DeptUser.fromJson(Map<String, dynamic> json) {
    return DeptUser(
      id: json['id'] as int,
      fio: json['fio'] as String,
      position: json['position'] as String?,
      photoURL: json['photoURL'] as String?,
    );
  }
}

class DeptById {
  final int id;
  final String name;
  final int? parent;
  final String? parent_name;
  final int? head;
  final String? head_fio;

  final List<DeptUser> deptUsers;
  
  DeptById({
    required this.id,
    required this.name,
    this.parent,
    this.parent_name,
    this.head,
    this.head_fio,
    required this.deptUsers,
  });

  factory DeptById.fromJson(Map<String, dynamic> json) {
    return DeptById(
      id: json['id'] as int,
      name: json['name'] as String,
      parent: json['parent'] as int?,
      parent_name: json['parentName'] as String?,
      head: json['head'] as int?,
      head_fio: json['headFIO'] as String?,
      
      deptUsers: (json['deptUserList'] as List?)
	  ?.map((e) => DeptUser.fromJson(e as Map<String, dynamic>))
	  .toList() ?? <DeptUser>[],
    );
  }
}
