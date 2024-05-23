import 'package:flutter/widgets.dart';
import 'package:smartuaq/presentation/start/splash_screen.dart';

class AppRoutes {
  static String initialRoute = '/splash';
  static String startRoute = '/start';
  static String loginRoute = '/login';
  static String guestMainRoute = '/guestMain';
  static String userMainRoute = '/userMain';
  static String homeRoute = '/home';
  static String tourRoute = '/tour';

  /// The map used to define our routes, needs to be supplied to [MaterialApp]
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AppRoutes.initialRoute: (context) => const SplashScreen(),
    };
  }
}
