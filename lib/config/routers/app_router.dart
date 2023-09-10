import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:speak_app_web/presentations/screens/management_screen.dart';

import '../../presentations/auth/screens/login_screen.dart';
import '../../presentations/auth/screens/register_screen.dart';
import '../../providers/auth_provider.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

// GoRouter configuration
class AppRouter {
  final AuthProvider authProvider;
  AppRouter(this.authProvider);

  late final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    refreshListenable: authProvider,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        name: 'HomeScreen',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const ManagementScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              // Change the opacity of the screen using a Curve based on the the animation's
              // value
              return FadeTransition(
                opacity:
                    CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        name: 'LoginScreen',
        path: '/login',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        name: 'RegisterScreen',
        path: '/register',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const RegisterScreen(),
        ),
      ),
    ],
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final loginLoc = state.pageKey;
      final loggingIn = state.matchedLocation == loginLoc;

      //final createAccountLoc = state.namedLocation(createAccountRouteName);
      //final creatingAccount = state.subloc == createAccountLoc;
      final loggedIn = authProvider.loggedIn;
      //final rootLoc = state.namedLocation(rootRouteName);

      if (!loggedIn) return '/';
      return null;
    },
  );
}
