import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../screens/login/login_page.dart';
import '../providers/protected_providers.dart';
import '../auth/auth_provider.dart';
import '../auth/auth_state.dart';

import '../screens/home/home_page.dart';
import '../screens/ai/ai_page.dart';
import '../screens/services/services_page.dart';
import '../screens/profile/profile_page.dart';
import '../screens/init/init_page.dart';
import '../screens/assistant/assistant_page.dart';
import '../utils/constants.dart';
import '../widgets/bottom_nav_scaffold.dart';

GoRouter createAppRouter(BuildContext context) {
  final authProvider = context.read<AuthProvider>();

  return GoRouter(
    initialLocation: AppRoutes.init,
    refreshListenable: authProvider,
    
    redirect: (context, state) {
      final status = authProvider.status;
      final currentPath = state.uri.path; 

      if (status == AuthStatus.unauthenticated){
	return AppRoutes.login;
      }
  
      if (status == AuthStatus.unknown) {
        return null;
      }
  
      if (status == AuthStatus.authenticated && currentPath == AppRoutes.login) {
        return AppRoutes.home;
      }
      return null;
    },
  
    routes: [
      GoRoute(
        path: AppRoutes.init,
        builder: (context, state) => const InitPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BottomNavScaffold(navigationShell: navigationShell);
        },
        branches: [
  	StatefulShellBranch(
  	  routes: [
  	    GoRoute(
  	      path: AppRoutes.home,
  	      builder: (context, state) { 
  		return MultiProvider(
  		  providers: protectedProviders(context),
  		  child: const HomePage(),
  		);
  	      }
  	    ),
  	  ],
  	),
  	StatefulShellBranch(
  	  routes: [
  	    GoRoute(
  	      path: AppRoutes.ai,
  	      builder: (context, state) { 
  		return MultiProvider(
  		  providers: protectedProviders(context),
  		  child: const AIPage(),
  		);
  	      }
  	    ),
  	  ],
  	),
  	StatefulShellBranch(
  	  routes: [
  	    GoRoute(
  	      path: AppRoutes.services,
  	      builder: (context, state) { 
  		return MultiProvider(
  		  providers: protectedProviders(context),
  		  child: const ServicesPage(),
  		);
  	      }
  	    ),
  	  ],
  	),
  	StatefulShellBranch(
  	  routes: [
  	    GoRoute(
  	      path: AppRoutes.profile,
  	      builder: (context, state) { 
  		return MultiProvider(
  		  providers: protectedProviders(context),
  		  child: const ProfilePage(),
  		);
  	      }
  	    ),
  	  ],
  	),
  	StatefulShellBranch(
  	  routes: [
  	    GoRoute(
  	      path: AppRoutes.assistant,
	      pageBuilder: (context, state) {
	        return NoTransitionPage(
      	          child: MultiProvider(
      	            providers: protectedProviders(context),
      	            child: const AssistantPage(),
      	          ),
      	        );
      	      },
  	    ),
  	  ],
  	),
        ],
      ),
    ],
  );
}
