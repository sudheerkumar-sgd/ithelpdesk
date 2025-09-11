// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';

class DynamicReportListWidget extends StatelessWidget {
  final List<dynamic> reportData;
  final List<String> ticketsHeaderData;
  final Map<int, FlexColumnWidth>? ticketsTableColunwidths;
  final int page;
  final int? totalPagecount;
  final Function(int)? onPageChange;
  final Function(dynamic)? onRowSelected;
  final Function(String, dynamic)? onColumnClick;
  const DynamicReportListWidget({
    required this.reportData,
    required this.ticketsHeaderData,
    this.ticketsTableColunwidths,
    this.onRowSelected,
    this.onColumnClick,
    this.page = 1,
    this.totalPagecount,
    this.onPageChange,
    super.key,
  });

  List<Widget> _getTicketData(BuildContext context, dynamic rowEntity) {
    final list = List<Widget>.empty(growable: true);
    rowEntity.toJson().forEach((key, value) {
      list.add(
        InkWell(
          onTap: () {
            onRowSelected?.call(rowEntity);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
            child: Text(
              '$value',
              maxLines: 2,
              textAlign: list.isEmpty ? TextAlign.left : TextAlign.center,
              style: key == 'action'
                  ? context.textFontWeight600
                      .onFontSize(
                        context.resources.fontSize.dp10,
                      )
                      .onColor(context.resources.color.rejected)
                      .copyWith(decoration: TextDecoration.underline)
                  : context.textFontWeight600.onFontSize(
                      context.resources.fontSize.dp10,
                    ),
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

    //final ticketsHeaderData = ['District', 'Mandal', 'Name', 'Action'];
    // final ticketsTableColunwidths = {
    //   0: const FlexColumnWidth(4),
    //   1: const FlexColumnWidth(4),
    //   2: const FlexColumnWidth(4),
    //   3: const FlexColumnWidth(4),
    // };
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
                  (index) => Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: resources.dimen.dp10,
                      horizontal: resources.dimen.dp10,
                    ),
                    child: Text(
                      ticketsHeaderData[index].toString(),
                      textAlign: index == 0 ? TextAlign.left : TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: context.textFontWeight600
                          .onColor(resources.color.colorWhite)
                          .onFontSize(resources.fontSize.dp10),
                    ),
                  ),
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
