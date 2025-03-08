import 'package:binhduongbus/presentation/pages/login_screen/login_screen.dart';
import 'package:binhduongbus/presentation/pages/route_details_screen/route_details_screen.dart';
import 'package:binhduongbus/presentation/pages/route_planning_screen/route_planning_screen.dart';
import 'package:binhduongbus/presentation/pages/splash_screen/splash_screen.dart';
import 'package:binhduongbus/presentation/pages/home_screen/home_screen.dart';
import 'package:binhduongbus/presentation/pages/notification_screen/notification_screen.dart';
import 'package:binhduongbus/presentation/pages/route_details_screen/route_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/config/app_routes.dart';
import 'core/config/app_theme.dart';

void main() async {
  await dotenv.load(fileName: ".env");
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
        AppRoutes.notification: (context) => const NotificationScreen(),
        // AppRoutes.routeDetails: (context) => const RouteDetailScreen(title: ''),
        AppRoutes.routePlanning: (context) => RoutePlanningScreen(),
      },
    );
  }
}
