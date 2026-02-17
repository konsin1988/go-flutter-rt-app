import 'package:graphql_flutter/graphql_flutter.dart';

import 'user_queries.dart';
import 'user_models.dart';

class UserRepository {
  final GraphQLClient _client;

  UserRepository(this._client);

  Future<User?> getMe() async {
    final result = await _client.query(
      QueryOptions(
        document: gql(UserQueries.mainUser),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    final data = result.data?['mainUser'];
    if (data == null) return null;

    return User.fromJson(data);
  }

  Future<User> userById(int user_id) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(UserQueries.userById),
	variables: {
	  'id': user_id,
	},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    final data = result.data?['userById'];
    if (data == null) { 
      throw Exception('Department not found');
    };

    return User.fromJson(data);
  }
}

