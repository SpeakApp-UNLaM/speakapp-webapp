import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:speak_app_web/presentations/auth/screens/login_screen.dart';
import 'package:speak_app_web/presentations/auth/screens/register_screen.dart';
import 'package:speak_app_web/presentations/config/user_config.dart';
import 'package:speak_app_web/presentations/screens/calendar_section/calendar_view.dart';
import 'package:speak_app_web/presentations/screens/manage_patient_screen.dart';
import 'package:speak_app_web/presentations/screens/patient_section/exercises_results.dart';
import 'package:speak_app_web/presentations/screens/patient_section/manage_exercises.dart';
import 'package:speak_app_web/presentations/screens/patient_section/manage_phoneme_exercises.dart';
import 'package:speak_app_web/presentations/screens/patient_section/phoneme_exercises_results.dart';
import 'package:speak_app_web/presentations/screens/patient_section/rfi_results.dart';
import 'package:speak_app_web/presentations/screens/patient_section/tab_bar_patient.dart';
import 'package:speak_app_web/providers/auth_provider.dart';

import '../../presentations/screens/home_screen.dart';
import '../../presentations/screens/message_section/message_view.dart';
import '../../presentations/screens/patient_section/patient_view.dart';

// GoRouter configuration
class AppRouter {
  final AuthProvider authProvider;

  AppRouter(this.authProvider);
  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _shellNavigator =
      GlobalKey(debugLabel: 'shell');
  final GlobalKey<NavigatorState> _shellTabNavigator =
      GlobalKey(debugLabel: 'shell');

  late final router = GoRouter(
    initialLocation: '/patients',
    navigatorKey: _rootNavigatorKey,
    refreshListenable: authProvider,
    routes: [
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
      ShellRoute(
          navigatorKey: _shellNavigator,
          builder: (context, state, child) {
            return HomeScreen(child: child);
          },
          routes: [
            GoRoute(
                path: '/patients',
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
                        opacity: CurvedAnimation(
                            curve: Curves.elasticIn, parent: animation),
                        child: child,
                      );
                    },
                  );
                },
                routes: [
                  ShellRoute(
                      navigatorKey: _shellTabNavigator,
                      pageBuilder: (context, state, child) {
                        return CustomTransitionPage(
                          key: state.pageKey,
                          child: TabBarPatient(
                              idPatient: int.parse(
                                  state.pathParameters['idPatient'] as String),
                              child: child),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: CurvedAnimation(
                                  curve: Curves.elasticIn, parent: animation),
                              child: child,
                            );
                          },
                        );
                      },
                      routes: [
                        GoRoute(
                            name: 'manage_exercises',
                            path: ':idPatient/manage_exercises',
                            parentNavigatorKey: _shellTabNavigator,
                            pageBuilder: (context, state) {
                              return CustomTransitionPage(
                                key: state.pageKey,
                                child: ManageExercises(
                                    idPatient: int.parse(
                                        state.pathParameters['idPatient']
                                            as String)),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity:
                                        CurveTween(curve: Curves.fastOutSlowIn)
                                            .animate(animation),
                                    child: child,
                                  );
                                },
                              );
                            },
                            routes: [
                              GoRoute(
                                  path: 'phoneme/:idPhoneme',
                                  name: 'manage_phoneme_exercises',
                                  parentNavigatorKey: _shellTabNavigator,
                                  pageBuilder: (context, state) {
                                    return CustomTransitionPage(
                                      key: state.pageKey,
                                      child: ManagePhonemeExercises(
                                        idPatient: int.parse(
                                            state.pathParameters['idPatient']
                                                as String),
                                        idPhoneme:
                                            state.pathParameters['idPhoneme']
                                                as String,
                                      ),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        return FadeTransition(
                                          opacity: CurveTween(
                                                  curve: Curves.fastOutSlowIn)
                                              .animate(animation),
                                          child: child,
                                        );
                                      },
                                    );
                                  }),
                            ]),
                        GoRoute(
                            name: 'exercises_result',
                            path: ':idPatient/exercises_results',
                            parentNavigatorKey: _shellTabNavigator,
                            pageBuilder: (context, state) {
                              return CustomTransitionPage(
                                key: state.pageKey,
                                child: ExercisesResults(
                                    idPatient: int.parse(
                                        state.pathParameters['idPatient']
                                            as String)),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity:
                                        CurveTween(curve: Curves.fastOutSlowIn)
                                            .animate(animation),
                                    child: child,
                                  );
                                },
                              );
                            },
                            routes: [
                              GoRoute(
                                  path: ':idPhoneme',
                                  name: 'phoneme_exercises_result',
                                  parentNavigatorKey: _shellTabNavigator,
                                  pageBuilder: (context, state) {
                                    return CustomTransitionPage(
                                      key: state.pageKey,
                                      child: PhonemeExercisesResults(
                                          idPatient: int.parse(
                                              state.pathParameters['idPatient']
                                                  as String),
                                          idPhoneme: int.parse(
                                              state.pathParameters['idPhoneme']
                                                  as String)),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        return FadeTransition(
                                          opacity: CurveTween(
                                                  curve: Curves.fastOutSlowIn)
                                              .animate(animation),
                                          child: child,
                                        );
                                      },
                                    );
                                  }),
                            ]),
                            GoRoute(
                            name: 'rfi_result',
                            path: ':idPatient/rfi',
                            parentNavigatorKey: _shellTabNavigator,
                            pageBuilder: (context, state) {
                              return CustomTransitionPage(
                                key: state.pageKey,
                                child: RFIResults(
                                    idPatient: int.parse(
                                        state.pathParameters['idPatient']
                                            as String)),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity:
                                        CurveTween(curve: Curves.fastOutSlowIn)
                                            .animate(animation),
                                    child: child,
                                  );
                                },
                              );
                            },
                            ),
                      ])
                ]),
            GoRoute(
              path: '/user_settings',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: const UserConfigScreen(),
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
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final loginLoc = state.pageKey;
      final loggingIn = state.matchedLocation == loginLoc;

      //final createAccountLoc = state.namedLocation(createAccountRouteName);
      //final creatingAccount = state.subloc == createAccountLoc;
      final loggedIn = authProvider.loggedIn;
      //final rootLoc = state.namedLocation(rootRouteName);

      if (!loggedIn) return '/login';
      return null;
    },
  );
}
