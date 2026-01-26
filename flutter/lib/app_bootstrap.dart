import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app/app_router.dart';
import 'package:provider/provider.dart';
import '../../features/posts/state/post_provider.dart';
import '../../features/user/state/user_provider.dart';
import '../../auth/auth_provider.dart';


class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key});

  @override 
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap>{
  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //final auth = context.read<AuthProvider>();
      //if (auth.isAuthenticated) {
      context.read<UserProvider>().loadMe();
      context.read<PostProvider>().loadPosts();
      //}
    });
  }

  @override 
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      title: 'РТ-ТЕХПРИЕМКА',
    );
  }
}
