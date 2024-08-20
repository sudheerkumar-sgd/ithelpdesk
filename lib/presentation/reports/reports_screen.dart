import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/bloc/services/services_bloc.dart';
import 'package:ithelpdesk/presentation/common_widgets/action_button_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dropdown_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/report_list_widget.dart';

import '../../domain/entities/user_credentials_entity.dart';
import '../../injection_container.dart';

class ReportsScreen extends BaseScreenWidget {
  ReportsScreen({super.key});
  final ServicesBloc _servicesBloc = sl<ServicesBloc>();

  Widget _getFilters(BuildContext context) {
    final resources = context.resources;
    final ticketTypes = [
      resources.string.notAssignedRequests,
      resources.string.openRequests,
      resources.string.closedRequests,
      resources.string.activeRequests.replaceAll('Requests', 'Requests'),
      resources.string.dueRequests.replaceAll('Requests', 'Requests'),
      resources.string.allRequests.replaceAll('Requests', 'Requests'),
    ];
    return Wrap(
      alignment: WrapAlignment.end,
      runSpacing: resources.dimen.dp10,
      runAlignment: WrapAlignment.start,
      children: [
        SizedBox(
          width: 170,
          child: Row(
            children: [
              Text(
                resources.string.category,
                style: context.textFontWeight600
                    .onFontSize(resources.fontSize.dp10),
              ),
              SizedBox(
                width: resources.dimen.dp5,
              ),
              Expanded(
                child: DropDownWidget(
                  height: 28,
                  list: ticketTypes,
                  iconSize: 20,
                  fontStyle: context.textFontWeight400
                      .onFontSize(resources.fontSize.dp10),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: resources.dimen.dp10,
        ),
        SizedBox(
          width: 170,
          child: Row(
            children: [
              Text(
                resources.string.sortBy,
                style: context.textFontWeight600
                    .onFontSize(resources.fontSize.dp10),
              ),
              SizedBox(
                width: resources.dimen.dp5,
              ),
              Expanded(
                child: DropDownWidget(
                  height: 28,
                  list: const ['Created Date', 'priority', 'status'],
                  iconSize: 20,
                  fontStyle: context.textFontWeight400
                      .onFontSize(resources.fontSize.dp10),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: resources.dimen.dp10,
        ),
        SizedBox(
          width: 120,
          child: Row(
            children: [
              Text(
                resources.string.export,
                style: context.textFontWeight600
                    .onFontSize(resources.fontSize.dp10),
              ),
              SizedBox(
                width: resources.dimen.dp5,
              ),
              Expanded(
                child: DropDownWidget(
                  height: 28,
                  list: const [
                    'exl',
                    'pdf',
                  ],
                  iconSize: 20,
                  fontStyle: context.textFontWeight400
                      .onFontSize(resources.fontSize.dp10),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: resources.dimen.dp10,
        ),
        InkWell(
          onTap: () {},
          child: ActionButtonWidget(
              text: resources.string.download,
              radious: resources.dimen.dp15,
              textSize: resources.fontSize.dp10,
              padding: EdgeInsets.symmetric(
                  vertical: resources.dimen.dp5,
                  horizontal: resources.dimen.dp15),
              color: resources.color.sideBarItemUnselected),
        ),
        SizedBox(
          width: resources.dimen.dp10,
        ),
        InkWell(
          onTap: () {},
          child: ActionButtonWidget(
            text: resources.string.print,
            padding: EdgeInsets.symmetric(
                vertical: resources.dimen.dp5,
                horizontal: resources.dimen.dp15),
            radious: resources.dimen.dp15,
            textSize: resources.fontSize.dp10,
            color: resources.color.sideBarItemUnselected,
          ),
        ),
      ],
    );
  }

  List<Widget> _getFilterBar(BuildContext context) {
    final resources = context.resources;
    return [
      Text(
        resources.string.report,
        style: context.textFontWeight600,
      ),
      if (UserCredentialsEntity.details().userType != UserType.user) ...[
        SizedBox(
          width: resources.dimen.dp20,
          height: resources.dimen.dp10,
        ),
        isDesktop(context)
            ? Expanded(
                child: _getFilters(context),
              )
            : _getFilters(context)
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.resources.color.appScaffoldBg,
      body: BlocProvider(
        create: (context) => _servicesBloc,
        child: Padding(
          padding: EdgeInsets.all(resources.dimen.dp20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isDesktop(context)
                    ? Row(
                        children: _getFilterBar(context),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _getFilterBar(context),
                      ),
                SizedBox(
                  height: resources.dimen.dp20,
                ),
                FutureBuilder(
                    future: _servicesBloc.getTticketsByUser(requestParams: {
                      'userId': UserCredentialsEntity.details().id
                    }),
                    builder: (context, snapsShot) {
                      return snapsShot.data?.entity?.items.isNotEmpty == true
                          ? ReportListWidget(
                              ticketsHeaderData: ticketsHeaderData,
                              ticketsData: snapsShot.data?.entity?.items ?? [],
                              ticketsTableColunwidths: ticketsTableColunwidths,
                              showActionButtons: true,
                            )
                          : const Center(child: CircularProgressIndicator());
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
