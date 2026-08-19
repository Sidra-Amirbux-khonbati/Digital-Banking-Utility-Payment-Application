import 'package:flutter/material.dart';

import '../../screens/splash/splash_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/user_type/user_type_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';     
  static const String login = '/login';
  static const String userType = '/userType';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    userType: (context) => const UserTypeScreen(),
  };
}