import 'package:binhduongbus/presentation/pages/login/login_screen.dart';
import 'package:binhduongbus/presentation/pages/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'core/config/app_routes.dart';
import 'core/config/app_theme.dart';
import 'presentation/pages/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bình Dương Bus',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.home: (context) => const RouteSearchScreen(),
      },
    );
  }
}
