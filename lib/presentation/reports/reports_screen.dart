import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/config/flavor_config.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/string_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/bloc/services/services_bloc.dart';
import 'package:ithelpdesk/presentation/common_widgets/action_button_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dropdown_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/report_list_widget.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';

import '../../core/common/log.dart';
import '../../core/constants/constants.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/entities/user_credentials_entity.dart';
import '../../injection_container.dart';
import '../../res/drawables/background_box_decoration.dart';
import '../common_widgets/alert_dialog_widget.dart';
import '../requests/view_request.dart';
import 'package:excel/excel.dart' as excelpackage;

// ignore: must_be_immutable
class ReportsScreen extends BaseScreenWidget {
  ReportsScreen({super.key});
  final ServicesBloc _servicesBloc = sl<ServicesBloc>();
  // final _masterDataBloc = sl<MasterDataBloc>();
  List<TicketEntity> tickets = List.empty(growable: true);
  int? index;
  int? totalPagecount;
  final ValueNotifier<bool> _onFilterChange = ValueNotifier(false);
  int? _selectedCategory = 0;
  // final ValueNotifier<UserEntity?> _selectedEmployee = ValueNotifier(null);
  String? selectedStatus;
  Map<String, dynamic>? filteredData;
  final ValueNotifier<List<String>> filteredDates = ValueNotifier([]);
  Future<bool> exportToExcel(List<dynamic> tickets) async {
    try {
      var excel = excelpackage.Excel.createExcel();
      var sheetObject = excel[excel.getDefaultSheet() ?? 'SheetName'];
      for (var (item as TicketEntity) in tickets) {
        List<excelpackage.CellValue> headerlist = List.empty(growable: true);
        List<excelpackage.CellValue> list = List.empty(growable: true);
        item.toExcel().forEach((k, v) {
          if (sheetObject.rows.isEmpty) {
            final cellValue = excelpackage.TextCellValue(k.capitalize());
            headerlist.add(cellValue);
          }
          final cellValue = excelpackage.TextCellValue("$v");
          list.add(cellValue);
        });
        if (sheetObject.rows.isEmpty) {
          sheetObject.appendRow(headerlist);
        }
        sheetObject.appendRow(list);
      }
      excel.save(fileName: 'Tickets.xlsx');
    } catch (e) {
      printLog(e);
      return false;
    }
    return true;
  }

  Widget _getFilters(BuildContext context) {
    final resources = context.resources;
    final categories = [
      resources.string.all,
      resources.string.assignedTickets,
      resources.string.myTickets,
      resources.string.employeeTickets,
    ];
    return Wrap(
      alignment: WrapAlignment.end,
      runSpacing: resources.dimen.dp10,
      runAlignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${resources.string.filterByDate}: ',
              style:
                  context.textFontWeight600.onFontSize(resources.fontSize.dp10),
            ),
            SizedBox(
              width: resources.dimen.dp10,
            ),
            ValueListenableBuilder(
                valueListenable: filteredDates,
                builder: (context, value, child) {
                  return Container(
                    decoration: BackgroundBoxDecoration(
                            radious: resources.dimen.dp15,
                            boarderColor: resources.color.sideBarItemUnselected)
                        .roundedCornerBox,
                    padding: EdgeInsets.symmetric(
                      vertical: resources.dimen.dp5,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: resources.dimen.dp10,
                        ),
                        InkWell(
                          onTap: () {
                            showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now()
                                        .add(const Duration(days: -365)),
                                    lastDate: DateTime.now())
                                .then((dateTime) {
                              if (dateTime != null) {
                                filteredDates
                                    .value = List<String>.empty(growable: true)
                                  ..add(
                                      getDateByformat('yyyy/MM/dd', dateTime));
                              }
                            });
                          },
                          child: Text.rich(
                            TextSpan(
                                text: value.isNotEmpty
                                    ? value[0]
                                    : resources.string.startDate,
                                children: [
                                  WidgetSpan(
                                    child: Padding(
                                      padding: isSelectedLocalEn
                                          ? const EdgeInsets.only(left: 5.0)
                                          : const EdgeInsets.only(right: 5.0),
                                      child: const Icon(
                                        Icons.calendar_month_sharp,
                                        size: 16,
                                      ),
                                    ),
                                  )
                                ]),
                            style: context.textFontWeight400
                                .onFontSize(resources.fontSize.dp10),
                          ),
                        ),
                        SizedBox(
                          width: resources.dimen.dp10,
                        ),
                        InkWell(
                          onTap: () {
                            if (value.isNotEmpty) {
                              showDatePicker(
                                      context: context,
                                      initialDate: getDateTimeByString(
                                          'yyyy/MM/dd', value[0]),
                                      firstDate: getDateTimeByString(
                                          'yyyy/MM/dd', value[0]),
                                      lastDate: DateTime.now())
                                  .then((dateTime) {
                                if (dateTime != null) {
                                  filteredDates.value =
                                      List<String>.empty(growable: true)
                                        ..add(value[0])
                                        ..add(getDateByformat(
                                            'yyyy/MM/dd', dateTime));
                                  if (context.mounted) {
                                    _updateTickets(context);
                                  }
                                }
                              });
                            } else {
                              Dialogs.showInfoDialog(
                                  context,
                                  PopupType.fail,
                                  resources.string.pleaseSelect +
                                      resources.string.startDate);
                            }
                          },
                          child: Text.rich(
                            TextSpan(
                                text: value.length > 1
                                    ? value[1]
                                    : resources.string.endDate,
                                children: [
                                  WidgetSpan(
                                    child: Padding(
                                      padding: isSelectedLocalEn
                                          ? const EdgeInsets.only(left: 5.0)
                                          : const EdgeInsets.only(right: 5.0),
                                      child: const Icon(
                                        Icons.calendar_month_sharp,
                                        size: 16,
                                      ),
                                    ),
                                  )
                                ]),
                            style: context.textFontWeight400
                                .onFontSize(resources.fontSize.dp10),
                          ),
                        ),
                        SizedBox(
                          width: resources.dimen.dp5,
                        ),
                        InkWell(
                          onTap: () {
                            if (filteredDates.value.isNotEmpty) {
                              filteredDates.value = List.empty();
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Icon(
                              Icons.clear,
                              size: 16,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: resources.dimen.dp5,
                        ),
                      ],
                    ),
                  );
                }),
          ],
        ),

        SizedBox(
          width: resources.dimen.dp20,
        ),
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
                  selectedValue: categories[_selectedCategory ?? 0],
                  iconSize: 20,
                  fontStyle: context.textFontWeight400
                      .onFontSize(resources.fontSize.dp12),
                  callback: (p0) {
                    _selectedCategory = categories.indexOf(p0 ?? 'All');
                    index = 0;
                    _updateTickets(context);
                  },
                ),
              ),
            ],
          ),
        ),
        // ValueListenableBuilder(
        //     valueListenable: _selectedCategory,
        //     builder: (context, category, child) {
        //       return (category == 0 || category == 3)
        //           ? SizedBox(
        //               width: 250,
        //               child: Row(
        //                 children: [
        //                   SizedBox(
        //                     width: resources.dimen.dp20,
        //                   ),
        //                   Text(
        //                     resources.string.employee,
        //                     style: context.textFontWeight600
        //                         .onFontSize(resources.fontSize.dp10),
        //                   ),
        //                   SizedBox(
        //                     width: resources.dimen.dp5,
        //                   ),
        //                   Expanded(
        //                     child: FutureBuilder(
        //                         future: _masterDataBloc.getAssignedEmployees(
        //                             requestParams: {},
        //                             apiUrl: assignedEmployeesByUserApiUrl),
        //                         builder: (context, snapShot) {
        //                           final items = snapShot.data?.items ?? [];
        //                           if (items.isNotEmpty) {
        //                             final employee = UserEntity();
        //                             employee.id = 0;
        //                             employee.name = resources.string.all;
        //                             _selectedEmployee.value = employee;
        //                             items.insert(0, employee);
        //                           }
        //                           return DropDownWidget(
        //                             isEnabled: true,
        //                             height: 32,
        //                             iconSize: 20,
        //                             selectedValue: _selectedEmployee.value,
        //                             fontStyle: context.textFontWeight400
        //                                 .onFontSize(resources.fontSize.dp12),
        //                             list: items,
        //                             callback: (value) {
        //                               _selectedEmployee.value = value;
        //                             },
        //                           );
        //                         }),
        //                   ),
        //                 ],
        //               ),
        //             )
        //           : const SizedBox();
        //     }),
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
          onTap: () async {
            if (context.mounted) {
              Dialogs.loader(context);
            }
            final allTicketsResponse = await _servicesBloc.getTticketsByUser(
                requestParams: _getFilteredData(null));
            await _servicesBloc
                .exportToExcel(allTicketsResponse.entity?.ticketsList ?? []);
            if (context.mounted) {
              Dialogs.dismiss(context);
            }
            // final ValueNotifier<List<String>> filteredDates = ValueNotifier([]);

            // Dialogs.showDialogWithClose(
            //   context,
            //   Column(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       SizedBox(
            //         height: resources.dimen.dp20,
            //       ),
            //       Row(
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           Text(
            //             '${resources.string.filterByDate}: ',
            //             style: context.textFontWeight600
            //                 .onFontSize(resources.fontSize.dp10),
            //           ),
            //           SizedBox(
            //             width: resources.dimen.dp10,
            //           ),
            //           ValueListenableBuilder(
            //               valueListenable: filteredDates,
            //               builder: (context, value, child) {
            //                 return Container(
            //                   decoration: BackgroundBoxDecoration(
            //                           radious: resources.dimen.dp15,
            //                           boarderColor:
            //                               resources.color.sideBarItemUnselected)
            //                       .roundedCornerBox,
            //                   padding: EdgeInsets.symmetric(
            //                     vertical: resources.dimen.dp5,
            //                   ),
            //                   child: Row(
            //                     children: [
            //                       SizedBox(
            //                         width: resources.dimen.dp10,
            //                       ),
            //                       InkWell(
            //                         onTap: () {
            //                           showDatePicker(
            //                                   context: context,
            //                                   firstDate: DateTime.now().add(
            //                                       const Duration(days: -365)),
            //                                   lastDate: DateTime.now())
            //                               .then((dateTime) {
            //                             if (dateTime != null) {
            //                               filteredDates.value =
            //                                   List<String>.empty(growable: true)
            //                                     ..add(getDateByformat(
            //                                         'yyyy/MM/dd', dateTime));
            //                             }
            //                           });
            //                         },
            //                         child: Text.rich(
            //                           TextSpan(
            //                               text: value.isNotEmpty
            //                                   ? value[0]
            //                                   : resources.string.startDate,
            //                               children: [
            //                                 WidgetSpan(
            //                                   child: Padding(
            //                                     padding: isSelectedLocalEn
            //                                         ? const EdgeInsets.only(
            //                                             left: 5.0)
            //                                         : const EdgeInsets.only(
            //                                             right: 5.0),
            //                                     child: const Icon(
            //                                       Icons.calendar_month_sharp,
            //                                       size: 16,
            //                                     ),
            //                                   ),
            //                                 )
            //                               ]),
            //                           style: context.textFontWeight400
            //                               .onFontSize(resources.fontSize.dp10),
            //                         ),
            //                       ),
            //                       SizedBox(
            //                         width: resources.dimen.dp10,
            //                       ),
            //                       InkWell(
            //                         onTap: () {
            //                           if (value.isNotEmpty) {
            //                             showDatePicker(
            //                                     context: context,
            //                                     initialDate:
            //                                         getDateTimeByString(
            //                                             'yyyy/MM/dd', value[0]),
            //                                     firstDate: getDateTimeByString(
            //                                         'yyyy/MM/dd', value[0]),
            //                                     lastDate: DateTime.now())
            //                                 .then((dateTime) {
            //                               if (dateTime != null) {
            //                                 filteredDates.value =
            //                                     List<String>.empty(
            //                                         growable: true)
            //                                       ..add(value[0])
            //                                       ..add(getDateByformat(
            //                                           'yyyy/MM/dd', dateTime));
            //                               }
            //                             });
            //                           } else {
            //                             Dialogs.showInfoDialog(
            //                                 context,
            //                                 PopupType.fail,
            //                                 resources.string.pleaseSelect +
            //                                     resources.string.startDate);
            //                           }
            //                         },
            //                         child: Text.rich(
            //                           TextSpan(
            //                               text: value.length > 1
            //                                   ? value[1]
            //                                   : resources.string.endDate,
            //                               children: [
            //                                 WidgetSpan(
            //                                   child: Padding(
            //                                     padding: isSelectedLocalEn
            //                                         ? const EdgeInsets.only(
            //                                             left: 5.0)
            //                                         : const EdgeInsets.only(
            //                                             right: 5.0),
            //                                     child: const Icon(
            //                                       Icons.calendar_month_sharp,
            //                                       size: 16,
            //                                     ),
            //                                   ),
            //                                 )
            //                               ]),
            //                           style: context.textFontWeight400
            //                               .onFontSize(resources.fontSize.dp10),
            //                         ),
            //                       ),
            //                       SizedBox(
            //                         width: resources.dimen.dp5,
            //                       ),
            //                       InkWell(
            //                         onTap: () {
            //                           if (filteredDates.value.isNotEmpty) {
            //                             filteredDates.value = List.empty();
            //                           }
            //                         },
            //                         child: const Padding(
            //                           padding:
            //                               EdgeInsets.symmetric(horizontal: 5),
            //                           child: Icon(
            //                             Icons.clear,
            //                             size: 16,
            //                           ),
            //                         ),
            //                       ),
            //                       SizedBox(
            //                         width: resources.dimen.dp5,
            //                       ),
            //                     ],
            //                   ),
            //                 );
            //               }),
            //         ],
            //       ),
            //       SizedBox(
            //         height: resources.dimen.dp30,
            //       ),
            //       InkWell(
            //         onTap: () {
            //           if (filteredDates.value.length == 2) {
            //             Navigator.of(context, rootNavigator: true)
            //                 .pop(filteredDates.value);
            //           }
            //         },
            //         child: ActionButtonWidget(
            //             text: resources.string.submit,
            //             radious: resources.dimen.dp15,
            //             textSize: resources.fontSize.dp10,
            //             padding: EdgeInsets.symmetric(
            //                 vertical: resources.dimen.dp5,
            //                 horizontal: resources.dimen.dp15),
            //             color: resources.color.sideBarItemSelected),
            //       ),
            //     ],
            //   ),
            //   maxWidth: 350,
            // ).then((value) async {
            //   if (value == null) {
            //     return;
            //   }
            //   if (context.mounted) {
            //     Dialogs.loader(context);
            //   }
            //   Future.delayed(const Duration(milliseconds: 200), () async {
            //     var dateFormat = DateFormat('dd-MMM-yyyy HH:mm');
            //     var startTime =
            //         DateFormat('yyyy/MM/dd').parse(filteredDates.value[0]);
            //     var endTime =
            //         DateFormat('yyyy/MM/dd').parse(filteredDates.value[1]);
            //     Map<String, dynamic> requestParams = {
            //       'ticketType': (_selectedCategory ?? 0) + 1,
            //       'category': (filteredData?['categories'] is List)
            //           ? (filteredData?['categories'].join(', '))
            //           : null,
            //       'department': (filteredData?['departments'] is List)
            //           ? (filteredData?['departments'].join(', '))
            //           : null,
            //       'status': (filteredData?['status'] is List)
            //           ? (filteredData?['status'].join(', '))
            //           : null,
            //       'startDate': dateFormat.format(startTime),
            //       'endDate': dateFormat.format(endTime),
            //     };
            //     final filterTickets = await _servicesBloc.getTticketsByUser(
            //         requestParams: requestParams);
            //     await _servicesBloc
            //         .exportToExcel(filterTickets.entity?.ticketsList ?? []);

            //     if (context.mounted) {
            //       Dialogs.dismiss(context);
            //     }
            //   });
            // });
          },
          child: ActionButtonWidget(
              text: resources.string.download,
              radious: resources.dimen.dp15,
              textSize: resources.fontSize.dp10,
              padding: EdgeInsets.symmetric(
                  vertical: resources.dimen.dp5,
                  horizontal: resources.dimen.dp15),
              color: resources.color.sideBarItemSelected),
        ),
        SizedBox(
          width: resources.dimen.dp10,
        ),
        InkWell(
          onTap: () {
            _printData(context);
          },
          child: ActionButtonWidget(
            text: resources.string.print,
            padding: EdgeInsets.symmetric(
                vertical: resources.dimen.dp5,
                horizontal: resources.dimen.dp15),
            radious: resources.dimen.dp15,
            textSize: resources.fontSize.dp10,
            color: resources.color.sideBarItemSelected,
          ),
        ),
      ],
    );
  }

  Future<void> _printData(BuildContext context) async {
    Dialogs.loader(context);
    final allTicketsResponse = await _servicesBloc.getTticketsByUser(
        requestParams: _getFilteredData(null));
    final allTickets = allTicketsResponse.entity?.ticketsList ?? [];
    List<String> headers = List.empty(growable: true);
    if (tickets.isNotEmpty) {
      tickets.first.toITCategotyPrintJson().forEach((k, v) {
        if (!headers.contains(k.capitalize())) {
          headers.add(k.capitalize());
        }
      });
    }
    String tableHeader = '<tr>';
    for (var item in headers) {
      tableHeader = '$tableHeader\n <td>$item</td>';
    }
    tableHeader = '$tableHeader\n</tr>';
    String tableBody = '';
    for (var item in allTickets) {
      tableBody = '$tableBody\n<tr>';
      item.toITCategotyPrintJson().forEach((k, v) {
        tableBody =
            '$tableBody\n <td>${k == 'TicketNo' ? '''<a href="${FlavorConfig.isProduction() ? "https://ithelpdesk.uaqgov.ae" : "http://localhost:50768"}/ticket/$v" target="_blank"> $v </a>''' : v}</td>';
      });
      tableBody = '$tableBody\n</tr>';
    }
    printData(
        title: "Tickets",
        headerData: tableHeader,
        bodyData: tableBody,
        count: allTickets.length);
    if (context.mounted) Dialogs.dismiss(context);
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

  _updateTickets(
    BuildContext context,
  ) async {
    if ((index ?? 0) == 0) {
      tickets.clear();
    }
    Dialogs.loader(context);
    final newTickets = await _servicesBloc.getTticketsByUser(
        requestParams: _getFilteredData(index ?? 0));
    if (context.mounted) {
      Dialogs.dismiss(context);
      tickets.addAll(newTickets.entity?.ticketsList ?? []);
      totalPagecount = newTickets.entity?.totalCount;
      _onFilterChange.value = !_onFilterChange.value;
    }
  }

  Map<String, dynamic> _getFilteredData(int? index) {
    String? startDate;
    String? endDate;
    if (filteredDates.value.isNotEmpty) {
      var dateFormat = DateFormat('dd-MMM-yyyy HH:mm');
      var startTime = DateFormat('yyyy/MM/dd').parse(filteredDates.value[0]);
      var endTime = DateFormat('yyyy/MM/dd').parse(filteredDates.value[1]);
      startDate = dateFormat.format(startTime);
      endDate = dateFormat.format(endTime);
    }
    Map<String, dynamic> requestParams = {
      'ticketType': (_selectedCategory ?? 0) + 1,
      'index': index,
      'category': (filteredData?['categories'] is List)
          ? (filteredData?['categories'].join(', '))
          : null,
      'department': (filteredData?['departments'] is List)
          ? (filteredData?['departments'].join(', '))
          : null,
      'status': (filteredData?['status'] is List)
          ? (filteredData?['status'].join(', '))
          : null,
      'startDate': startDate,
      'endDate': endDate,
    };
    return requestParams;
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    Future.delayed(Duration.zero, () {
      if (tickets.isEmpty && context.mounted) {
        _updateTickets(context);
      }
    });
    return SelectionArea(
      child: Scaffold(
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
                  ValueListenableBuilder(
                    valueListenable: _onFilterChange,
                    builder: (context, value, child) {
                      return ValueListenableBuilder(
                          valueListenable: _onFilterChange,
                          builder: (context, value, child) {
                            return ReportListWidget(
                              ticketsData: tickets,
                              showActionButtons: true,
                              pageIndex: (index ?? 0) + 1,
                              totalPagecount: totalPagecount ?? 0,
                              filters: filteredData,
                              onTicketSelected: (ticket) {
                                ViewRequest.start(context, ticket);
                              },
                              onFilterChange: (p0) {
                                filteredData = p0;
                                index = 0;
                                _updateTickets(context);
                              },
                              onPageChange: (page) {
                                index = (index ?? 0) + page;
                                if (page == 1 &&
                                    (index ?? 0) >= tickets.length / 20) {
                                  _updateTickets(context);
                                }
                              },
                            );
                          });
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
