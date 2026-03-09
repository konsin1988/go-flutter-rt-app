import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';

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

    //final Link link = authLink.concat(HttpLink(AppLinks.graphqlURL));
    final HttpLink httpLink = HttpLink(AppLinks.graphqlURL);

    final WebSocketLink wsLink = WebSocketLink(
      "ws://192.168.3.31:8000/graphql",
      config: SocketClientConfig(
        autoReconnect: true,
        inactivityTimeout: Duration(seconds: 30),
        initialPayload: () async {
          //final token = TokenStorage().accessToken;
          //if (token == null) return {};
	  String? token;
	  while ((token = TokenStorage().accessToken) == null) {
	    await Future.delayed(Duration(milliseconds: 50));
  	  }
          return {
            "Authorization": "Bearer ${token}",
          };
        },
      ),
    );

    final Link link = Link.split(
      (request) => request.isSubscription,
      wsLink,
      authLink.concat(httpLink),
    );

    client = GraphQLClient(
      cache: GraphQLCache(store: HiveStoreFactory.create()),
      link: link,
    );
  }

  void clearCache() {
    client.cache.store.reset();
  }
}
