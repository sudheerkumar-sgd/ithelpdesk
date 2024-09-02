import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
import '../requests/view_request.dart';

// ignore: must_be_immutable
class ReportsScreen extends BaseScreenWidget {
  ReportsScreen({super.key});
  final ServicesBloc _servicesBloc = sl<ServicesBloc>();
  List<dynamic>? tickets;
  ValueNotifier<int?> _selectedCategory = ValueNotifier(null);
  String? selectedStatus;
  List<String>? ticketsHeaderData;

  Widget _getFilters(BuildContext context) {
    final resources = context.resources;
    final categories = const [
      'All',
      'Assigned Tickets',
      'My Tickets',
    ];
    return Wrap(
      alignment: WrapAlignment.end,
      runSpacing: resources.dimen.dp10,
      runAlignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 200,
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
                child: DropDownWidget<String>(
                  height: 32,
                  list: categories,
                  selectedValue: categories[_selectedCategory.value ?? 0],
                  iconSize: 20,
                  fontStyle: context.textFontWeight400
                      .onFontSize(resources.fontSize.dp12),
                  callback: (p0) {
                    _selectedCategory.value = categories.indexOf(p0 ?? 'All');
                  },
                ),
              ),
            ],
          ),
        ),
        // SizedBox(
        //   width: resources.dimen.dp10,
        // ),
        // SizedBox(
        //   width: 200,
        //   child: Row(
        //     children: [
        //       Text(
        //         resources.string.status,
        //         style: context.textFontWeight600
        //             .onFontSize(resources.fontSize.dp10),
        //       ),
        //       SizedBox(
        //         width: resources.dimen.dp10,
        //       ),
        //       Expanded(
        //         child: DropDownWidget(
        //           height: 32,
        //           list: statusTypes,
        //           iconSize: 20,
        //           selectedValue: selectedStatus ?? statusTypes[0],
        //           fontStyle: context.textFontWeight400
        //               .onFontSize(resources.fontSize.dp12),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // SizedBox(
        //   width: resources.dimen.dp10,
        // ),
        // SizedBox(
        //   width: 120,
        //   child: Row(
        //     children: [
        //       Text(
        //         resources.string.export,
        //         style: context.textFontWeight600
        //             .onFontSize(resources.fontSize.dp10),
        //       ),
        //       SizedBox(
        //         width: resources.dimen.dp5,
        //       ),
        //       Expanded(
        //         child: DropDownWidget(
        //           height: 28,
        //           list: const [
        //             'exl',
        //             'pdf',
        //           ],
        //           iconSize: 20,
        //           fontStyle: context.textFontWeight400
        //               .onFontSize(resources.fontSize.dp10),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        SizedBox(
          width: resources.dimen.dp10,
        ),
        InkWell(
          onTap: () {
            var excel = Excel.createExcel();
            var sheetObject = excel[excel.getDefaultSheet() ?? 'SheetName'];

            tickets?.forEach((item) {
              List<CellValue> headerlist = List.empty(growable: true);
              List<CellValue> list = List.empty(growable: true);

              item.toJson().forEach((k, v) {
                if (sheetObject.rows.isEmpty) {
                  final cellValue = TextCellValue("$k");
                  headerlist.add(cellValue);
                }
                final cellValue = TextCellValue("$v");
                list.add(cellValue);
              });
              if (sheetObject.rows.isEmpty) {
                sheetObject.appendRow(headerlist);
              }
              sheetObject.appendRow(list);
            });
            excel.save(fileName: 'Tickets.xlsx');
          },
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
          onTap: () {
            _printData(ticketsHeaderData ?? []);
          },
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

  Future<void> _printData(List<String> headers) async {
    String tableHeader = '<tr>';
    for (var item in headers) {
      tableHeader = '$tableHeader\n <td>$item</td>';
    }
    tableHeader = '$tableHeader\n</tr>';
    String tableBody = '';
    tickets?.forEach((item) {
      tableBody = '$tableBody\n<tr>';
      item.toJson().forEach((k, v) {
        tableBody = '$tableBody\n <td>$v</td>';
      });
      tableBody = '$tableBody\n</tr>';
    });
    printData(title: "Tickets", headerData: tableHeader, bodyData: tableBody);
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
    ticketsHeaderData = isDesktop(context)
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
                      tickets = snapsShot.data?.entity?.items;
                      return tickets?.isNotEmpty == true
                          ? ValueListenableBuilder(
                              valueListenable: _selectedCategory,
                              builder: (context, value, child) {
                                var filteredTickets = tickets;
                                if (value == 1) {
                                  filteredTickets = tickets
                                      ?.where((item) =>
                                          item.userID !=
                                          UserCredentialsEntity.details().id)
                                      .toList();
                                } else if (value == 2) {
                                  filteredTickets = tickets
                                      ?.where((item) =>
                                          item.userID ==
                                          UserCredentialsEntity.details().id)
                                      .toSet()
                                      .toList();
                                }
                                return ReportListWidget(
                                  ticketsHeaderData: ticketsHeaderData ?? [],
                                  ticketsData: filteredTickets ?? [],
                                  ticketsTableColunwidths:
                                      ticketsTableColunwidths,
                                  showActionButtons: true,
                                  onTicketSelected: (ticket) {
                                    ViewRequest.start(context, ticket);
                                  },
                                );
                              },
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
