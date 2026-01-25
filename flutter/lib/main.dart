import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rt_app/utils/constants.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'app/app_router.dart';
import 'package:provider/provider.dart';

import '../../auth/auth_provider.dart';
import '../../style/colors.dart';
import '../../style/fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  runApp(
    ChangeNotifierProvider<AuthProvider>.value(
    value: authProvider,
    child: const MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      title: 'РТ-ТЕХПРИЕМКА',
    );
  }
}

