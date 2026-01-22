import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home/home_page.dart';
import '../screens/ai/ai_page.dart';
import '../screens/services/services_page.dart';
import '../screens/profile/profile_page.dart';
import '../screens/init/init_page.dart';
import '../utils/constants.dart';
import '../widgets/bottom_nav_scaffold.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.init,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return BottomNavScaffold(navigationShell: navigationShell);
      },
      branches: [
	StatefulShellBranch(
	  routes: [
	    GoRoute(
	      path: AppRoutes.home,
	      builder: (context, state) => const HomePage(),
	    ),
	  ],
	),
	StatefulShellBranch(
	  routes: [
	    GoRoute(
	      path: AppRoutes.ai,
	      builder: (context, state) => const AIPage(),
	    ),
	  ],
	),
	StatefulShellBranch(
	  routes: [
	    GoRoute(
	      path: AppRoutes.services,
	      builder: (context, state) => const ServicesPage(),
	    ),
	  ],
	),
	StatefulShellBranch(
	  routes: [
	    GoRoute(
	      path: AppRoutes.profile,
	      builder: (context, state) => const ProfilePage(),
	    ),
	  ],
	),
      ],
    ),
  ],
);

