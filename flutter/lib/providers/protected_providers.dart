import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../graphql/graphql_service.dart';
import '../../features/user/state/user_provider.dart';
import '../../features/user/data/user_repository.dart';
import '../../features/posts/state/post_provider.dart';
import '../../features/posts/data/post_repository.dart';

List<SingleChildWidget> protectedProviders(BuildContext context) {
  return [
    ChangeNotifierProvider(
      create: (_) => UserProvider(
        UserRepository(context.read<GraphQLClient>()),
      ),
    ),
    ChangeNotifierProvider(
      create: (_) => PostProvider(
        PostRepository(context.read<GraphQLClient>()),
      ),
    ),
  ];
}

