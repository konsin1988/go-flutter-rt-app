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

class DepartmentById {
  final int id;
  final String name;
  final int parent;
  final String parent_name;
  final int head;
  final String head_fio;

  final List<DepartmentUser> deptUsers;
  
  DepartmentById({
    required this.id,
    required this.name,
    required this.parent,
    required this.parent_name,
    required this.head,
    required this.head_fio,
    required this.deptUsers,
  });

  factory DepartmentById.fromJson(Map<String, dynamic> json) {
    return DepartmentById(
      id: json['id'] as int,
      name: json['name'] as String,
      parent: json['parent'] as int,
      parent_name: json['parent_name'] as String,
      head: json['head'] as int,
      head_fio: json['head_fio'] as String,
      
      deptUsers: (json['dept_users'] as List?)
	  ?.map((e) => DepartmentUser.fromJson(e as Map<String, dynamic>))
	  .toList() ?? <DepartmentUser>[],
    );
  }
}
