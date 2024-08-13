import 'package:flutter/widgets.dart';
import 'package:ithelpdesk/presentation/home/user_main_screen.dart';
import 'package:ithelpdesk/presentation/start/splash_screen.dart';

class AppRoutes {
  static String initialRoute = '/splash';
  static String startRoute = '/start';
  static String loginRoute = '/login';
  static String guestMainRoute = '/guestMain';
  static String userMainRoute = '/dashboard';
  static String homeRoute = '/home';
  static String tourRoute = '/tour';

  /// The map used to define our routes, needs to be supplied to [MaterialApp]
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AppRoutes.initialRoute: (context) => SplashScreen(),
      AppRoutes.startRoute: (context) => SplashScreen(),
      AppRoutes.userMainRoute: (context) => const UserMainScreen(),
    };
  }
}
