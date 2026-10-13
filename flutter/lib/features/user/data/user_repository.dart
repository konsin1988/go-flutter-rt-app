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

  Future<User> userById(int userID) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(UserQueries.userById),
	      variables: {
	        'id': userID,
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
    }

    return User.fromJson(data);
  }

  Future<List<SearchUser>> getSearchUsers(String searchPath, int offset) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(UserQueries.getSearchUsers),
	      variables: {
	        'search_path': searchPath,
          'offset': offset,
	      },
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    final rawUsers = result.data?['GetSearchUsers'];
    if (rawUsers == null) {
      return [];
    }

    return (rawUsers as List<dynamic>)
      .map((json) => SearchUser.fromJson(json as Map<String, dynamic>))
      .toList();

  }
}

