class AiQueries {
  static const String ConversationList = r'''
    query ConversationList {
      ConversationList {
	id
	title	
	createdAt	
	updatedAt	
      }
    }
  ''';

  static const String ConversationById = r'''
    query GetConversationById($id: Int!) {
      ConversationById(id: $id) {
	id
	title
	createdAt
	updatedAt
	messages(limit: 50) {
	  id
	  conversationId
	  role
	  content
	  createdAt
	}
      }
    }
  ''';
}

