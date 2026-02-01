class UserQueries {
  static const String me = r'''
    query Me {
      me {
        email
	lastName
	firstName
	secondName
	wphone
	phone
	birthday	
	dept	
	head	
      }
    }
  ''';
}

