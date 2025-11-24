// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/home/admin_dashboard_screen.dart';
import 'package:ithelpdesk/presentation/home/user_home_screen.dart';

class UserHomeNavigatorScreen extends BaseScreenWidget {
  UserHomeNavigatorScreen({Key? key}) : super(key: key);
  static GlobalKey<NavigatorState> homeKey = GlobalKey<NavigatorState>();
  late UserHomeScreen homScreen;
  late AdminDashboardScreen adminDashboardScreen;
  @override
  Widget build(BuildContext context) {
    homScreen = const UserHomeScreen();
    adminDashboardScreen = const AdminDashboardScreen();
    return Navigator(
      key: homeKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext _) => adminDashboardScreen,
            settings: settings);
      },
      onPopPage: (route, result) {
        return true;
      },
    );
  }

  @override
  doDispose() {
    // homScreen.doDispose();
  }
}
