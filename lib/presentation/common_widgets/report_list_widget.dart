// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';

class TableColumn<T> {
  final String key;
  final String title;
  final double weight;
  final bool sortable;
  final int Function(T a, T b)? compare;
  final Future<void> Function()? onHeaderTap;
  final Widget Function(T item) cell;

  TableColumn({
    required this.key,
    required this.title,
    this.weight = 1,
    this.sortable = false,
    this.compare,
    this.onHeaderTap,
    required this.cell,
  });
}

Widget ticketTableCell(
  BuildContext context,
  dynamic value, {
  VoidCallback? onTap,
  bool numeric = false,
}) {
  final style = numeric
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
                      : fontFamilyEN);
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
      child: Text(
        '${value ?? ''}',
        textAlign: TextAlign.left,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style,
      ),
    ),
  );
}

class ReportListWidget<T> extends StatelessWidget {
  final List<T> ticketsData;
  final List<TableColumn<T>> columns;
  final int pageIndex;
  final int? totalPagecount;
  final Function(int)? onPageChange;

  ReportListWidget({
    required this.ticketsData,
    required this.columns,
    this.pageIndex = 1,
    this.totalPagecount,
    this.onPageChange,
    super.key,
  });

  final ValueNotifier<bool> _onSortChange = ValueNotifier(false);
  String? _sortKey;
  int _sortDir = -1;
  int page = 1;
  int pageCount = 20;

  Future<void> _onSort(TableColumn<T> column) async {
    if (_sortKey == column.key) {
      _sortDir = _sortDir == 1 ? 0 : 1;
    } else {
      _sortKey = column.key;
      _sortDir = 1;
    }
    page = 1;
    _onSortChange.value = !_onSortChange.value;
  }

  IconData _headerIcon(TableColumn<T> column) {
    if (!column.sortable) return Icons.filter_list;
    if (_sortKey != column.key) return Icons.sort;
    return _sortDir == 1
        ? Icons.arrow_upward_sharp
        : Icons.arrow_downward_sharp;
  }

  Widget _headerCell(BuildContext context, TableColumn<T> column) {
    final resources = context.resources;
    final style = context.textFontWeight600
        .onColor(resources.color.textColorLight)
        .onFontSize(resources.fontSize.dp10);
    final clickable = column.sortable || column.onHeaderTap != null;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: resources.dimen.dp10, horizontal: resources.dimen.dp10),
      child: !clickable
          ? Text(
              column.title,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: style,
            )
          : InkWell(
              onTap: () async {
                if (column.sortable) await _onSort(column);
                await column.onHeaderTap?.call();
              },
              child: Text.rich(
                TextSpan(text: column.title, children: [
                  WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Padding(
                        padding: isSelectedLocalEn
                            ? const EdgeInsets.only(left: 5.0)
                            : const EdgeInsets.only(right: 5.0),
                        child: Icon(
                          _headerIcon(column),
                          size: 16,
                        ),
                      ))
                ]),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: style,
              ),
            ),
    );
  }

  int _getPageCount(int cuttentpageCount) {
    if (cuttentpageCount == ticketsData.length) {
      return totalPagecount ?? cuttentpageCount;
    }
    return cuttentpageCount;
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    page = pageIndex;
    final columnWidths = {
      for (var i = 0; i < columns.length; i++)
        i: FlexColumnWidth(columns[i].weight),
    };
    return ValueListenableBuilder(
        valueListenable: _onSortChange,
        builder: (context, value, child) {
          var filteredData = List<T>.from(ticketsData);
          if (_sortKey != null) {
            TableColumn<T>? column;
            for (final item in columns) {
              if (item.key == _sortKey) {
                column = item;
                break;
              }
            }
            if (column?.compare != null) {
              filteredData.sort((a, b) {
                final result = column!.compare!(a, b);
                return _sortDir == 0 ? -result : result;
              });
            }
          }
          final startIndex = (page - 1) * pageCount;
          final currentPageData = filteredData.sublist(
              min(startIndex, filteredData.length),
              min(startIndex + 20, filteredData.length));
          return Column(
            children: [
              Table(
                columnWidths: columnWidths,
                children: [
                  TableRow(
                      children: columns
                          .map((column) => _headerCell(context, column))
                          .toList()),
                  for (final row in currentPageData) ...[
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
                        children:
                            columns.map((column) => column.cell(row)).toList()),
                  ],
                ],
              ),
              Container(
                  margin: EdgeInsets.only(
                    bottom: resources.dimen.dp20,
                  ),
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: resources.dimen.dp5,
                        horizontal: resources.dimen.dp5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            if (page > 1) {
                              page--;
                              onPageChange?.call(-1);
                              _onSortChange.value = !(_onSortChange.value);
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(resources.dimen.dp5),
                            child: Icon(
                              Icons.chevron_left_sharp,
                              color: page == 1
                                  ? resources.color.colorGray9E9E9E
                                  : null,
                            ),
                          ),
                        ),
                        Text(
                            '${min(page * pageCount, filteredData.length)} / ${_getPageCount(
                              filteredData.length,
                            )}',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: context.textFontWeight500
                                .onFontSize(resources.fontSize.dp12)
                                .onFontFamily(fontFamily: fontFamilyEN)),
                        InkWell(
                          onTap: () {
                            if (page * pageCount <
                                _getPageCount(filteredData.length)) {
                              page++;
                              if (page <= (filteredData.length / 20).ceil()) {
                                _onSortChange.value = !(_onSortChange.value);
                              }
                              if (ticketsData.length == filteredData.length) {
                                onPageChange?.call(1);
                              }
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(resources.dimen.dp5),
                            child: Icon(Icons.chevron_right_sharp,
                                color: page * pageCount <
                                        _getPageCount(filteredData.length)
                                    ? null
                                    : resources.color.colorGray9E9E9E),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          );
        });
  }
}
