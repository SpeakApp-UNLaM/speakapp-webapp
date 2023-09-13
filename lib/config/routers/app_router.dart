import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speak_app_web/presentations/screens/calendar_section/calendar_view.dart';
import 'package:speak_app_web/presentations/screens/manage_patient_screen.dart';

import '../../presentations/screens/home_screen.dart';
import '../../presentations/screens/message_section/message_view.dart';
import '../../presentations/screens/patient_section/patient_view.dart';

// GoRouter configuration
class AppRouter {
  AppRouter();
  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _shellNavigator =
      GlobalKey(debugLabel: 'shell');

  late final router = GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    routes: [
      ShellRoute(
          navigatorKey: _shellNavigator,
          builder: (context, state, child) {
            return HomeScreen(child: child);
          },
          routes: [
            GoRoute(
                path: '/',
                name: 'HomeScreen',
                parentNavigatorKey: _shellNavigator,
                pageBuilder: (context, state) {
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: const PatientView(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      // Change the opacity of the screen using a Curve based on the the animation's
                      // value
                      return FadeTransition(
                        opacity: CurveTween(curve: Curves.fastOutSlowIn)
                            .animate(animation),
                        child: child,
                      );
                    },
                  );
                },
                routes: [
                  GoRoute(
                    path: 'patient_screen',
                    pageBuilder: (context, state) {
                      return CustomTransitionPage(
                        key: state.pageKey,
                        child: const ManagePatientScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          // Change the opacity of the screen using a Curve based on the the animation's
                          // value
                          return FadeTransition(
                            opacity: CurveTween(curve: Curves.fastOutSlowIn)
                                .animate(animation),
                            child: child,
                          );
                        },
                      );
                    },
                  )
                ]),
            GoRoute(
              path: '/message_view',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: const MessageView(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    // Change the opacity of the screen using a Curve based on the the animation's
                    // value
                    return FadeTransition(
                      opacity: CurveTween(curve: Curves.fastOutSlowIn)
                          .animate(animation),
                      child: child,
                    );
                  },
                );
              },
            ),
            GoRoute(
              path: '/calendar_view',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: const CalendarView(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    // Change the opacity of the screen using a Curve based on the the animation's
                    // value
                    return FadeTransition(
                      opacity: CurveTween(curve: Curves.fastOutSlowIn)
                          .animate(animation),
                      child: child,
                    );
                  },
                );
              },
            )
          ])
    ],
  );
}
