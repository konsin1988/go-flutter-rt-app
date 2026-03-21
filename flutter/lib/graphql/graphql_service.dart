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

    final HttpLink httpLink = HttpLink(AppLinks.graphqlURL);

    final WebSocketLink wsLink = WebSocketLink(
      AppLinks.graphqlWS,
      config: SocketClientConfig(
        autoReconnect: true,
        //inactivityTimeout: Duration(seconds: 30), 
        inactivityTimeout: null, 
	delayBetweenReconnectionAttempts: const Duration(seconds: 1),  
	queryAndMutationTimeout: const Duration(seconds: 45),
        initialPayload: () async {
	  String? token;
	  int attempts = 0;
	  while ((token = TokenStorage().accessToken) == null && attempts < 20) {
  	    await Future.delayed(Duration(milliseconds: 50));
  	    attempts++;
  	  }
  	  
  	  print('WS Token: ${token?.substring(0, 20)}...'); 
  	  print('Token length: ${token?.length ?? 0}');
    
  	  if (token == null) {
  	    print('NO TOKEN IN STORAGE!');
  	    return null; 
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
    //final Link link = Link.split(
    //  (request) {
    //    final doc = request.document;
    //    if (doc == null) return false;
    //    
    //    // Parse operation type from document definitions
    //    for (final def in doc.definitions) {
    //      if (def is OperationDefinitionNode) {
    //        return def.type == OperationType.subscription;
    //      }
    //    }
    //    return false;
    //  },
    //  wsLink,
    //  authLink.concat(httpLink),
    //);

    client = GraphQLClient(
      cache: GraphQLCache(store: HiveStoreFactory.create()),
      link: link,
    );
  }

  void clearCache() {
    client.cache.store.reset();
  }
}
