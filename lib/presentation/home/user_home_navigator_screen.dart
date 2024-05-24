// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/home/user_home_screen.dart';

class UserHomeNavigatorScreen extends BaseScreenWidget {
  UserHomeNavigatorScreen({Key? key}) : super(key: key);
  static late GlobalKey<NavigatorState> homeKey;
  late UserHomeScreen homScreen;
  @override
  Widget build(BuildContext context) {
    homeKey = GlobalKey<NavigatorState>();
    homScreen = UserHomeScreen();
    return Navigator(
      key: homeKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext _) => homScreen, settings: settings);
      },
      onPopPage: (route, result) {
        return true;
      },
    );
  }

  @override
  doDispose() {
    homScreen.doDispose();
  }
}
