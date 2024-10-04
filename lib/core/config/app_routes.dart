import 'package:flutter/widgets.dart';
import 'package:ithelpdesk/domain/entities/dashboard_entity.dart';
import 'package:ithelpdesk/presentation/home/user_main_screen.dart';
import 'package:ithelpdesk/presentation/profile/profile_screen.dart';
import 'package:ithelpdesk/presentation/requests/view_request.dart';

class AppRoutes {
  static String initialRoute = '/';
  static String startRoute = '/start';
  static String loginRoute = '/login';
  static String guestMainRoute = '/guestMain';
  static String userMainRoute = '/dashboard';
  static String homeRoute = '/home';
  static String tourRoute = '/tour';
  static String profileRoute = '/profile';
  static String ticketRoute = '/ticket/:id';

  /// The map used to define our routes, needs to be supplied to [MaterialApp]
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AppRoutes.initialRoute: (context) => const UserMainScreen(),
      AppRoutes.userMainRoute: (context) => const UserMainScreen(),
      AppRoutes.profileRoute: (context) => ProfileScreen(),
      AppRoutes.ticketRoute: (context) => ViewRequest(
            ticket: TicketEntity(),
          ),
    };
  }
}
