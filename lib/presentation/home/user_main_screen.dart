// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/alert_dialog_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/msearch_user_app_bar.dart';
import 'package:ithelpdesk/presentation/common_widgets/search_user_app_bar.dart';
import 'package:ithelpdesk/presentation/common_widgets/side_bar.dart';
import 'package:ithelpdesk/presentation/home/temp.dart';
import 'package:ithelpdesk/presentation/home/user_home_navigator_screen.dart';
import 'package:ithelpdesk/presentation/utils/NavbarNotifier.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';
import 'package:ithelpdesk/res/resources.dart';
import 'package:animated_sidebar/animated_sidebar.dart';

class UserMainScreen extends StatefulWidget {
  static ValueNotifier onUnAuthorizedResponse = ValueNotifier<bool>(false);
  static ValueNotifier onNetworkConnectionError = ValueNotifier<int>(1);
  const UserMainScreen({super.key});
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<UserMainScreen> {
  final NavbarNotifier _navbarNotifier = NavbarNotifier();
  int backpressCount = 0;
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);
  BaseScreenWidget? currentScreen;
  int activeTab = 0;
  double sideBarWidth = 200;

  final List<SidebarItem> items = [
    SidebarItem(icon: Icons.home, text: 'Home'),
    SidebarItem(
      icon: Icons.person,
      text: 'Management',
      children: [
        SidebarChildItem(icon: Icons.person, text: 'Users'),
        SidebarChildItem(icon: Icons.verified_user, text: 'Roles'),
      ],
    ),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex.value == index) {
      _navbarNotifier.onUserBackButtonPressed(_selectedIndex.value);
    }
    _selectedIndex.value = index;
  }

  Widget getScreen(int index) {
    if (currentScreen != null) {
      currentScreen?.doDispose();
    }
    switch (index) {
      default:
        currentScreen = UserHomeNavigatorScreen();
    }
    return currentScreen ?? UserHomeNavigatorScreen();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (currentScreen != null) {
      currentScreen?.doDispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Resources resources = context.resources;
    Future.delayed(Duration.zero, () {
      UserMainScreen.onUnAuthorizedResponse.addListener(
        () {
          if (UserMainScreen.onUnAuthorizedResponse.value) {
            UserMainScreen.onUnAuthorizedResponse.value = false;
            logout(context);
          }
        },
      );

      UserMainScreen.onNetworkConnectionError.addListener(
        () {
          if (UserMainScreen.onNetworkConnectionError.value == 2) {
            UserMainScreen.onNetworkConnectionError.value = 3;
            Dialogs.showInfoDialog(context, PopupType.fail,
                    'No internet connection found.\nCheck your connection and try again.')
                .then((value) {
              UserMainScreen.onNetworkConnectionError.value = 1;
            });
          }
        },
      );
    });
    final isWebMobile = kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android);

    return Scaffold(
      backgroundColor: resources.color.colorWhite,
      drawer: SizedBox(
        width: 200,
        child: SideBar(
          onItemSelected: (p0) {},
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop(context))
            SizedBox(
              width: 150,
              child: SideBar(
                onItemSelected: (p0) {},
              ),
            ),
          Expanded(
            child: Column(
              children: [
                isDesktop(context)
                    ? const SearchUserAppBarWidget(
                        userName: 'Sudheer Kumar A',
                      )
                    : MSearchUserAppBarWidget(
                        userName: 'Sudheer Kumar A',
                      ),
                ValueListenableBuilder(
                    valueListenable: _selectedIndex,
                    builder: (context, index, child) {
                      return Expanded(child: getScreen(index));
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
