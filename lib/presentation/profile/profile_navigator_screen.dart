// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/profile/profile_screen.dart';

class ProfileNavigatorScreen extends BaseScreenWidget {
  ProfileNavigatorScreen({Key? key}) : super(key: key);
  static GlobalKey<NavigatorState> profileKey = GlobalKey<NavigatorState>();
  late ProfileScreen profileScreen;
  @override
  Widget build(BuildContext context) {
    profileScreen = ProfileScreen();
    return Navigator(
      key: profileKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext _) => profileScreen, settings: settings);
      },
      onPopPage: (route, result) {
        return true;
      },
    );
  }

  @override
  doDispose() {
    //profileScreen.doDispose();
  }
}
