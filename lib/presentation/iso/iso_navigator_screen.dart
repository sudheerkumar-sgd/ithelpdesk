// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/iso/iso_cr_home_screen.dart';

class ISONavigatorScreen extends BaseScreenWidget {
  ISONavigatorScreen({Key? key}) : super(key: key);
  static GlobalKey<NavigatorState> isoKey = GlobalKey<NavigatorState>();
  late IsoCrHomeScreen isoCrHomeScreen;
  @override
  Widget build(BuildContext context) {
    isoCrHomeScreen = IsoCrHomeScreen();
    return Navigator(
      key: isoKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext _) => isoCrHomeScreen, settings: settings);
      },
      onPopPage: (route, result) {
        return true;
      },
    );
  }

  @override
  doDispose() {
    //iosSystemCrScreen.doDispose();
  }
}
