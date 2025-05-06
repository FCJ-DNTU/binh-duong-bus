import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/config/app_routes.dart';
import 'core/config/app_theme.dart';
import 'package:binhduongbus/presentation/pages/splash_screen/splash_screen.dart';
import 'package:binhduongbus/presentation/pages/login_screen/login_screen.dart';
import 'package:binhduongbus/presentation/pages/register_screen/register_screen.dart';
import 'package:binhduongbus/presentation/pages/home_screen/home_screen.dart';
import 'package:binhduongbus/presentation/pages/setting_screen/setting_screen.dart';
import 'package:binhduongbus/presentation/pages/route_search_screen/route_search_screen.dart';
import 'package:binhduongbus/presentation/pages/route_planning_screen/route_planning_screen.dart';
import 'package:binhduongbus/presentation/pages/favorite_routes_screen/favorite_routes_screen.dart';
import 'package:binhduongbus/presentation/pages/payment_screen/payment_screen.dart';
import 'package:binhduongbus/presentation/pages/event_screen/event_detail_screen.dart';
import 'package:binhduongbus/presentation/pages/event_screen/event_list_screen.dart';
import 'package:binhduongbus/presentation/pages/notification_screen/notification_screen.dart';
import 'package:binhduongbus/presentation/pages/chat_screen/chat_screen.dart';

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
        AppRoutes.register: (context) => const RegisterScreen(),
        AppRoutes.home: (context) => HomeScreen(),
        AppRoutes.settings: (context) => const SettingScreen(),
        AppRoutes.routes: (context) => const RouteSearchScreen(),
        AppRoutes.routePlanning: (context) => RoutePlanningScreen(),
        AppRoutes.favoriteRoutes: (context) => FavoriteRoutesScreen(),
        AppRoutes.payment: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>? ??
              {};
          return PaymentScreen();
        },
        AppRoutes.eventList: (context) => const EventListScreen(),
        AppRoutes.eventDetail: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>? ??
              {};
          return EventDetailScreen();
        },
        AppRoutes.notification: (context) => const NotificationScreen(),
        '/chat': (context) => ChatScreen(),
      },
    );
  }
}
