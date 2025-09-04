// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/iso/iso_system_cr_screen.dart';

class ISONavigatorScreen extends BaseScreenWidget {
  ISONavigatorScreen({Key? key}) : super(key: key);
  static late GlobalKey<NavigatorState> isoKey;
  late IsoSystemCrScreen iosSystemCrScreen;
  @override
  Widget build(BuildContext context) {
    isoKey = GlobalKey<NavigatorState>();
    iosSystemCrScreen = IsoSystemCrScreen();
    return Navigator(
      key: isoKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext _) => iosSystemCrScreen, settings: settings);
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
