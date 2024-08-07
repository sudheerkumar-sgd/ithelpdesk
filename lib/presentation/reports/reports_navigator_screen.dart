// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/reports/reports_screen.dart';

class ReportsNavigatorScreen extends BaseScreenWidget {
  ReportsNavigatorScreen({Key? key}) : super(key: key);
  static late GlobalKey<NavigatorState> reportKey;
  late ReportsScreen reportsScreen;
  @override
  Widget build(BuildContext context) {
    reportKey = GlobalKey<NavigatorState>();
    reportsScreen = ReportsScreen();
    return Navigator(
      key: reportKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext _) => reportsScreen, settings: settings);
      },
      onPopPage: (route, result) {
        return true;
      },
    );
  }

  @override
  doDispose() {
    reportsScreen.doDispose();
  }
}
