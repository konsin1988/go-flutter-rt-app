import 'package:intl/intl.dart';

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

  Message copyWith({
    int? ID,
    int? ConversationID,
    String? Role,
    String? Content,
    DateTime? CreatedAt,
  }) {
    return Message(
      ID: ID ?? this.ID,
      ConversationID: ConversationID ?? this.ConversationID,
      Role: Role ?? this.Role,
      Content: Content ?? this.Content,
      CreatedAt: CreatedAt ?? this.CreatedAt,
    );
  }
  
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      ID: json['id'] as int,
      ConversationID: json['conversationId'] as int,
      Role: json['role'] as String,
      Content: json['content'] as String,
      CreatedAt: DateTime.parse(json['createdAt'] as String),
    );
  }
  
  String _formatTime(DateTime date) {
    //final msk = dateDt.timeZoneName; 
    final dateDt = date.toLocal();
    final day = DateFormat('dd').format(dateDt);
    final month = _getMonth(dateDt.month);
    final year = DateFormat('yyyy').format(dateDt);
    final hour = DateFormat('HH').format(dateDt);
    final minute = DateFormat('mm').format(dateDt);
    return '$day $month $year $hour:$minute ';
  }

  String get CreatedAtFormatted => _formatTime(CreatedAt);

  static String _getMonth(int month) {
    const months = [
      '', 'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];
    return months[month];
  }

  @override
  String toString() => 
      'Message(id: $ID, role: $Role, content: "${Content.substring(0, Content.length.clamp(0, 50))}..."';
}

class Conversation {
  int ID;
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
  final int  IsPinned;
  
  ConversationListItem({
    required this.ID,
    required this.Title,
    required this.CreatedAt,
    required this.UpdatedAt,
    required this.IsPinned,
  });

  ConversationListItem copyWith({
    int? ID,
    String? Title,
    DateTime? CreatedAt,
    DateTime? UpdatedAt,
    int? IsPinned,
  }) {
    return ConversationListItem(
      ID: ID ?? this.ID,
      Title: Title ?? this.Title,
      CreatedAt: CreatedAt ?? this.CreatedAt,
      UpdatedAt: UpdatedAt ?? this.UpdatedAt,
      IsPinned: IsPinned ?? this.IsPinned,
    );
  }
  
  factory ConversationListItem.fromJson(Map<String, dynamic> json) {
    return ConversationListItem(
      ID: json['id'] as int,
      Title: json['title'] as String,
      CreatedAt: DateTime.parse(json['createdAt']),
      UpdatedAt: DateTime.parse(json['updatedAt']), 
      IsPinned: json['isPinned'] as int,
    );
  }
}
