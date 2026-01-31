import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rt_app/utils/constants.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'app/app_router.dart';
import 'package:provider/provider.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../graphql/graphql_service.dart';
import '../../auth/auth_provider.dart';
import '../../style/colors.dart';
import '../../style/fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  
  final authProvider = AuthProvider();
  await authProvider.init();
  await GraphQLService().init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        Provider<GraphQLClient>.value(value: GraphQLService().client),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: createAppRouter(context),
      title: 'РТ-ТЕХПРИЕМКА',
    );
  }
}


