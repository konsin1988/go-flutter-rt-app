import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'absence_queries.dart';
import 'absence_models.dart';

class AbsenceRepository {
  final GraphQLClient _client;

  AbsenceRepository(this._client);

  Future<Absence> createAbsenceData({
    required String prompt,
    }) async {
    final result = await _client.mutate(
      MutationOptions(
	document: gql(AbsenceQueries.createAbsenceData),
	variables: {
	  'prompt': prompt,
	},
        fetchPolicy: FetchPolicy.networkOnly,
    ));
    debugPrint("RESULT FROM GO: ${result}");

    if (result.hasException) {
      debugPrint("${result.exception}");
      throw result.exception!;
    }

    final data = result.data!['createAbsenceData'];
    return Absence.fromJson(data);
  }
}
