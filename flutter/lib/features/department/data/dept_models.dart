class Department {
  final int id;
  final String name;
  final int? parent;
  final int? head;

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
  final String? parentName;
  final int? head;
  final String? headFio;

  final List<DeptUser> deptUsers;
  final List<Department> childDeptList;
  
  DeptById({
    required this.id,
    required this.name,
    this.parent,
    this.parentName,
    this.head,
    this.headFio,
    required this.deptUsers,
    required this.childDeptList,
  });

  factory DeptById.fromJson(Map<String, dynamic> json) {
    return DeptById(
      id: json['id'] as int,
      name: json['name'] as String,
      //parent: json['parent'] as int?,
      parent: (json['parent'] as num?)?.toInt(),
      //parentName: json['parentName'] as String?,
      parentName: (json['parentName'] ?? json['parent_name']) as String?,
      head: json['head'] as int?,
      headFio: json['headFIO'] as String?,
      
      deptUsers: (json['deptUserList'] as List?)
	  ?.map((e) => DeptUser.fromJson(e as Map<String, dynamic>))
	  .toList() ?? <DeptUser>[],

      childDeptList: (json['childDeptList'] as List?)
	  ?.map((e) => Department.fromJson(e as Map<String, dynamic>))
	  .toList() ?? <Department>[],
    );
  }
}
