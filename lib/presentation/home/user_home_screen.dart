// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:smartuaq/core/common/log.dart';
import 'package:smartuaq/core/extensions/build_context_extension.dart';
import 'package:smartuaq/domain/entities/requests_entity.dart';
import 'package:smartuaq/domain/entities/services_entity.dart';
import 'package:smartuaq/injection_container.dart';
import 'package:smartuaq/presentation/bloc/services/services_bloc.dart';
import 'package:smartuaq/presentation/common_widgets/base_screen_widget.dart';
import 'package:smartuaq/presentation/common_widgets/user_app_bar.dart';
import 'package:smartuaq/res/resources.dart';

class UserHomeScreen extends BaseScreenWidget {
  UserHomeScreen({super.key});
  final _servicesBloc = sl<ServicesBloc>();
  MostUsedServicesEntity? mostUsedServices;
  final ValueNotifier<List<ServiceEntity>> _favoriteServices =
      ValueNotifier([]);
  final ValueNotifier<bool> _isRequestsLoaded = ValueNotifier(false);
  List<RequestsEntity> _requests = [];
  List<ServiceEntity> allServices = [];
  final ValueNotifier _isFavoriteEdited = ValueNotifier<bool>(false);
  final requestNumberTextController = TextEditingController();
  late FocusNode requestStatusFocusNode;

  void onRequestValueChanged(String value) {
    if (value.trim().length == 6) {
      requestStatusFocusNode.canRequestFocus = !requestStatusFocusNode.hasFocus;
    }
  }

  @override
  Widget build(BuildContext context) {
    Resources resources = context.resources;
    logFirbaseScreenView(
      screenName: 'user home screen',
    );
    return SafeArea(
        child: Container(
      padding: EdgeInsets.symmetric(horizontal: context.resources.dimen.dp25),
      child: Scaffold(
        backgroundColor: context.resources.color.colorWhite,
        appBar: UserAppBarWidget(
          wish: 'welcome',
          title: 'userDisplayName',
          showSearch: true,
          padding:
              EdgeInsets.symmetric(horizontal: context.resources.dimen.dp25),
        ),
        body: const SizedBox(),
      ),
    ));
  }

  @override
  doDispose() {
    _favoriteServices.dispose();
    _servicesBloc.close();
    _isFavoriteEdited.dispose();
    _isRequestsLoaded.dispose();
  }
}
