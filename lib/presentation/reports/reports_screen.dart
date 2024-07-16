import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/action_button_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dropdown_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/report_list_widget.dart';

class ReportsScreen extends BaseScreenWidget {
  const ReportsScreen({super.key});

  Widget _getFilters(BuildContext context) {
    final resources = context.resources;
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
        '${resources.string.notAssignedRequests.replaceAll('\n', ' ')} ${resources.string.report}',
        style: context.textFontWeight600,
      ),
      SizedBox(
        width: resources.dimen.dp20,
        height: resources.dimen.dp10,
      ),
      isDesktop(context)
          ? Expanded(
              child: _getFilters(context),
            )
          : _getFilters(context)
    ];
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    final ticketTypesRows = isDesktop(context) ? 1 : 2;
    final ticketTypesColumns = isDesktop(context) ? 6 : 3;
    final ticketTypes = [
      resources.string.notAssignedRequests,
      resources.string.openRequests,
      resources.string.closedRequests,
      resources.string.activeRequests.replaceAll('Requests', 'Requests'),
      resources.string.dueRequests.replaceAll('Requests', 'Requests'),
      resources.string.allRequests.replaceAll('Requests', 'Requests'),
    ];
    final ticketsHeaderData = isDesktop(context)
        ? [
            'ID',
            'EmployeeName',
            'Subject',
            'Status',
            'Priority',
            'Assignee',
            'Department',
            'CreateDate',
            'Action'
          ]
        : ['ID', 'Subject', 'Status', 'Priority', 'CreateDate', 'Action'];
    final ticketsTableColunwidths = isDesktop(context)
        ? {
            0: const FlexColumnWidth(1),
            1: const FlexColumnWidth(3),
            2: const FlexColumnWidth(4),
            3: const FlexColumnWidth(2),
            4: const FlexColumnWidth(1),
            5: const FlexColumnWidth(2),
            6: const FlexColumnWidth(3),
            7: const FlexColumnWidth(2),
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
      body: Padding(
        padding: EdgeInsets.all(resources.dimen.dp20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  for (int c = 0; c < ticketTypesRows; c++) ...[
                    Row(
                      children: [
                        for (int r = 0; r < ticketTypesColumns; r++) ...[
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: ActionButtonWidget(
                                text:
                                    (ticketTypes[r + (c * ticketTypesColumns)])
                                        .toString(),
                                color: resources.color.colorWhite,
                                radious: 0,
                                textColor: resources.color.textColor,
                                textSize: resources.fontSize.dp12,
                                maxLines: 2,
                                padding: EdgeInsets.symmetric(
                                    vertical: resources.dimen.dp10,
                                    horizontal: resources.dimen.dp10),
                              ),
                            ),
                          ),
                          if (r < ticketTypesColumns - 1) ...[
                            SizedBox(
                              width: resources.dimen.dp10,
                            ),
                          ]
                        ]
                      ],
                    ),
                    if (c < ticketTypesColumns - 1) ...[
                      SizedBox(
                        height: resources.dimen.dp20,
                      ),
                    ]
                  ]
                ],
              ),
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
              ReportListWidget(
                ticketsHeaderData: ticketsHeaderData,
                ticketsData: [],
                ticketsTableColunwidths: ticketsTableColunwidths,
                showActionButtons: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
