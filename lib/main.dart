import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speak_app_web/providers/exercise_provider.dart';
import 'config/api.dart';
import 'config/routers/app_router.dart';
import 'config/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/login_provider.dart';

Future<void> main() async {
  Api.configureDio();
  final state = AuthProvider(await SharedPreferences.getInstance());
  state.checkLoggedIn();

  runApp(MyApp(authProvider: state));
}

class MyApp extends StatelessWidget {
  final AuthProvider authProvider;

  const MyApp({super.key, required this.authProvider});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
            lazy: false, create: (BuildContext createContext) => authProvider),
        Provider<AppRouter>(
          lazy: false,
          create: (BuildContext createContext) => AppRouter(authProvider),
        ),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ExerciseProvider()),
        Provider<AppRouter>(
          lazy: false,
          create: (BuildContext createContext) => AppRouter(authProvider),
        ),
      ],
      child: Builder(
        builder: (BuildContext context) {
          final router = Provider.of<AppRouter>(context, listen: false).router;
          return MaterialApp.router(
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate,
            routeInformationProvider: router.routeInformationProvider,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.theme(),
          );
        },
      ),
    );
  }
}
