// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/ibtaker/ibtaker_home_screen.dart';

class IbtakerNavigatorScreen extends BaseScreenWidget {
  IbtakerNavigatorScreen({Key? key}) : super(key: key);
  static GlobalKey<NavigatorState> ibtakerKey = GlobalKey<NavigatorState>();
  late IbtakerHomeScreen ibtakerHomeScreen;

  @override
  Widget build(BuildContext context) {
    ibtakerHomeScreen = IbtakerHomeScreen();
    return Navigator(
      key: ibtakerKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext _) => ibtakerHomeScreen,
            settings: settings);
      },
      onPopPage: (route, result) {
        return true;
      },
    );
  }

  @override
  void doDispose() {}
}
