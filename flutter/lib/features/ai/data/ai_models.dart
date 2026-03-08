class Message {
  final int ID;
  final int ConversationID;
  final String Role;
  final String Content;
  final DateTime CreatedAt;
  
  Message({
    required this.ID,
    required this.ConversationID,
    required this.Role,
    required this.Content,
    required this.CreatedAt,
  });
  
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      ID: json['id'] as int,
      ConversationID: json['conversationId'] as int,
      Role: json['role'] as String,
      Content: json['content'] as String,
      CreatedAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  String toString() => 
      'Message(id: $ID, role: $Role, content: "${Content.substring(0, Content.length.clamp(0, 50))}..."';
}

class Conversation {
  final int ID;
  final String Title;
  final DateTime CreatedAt;
  final DateTime UpdatedAt;
  final List<Message> Messages;

  Conversation({
    required this.ID,
    required this.Title,
    required this.CreatedAt,
    required this.UpdatedAt,
    required this.Messages,
  });

  factory Conversation.fromJson(Map<String, dynamic> json){
    final messagesJson = json['messages'] as List?;
    final List<Message> messages = (messagesJson ?? [])
        .map((m) => Message.fromJson(m as Map<String, dynamic>))
        .toList();

    messages.sort((a, b) => a.ID.compareTo(b.ID));

    return Conversation(
      ID: json['id'] as int,
      Title: json['title'] as String,
      CreatedAt: DateTime.parse(json['createdAt'] as String),
      UpdatedAt: DateTime.parse(json['updatedAt'] as String),
      Messages: messages,
     // Messages: (json['messages'] as List)
     //   ?.map((m) => Message.fromJson(m as Map<String,dynamic>))
     //   .toList() ?? [],
    );
  }

  @override
  String toString() => 
      'Conversation(id: $ID, title: "$Title", messages: $Messages)';
}


class ConversationListItem {
  final int ID;
  final String Title;
  final DateTime CreatedAt;
  final DateTime UpdatedAt;
  
  ConversationListItem({
    required this.ID,
    required this.Title,
    required this.CreatedAt,
    required this.UpdatedAt,
  });
  
  factory ConversationListItem.fromJson(Map<String, dynamic> json) {
    return ConversationListItem(
      ID: json['id'] as int,
      Title: json['title'] as String,
      CreatedAt: DateTime.parse(json['createdAt']),
      UpdatedAt: DateTime.parse(json['updatedAt']), 
    );
  }
}
