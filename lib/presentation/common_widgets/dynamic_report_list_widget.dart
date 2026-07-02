// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/string_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/dynamic_report_column_config.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';

class DynamicReportListWidget extends StatelessWidget {
  final List<dynamic> reportData;
  final List<DynamicReportHeaderEntity> ticketsHeaderData;
  final Map<int, FlexColumnWidth>? ticketsTableColunwidths;
  final String? activeSortFieldKey;
  final bool sortAscending;
  final int page;
  final int? totalPagecount;
  final Function(int)? onPageChange;
  final Function(dynamic)? onRowSelected;
  final Function(String, dynamic)? onColumnClick;
  final Future<void> Function(
          BuildContext context, DynamicReportHeaderEntity header)?
      onColumnHeaderTap;

  const DynamicReportListWidget({
    required this.reportData,
    required this.ticketsHeaderData,
    this.ticketsTableColunwidths,
    this.activeSortFieldKey,
    this.sortAscending = true,
    this.onRowSelected,
    this.onColumnClick,
    this.onPageChange,
    this.onColumnHeaderTap,
    this.page = 1,
    this.totalPagecount,
    super.key,
  });

  IconData _getFilterOrSortIcon(DynamicReportHeaderEntity header) {
    if (header.hasFilter) {
      return Icons.filter_list;
    }
    if (header.hasSort) {
      if (activeSortFieldKey == header.resolvedFieldKey) {
        return sortAscending
            ? Icons.arrow_upward_sharp
            : Icons.arrow_downward_sharp;
      }
      return Icons.sort;
    }
    return Icons.sort;
  }

  List<Widget> _getTicketData(BuildContext context, dynamic rowEntity) {
    final rowJson = rowEntity.toJson() as Map<String, dynamic>;
    final list = List<Widget>.empty(growable: true);
    for (final header in ticketsHeaderData) {
      final key = header.label;
      final value = rowJson[key];
      list.add(
        InkWell(
          onTap: () {
            onRowSelected?.call(rowEntity);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
            child: Text(
              '${value ?? ''}',
              maxLines: 2,
              textAlign: list.isEmpty ? TextAlign.left : TextAlign.center,
              style: key == 'action'
                  ? context.textFontWeight600
                      .onFontSize(
                        context.resources.fontSize.dp10,
                      )
                      .onColor(context.resources.color.rejected)
                      .onFontFamily(
                          fontFamily: '${value ?? ''}'.getFontStyleByString())
                      .copyWith(decoration: TextDecoration.underline)
                  : context.textFontWeight600
                      .onFontSize(
                        context.resources.fontSize.dp10,
                      )
                      .onFontFamily(
                          fontFamily: '${value ?? ''}'.getFontStyleByString()),
            ),
          ),
        ),
      );
    }
    return list;
  }

  Widget _buildHeaderCell(BuildContext context, int index) {
    final resources = context.resources;
    final header = ticketsHeaderData[index];
    final headerStyle = context.textFontWeight600
        .onColor(resources.color.colorWhite)
        .onFontSize(resources.fontSize.dp10);
    final isInteractive =
        (header.hasFilter || header.hasSort) && onColumnHeaderTap != null;

    if (!isInteractive) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: resources.dimen.dp10,
          horizontal: resources.dimen.dp10,
        ),
        child: Text(
          header.toString(),
          textAlign: index == 0 ? TextAlign.left : TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: headerStyle,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: resources.dimen.dp10,
        horizontal: resources.dimen.dp10,
      ),
      child: InkWell(
        onTap: () => onColumnHeaderTap?.call(context, header),
        child: Text.rich(
          TextSpan(
            text: header.toString(),
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(
                  padding: isSelectedLocalEn
                      ? const EdgeInsets.only(left: 5.0)
                      : const EdgeInsets.only(right: 5.0),
                  child: Icon(
                    _getFilterOrSortIcon(header),
                    size: 16,
                    color: resources.color.colorWhite,
                  ),
                ),
              ),
            ],
          ),
          textAlign: index == 0 ? TextAlign.left : TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: headerStyle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Table(
            defaultColumnWidth: const IntrinsicColumnWidth(),
            columnWidths: ticketsTableColunwidths,
            children: [
              TableRow(
                decoration: BackgroundBoxDecoration(
                  boxColor: resources.color.colorGray9E9E9E,
                  boxBorder: Border(
                    top: BorderSide(
                      color: resources.color.appScaffoldBg,
                      width: 5,
                    ),
                    bottom: BorderSide(
                      color: resources.color.appScaffoldBg,
                      width: 5,
                    ),
                  ),
                ).roundedCornerBox,
                children: List.generate(
                  ticketsHeaderData.length,
                  (index) => _buildHeaderCell(context, index),
                ),
              ),
              for (var i = 0; i < reportData.length; i++) ...[
                TableRow(
                  decoration: BackgroundBoxDecoration(
                    boxColor: resources.color.colorWhite,
                    boxBorder: Border(
                      top: BorderSide(
                        color: resources.color.appScaffoldBg,
                        width: 5,
                      ),
                      bottom: BorderSide(
                        color: resources.color.appScaffoldBg,
                        width: 5,
                      ),
                    ),
                  ).roundedCornerBox,
                  children: _getTicketData(context, reportData[i]),
                ),
              ],
            ],
          ),
        ),
        if ((totalPagecount ?? 0) > 0)
          Container(
            margin: EdgeInsets.only(bottom: resources.dimen.dp20),
            decoration: BackgroundBoxDecoration(
              boxColor: resources.color.colorWhite,
              boxBorder: Border(
                top: BorderSide(
                  color: resources.color.appScaffoldBg,
                  width: 5,
                ),
                bottom: BorderSide(
                  color: resources.color.appScaffoldBg,
                  width: 5,
                ),
              ),
            ).roundedCornerBox,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: resources.dimen.dp5,
                horizontal: resources.dimen.dp5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      if (page > 1) {
                        onPageChange?.call(page - 1);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(resources.dimen.dp5),
                      child: Icon(
                        Icons.chevron_left_sharp,
                        color:
                            page == 1 ? resources.color.colorGray9E9E9E : null,
                      ),
                    ),
                  ),
                  Text(
                    '$page / $totalPagecount',
                    style: context.textFontWeight500
                        .onFontSize(resources.fontSize.dp12)
                        .onFontFamily(fontFamily: fontFamilyEN),
                  ),
                  InkWell(
                    onTap: () {
                      if (page < (totalPagecount ?? 0)) {
                        onPageChange?.call(page + 1);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(resources.dimen.dp5),
                      child: Icon(
                        Icons.chevron_right_sharp,
                        color: page < (totalPagecount ?? 0)
                            ? null
                            : resources.color.colorGray9E9E9E,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
