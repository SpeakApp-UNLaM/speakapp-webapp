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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppRouter>(
          lazy: false,
          create: (BuildContext createContext) => AppRouter(),
        ),
        ChangeNotifierProvider(create: (_) => ExerciseProvider()),
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
