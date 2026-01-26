import 'package:graphql_flutter/graphql_flutter.dart';

import 'post_queries.dart';
import 'post_models.dart';


class PostRepository {
  final GraphQLClient _client;

  PostRepository(this._client);

  Future<List<Post>> getPosts() async {
    final result = await _client.query(
      QueryOptions(
        document: gql(PostQueries.getPostsQuery),
        fetchPolicy: FetchPolicy.networkOnly, // optional, but recommended
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final data = result.data;
    if (data == null || data['posts'] == null) {
      return [];
    }

    final List postsJson = data['posts'] as List;

    return postsJson
        .map(
          (json) => Post.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }
}

