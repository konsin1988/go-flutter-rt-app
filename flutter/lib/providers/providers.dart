import 'package:provider/provider.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../auth/auth_provider.dart';
import '../../features/user/state/user_provider.dart';
import '../../graphql/graphql_service.dart';
import '../../features/user/data/user_repository.dart';
import '../../features/posts/state/post_provider.dart';
import '../../features/posts/data/post_repository.dart';

final appProviders = [
  ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
  Provider<GraphQLClient>.value(value: GraphQLService().client),
  ChangeNotifierProvider<UserProvider>(
    create: (context) => UserProvider(
      UserRepository(context.read<GraphQLClient>()),
    ),
    lazy: false,
  ),
  ChangeNotifierProvider<PostProvider>(
    create: (context) => PostProvider(
      PostRepository(context.read<GraphQLClient>()),
    ),
    lazy: false,
  ),
];
