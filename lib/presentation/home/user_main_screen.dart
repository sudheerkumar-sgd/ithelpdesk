// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/common/log.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/alert_dialog_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/update_dialog_widget.dart';
import 'package:ithelpdesk/presentation/home/user_home_navigator_screen.dart';
import 'package:ithelpdesk/presentation/utils/NavbarNotifier.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';
import 'package:ithelpdesk/res/drawables/drawable_assets.dart';
import 'package:ithelpdesk/res/resources.dart';
import 'package:update_available/update_available.dart';

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

    return Container(
      color: context.resources.color.bgColor,
      child: SafeArea(
        child: ValueListenableBuilder(
            valueListenable: _selectedIndex,
            builder: (context, value, widget) {
              return Scaffold(
                body: Container(
                    margin: EdgeInsets.only(top: resources.dimen.dp20),
                    child: getScreen(value)),
                //_widgetOptions(context),
                backgroundColor: context.resources.color.colorWhite,
                drawer: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 1,
                      decoration:
                          BackgroundBoxDecoration().roundedBoxWithShadow,
                    ),
                    BottomNavigationBar(
                      items: <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: ImageWidget(
                            path: DrawableAssets.icHome,
                            boxType: BoxFit.fill,
                            padding: EdgeInsets.all(resources.dimen.dp5),
                            colorFilter: ColorFilter.mode(
                                _selectedIndex.value == 0
                                    ? context
                                        .resources.color.bottomSheetIconSelected
                                    : context.resources.color
                                        .bottomSheetIconUnSelected,
                                BlendMode.srcIn),
                          ).loadImageWithMoreTapArea,
                          label: 'home',
                        ),
                        BottomNavigationBarItem(
                          icon: ImageWidget(
                            path: DrawableAssets.icMywallet,
                            boxType: BoxFit.fill,
                            padding: EdgeInsets.all(resources.dimen.dp5),
                            colorFilter: ColorFilter.mode(
                                _selectedIndex.value == 1
                                    ? context
                                        .resources.color.bottomSheetIconSelected
                                    : context.resources.color
                                        .bottomSheetIconUnSelected,
                                BlendMode.srcIn),
                          ).loadImageWithMoreTapArea,
                          label: 'myWallet',
                        ),
                        BottomNavigationBarItem(
                          icon: ImageWidget(
                            path: DrawableAssets.icService,
                            boxType: BoxFit.fill,
                            padding: EdgeInsets.all(resources.dimen.dp5),
                            colorFilter: ColorFilter.mode(
                                _selectedIndex.value == 2
                                    ? context
                                        .resources.color.bottomSheetIconSelected
                                    : context.resources.color
                                        .bottomSheetIconUnSelected,
                                BlendMode.srcIn),
                          ).loadImageWithMoreTapArea,
                          label: 'services',
                        ),
                        BottomNavigationBarItem(
                          icon: ImageWidget(
                            path: DrawableAssets.icSupport,
                            boxType: BoxFit.fill,
                            padding: EdgeInsets.all(resources.dimen.dp5),
                            colorFilter: ColorFilter.mode(
                                _selectedIndex.value == 3
                                    ? context
                                        .resources.color.bottomSheetIconSelected
                                    : context.resources.color
                                        .bottomSheetIconUnSelected,
                                BlendMode.srcIn),
                          ).loadImageWithMoreTapArea,
                          label: 'support',
                        ),
                        BottomNavigationBarItem(
                          icon: ImageWidget(
                            path: DrawableAssets.icMore,
                            boxType: BoxFit.fill,
                            padding: EdgeInsets.all(resources.dimen.dp5),
                            colorFilter: ColorFilter.mode(
                                _selectedIndex.value == 4
                                    ? context
                                        .resources.color.bottomSheetIconSelected
                                    : context.resources.color
                                        .bottomSheetIconUnSelected,
                                BlendMode.srcIn),
                          ).loadImageWithMoreTapArea,
                          label: 'more',
                        ),
                      ],
                      elevation: 0.0,
                      type: BottomNavigationBarType.fixed,
                      currentIndex: _selectedIndex.value,
                      selectedItemColor:
                          context.resources.color.bottomSheetIconSelected,
                      unselectedItemColor:
                          context.resources.color.bottomSheetIconUnSelected,
                      backgroundColor: Colors.white,
                      selectedFontSize: context.resources.fontSize.dp10,
                      unselectedFontSize: context.resources.fontSize.dp10,
                      onTap: _onItemTapped,
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
