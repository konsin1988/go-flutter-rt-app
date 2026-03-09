import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';

import 'ai_queries.dart';
import 'ai_models.dart';

class AiRepository {
  final GraphQLClient _client;

  AiRepository(this._client);

  // Conversation by ID
  Future<Conversation> conversationById(int id) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(AiQueries.ConversationById),
	variables: {'id': id },
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      debugPrint('GraphQL error: ${result.exception}');
      throw result.exception!;
    }

    final data = result.data;
    if (data == null || data['ConversationById'] == null) {
      throw Exception('Conversation not found');
    }
    return Conversation.fromJson(data['ConversationById'] as Map<String, dynamic>);
  }


  // Conversation List
  Future<List<ConversationListItem>> ConversationList() async {
    final result = await _client.query(
      QueryOptions(
        document: gql(AiQueries.ConversationList),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );


    if (result.hasException) {
      throw result.exception!;
    }

    final data = result.data;
    if (data == null || data['ConversationList'] == null) return [];

    final List ConversationsJson = data['ConversationList'] as List;

    return ConversationsJson
        .map(
          (json) => ConversationListItem.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  Future<Message> createMessage({
    required int? conversationId, 
    required String content,
    }) async {
    final result = await _client.mutate(
      MutationOptions(
	document: gql(AiQueries.createMessage),
	variables: {
	  'conversationId': conversationId,
	  'content': content,
	},
      ), 
    );

    if (result.hasException) {
      throw result.exception!;
    }

    final data = result.data!['createMessage'];
    return Message.fromJson(data);
  }

  // messageStream
  Stream<QueryResult> messageStream({
    required int messageId,
    required int conversationId,
  }) {
    return _client.subscribe(
      SubscriptionOptions(
        document: gql(AiQueries.messageStream),
        variables: {
          "messageId": messageId,
          "conversationId": conversationId,
        },
      ),
    );
  }
}
