class DeptQueries {
  static const String ieptById = r'''
    query deptById {
      deptById {
	id
    	name
    	parent
    	parent_name
    	head
    	head_fio
    	deptUsers {
	  id;
  	  fio;
  	  position;
  	  photoURL;
	}
      }
    }
  ''';
}

