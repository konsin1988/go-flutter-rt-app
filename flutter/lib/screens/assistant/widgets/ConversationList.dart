import 'package:flutter/material.dart';

class ConversationList extends StatelessWidget {
  const ConversationList({super.key});

  @override
  Widget build(BuildContext context) {
    // Example mock conversation items
    final conversations = List.generate(
      10,
      (index) => 'Conversation ${index + 1}',
    );

    return SafeArea(
      child: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: conversations.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.chat),
            ),
            title: Text(conversations[index]),
            subtitle: const Text('Last message preview...'),
            onTap: () {
              // Close drawer when selecting a conversation
              Navigator.of(context).pop();
              // TODO: navigate to conversation chat
            },
          );
        },
      ),
    );
  }
}
