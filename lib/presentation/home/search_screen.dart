import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/domain/entities/master_data_entities.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:page_transition/page_transition.dart';

import '../../core/common/common_utils.dart';
import '../../domain/entities/user_credentials_entity.dart';
import '../../injection_container.dart';
import '../../res/resources.dart';
import '../bloc/services/services_bloc.dart';
import '../common_widgets/report_list_widget.dart';
import '../common_widgets/search_textfield_widget.dart';
import '../requests/view_request.dart';

class SearchScreen extends BaseScreenWidget {
  static start(BuildContext context) {
    Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeft, child: SearchScreen()),
    );
  }

  SearchScreen({super.key});
  final _servicesBloc = sl<ServicesBloc>();
  final ValueNotifier<String> _searchValue = ValueNotifier('');
  final searchTextController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    Resources resources = context.resources;
    Future.delayed(const Duration(milliseconds: 400), () {
      _servicesBloc.getTticketsByUser(
          requestParams: {'userId': UserCredentialsEntity.details().id});
    });
    searchTextController.addListener(() {
      if (searchTextController.text.length > 3) {
        _searchValue.value = searchTextController.text;
      }
    });
    searchFocusNode.requestFocus();
    final ticketsHeaderData = isDesktop(context)
        ? [
            'ID',
            'EmployeeName',
            'Category',
            'Subject',
            'Status',
            'Priority',
            'Assignee',
            'Department',
            'CreateDate',
          ]
        : ['ID', 'Subject', 'Status', 'Priority', 'CreateDate', 'Action'];
    final ticketsTableColunwidths = isDesktop(context)
        ? {
            0: const FlexColumnWidth(1),
            1: const FlexColumnWidth(3),
            2: const FlexColumnWidth(2),
            3: const FlexColumnWidth(4),
            4: const FlexColumnWidth(2),
            5: const FlexColumnWidth(2),
            6: const FlexColumnWidth(3),
            7: const FlexColumnWidth(1),
            8: const FlexColumnWidth(3),
          }
        : {
            0: const FlexColumnWidth(1),
            1: const FlexColumnWidth(4),
            2: const FlexColumnWidth(2),
            3: const FlexColumnWidth(2),
            4: const FlexColumnWidth(2),
            5: const FlexColumnWidth(3),
          };
    return SafeArea(
        child: Scaffold(
            backgroundColor: context.resources.color.colorWhite,
            body: BlocProvider(
              create: (context) => _servicesBloc,
              child: BlocListener<ServicesBloc, ServicesState>(
                listener: (context, state) {},
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: context.resources.dimen.dp25),
                        child: Column(
                          children: [
                            SearchTextfieldWidget(
                              textController: searchTextController,
                            ),
                            SizedBox(
                              height: context.resources.dimen.dp20,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ValueListenableBuilder(
                            valueListenable: _searchValue,
                            builder: (context, value, child) {
                              return FutureBuilder(
                                  future: _servicesBloc
                                      .getTticketsByUser(requestParams: {
                                    'userId': UserCredentialsEntity.details().id
                                  }),
                                  builder: (context, snapsShot) {
                                    final tickets =
                                        snapsShot.data?.entity?.items ?? [];
                                    return snapsShot.data?.entity?.items
                                                .isNotEmpty ==
                                            true
                                        ? ReportListWidget(
                                            ticketsHeaderData:
                                                ticketsHeaderData,
                                            ticketsData: tickets,
                                            ticketsTableColunwidths:
                                                ticketsTableColunwidths,
                                            showActionButtons: true,
                                            onTicketSelected: (ticket) {
                                              ViewRequest.start(
                                                  context, ticket);
                                            },
                                          )
                                        : const Center(
                                            child: CircularProgressIndicator());
                                  });
                            }),
                      ),
                    ]),
              ),
            )));
  }
}
