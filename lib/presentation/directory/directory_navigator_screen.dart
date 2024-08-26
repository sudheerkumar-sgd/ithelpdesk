// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/directory/directory_screen.dart';

class DirectoryNavigatorScreen extends BaseScreenWidget {
  DirectoryNavigatorScreen({Key? key}) : super(key: key);
  static late GlobalKey<NavigatorState> directoryKey;
  late DirectoryScreen directoryScreen;
  @override
  Widget build(BuildContext context) {
    directoryKey = GlobalKey<NavigatorState>();
    directoryScreen = DirectoryScreen();
    return Navigator(
      key: directoryKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext _) => directoryScreen, settings: settings);
      },
      onPopPage: (route, result) {
        return true;
      },
    );
  }

  @override
  doDispose() {
    directoryScreen.doDispose();
  }
}
