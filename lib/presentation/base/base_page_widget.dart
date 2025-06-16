// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/data/local/app_settings_db.dart';
import 'package:ithelpdesk/data/local/user_data_db.dart';
import 'package:ithelpdesk/domain/entities/user_credentials_entity.dart';
import 'package:ithelpdesk/injection_container.dart';
import 'package:ithelpdesk/presentation/bloc/user/user_bloc.dart';
import 'package:ithelpdesk/presentation/common_widgets/alert_dialog_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/msearch_user_app_bar.dart';
import 'package:ithelpdesk/presentation/common_widgets/page_user_app_bar.dart';
import 'package:ithelpdesk/presentation/common_widgets/search_user_app_bar.dart';
import 'package:ithelpdesk/presentation/home/user_home_navigator_screen.dart';
import 'package:ithelpdesk/presentation/utils/NavbarNotifier.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';
import 'package:ithelpdesk/res/resources.dart';

abstract class BasePageWidget extends StatefulWidget {
  const BasePageWidget({super.key});
  @override
  State<StatefulWidget> createState() => _BasePageWidgetState();
  Widget getContentWidget();
}

class _BasePageWidgetState extends State<BasePageWidget> {
  final NavbarNotifier _navbarNotifier = NavbarNotifier();
  int backpressCount = 0;
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);
  BaseScreenWidget? currentScreen;
  int activeTab = 0;
  double sideBarWidth = 200;
  final UserBloc _userBloc = sl<UserBloc>();
  Widget getScreen(int index) {
    if (currentScreen != null) {
      currentScreen?.doDispose();
    }
    switch (index) {
      case 0:
        currentScreen = UserHomeNavigatorScreen();
      case 1:
      //currentScreen = ReportsNavigatorScreen();
      case 2:
      //currentScreen = DirectoryNavigatorScreen();
      case 3:
      //currentScreen = ProfileNavigatorScreen();
      default:
        currentScreen = UserHomeNavigatorScreen();
    }
    return currentScreen ?? UserHomeNavigatorScreen();
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex.value = context.appSettingsDB
        .get(AppSettingsDB.selectedSideBarIndex, defaultValue: 0);
  }

  @override
  void dispose() {
    if (currentScreen != null) {
      currentScreen?.doDispose();
    }
    super.dispose();
  }

  Widget getUserAppBar(BuildContext context) {
    context.userDataDB.put(
        UserDataDB.userOnvaction,
        UserCredentialsEntity.details().userOnvaction ??
            context.userDataDB
                .get(UserDataDB.userOnvaction, defaultValue: false));
    return isDesktop(context)
        ? SearchUserAppBarWidget(
            userName: UserCredentialsEntity.details().name ?? "",
            onItemTap: (p0) {},
          )
        : MSearchUserAppBarWidget(
            userName: UserCredentialsEntity.details().name ?? "",
          );
  }

  @override
  Widget build(BuildContext context) {
    Resources resources = context.resources;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, value) async {
        await _navbarNotifier.onBackButtonPressed(_selectedIndex.value);
      },
      child: BlocProvider(
        create: (context) => _userBloc,
        child: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is OnLoginLoading) {
              Dialogs.loader(context);
            } else if (state is UpdateVactionStatus) {
              Dialogs.dismiss(context);
              Dialogs.showInfoDialog(
                  context, PopupType.success, state.updateVactionStatus);
            } else if (state is OnLoginApiError) {
              Dialogs.dismiss(context);
              Dialogs.showInfoDialog(context, PopupType.fail, state.message);
            }
          },
          child: Scaffold(
            backgroundColor: resources.color.appScaffoldBg,
            resizeToAvoidBottomInset: false,
            body: SelectionArea(
              child: Column(
                children: [
                  PageUserAppBarWidget(
                      userName: UserCredentialsEntity.details().name ?? ""),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: resources.dimen.dp20),
                        child: Column(
                          children: [
                            widget.getContentWidget(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
