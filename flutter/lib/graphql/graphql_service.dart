import 'package:graphql_flutter/graphql_flutter.dart';

import '../utils/constants.dart';
import '../../auth/token_storage.dart';
import 'cache/hive_store.dart';

class GraphQLService {
  static final GraphQLService _instance = GraphQLService._internal();
  factory GraphQLService() => _instance;
  GraphQLService._internal();

  late GraphQLClient client;

  Future<void> init() async {
    await initHiveForFlutter();

    final AuthLink authLink = AuthLink(
      getToken: () async {
	final token = TokenStorage().accessToken;
	if (token == null) return null; 
	return 'Bearer $token';
      },
    );

    final Link link = authLink.concat(HttpLink(AppLinks.graphqlURL));

    client = GraphQLClient(
      cache: GraphQLCache(store: HiveStoreFactory.create()),
      link: link,
    );
  }

  void clearCache() {
    client.cache.store.reset();
  }

}
