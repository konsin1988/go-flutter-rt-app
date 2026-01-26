import 'package:graphql_flutter/graphql_flutter.dart';

import 'user_queries.dart';
import 'user_models.dart';

class UserRepository {
  final GraphQLClient _client;

  UserRepository(this._client);

  Future<User?> getMe() async {
    final result = await _client.query(
      QueryOptions(
        document: gql(UserQueries.me),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    final data = result.data?['me'];
    if (data == null) return null;

    return User.fromJson(data);
  }
}

