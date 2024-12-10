// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/data/remote/api_urls.dart';
import 'package:ithelpdesk/domain/entities/dashboard_entity.dart';
import 'package:ithelpdesk/domain/entities/master_data_entities.dart';
import 'package:ithelpdesk/domain/entities/single_data_entity.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';
import '../../injection_container.dart';
import '../bloc/master_data/master_data_bloc.dart';
import 'multi_select_dialog_widget.dart';

class ReportListWidget extends StatelessWidget {
  final List<dynamic> ticketsData;
  final bool showActionButtons;
  final Function(TicketEntity)? onTicketSelected;
  ReportListWidget(
      {required this.ticketsData,
      this.showActionButtons = false,
      this.onTicketSelected,
      super.key});

  final ValueNotifier<bool> _onSortChange = ValueNotifier(false);
  int dateSort = -1;
  int prioritySort = -1;
  String sortBy = '';
  int page = 1;
  int pageCount = 20;
  final List<int> _selectedEmployees = List<int>.empty(growable: true);
  final List<int> _selectedDepartments = List<int>.empty(growable: true);
  final List<int> _selectedCategories = List<int>.empty(growable: true);
  final List<StatusType> _filteredStatus =
      List<StatusType>.empty(growable: true);
  final _masterDataBloc = sl<MasterDataBloc>();
  List<dynamic>? _employees;
  List<dynamic>? _departments;

  Future<List> _getEmpleyees() async {
    if (_employees != null) {
      return Future.value(_employees);
    }
    final result = await _masterDataBloc.getAssignedEmployees(
        requestParams: {}, apiUrl: assignedEmployeesByUserApiUrl);
    _employees = result.items;
    return Future.value(_employees);
  }

  Future<List> _getDepartments() async {
    if (_departments != null) {
      return Future.value(_departments);
    }
    final result = await _masterDataBloc.getDepartments(requestParams: {});
    _departments = result.items;
    final externalDpt = DepartmentEntity();
    externalDpt.id = 0;
    externalDpt.shortName = 'External';
    externalDpt.name = 'External';
    _departments?.add(externalDpt);
    return Future.value(_departments);
  }

  IconData _getFilerOrSortIcon(NameIDEntity tableColumn) {
    switch (tableColumn.id) {
      case 9:
        return (dateSort == 1
            ? Icons.arrow_upward_sharp
            : Icons.arrow_downward_sharp);
      case 6:
        return prioritySort == 1
            ? Icons.arrow_downward_sharp
            : Icons.arrow_upward_sharp;
      case 5:
        return Icons.filter_list;
      case 7:
        return Icons.filter_list;
      case 8:
        return Icons.filter_list;
      default:
        return Icons.sort;
    }
  }

  List<Widget> _getTicketData(BuildContext context, TicketEntity ticketEntity) {
    final list = List<Widget>.empty(growable: true);
    (isDesktop(context) ? ticketEntity.toJson() : ticketEntity.toMobileJson())
        .forEach((key, value) {
      list.add(
        InkWell(
          onTap: () {
            onTicketSelected?.call(ticketEntity);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
            child: Text(
              '$value',
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: (key.toString().toLowerCase().contains('date') ||
                      key.toString().toLowerCase().contains('id'))
                  ? context.textFontWeight600
                      .onFontSize(context.resources.fontSize.dp10)
                      .onFontFamily(fontFamily: fontFamilyEN)
                  : value is StatusType
                      ? context.textFontWeight600
                          .onFontSize(context.resources.fontSize.dp10)
                          .onColor(value.getColor())
                      : context.textFontWeight600
                          .onFontSize(context.resources.fontSize.dp10)
                          .onFontFamily(
                              fontFamily: isStringArabic(value.toString())
                                  ? fontFamilyAR
                                  : fontFamilyEN),
            ),
          ),
        ),
      );
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;

    final ticketsHeaderData = isDesktop(context)
        ? [
            NameIDEntity(1, resources.string.id),
            NameIDEntity(2, resources.string.employeeName),
            NameIDEntity(3, resources.string.category),
            NameIDEntity(4, resources.string.subject),
            NameIDEntity(5, resources.string.status),
            NameIDEntity(6, resources.string.priority),
            NameIDEntity(7, resources.string.assignee),
            NameIDEntity(8, resources.string.department),
            NameIDEntity(9, resources.string.createDate),
            NameIDEntity(9, resources.string.updateDate),
          ]
        : [
            NameIDEntity(1, resources.string.id),
            NameIDEntity(4, resources.string.subject),
            NameIDEntity(5, resources.string.status),
            NameIDEntity(6, resources.string.priority),
            NameIDEntity(9, resources.string.createDate),
            NameIDEntity(9, resources.string.createDate),
          ];
    final ticketsTableColunwidths = isDesktop(context)
        ? {
            0: const FlexColumnWidth(2),
            1: const FlexColumnWidth(3),
            2: const FlexColumnWidth(2),
            3: const FlexColumnWidth(3),
            4: const FlexColumnWidth(2),
            5: const FlexColumnWidth(2),
            6: const FlexColumnWidth(2),
            7: const FlexColumnWidth(2),
            8: const FlexColumnWidth(3),
            9: const FlexColumnWidth(3),
          }
        : {
            0: const FlexColumnWidth(2),
            1: const FlexColumnWidth(4),
            2: const FlexColumnWidth(2),
            3: const FlexColumnWidth(2),
            4: const FlexColumnWidth(2),
          };
    return ValueListenableBuilder(
        valueListenable: _onSortChange,
        builder: (context, value, child) {
          var filteredData = ticketsData;
          if (_selectedCategories.isNotEmpty) {
            filteredData = filteredData
                .where(
                    (item) => (_selectedCategories.contains(item.categoryID)))
                .toList();
          }
          if (_filteredStatus.isNotEmpty) {
            filteredData = filteredData
                .where((item) => (_filteredStatus.contains(item.status) ||
                    (_filteredStatus.contains(StatusType.notAssigned) &&
                        item.assignedUserID == null)))
                .toList();
          }
          if (_selectedEmployees.isNotEmpty) {
            filteredData = filteredData
                .where((item) =>
                    (_selectedEmployees.contains(item.assignedUserID)))
                .toList();
          }
          if (_selectedDepartments.isNotEmpty) {
            filteredData = filteredData
                .where((item) =>
                    (_selectedDepartments.contains(item.departmentID)))
                .toList();
          }
          if (sortBy == 'date') {
            filteredData.sort(
              (a, b) {
                int aDate =
                    getDateTimeByString('dd-MMM-yyyy HH:mm', a.createdOn)
                        .microsecondsSinceEpoch;
                int bDate =
                    getDateTimeByString('dd-MMM-yyyy HH:mm', b.createdOn)
                        .microsecondsSinceEpoch;
                return dateSort == 0
                    ? bDate.compareTo(aDate)
                    : aDate.compareTo(bDate);
              },
            );
          }
          if (sortBy == 'priority') {
            filteredData.sort(
              (a, b) {
                return prioritySort == 0
                    ? a.priority.value.compareTo(b.priority.value)
                    : b.priority.value.compareTo(a.priority.value);
              },
            );
          }
          final startIndex = (page - 1) * pageCount;
          final currentPageData = filteredData.sublist(
              startIndex, min(startIndex + 20, filteredData.length));
          return Table(
            columnWidths: ticketsTableColunwidths,
            children: [
              TableRow(
                  children: List.generate(
                      ticketsHeaderData.length,
                      (index) => Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: resources.dimen.dp10,
                                horizontal: resources.dimen.dp10),
                            child: (ticketsHeaderData[index].id == 9 ||
                                    ticketsHeaderData[index].id == 6 ||
                                    ticketsHeaderData[index].id == 5 ||
                                    ticketsHeaderData[index].id == 7 ||
                                    ticketsHeaderData[index].id == 3 ||
                                    ticketsHeaderData[index].id == 8)
                                ? InkWell(
                                    onTap: () async {
                                      if (ticketsHeaderData[index].id == 9) {
                                        sortBy = 'date';
                                        if (dateSort == 1) {
                                          dateSort = 0;
                                        } else {
                                          dateSort = 1;
                                        }
                                        page = 1;

                                        _onSortChange.value =
                                            !_onSortChange.value;
                                      } else if (ticketsHeaderData[index].id ==
                                          6) {
                                        sortBy = 'priority';
                                        if (prioritySort == 1) {
                                          prioritySort = 0;
                                        } else {
                                          prioritySort = 1;
                                        }
                                        page = 1;

                                        _onSortChange.value =
                                            !_onSortChange.value;
                                      } else if (ticketsHeaderData[index].id ==
                                          5) {
                                        Dialogs.showDialogWithClose(
                                                context,
                                                MultiSelectDialogWidget<
                                                    StatusType>(
                                                  list: getStatusTypes(),
                                                  selectedItems:
                                                      _filteredStatus,
                                                ),
                                                maxWidth: isDesktop(context)
                                                    ? 250
                                                    : null,
                                                showClose: false)
                                            .then((value) {
                                          if (value != null) {
                                            _filteredStatus.clear();
                                            _filteredStatus.addAll(value);
                                            page = 1;
                                            _onSortChange.value =
                                                !_onSortChange.value;
                                          }
                                        });
                                      } else if (ticketsHeaderData[index].id ==
                                          7) {
                                        final items = await _getEmpleyees();
                                        final selectedEmployees = items
                                            .where((item) => _selectedEmployees
                                                .contains(item.id))
                                            .toList();
                                        if (context.mounted) {
                                          Dialogs.showDialogWithClose(
                                                  context,
                                                  MultiSelectDialogWidget(
                                                    list: items,
                                                    selectedItems:
                                                        selectedEmployees,
                                                  ),
                                                  maxWidth: isDesktop(context)
                                                      ? 400
                                                      : null,
                                                  showClose: false)
                                              .then((value) {
                                            if (value != null) {
                                              _selectedEmployees.clear();
                                              final ids = (value as List)
                                                  .map((item) =>
                                                      (item.id ?? 0) as int)
                                                  .toList();
                                              _selectedEmployees.addAll(ids);
                                              page = 1;
                                              _onSortChange.value =
                                                  !_onSortChange.value;
                                            }
                                          });
                                        }
                                      } else if (ticketsHeaderData[index].id ==
                                          8) {
                                        final items = await _getDepartments();
                                        final selectedDepartments = items
                                            .where((item) =>
                                                _selectedDepartments
                                                    .contains(item.id))
                                            .toList();
                                        if (context.mounted) {
                                          Dialogs.showDialogWithClose(
                                                  context,
                                                  MultiSelectDialogWidget(
                                                    list: items,
                                                    selectedItems:
                                                        selectedDepartments,
                                                  ),
                                                  maxWidth: isDesktop(context)
                                                      ? 400
                                                      : null,
                                                  showClose: false)
                                              .then((value) {
                                            if (value != null) {
                                              _selectedDepartments.clear();
                                              final ids = (value as List)
                                                  .map((item) =>
                                                      (item.id ?? 0) as int)
                                                  .toList();
                                              _selectedDepartments.addAll(ids);
                                              page = 1;
                                              _onSortChange.value =
                                                  !_onSortChange.value;
                                            }
                                          });
                                        }
                                      } else if (ticketsHeaderData[index].id ==
                                          3) {
                                        final List<NameIDEntity> items = [
                                          NameIDEntity(1, "IT Support",
                                              nameAr: "الدعم الفني"),
                                          NameIDEntity(2, "ISO CR",
                                              nameAr: "نماذج طلبات التغيير"),
                                          NameIDEntity(3, "Eservices",
                                              nameAr: "الخدمات"),
                                          NameIDEntity(4, "Application",
                                              nameAr: "الانظمة"),
                                        ];
                                        final selectedCategories = items
                                            .where((item) => _selectedCategories
                                                .contains(item.id))
                                            .toList();
                                        if (context.mounted) {
                                          Dialogs.showDialogWithClose(
                                                  context,
                                                  MultiSelectDialogWidget(
                                                    list: items,
                                                    selectedItems:
                                                        selectedCategories,
                                                  ),
                                                  maxWidth: isDesktop(context)
                                                      ? 400
                                                      : null,
                                                  showClose: false)
                                              .then((value) {
                                            if (value != null) {
                                              _selectedCategories.clear();
                                              final ids = (value as List)
                                                  .map((item) =>
                                                      (item.id as int))
                                                  .toList();
                                              _selectedCategories.addAll(ids);
                                              page = 1;
                                              _onSortChange.value =
                                                  !_onSortChange.value;
                                            }
                                          });
                                        }
                                      }
                                    },
                                    child: Text.rich(
                                      TextSpan(
                                          text: ticketsHeaderData[index]
                                              .toString(),
                                          children: [
                                            WidgetSpan(
                                                alignment:
                                                    PlaceholderAlignment.middle,
                                                child: Padding(
                                                  padding: isSelectedLocalEn
                                                      ? const EdgeInsets.only(
                                                          left: 5.0)
                                                      : const EdgeInsets.only(
                                                          right: 5.0),
                                                  child: Icon(
                                                    _getFilerOrSortIcon(
                                                        ticketsHeaderData[
                                                            index]),
                                                    size: 16,
                                                  ),
                                                ))
                                          ]),
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.textFontWeight600
                                          .onColor(
                                              resources.color.textColorLight)
                                          .onFontSize(resources.fontSize.dp10),
                                    ),
                                  )
                                : Text(
                                    ticketsHeaderData[index].toString(),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.textFontWeight600
                                        .onColor(resources.color.textColorLight)
                                        .onFontSize(resources.fontSize.dp10),
                                  ),
                          ))),
              for (var i = 0; i < currentPageData.length; i++) ...[
                TableRow(
                    decoration: BackgroundBoxDecoration(
                            boxColor: resources.color.colorWhite,
                            boxBorder: Border(
                                top: BorderSide(
                                    color: resources.color.appScaffoldBg,
                                    width: 5),
                                bottom: BorderSide(
                                    color: resources.color.appScaffoldBg,
                                    width: 5)))
                        .roundedCornerBox,
                    children: _getTicketData(context, currentPageData[i])),
              ],
              TableRow(
                  decoration: BackgroundBoxDecoration(
                          boxColor: resources.color.colorWhite,
                          boxBorder: Border(
                              top: BorderSide(
                                  color: resources.color.appScaffoldBg,
                                  width: 5),
                              bottom: BorderSide(
                                  color: resources.color.appScaffoldBg,
                                  width: 5)))
                      .roundedCornerBox,
                  children: List.generate(ticketsHeaderData.length, (index) {
                    return index < ticketsHeaderData.length - 1
                        ? const SizedBox()
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: resources.dimen.dp5,
                                horizontal: resources.dimen.dp5),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (page > 1) {
                                      page--;
                                      _onSortChange.value =
                                          !(_onSortChange.value);
                                    }
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.all(resources.dimen.dp5),
                                    child: Icon(
                                      Icons.chevron_left_sharp,
                                      color: page == 1
                                          ? resources.color.colorGray9E9E9E
                                          : null,
                                    ),
                                  ),
                                ),
                                Text(
                                    '${min(page * pageCount, filteredData.length)} / ${filteredData.length}',
                                    style: context.textFontWeight500
                                        .onFontSize(resources.fontSize.dp12)
                                        .onFontFamily(
                                            fontFamily: fontFamilyEN)),
                                InkWell(
                                  onTap: () {
                                    if (page * pageCount <
                                        (filteredData.length)) {
                                      page++;
                                      _onSortChange.value =
                                          !(_onSortChange.value);
                                    }
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.all(resources.dimen.dp5),
                                    child: Icon(Icons.chevron_right_sharp,
                                        color: page * pageCount <
                                                (filteredData.length)
                                            ? null
                                            : resources.color.colorGray9E9E9E),
                                  ),
                                ),
                              ],
                            ),
                          );
                  })),
            ],
          );
        });
  }
}
