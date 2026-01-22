import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rt_app/utils/constants.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
//import 'app/main_screen.dart';
import 'app/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initConstants();
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      title: 'Flutter GoRouter Example',
    );
  }
}

