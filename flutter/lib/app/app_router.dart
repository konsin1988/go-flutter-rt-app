import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../screens/login/login_page.dart';
import '../providers/protected_providers.dart';
import '../auth/auth_provider.dart';
import '../auth/auth_state.dart';
import '../../widgets/app_top_bar.dart';
import 'package:rt_app/features/user/state/user_provider.dart';

import 'package:rt_app/screens/home/home_page.dart';
import 'package:rt_app/screens/ai/ai_page.dart';
import 'package:rt_app/screens/services/services_page.dart';
import 'package:rt_app/screens/profile/profile_page.dart';
import 'package:rt_app/screens/profile/UserPage.dart';
import 'package:rt_app/screens/init/init_page.dart';
import 'package:rt_app/screens/assistant/assistant_page.dart';
import 'package:rt_app/screens/department/department_page.dart';


import '../utils/constants.dart';
import '../widgets/bottom_nav_scaffold.dart';

import '../../style/colors.dart';
import '../../style/fonts.dart';

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
	pageBuilder: (context, state) =>
	    const NoTransitionPage(child: LoginPage()),
      ),
      StatefulShellRoute(
        navigatorContainerBuilder: (context, navigationShell, children) {
          return IndexedStack(
            index: navigationShell.currentIndex,
            children: children,
          );
        },
        builder: (context, state, navigationShell) {
          return MultiProvider(
            providers: protectedProviders(context),
            child: BottomNavScaffold(
              navigationShell: navigationShell,
            ),
          );
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
                pageBuilder: (context, state) {
		  return NoTransitionPage(
		    child: AIPage(),
		  );
		},
              ),
	      GoRoute(
  	        path: AppRoutes.assistant,
                pageBuilder: (context, state) {
		  return NoTransitionPage(
      	            child: AssistantPage(),
		  );
		},
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
                pageBuilder: (context, state) {
		  final userProvider = context.watch<UserProvider>();
		  final user = userProvider.authUser; 
		  return CustomTransitionPage(
		    key: state.pageKey,
    		    transitionDuration: const Duration(milliseconds: 200), 
    		    child: ProfilePage(),
    		    transitionsBuilder: (context, animation, secondaryAnimation, child) {
    		      return SlideTransition(
    		        position: Tween<Offset>(
    		          begin: const Offset(1.0, 0.0),
    		          end: Offset.zero,
    		        ).animate(animation),
    		        child: child,
    		      );
    		    },
    		  );
		},
		routes: [
		  GoRoute(
      		    path: 'department/:id',
		    pageBuilder: (context, state) {
      		      final idString = state.pathParameters['id']!;
      		      final departmentId = int.tryParse(idString)!;
		      return NoTransitionPage(
      	                child: DepartmentPage(departmentId: departmentId),
		      );
		    },
      		  ),
		  GoRoute(
      		    path: 'user/:id',
		    pageBuilder: (context, state) {
      		      final idString = state.pathParameters['id']!;
      		      final userId = int.tryParse(idString)!;
		      return NoTransitionPage(
      	                child: UserPage(userId: userId),
		      );
		    },
      		  ),
		],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

