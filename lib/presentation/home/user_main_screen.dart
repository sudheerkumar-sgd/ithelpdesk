// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/domain/entities/user_credentials_entity.dart';
import 'package:ithelpdesk/injection_container.dart';
import 'package:ithelpdesk/presentation/bloc/user/user_bloc.dart';
import 'package:ithelpdesk/presentation/common_widgets/alert_dialog_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/msearch_user_app_bar.dart';
import 'package:ithelpdesk/presentation/common_widgets/search_user_app_bar.dart';
import 'package:ithelpdesk/presentation/common_widgets/side_bar.dart';
import 'package:ithelpdesk/presentation/directory/directory_navigator_screen.dart';
import 'package:ithelpdesk/presentation/home/user_home_navigator_screen.dart';
import 'package:ithelpdesk/presentation/profile/profile_navigator_screen.dart';
import 'package:ithelpdesk/presentation/reports/reports_navigator_screen.dart';
import 'package:ithelpdesk/presentation/utils/NavbarNotifier.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';
import 'package:ithelpdesk/res/resources.dart';

import '../../core/enum/enum.dart';
import '../requests/create_new_request.dart';

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
  final UserBloc _userBloc = sl<UserBloc>();
  late SideBar sideBar;

  Widget getUserAppBar(BuildContext context) {
    return isDesktop(context)
        ? SearchUserAppBarWidget(
            userName: UserCredentialsEntity.details().name ?? "",
            onItemTap: (p0) {
              if (p0 == AppBarItem.user) {
                sideBar.selectItem(3);
              }
            },
          )
        : MSearchUserAppBarWidget(
            userName: UserCredentialsEntity.details().name ?? "",
          );
  }

  void _onItemTapped(int index) {
    if (_selectedIndex.value == index) {
      _navbarNotifier.onBackButtonPressed(_selectedIndex.value);
    }
    _selectedIndex.value = index;
  }

  Widget getScreen(int index) {
    if (currentScreen != null) {
      currentScreen?.doDispose();
    }
    switch (index) {
      case 0:
        currentScreen =
            UserCredentialsEntity.details().userType == UserType.user
                ? CreateNewRequest()
                : UserHomeNavigatorScreen();
      case 1:
        currentScreen = ReportsNavigatorScreen();
      case 2:
        currentScreen = DirectoryNavigatorScreen();
      case 3:
        currentScreen = ProfileNavigatorScreen();
      default:
        currentScreen =
            UserCredentialsEntity.details().userType == UserType.user
                ? CreateNewRequest()
                : UserHomeNavigatorScreen();
    }
    return currentScreen ??
        (UserCredentialsEntity.details().userType == UserType.user
            ? CreateNewRequest()
            : UserHomeNavigatorScreen());
  }

  @override
  void initState() {
    super.initState();
    sideBar = SideBar(
      onItemSelected: (p0) {
        _onItemTapped(p0);
      },
    );
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
    // final isWebMobile = kIsWeb &&
    //     (defaultTargetPlatform == TargetPlatform.iOS ||
    //         defaultTargetPlatform == TargetPlatform.android);

    return BlocProvider(
      create: (context) => _userBloc,
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          await _navbarNotifier.onBackButtonPressed(_selectedIndex.value);
        },
        child: Scaffold(
          backgroundColor: resources.color.colorWhite,
          resizeToAvoidBottomInset: false,
          drawer: SizedBox(
            width: 200,
            child: SideBar(
              onItemSelected: (p0) {
                _onItemTapped(p0);
              },
            ),
          ),
          body: LayoutBuilder(builder: (context, size) {
            screenSize = size.biggest;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isDesktop(context, size: size.biggest))
                  SizedBox(
                    width: 150,
                    child: sideBar,
                  ),
                Expanded(
                  child: Column(
                    children: [
                      (UserCredentialsEntity.details().name?.isNotEmpty == true)
                          ? getUserAppBar(context)
                          : FutureBuilder(
                              future: _userBloc.validateUser({}),
                              builder: (context, snapShot) {
                                UserCredentialsEntity.create(
                                    snapShot.data?.token ?? '');
                                userToken = snapShot.data?.token ?? '';
                                return getUserAppBar(context);
                              }),
                      ValueListenableBuilder(
                          valueListenable: _selectedIndex,
                          builder: (context, index, child) {
                            return Expanded(child: getScreen(index));
                          }),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
