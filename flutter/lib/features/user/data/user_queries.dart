class UserQueries {
  static const String mainUser = r'''
    query mainUser {
      mainUser {
	id
	lastName
	firstName
	secondName
        email
	birthday	
	photoURL
	mobile	
	inner
	position
	deptList {
	  id
	  name
	  parent
	  head
	}
	headList {
	  id
	  fio
	}
      }
    }
  ''';

  static const String userById = r'''
    query userById($id: Int!){
      userById(user_id: $id) {
	id
	lastName
	firstName
	secondName
        email
	birthday	
	photoURL
	mobile	
	inner
	position
	deptList {
	  id
	  name
	  parent
	  head
	}
	headList {
	  id
	  fio
	}
      }
    }
  ''';
}

