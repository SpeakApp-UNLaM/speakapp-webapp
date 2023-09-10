import 'package:flutter/material.dart';
import 'package:speak_app_web/screens/manage_exercise_screen.dart';

import 'config/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.theme(),
      home: const TabBarExample(),
    );
  }
}