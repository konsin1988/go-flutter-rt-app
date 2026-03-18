import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../graphql/graphql_service.dart';
import 'package:rt_app/features/user/state/user_provider.dart';
import 'package:rt_app/features/user/data/user_repository.dart';
import 'package:rt_app/features/posts/state/post_provider.dart';
import 'package:rt_app/features/posts/data/post_repository.dart';
import 'package:rt_app/features/ai/state/ai_provider.dart';
import 'package:rt_app/features/ai/data/ai_repo.dart';

import 'package:rt_app/features/absence/state/absence_provider.dart';
import 'package:rt_app/features/absence/data/absence_repo.dart';

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
    ChangeNotifierProvider(
      create: (_) => AiProvider(
        AiRepository(context.read<GraphQLClient>()),
      ),
    ),
    ChangeNotifierProvider(
      create: (_) => AbsenceProvider(
        AbsenceRepository(context.read<GraphQLClient>()),
      ),
    ),
  ];
}

