// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/domain/entities/dashboard_entity.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';

import 'multi_select_dialog_widget.dart';

class ReportListWidget extends StatelessWidget {
  final List<String> ticketsHeaderData;
  final List<dynamic> ticketsData;
  final Map<int, FlexColumnWidth>? ticketsTableColunwidths;
  final bool showActionButtons;
  final Function(TicketEntity)? onTicketSelected;
  ReportListWidget(
      {required this.ticketsHeaderData,
      required this.ticketsData,
      this.ticketsTableColunwidths,
      this.showActionButtons = false,
      this.onTicketSelected,
      super.key});

  final ValueNotifier<bool> _onSortChange = ValueNotifier(false);
  int dateSort = -1;
  int prioritySort = -1;
  String sortBy = '';
  int page = 1;
  int pageCount = 20;
  List<StatusType> filteredStatus = List<StatusType>.empty(growable: true);

  IconData _getFilerOrSortIcon(String tableColumn) {
    switch (tableColumn.toLowerCase()) {
      case 'createdate':
        return (dateSort == 1
            ? Icons.arrow_upward_sharp
            : Icons.arrow_downward_sharp);
      case 'priority':
        return prioritySort == 1
            ? Icons.arrow_downward_sharp
            : Icons.arrow_upward_sharp;
      case 'status':
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
                          .onFontSize(context.resources.fontSize.dp10),
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

    return ValueListenableBuilder(
        valueListenable: _onSortChange,
        builder: (context, value, child) {
          var filteredData = ticketsData;
          if (filteredStatus.isNotEmpty) {
            filteredData = filteredData
                .where((item) => (filteredStatus.contains(item.status) ||
                    (filteredStatus.contains(StatusType.notAssigned) &&
                        item.assignedUserID == null)))
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
                            child: (ticketsHeaderData[index] == 'CreateDate' ||
                                    ticketsHeaderData[index] == 'Priority' ||
                                    ticketsHeaderData[index] == 'Status')
                                ? InkWell(
                                    onTap: () {
                                      if (ticketsHeaderData[index] ==
                                          'CreateDate') {
                                        sortBy = 'date';
                                        if (dateSort == 1) {
                                          dateSort = 0;
                                        } else {
                                          dateSort = 1;
                                        }
                                        page = 1;

                                        _onSortChange.value =
                                            !_onSortChange.value;
                                      } else if (ticketsHeaderData[index] ==
                                          'Priority') {
                                        sortBy = 'priority';
                                        if (prioritySort == 1) {
                                          prioritySort = 0;
                                        } else {
                                          prioritySort = 1;
                                        }
                                        page = 1;

                                        _onSortChange.value =
                                            !_onSortChange.value;
                                      } else if (ticketsHeaderData[index] ==
                                          'Status') {
                                        Dialogs.showDialogWithClose(
                                                context,
                                                MultiSelectDialogWidget<
                                                    StatusType>(
                                                  list: getStatusTypes(),
                                                  selectedItems: filteredStatus,
                                                ),
                                                maxWidth: isDesktop(context)
                                                    ? 250
                                                    : null,
                                                showClose: false)
                                            .then((value) {
                                          if (value != null) {
                                            filteredStatus.clear();
                                            filteredStatus.addAll(value);
                                            page = 1;
                                            _onSortChange.value =
                                                !_onSortChange.value;
                                          }
                                        });
                                      }
                                    },
                                    child: Text.rich(
                                      TextSpan(
                                          text: ticketsHeaderData[index],
                                          children: [
                                            WidgetSpan(
                                                alignment:
                                                    PlaceholderAlignment.middle,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0),
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
                                    ticketsHeaderData[index],
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
