import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ithelpdesk/presentation/directory/directory_navigator_screen.dart';
import 'package:ithelpdesk/presentation/home/user_home_navigator_screen.dart';
import 'package:ithelpdesk/presentation/profile/profile_navigator_screen.dart';
import 'package:ithelpdesk/presentation/reports/reports_navigator_screen.dart';

class NavbarNotifier extends ChangeNotifier {
  int _index = 0;
  int get index => _index;
  bool _hideBottomNavBar = false;

  set index(int x) {
    _index = x;
    notifyListeners();
  }

  bool get hideBottomNavBar => _hideBottomNavBar;
  set hideBottomNavBar(bool x) {
    _hideBottomNavBar = x;
    notifyListeners();
  }

  // pop routes from the nested navigator stack and not the main stack
  // this is done based on the currentIndex of the bottom navbar
  // if the backButton is pressed on the initial route the app will be terminated
  FutureOr<bool> onBackButtonPressed(int index) async {
    bool exitingApp = true;
    switch (index) {
      case 0:
        if (UserHomeNavigatorScreen.homeKey.currentState != null &&
            UserHomeNavigatorScreen.homeKey.currentState!.canPop()) {
          UserHomeNavigatorScreen.homeKey.currentState!.maybePop();
          exitingApp = false;
        }
        break;
      case 1:
        if (ReportsNavigatorScreen.reportKey.currentState != null &&
            ReportsNavigatorScreen.reportKey.currentState!.canPop()) {
          ReportsNavigatorScreen.reportKey.currentState!.maybePop();
          exitingApp = false;
        }
        break;
      case 2:
        if (DirectoryNavigatorScreen.directoryKey.currentState != null &&
            DirectoryNavigatorScreen.directoryKey.currentState!.canPop()) {
          DirectoryNavigatorScreen.directoryKey.currentState!.maybePop();
          exitingApp = false;
        }
        break;
      case 3:
        if (ProfileNavigatorScreen.profileKey.currentState != null &&
            ProfileNavigatorScreen.profileKey.currentState!.canPop()) {
          ProfileNavigatorScreen.profileKey.currentState!.maybePop();
          exitingApp = false;
        }
        break;
      default:
        return false;
    }
    return exitingApp;
  }

  // pops all routes except first, if there are more than 1 route in each navigator stack
  void popAllRoutes(int index) {
    switch (index) {
      case 0:
        // if (HomeNavigatorScreen.homeKey.currentState!.canPop()) {
        //   HomeNavigatorScreen.homeKey.currentState!
        //       .popUntil((route) => route.isFirst);
        // }
        return;
      default:
        break;
    }
  }

  FutureOr<bool> onGustBackButtonPressed(int index) async {
    switch (index) {
      default:
        return false;
    }
  }
}
