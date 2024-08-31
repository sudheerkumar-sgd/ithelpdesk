import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/domain/entities/dashboard_entity.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';

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
          if (prioritySort != -1) {
            ticketsData.sort(
              (a, b) {
                return prioritySort == 0
                    ? a.priority.value.compareTo(b.priority.value)
                    : b.priority.value.compareTo(a.priority.value);
              },
            );
          }
          if (dateSort != -1) {
            ticketsData.sort(
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
          // return LayoutBuilder(builder: (context, constraints) {
          //   return SizedBox(
          //     width: constraints.maxWidth,
          //     child: PaginatedDataTable(
          //         columnSpacing: 0,
          //         rowsPerPage: min(ticketsData.length, 10),
          //         columns: List.generate(ticketsHeaderData.length, (index) {
          //           return DataColumn(
          //               onSort: (columnIndex, ascending) {},
          //               label: (ticketsHeaderData[index] == 'CreateDate' ||
          //                       ticketsHeaderData[index] == 'Priority')
          //                   ? InkWell(
          //                       onTap: () {
          //                         if (ticketsHeaderData[index] ==
          //                             'CreateDate') {
          //                           if (dateSort == 1) {
          //                             dateSort = 0;
          //                           } else {
          //                             dateSort = 1;
          //                           }
          //                         } else if (ticketsHeaderData[index] ==
          //                             'Priority') {
          //                           if (prioritySort == 1) {
          //                             prioritySort = 0;
          //                           } else {
          //                             prioritySort = 1;
          //                           }
          //                         }
          //                         _onSortChange.value = !_onSortChange.value;
          //                       },
          //                       child: Text.rich(
          //                         TextSpan(
          //                             text: ticketsHeaderData[index],
          //                             children: [
          //                               WidgetSpan(
          //                                   alignment:
          //                                       PlaceholderAlignment.middle,
          //                                   child: Padding(
          //                                     padding: const EdgeInsets.only(
          //                                         left: 5.0),
          //                                     child: Icon(
          //                                       ticketsHeaderData[index] ==
          //                                               'CreateDate'
          //                                           ? (dateSort == 1
          //                                               ? Icons
          //                                                   .arrow_upward_sharp
          //                                               : Icons
          //                                                   .arrow_downward_sharp)
          //                                           : (prioritySort == 1
          //                                               ? Icons
          //                                                   .arrow_downward_sharp
          //                                               : Icons
          //                                                   .arrow_upward_sharp),
          //                                       size: 16,
          //                                     ),
          //                                   ))
          //                             ]),
          //                         textAlign: TextAlign.center,
          //                         style: context.textFontWeight600
          //                             .onColor(resources.color.textColorLight)
          //                             .onFontSize(resources.fontSize.dp10),
          //                       ),
          //                     )
          //                   : Text(
          //                       ticketsHeaderData[index],
          //                       textAlign: TextAlign.center,
          //                       style: context.textFontWeight600
          //                           .onColor(resources.color.textColorLight)
          //                           .onFontSize(resources.fontSize.dp10),
          //                     ));
          //         }),
          //         source: _DataSource(
          //             context: context,
          //             data: ticketsData,
          //             onTicketSelected: onTicketSelected)),
          //   );
          // });
          //});
          return Table(
            columnWidths: ticketsTableColunwidths,
            children: [
              TableRow(
                  children: List.generate(
                      ticketsHeaderData.length,
                      (index) => Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: resources.dimen.dp10),
                            child: (ticketsHeaderData[index] == 'CreateDate' ||
                                    ticketsHeaderData[index] == 'Priority')
                                ? InkWell(
                                    onTap: () {
                                      if (ticketsHeaderData[index] ==
                                          'CreateDate') {
                                        if (dateSort == 1) {
                                          dateSort = 0;
                                        } else {
                                          dateSort = 1;
                                        }
                                      } else if (ticketsHeaderData[index] ==
                                          'Priority') {
                                        if (prioritySort == 1) {
                                          prioritySort = 0;
                                        } else {
                                          prioritySort = 1;
                                        }
                                      }
                                      _onSortChange.value =
                                          !_onSortChange.value;
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
                                                    ticketsHeaderData[index] ==
                                                            'CreateDate'
                                                        ? (dateSort == 1
                                                            ? Icons
                                                                .arrow_upward_sharp
                                                            : Icons
                                                                .arrow_downward_sharp)
                                                        : (prioritySort == 1
                                                            ? Icons
                                                                .arrow_downward_sharp
                                                            : Icons
                                                                .arrow_upward_sharp),
                                                    size: 16,
                                                  ),
                                                ))
                                          ]),
                                      textAlign: TextAlign.left,
                                      style: context.textFontWeight600
                                          .onColor(
                                              resources.color.textColorLight)
                                          .onFontSize(resources.fontSize.dp10),
                                    ),
                                  )
                                : Text(
                                    ticketsHeaderData[index],
                                    textAlign: TextAlign.center,
                                    style: context.textFontWeight600
                                        .onColor(resources.color.textColorLight)
                                        .onFontSize(resources.fontSize.dp10),
                                  ),
                          ))),
              for (var i = 0; i < ticketsData.length; i++) ...[
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
                    children: _getTicketData(context, ticketsData[i])),
              ]
            ],
          );
        });
  }
}

class _DataSource extends DataTableSource {
  final BuildContext context;
  final List<dynamic> data;
  final Function(TicketEntity)? onTicketSelected;

  _DataSource(
      {required this.context, required this.data, this.onTicketSelected});

  @override
  DataRow? getRow(int index) {
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
    if (index >= data.length) {
      return null;
    }

    final item = data[index];

    return DataRow(
        cells: _getTicketData(context, item,
            ((ticketsTableColunwidths[index]?.value) ?? 1).toInt()));
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;

  List<DataCell> _getTicketData(
      BuildContext context, TicketEntity ticketEntity, int width) {
    final list = List<DataCell>.empty(growable: true);
    (isDesktop(context) ? ticketEntity.toJson() : ticketEntity.toMobileJson())
        .forEach((key, value) {
      list.add(DataCell(
        Flexible(
          flex: width,
          child: InkWell(
            onTap: () {
              onTicketSelected?.call(ticketEntity);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Text(
                '$value',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: (key.toString().toLowerCase().contains('date') ||
                        key.toString().toLowerCase().contains('id'))
                    ? context.textFontWeight600
                        .onFontSize(context.resources.fontSize.dp10)
                        .onFontFamily(fontFamily: fontFamilyEN)
                    : context.textFontWeight600
                        .onFontSize(context.resources.fontSize.dp10),
              ),
            ),
          ),
        ),
      ));
    });
    return list;
  }
}
