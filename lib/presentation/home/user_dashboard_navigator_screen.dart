// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';

class UserDashboardNavigatorScreen extends BaseScreenWidget {
  final Widget screen;
  const UserDashboardNavigatorScreen({required this.screen, Key? key})
      : super(key: key);
  static GlobalKey<NavigatorState> homeKey = GlobalKey<NavigatorState>();
  // late UserHomeScreen homeScreen;
  // late AdminDashboardScreen adminDashboardScreen;
  @override
  Widget build(BuildContext context) {
    // homeScreen = const UserHomeScreen();
    // adminDashboardScreen = const AdminDashboardScreen();
    return Navigator(
      key: homeKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext _) => screen, settings: settings);
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
