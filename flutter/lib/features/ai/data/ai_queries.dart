class AiQueries {

  // Conversation list
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

  // Conversation By ID
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

  // Create Message
  static const String createMessage = r'''
    mutation CreateMessage($ConversationId: Int, $content: String!){
      createMessage(conversationId: $conversationId, content: $content) {
	id
	conversationId
	role
	content
	createdAt
      }
    }
  ''';
}

