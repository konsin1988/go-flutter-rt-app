import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';

import 'dept_queries.dart';
import 'dept_models.dart';

class DeptRepository {
  final GraphQLClient _client;

  DeptRepository(this._client);

  Future<DeptById> getDeptById(int id) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(DeptQueries.deptById),
	variables: {
	  'id': id
	},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    final data = result.data?['GetDeptById'];
    if (data == null) {
      throw Exception('Department not found');
    }

    return DeptById.fromJson(data);
  }
}

