class DeptQueries {
  static const String deptById = r'''
    query DeptById($id: Int!) {
      GetDeptById(dept_id: $id) {
	id
    	name
    	parent
    	parentName
    	head
    	headFIO
    	deptUserList {
	  id
  	  fio
  	  position
  	  photoURL
	}
      }
    }
  ''';
}

