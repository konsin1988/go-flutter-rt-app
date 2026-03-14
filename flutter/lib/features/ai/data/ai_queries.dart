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
    mutation CreateMessage($conversationId: Int, $content: String!){
      createMessage(conversationId: $conversationId, content: $content) {
	id
	conversationId
	role
	content
	createdAt
      }
    }
  ''';

  // Delete Conversation 
  static const String deleteConversation = r'''
    mutation deleteConversation($conversationId: Int!){
      deleteConversation(conversationId: $conversationId) 
    }
  ''';

  // messageStream
  static const String messageStream = r'''
    subscription MessageStream($messageId: Int!, $conversationId: Int!) {
      messageStream(messageId: $messageId, conversationId: $conversationId) {
        chunk
        done
      }
    }
    ''';
}

