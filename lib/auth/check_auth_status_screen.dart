import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart'; // Make sure to import Provider

class CheckAuthStatusScreen extends StatelessWidget {
  const CheckAuthStatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Check if the user is logged in
    if (authProvider.loggedInStatus == Status.LoggedIn) {
      // User is logged in, navigate to HomeScreen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/');
      });
    } else {
       WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/login');
      });
    }

    return Scaffold(
      body: Center(child: CircularProgressIndicator(strokeWidth: 4)),
    );
  }
}