import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speak_app_web/presentations/screens/calendar_section/calendar_view.dart';
import 'package:speak_app_web/presentations/screens/manage_patient_screen.dart';
import 'package:speak_app_web/presentations/screens/patient_section/exercises_results.dart';
import 'package:speak_app_web/presentations/screens/patient_section/manage_exercises.dart';
import 'package:speak_app_web/presentations/screens/patient_section/manage_phoneme_exercises.dart';
import 'package:speak_app_web/presentations/screens/patient_section/tab_bar_patient.dart';

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
  final GlobalKey<NavigatorState> _shellTabNavigator =
      GlobalKey(debugLabel: 'shell');

  late final router = GoRouter(
    initialLocation: '/patients',
    navigatorKey: _rootNavigatorKey,
    routes: [
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
                        opacity: CurveTween(curve: Curves.fastOutSlowIn)
                            .animate(animation),
                        child: child,
                      );
                    },
                  );
                },
                routes: [
                  ShellRoute(
                      navigatorKey: _shellTabNavigator,
                      builder: (context, state, child) {
                        return TabBarPatient(
                            idPatient: int.parse(
                                state.pathParameters['idPatient'] as String),
                            child: child);
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
                                        idPatient: int.parse(state.pathParameters['idPatient'] as String),
                                        idPhoneme:
                                            state.pathParameters['idPhoneme']
                                                as String,
                                        namePhoneme: (state.extra as String)
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
                              child: const ExercisesResults(),
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
