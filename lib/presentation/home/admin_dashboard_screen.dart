// ignore_for_file: must_be_immutable
import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/data/remote/api_urls.dart';
import 'package:ithelpdesk/domain/entities/dashboard_entity.dart';
import 'package:ithelpdesk/domain/entities/user_credentials_entity.dart';
import 'package:ithelpdesk/injection_container.dart';
import 'package:ithelpdesk/presentation/bloc/services/services_bloc.dart';
import 'package:ithelpdesk/presentation/common_widgets/barchart_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dropdown_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/my_custom_scrollbehavior.dart';
import 'package:ithelpdesk/presentation/common_widgets/tooltip_widget.dart';
import 'package:ithelpdesk/presentation/requests/view_request.dart';
import 'package:ithelpdesk/presentation/utils/date_time_util.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';
import 'package:ithelpdesk/res/drawables/drawable_assets.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late FocusNode requestStatusFocusNode;

  final ServicesBloc _servicesBloc = sl<ServicesBloc>();

  DashboardEntity? _dashboardEntity;

  final ValueNotifier<bool> _onDataChange = ValueNotifier(false);

  List<Map<String, Object>> _requestTypes = [];

  List<TicketEntity> ticketsData = [];

  int selectTicketCategory = 1;

  DashboardFilterEnum _selectedFilter = DashboardFilterEnum.current;

  final ValueNotifier<bool> _onDateRangeChange = ValueNotifier(false);

  StatusType filteredStatus = StatusType.all;

  DateTime? startDate;
  DateTime? endDate;

  TextAlign getAlign(int i, int length) {
    if (length == 2) {
      return i == 0 ? TextAlign.start : TextAlign.end;
    }

    // default behavior for other lengths
    final middle = (length / 2).floor();

    return (i == middle)
        ? TextAlign.center
        : (i < middle ? TextAlign.start : TextAlign.end);
  }

  Widget getLineChart(
      BuildContext context, List<TicketsByMonthEntity> ticketsByMonthEntity) {
    final resources = context.resources;
    final lineChartData = List<FlSpot>.empty(growable: true);
    final tilesData = List<Widget>.empty(growable: true);
    // if (_selectedFilter.value == DashboardFilterEnum.week) {
    //   for (var i = 0; i < ticketsByMonthEntity.length; i++) {
    //     lineChartData
    //         .add(FlSpot(i + 1.toDouble(), ticketsByMonthEntity[i].count ?? 0));
    //     tilesData.add(Expanded(
    //       child: Text(
    //           textAlign: getAlign(i, ticketsByMonthEntity.length),
    //           weekDayName((ticketsByMonthEntity[i].month?.toInt() ?? 1))),
    //     ));
    //   }
    // } else

    if (_selectedFilter == DashboardFilterEnum.current ||
        _selectedFilter == DashboardFilterEnum.month) {
      for (var i = 0; i < ticketsByMonthEntity.length; i++) {
        lineChartData.add(FlSpot(
            double.parse('${i + 1}'), ticketsByMonthEntity[i].count ?? 0));
        tilesData.add(Expanded(
          child: Text(
              textAlign: getAlign(i, ticketsByMonthEntity.length),
              '${ticketsByMonthEntity[i].month?.toInt() ?? 1}'),
        ));
      }
    } else {
      for (var i = 0; i < ticketsByMonthEntity.length; i++) {
        // final currentMonth = DateTime.now().month;
        // final startMonth = ((currentMonth + i) % 12) + 1;
        // final monthData = ticketsByMonthEntity
        //     .where((month) => month.month == startMonth)
        //     .firstOrNull;
        // if (monthData != null) {
        lineChartData.add(FlSpot(
            double.parse('${i + 1}'), ticketsByMonthEntity[i].count ?? 0));
        tilesData.add(Expanded(
          child: Text(
              textAlign: getAlign(i, ticketsByMonthEntity.length),
              (_selectedFilter == DashboardFilterEnum.custom &&
                      getDays(startDate ?? DateTime.now(),
                              endDate ?? DateTime.now()) <=
                          31)
                  ? '${ticketsByMonthEntity[i].month?.toInt() ?? 1}'
                  : monthName((ticketsByMonthEntity[i].month?.toInt() ?? 1))),
        ));
        // }
        //  else {
        //   lineChartData.add(FlSpot(double.parse('${i + 1}'), 0));
        //   tilesData.add(Expanded(
        //     child: Text(textAlign: TextAlign.right, monthName(startMonth)),
        //   ));
        // }
      }
    }
    final maxValue = ticketsByMonthEntity.isEmpty
        ? 0
        : ticketsByMonthEntity
            .map((e) => e.count ?? 0)
            .reduce((a, b) => a > b ? a : b);
    return Container(
      height: 350,
      padding: EdgeInsets.all(resources.dimen.dp15),
      decoration: BackgroundBoxDecoration(
              boxColor: resources.color.colorWhite,
              radious: resources.dimen.dp10)
          .roundedBoxWithShadow,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: resources.string.ticketsSummary,
                    style: context.textFontWeight600
                        .onFontSize(resources.fontSize.dp12),
                    //children: [
                    // TextSpan(
                    //     text: '${resources.string.ticketsSummaryDes}\n',
                    //     style: context.textFontWeight400
                    //         .onFontSize(resources.fontSize.dp10)
                    //         .onColor(resources.color.textColorLight)
                    //         .onHeight(1))
                    //]
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: resources.dimen.dp20,
          ),
          Expanded(
            child: LineChart(
              LineChartData(
                baselineY: 0,
                minY: 0,
                gridData: const FlGridData(show: false),
                backgroundColor: resources.color.colorWhite,
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 10,
                    getTooltipColor: (touchedSpot) {
                      return context.resources.color.dashboardSecondary;
                    },
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        return LineTooltipItem(
                          touchedSpot.y.ceil().toString(),
                          context.textFontWeight600
                              .onColor(Colors.white)
                              .onFontSize(12)
                              .onFontFamily(fontFamily: fontFamilyEN),
                        );
                      }).toList();
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40, // ✅ Gives enough space for numbers
                        interval: maxValue > 400
                            ? 100
                            : maxValue > 200
                                ? 50
                                : maxValue >= 100
                                    ? 20
                                    : maxValue > 20
                                        ? 10
                                        : maxValue >= 6
                                            ? 2
                                            : 1, // ✅ Controls vertical distance between labels
                        getTitlesWidget: (value, meta) {
                          if (value == meta.max) return const SizedBox();
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Text(
                              value.toInt().toString(),
                              style: context.textFontWeight400
                                  .onFontSize(resources.fontSize.dp12)
                                  .onFontFamily(fontFamily: fontFamilyEN),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(),
                    rightTitles: const AxisTitles(),
                    bottomTitles: AxisTitles(
                      axisNameWidget: Padding(
                        padding:
                            EdgeInsetsGeometry.only(left: resources.dimen.dp40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: tilesData,
                        ),
                      ),
                    )),
                borderData: FlBorderData(
                    show: true,
                    border: const Border(
                        left: BorderSide(color: Color(0XFFD1DAE2)),
                        bottom: BorderSide(color: Color(0XFFD1DAE2)))),
                lineBarsData: [
                  LineChartBarData(
                      color: const Color(0xFF3E76EE),
                      show: true,
                      spots: lineChartData,
                      preventCurveOvershootingThreshold: 12,
                      isCurved: true,
                      preventCurveOverShooting: true,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            resources.color.dashboardSecondary
                                .withAlpha((0.3 * 255).toInt()),
                            resources.color.dashboardSecondary
                                .withAlpha((0.05 * 255).toInt()),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      barWidth: 2),
                ],
              ), // Optional
            ),
          ),
        ],
      ),
    );
  }

  Widget getPieChart(BuildContext context,
      List<TicketsByCategoryEntity> ticketsByCategoryEntity) {
    final resources = context.resources;
    final categoryData = List.empty(growable: true);
    var totalCount = 0;
    for (var i = 0; i < ticketsByCategoryEntity.length; i++) {
      switch (ticketsByCategoryEntity[i].category) {
        case 1:
          {
            var item = {
              'name': resources.string.support,
              'count': ticketsByCategoryEntity[i].count ?? 0,
              'color': const Color(0xFF7685FB)
            };
            categoryData.add(item);
            totalCount = (ticketsByCategoryEntity[i].count ?? 0) + totalCount;
          }
        case 2:
          {
            var item = {
              'name': resources.string.itRequests,
              'count': ticketsByCategoryEntity[i].count ?? 0,
              'color': const Color(0xFF7685FB)
            };
            categoryData.add(item);
            totalCount = (ticketsByCategoryEntity[i].count ?? 0) + totalCount;
          }
        case 3:
          {
            var item = {
              'name': resources.string.eservices,
              'count': ticketsByCategoryEntity[i].count ?? 0,
              'color': const Color(0xFF344BFD)
            };
            categoryData.add(item);
            totalCount = (ticketsByCategoryEntity[i].count ?? 0) + totalCount;
          }
        case 4:
          {
            var item = {
              'name': resources.string.application,
              'count': ticketsByCategoryEntity[i].count ?? 0,
              'color': const Color(0xFF102559)
            };
            categoryData.add(item);
            totalCount = (ticketsByCategoryEntity[i].count ?? 0) + totalCount;
          }
      }
    }
    return Container(
      height: 275,
      width: double.infinity,
      decoration: BackgroundBoxDecoration(
              boxColor: resources.color.colorWhite,
              radious: resources.dimen.dp10)
          .roundedBoxWithShadow,
      padding: EdgeInsets.all(resources.dimen.dp15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isSelectedLocalEn ? 'By Category' : 'حسب الفئة',
            style:
                context.textFontWeight600.onFontSize(resources.fontSize.dp12),
          ),
          SizedBox(
            height: resources.dimen.dp10,
          ),
          Expanded(
            child: PieChart(
              PieChartData(
                borderData: FlBorderData(
                    show: true,
                    border: Border(
                        left: BorderSide(
                            color: resources.color.sideBarItemUnselected),
                        bottom: BorderSide(
                            color: resources.color.sideBarItemUnselected))),
                sections: List.generate(categoryData.length, (index) {
                  final percentage =
                      (((categoryData[index]['count'] as int) / totalCount) *
                              100)
                          .round();
                  return PieChartSectionData(
                      radius: 25,
                      value: percentage > 0
                          ? (categoryData[index]['count'] ?? 0) as double
                          : 0,
                      color: (categoryData[index]['color'] ?? Colors.yellow)
                          as Color,
                      title:
                          '${((categoryData[index]['count'] / totalCount) * 100).toStringAsFixed(0)}%',
                      titleStyle: context.textFontWeight600
                          .onFontSize(10)
                          .onFontFamily(fontFamily: fontFamilyEN)
                          .onColor(resources.color.colorWhite));
                }),
              ), // Optional
            ),
          ),
          SizedBox(
            height: resources.dimen.dp20,
          ),
          Row(
            children: List.generate(categoryData.length, (index) {
              final percentage =
                  (((categoryData[index]['count'] as int) / totalCount) * 100)
                      .round();
              return percentage > 0
                  ? Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text.rich(
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  TextSpan(
                                      text: '$percentage%\n'.toString(),
                                      style: context.textFontWeight700
                                          .onFontSize(resources.fontSize.dp12)
                                          .onFontFamily(
                                              fontFamily: fontFamilyEN),
                                      children: [
                                        TextSpan(
                                            text: categoryData[index]['name']
                                                .toString(),
                                            style: context.textFontWeight400
                                                .onFontSize(
                                                    resources.fontSize.dp10))
                                      ])),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            }),
          ),
        ],
      ),
    );
  }

  Widget _getByPriorityWidget(List<TicketsByCategoryEntity> ticketsByPriority) {
    final resources = context.resources;
    final maxValue = ticketsByPriority.isEmpty
        ? 0
        : ticketsByPriority
            .map((e) => e.count ?? 0)
            .reduce((a, b) => a > b ? a : b);
    return Container(
      height: 275,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: resources.dimen.dp20, vertical: resources.dimen.dp15),
      decoration: BackgroundBoxDecoration(
        boxColor: resources.color.colorWhite,
        radious: resources.dimen.dp10,
      ).roundedBoxWithShadow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isSelectedLocalEn ? 'By Priority' : 'حسب الأولوية',
            maxLines: 1,
            style: context.textFontWeight600.onFontSize(
              resources.fontSize.dp12,
            ),
          ),
          SizedBox(
            height: resources.dimen.dp10,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (int i = 0; i < ticketsByPriority.length; i++)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Count bubble
                        TooltipWidget(text: '${ticketsByPriority[i].count}'),

                        const SizedBox(height: 6),

                        // Animated Bar
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOut,
                          height: maxValue == 0
                              ? 0
                              : ((ticketsByPriority[i].count ?? 0) / maxValue) *
                                  (275 * 0.55),
                          width: 24,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(18)),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                resources.color.dashboardSecondary
                                    .withAlpha(50),
                                resources.color.dashboardSecondary
                                    .withAlpha(255),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Label
                        Text(
                          PriorityType.fromId(
                                  ticketsByPriority[i].category ?? 1)
                              .toString(),
                          maxLines: 1,
                          style: context.textFontWeight600.onFontSize(10),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getByIssutypeWidget(List<TicketsByCategoryEntity> ticketsByIssutype) {
    final resources = context.resources;
    return Container(
        height: 275,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            horizontal: resources.dimen.dp20, vertical: resources.dimen.dp15),
        decoration: BackgroundBoxDecoration(
          boxColor: resources.color.colorWhite,
          radious: resources.dimen.dp10,
        ).roundedBoxWithShadow,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isSelectedLocalEn ? 'By Issue Type' : 'حسب نوع المشكلة',
              style: context.textFontWeight600.onFontSize(
                resources.fontSize.dp12,
              ),
            ),
            SizedBox(
              height: resources.dimen.dp10,
            ),
            for (int i = 0; i < ticketsByIssutype.length; i++)
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  margin: EdgeInsets.only(bottom: resources.dimen.dp5),
                  decoration: BackgroundBoxDecoration(
                          boxColor: Colors.white,
                          radious: 8,
                          shadowColor: Colors.black.withAlpha(15),
                          shadowBlurRadius: 8,
                          shadowOffset: const Offset(0, 2))
                      .roundedCornerBoxWithShadow,
                  child: Row(children: [
                    Expanded(
                      child: Text(
                          IssueType.fromId(ticketsByIssutype[i].category ?? 1)
                              .toString(),
                          maxLines: 1,
                          style: context.textFontWeight700
                              .onFontSize(resources.fontSize.dp8)
                              .onColor(const Color(0xFF14213D))),
                    ),
                    Text('${ticketsByIssutype[i].count ?? 0}',
                        maxLines: 1,
                        style: context.textFontWeight700
                            .onFontSize(resources.fontSize.dp10)
                            .onColor(resources.color.dashboardSecondary)
                            .onFontFamily(fontFamily: fontFamilyEN)),
                  ]),
                ),
              )
          ],
        ));
  }

  Widget _getByOpenDayWidget(List<TicketsByCategoryEntity> ticketsByOpenDay) {
    final resources = context.resources;
    final lables = ticketsByOpenDay.isEmpty
        ? [].cast<String>()
        : ticketsByOpenDay
            .map((e) => e.getOpendayDisplayName().toString())
            .toList();
    final values = ticketsByOpenDay.isEmpty
        ? [].cast<double>()
        : ticketsByOpenDay.map((e) => e.count as double).toList();
    return Container(
      height: 275,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: resources.dimen.dp20, vertical: resources.dimen.dp15),
      decoration: BackgroundBoxDecoration(
        boxColor: resources.color.colorWhite,
        radious: resources.dimen.dp10,
      ).roundedBoxWithShadow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isSelectedLocalEn ? 'By Open Day' : 'حسب يوم الفتح',
            style: context.textFontWeight600.onFontSize(
              resources.fontSize.dp12,
            ),
          ),
          SizedBox(
            height: resources.dimen.dp20,
          ),
          Expanded(
            child: lables.isEmpty
                ? const SizedBox()
                : BarchartWidget(
                    bottomLables: lables,
                    values: values,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _getDelayedCasesWidget(List<TicketEntity> delayedTickets) {
    final resources = context.resources;
    final pageController = PageController(initialPage: 0);
    ValueNotifier pageIndex = ValueNotifier(0);
    return Container(
        height: 200,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            horizontal: resources.dimen.dp20, vertical: resources.dimen.dp15),
        decoration: BackgroundBoxDecoration(
          boxColor: resources.color.colorWhite,
          radious: resources.dimen.dp10,
        ).roundedBoxWithShadow,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isSelectedLocalEn ? 'Delayed Cases' : 'الحالات المتأخرة',
              style: context.textFontWeight600
                  .onFontSize(
                    resources.fontSize.dp12,
                  )
                  .onHeight(1),
            ),
            SizedBox(
              height: resources.dimen.dp10,
            ),
            Expanded(
              child: delayedTickets.isEmpty
                  ? Center(
                      child: Text(
                        isSelectedLocalEn
                            ? 'No Delayed Cases'
                            : 'لا توجد الحالات المتأخرة',
                        style: context.textFontWeight600
                            .onColor(resources.color.viewBgColor),
                      ),
                    )
                  : ScrollConfiguration(
                      behavior: MyCustomScrollBehavior(),
                      child: PageView(
                        controller: pageController,
                        children: [
                          for (int c = 0;
                              c < (delayedTickets.length / 2).ceil();
                              c++)
                            Row(
                              children: [
                                for (int r = 0; r < 2; r++)
                                  Expanded(
                                    child: (c * 2 + r < delayedTickets.length)
                                        ? Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 7),
                                            margin: EdgeInsets.only(
                                                bottom: resources.dimen.dp5,
                                                right: r == 0
                                                    ? resources.dimen.dp10
                                                    : 0),
                                            decoration: BackgroundBoxDecoration(
                                                    boxColor: resources
                                                        .color.colorF7F8FF,
                                                    radious: 8)
                                                .roundedCornerBox,
                                            child: Column(
                                              children:
                                                  (delayedTickets[c * 2 + r]
                                                      .toDelayedCasesJson()
                                                      .entries
                                                      .map((v) {
                                                return Expanded(
                                                  child: Row(children: [
                                                    Expanded(
                                                      child: Text(v.key,
                                                          maxLines: 1,
                                                          style: context
                                                              .textFontWeight400
                                                              .onFontSize(
                                                                  resources
                                                                      .fontSize
                                                                      .dp10)
                                                              .onColor(const Color(
                                                                  0xFF14213D))),
                                                    ),
                                                    Expanded(
                                                      child: v.key ==
                                                              'Request No.'
                                                          ? InkWell(
                                                              onTap: () {
                                                                ViewRequest.start(
                                                                    context,
                                                                    null,
                                                                    ticketId: v
                                                                        .value
                                                                        .toString());
                                                              },
                                                              child: Text(
                                                                  '${v.value}',
                                                                  maxLines: 1,
                                                                  style: context
                                                                      .textFontWeight600
                                                                      .onFontSize(resources
                                                                          .fontSize
                                                                          .dp10)
                                                                      .onFontFamily(
                                                                          fontFamily:
                                                                              fontFamilyEN)
                                                                      .copyWith(
                                                                        decoration:
                                                                            TextDecoration.underline,
                                                                      )),
                                                            )
                                                          : Text('${v.value}',
                                                              maxLines: 1,
                                                              style: isStringArabic(
                                                                      '${v.value}')
                                                                  ? context
                                                                      .textFontWeight600
                                                                      .onFontSize(resources
                                                                          .fontSize
                                                                          .dp10)
                                                                  : context
                                                                      .textFontWeight600
                                                                      .onFontSize(resources
                                                                          .fontSize
                                                                          .dp10)
                                                                      .onFontFamily(
                                                                          fontFamily:
                                                                              fontFamilyEN)),
                                                    ),
                                                  ]),
                                                );
                                              }).toList()),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ),
                              ],
                            ),
                        ],
                        onPageChanged: (value) {
                          pageIndex.value = value;
                        },
                      ),
                    ),
            ),
            SizedBox(
              height: resources.dimen.dp10,
            ),
            ValueListenableBuilder(
                valueListenable: pageIndex,
                builder: (context, value, child) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0;
                            i < (delayedTickets.length / 2).ceil();
                            i++)
                          Container(
                            width: 8,
                            height: 8,
                            margin: EdgeInsets.only(right: resources.dimen.dp5),
                            decoration: BackgroundBoxDecoration(
                                    boxColor: i == value
                                        ? const Color(0xFF9EA4CC)
                                        : const Color(0xFFE3E5F3))
                                .circularBox,
                          ),
                      ]);
                })
          ],
        ));
  }

  Widget _getTopResolversWidget(List<TopResolversEntity> topResolvers) {
    final resources = context.resources;
    return Container(
        height: 200,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            horizontal: resources.dimen.dp20, vertical: resources.dimen.dp15),
        decoration: BackgroundBoxDecoration(
          boxColor: resources.color.colorWhite,
          radious: resources.dimen.dp10,
        ).roundedBoxWithShadow,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isSelectedLocalEn ? 'Top Resolvers' : 'أفضل المحلين',
              style: context.textFontWeight600
                  .onFontSize(
                    resources.fontSize.dp12,
                  )
                  .onHeight(1),
            ),
            SizedBox(
              height: resources.dimen.dp10,
            ),
            Expanded(
                child: SingleChildScrollView(
                    child: Column(children: [
              for (int i = 0; i < topResolvers.length; i++)
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  margin: EdgeInsets.only(bottom: resources.dimen.dp5),
                  decoration: BackgroundBoxDecoration(
                          boxColor: Colors.white,
                          radious: 8,
                          shadowColor: Colors.black.withAlpha(15),
                          shadowBlurRadius: 8,
                          shadowOffset: const Offset(0, 2))
                      .roundedCornerBoxWithShadow,
                  child: Row(children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BackgroundBoxDecoration(
                              boxColor: const Color(0xFFA3AED0))
                          .circularBox,
                    ),
                    SizedBox(
                      width: resources.dimen.dp10,
                    ),
                    Expanded(
                      child: Text.rich(
                          maxLines: 2,
                          TextSpan(
                              text: topResolvers[i].name.toString(),
                              style: context.textFontWeight700
                                  .onFontSize(resources.fontSize.dp10)
                                  .onColor(const Color(0xFF14213D))
                                  .onFontFamily(fontFamily: fontFamilyEN),
                              children: [
                                TextSpan(
                                    text:
                                        '\n${topResolvers[i].designation.toString()}',
                                    style: context.textFontWeight400
                                        .onFontSize(resources.dimen.dp10)
                                        .onColor(resources.color.textColorLight)
                                        .onFontFamily(fontFamily: fontFamilyEN))
                              ])),
                    ),
                    Text('\n${topResolvers[i].ticketCount.toString()}',
                        style: context.textFontWeight700
                            .onFontSize(resources.fontSize.dp12)
                            .onColor(resources.color.dashboardSecondary)
                            .onFontFamily(fontFamily: fontFamilyEN)),
                  ]),
                )
            ]))),
          ],
        ));
  }

  Timer? _resizeTimer;
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      _servicesBloc.getDashboardData(
          apiUrl: newDashboardApiUrl,
          requestParams: UserCredentialsEntity.details().id != null
              ? {
                  "userId": UserCredentialsEntity.details().id,
                  'showWeekly': true
                }
              : {'showWeekly': true});
    });
    _resizeTimer = Timer(const Duration(minutes: 15), () {
      if (!mounted) return;
      _onDataChange.value = (!_onDataChange.value);
    });
    super.initState();
  }

  @override
  void dispose() {
    _resizeTimer?.cancel();
    _resizeTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    //_selectedYear.value = '${DateTime.now().year}';
    final requestTypesRows = isDesktop(context) ? 1 : 2;
    final requestTypesColumns = isDesktop(context) ? 5 : 2;
    if (_requestTypes.isEmpty) {
      _requestTypes = [
        {
          'name': resources.string.noOfRequests,
          'icon_path': DrawableAssets.icNotAssignedRequests,
          'count': 0
        },
        {
          'name': resources.string.openRequests,
          'icon_path': DrawableAssets.icOpenRequests,
          'count': 0
        },
        {
          'name': resources.string.closedRequests,
          'icon_path': DrawableAssets.icNoOfRequests,
          'count': 0
        },
        {
          'name': isSelectedLocalEn ? 'AVG. Day open' : 'متوسط الأيام المفتوحة',
          'icon_path': DrawableAssets.icClosedRequests,
          'count': 0
        },
        {
          'name': UserCredentialsEntity.details().userType == UserType.itAdmin
              ? isSelectedLocalEn
                  ? 'Employee Satisfaction'
                  : 'رضا الموظف'
              : isSelectedLocalEn
                  ? 'Damek Satisfaction'
                  : 'رضا دامك',
          'icon_path': DrawableAssets.icDamek,
          'count': 0
        },
      ];
    }
    double topBannerHeight = screenSize.height * 0.25;
    return SelectionArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: context.resources.color.appScaffoldBg,
        body: BlocProvider(
          create: (context) => _servicesBloc,
          child: BlocListener<ServicesBloc, ServicesState>(
            listener: (context, state) {
              if (state is OnDashboardSuccess) {
                _dashboardEntity = state.dashboardEntity.entity;
                _requestTypes[0]['count'] =
                    _dashboardEntity?.totalRequests ?? 0;
                _requestTypes[1]['count'] = _dashboardEntity?.openRequests ?? 0;
                _requestTypes[2]['count'] =
                    _dashboardEntity?.closedRequests ?? 0;
                _requestTypes[3]['count'] =
                    _dashboardEntity?.averageDayOpenRequests ?? 0;
                _requestTypes[4]['count'] =
                    _dashboardEntity?.damekSatisfaction ?? 0;
                ticketsData = _dashboardEntity?.assignedTickets ?? [];
                _onDataChange.value = !(_onDataChange.value);
              }
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: double.infinity,
                        height: topBannerHeight,
                        clipBehavior: Clip.antiAlias,
                        decoration:
                            BackgroundBoxDecoration(gradientColors: const [
                          Color(0xFF0B0620),
                          Color(0xFF241A6D),
                          Color(0xFF3A45E8),
                          Color(0xFF9A8CFF),
                        ]).linearGradient,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: resources.dimen.dp20,
                              right: resources.dimen.dp20,
                              bottom: resources.dimen.dp20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                      text:
                                          '${resources.string.supportSummary}\n',
                                      style: context.textFontWeight600
                                          .onColor(resources.color.colorWhite),
                                      children: [
                                        TextSpan(
                                            text:
                                                '${resources.string.supportSummaryDes}\n',
                                            style: context.textFontWeight400
                                                .onFontSize(
                                                    resources.fontSize.dp12)
                                                .onColor(
                                                    resources.color.colorWhite)
                                                .onHeight(1))
                                      ]),
                                ),
                              ),
                              DropDownWidget<DashboardFilterEnum>(
                                width: 120,
                                height: 28,
                                list: DashboardFilterEnum.values,
                                iconSize: 20,
                                selectedValue: _selectedFilter,
                                fontStyle: context.textFontWeight400
                                    .onFontSize(resources.fontSize.dp10),
                                callback: (p0) {
                                  final requestParams = <String, dynamic>{
                                    "userId": UserCredentialsEntity.details().id
                                  };
                                  // if (p0 == DashboardFilterEnum.current) {
                                  //   requestParams['showWeekly'] = true;
                                  // } else
                                  if (p0 == DashboardFilterEnum.month) {
                                    requestParams['showMonthly'] = true;
                                  } else if (p0 == DashboardFilterEnum.year) {
                                    requestParams['showYearly'] = true;
                                  } else if (p0 == DashboardFilterEnum.custom) {
                                    showDateRangePickerDialog(context,
                                        selectionMode:
                                            DateRangePickerSelectionMode.range,
                                        initialSelectedDate:
                                            startDate ?? DateTime.now(),
                                        initialSelectedDates: [
                                          startDate ?? DateTime.now(),
                                          endDate ?? DateTime.now()
                                        ],
                                        initialSelectedRange:
                                            PickerDateRange(startDate, endDate),
                                        initialSelectedRanges: [
                                          PickerDateRange(startDate, endDate)
                                        ]).then((value) {
                                      if (value != null &&
                                          value is PickerDateRange &&
                                          value.startDate != null) {
                                        startDate = value.startDate!;
                                        endDate =
                                            value.endDate ?? value.startDate!;
                                        _onDateRangeChange.value =
                                            !(_onDateRangeChange.value);
                                        requestParams['startDate'] =
                                            getDateByformat('yyyy-MM-dd',
                                                startDate ?? DateTime.now());
                                        requestParams['endDate'] =
                                            getDateByformat('yyyy-MM-dd',
                                                endDate ?? DateTime.now());
                                        _servicesBloc.getDashboardData(
                                            apiUrl: newDashboardApiUrl,
                                            requestParams: requestParams);
                                      }
                                    });
                                  }
                                  _selectedFilter =
                                      p0 ?? DashboardFilterEnum.current;
                                  if (p0 != DashboardFilterEnum.custom) {
                                    _servicesBloc.getDashboardData(
                                        apiUrl: newDashboardApiUrl,
                                        requestParams: requestParams);
                                  }
                                  _onDateRangeChange.value =
                                      !(_onDateRangeChange.value);
                                },
                              ),
                              ValueListenableBuilder(
                                  valueListenable: _onDateRangeChange,
                                  builder: (context, value, child) {
                                    return _selectedFilter ==
                                            DashboardFilterEnum.custom
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                left: isSelectedLocalEn
                                                    ? resources.dimen.dp10
                                                    : 0,
                                                right: isSelectedLocalEn
                                                    ? 0
                                                    : resources.dimen.dp10),
                                            child: Text(
                                              '${getDateByformat('dd/MMM/yyyy', startDate ?? DateTime.now())} - ${getDateByformat('dd/MMM/yyyy', endDate ?? DateTime.now())}',
                                              style: context.textFontWeight600
                                                  .onFontSize(
                                                      resources.fontSize.dp12)
                                                  .onColor(resources
                                                      .color.colorWhite)
                                                  .onFontFamily(
                                                      fontFamily: fontFamilyEN),
                                            ),
                                          )
                                        : const SizedBox.shrink();
                                  }),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: -40,
                        child: ValueListenableBuilder(
                            valueListenable: _onDataChange,
                            builder: (context, onDataChange, child) {
                              return Column(
                                children: [
                                  for (var i = 0;
                                      i < requestTypesRows;
                                      i++) ...[
                                    IntrinsicHeight(
                                      child: Row(
                                        children: List.generate(
                                            requestTypesColumns, (index) {
                                          final newIndex =
                                              index + (i * requestTypesColumns);
                                          return Expanded(
                                            child: InkWell(
                                              child: Container(
                                                height: double.infinity,
                                                decoration:
                                                    BackgroundBoxDecoration(
                                                            boxColor:
                                                                resources.color
                                                                    .colorWhite,
                                                            radious: resources
                                                                .dimen.dp10)
                                                        .roundedCornerBox,
                                                margin: isSelectedLocalEn
                                                    ? EdgeInsets.only(
                                                        right: index <
                                                                requestTypesColumns -
                                                                    1
                                                            ? resources
                                                                .dimen.dp15
                                                            : 0,
                                                      )
                                                    : EdgeInsets.only(
                                                        left: index <
                                                                requestTypesColumns -
                                                                    1
                                                            ? resources
                                                                .dimen.dp15
                                                            : 0,
                                                      ),
                                                padding: EdgeInsets.all(
                                                    resources.dimen.dp20),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Text.rich(
                                                        textAlign:
                                                            TextAlign.start,
                                                        TextSpan(
                                                            text:
                                                                '${_requestTypes[newIndex]['count'].toString()}\n',
                                                            style: context
                                                                .textFontWeight700
                                                                .onFontSize(
                                                                    resources
                                                                        .fontSize
                                                                        .dp25)
                                                                .onFontFamily(
                                                                    fontFamily:
                                                                        fontFamilyEN),
                                                            children: [
                                                              TextSpan(
                                                                text: _requestTypes[
                                                                            newIndex]
                                                                        ['name']
                                                                    .toString(),
                                                                style: context
                                                                    .textFontWeight600
                                                                    .onFontSize(
                                                                        resources
                                                                            .fontSize
                                                                            .dp12)
                                                                    .onHeight(
                                                                        1.1),
                                                              )
                                                            ]),
                                                      ),
                                                    ),
                                                    ImageWidget(
                                                            path: _requestTypes[
                                                                        newIndex]
                                                                    [
                                                                    'icon_path']
                                                                .toString(),
                                                            width: 20,
                                                            height: 20)
                                                        .loadImage,
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ],
                                ],
                              );
                            }),
                      ),
                      if (UserCredentialsEntity.details().userType ==
                          UserType.superAdmin)
                        Positioned(
                          top: resources.dimen.dp5,
                          right: isSelectedLocalEn ? resources.dimen.dp20 : 0,
                          left: isSelectedLocalEn ? 0 : resources.dimen.dp20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  resources.setLocal(
                                      language:
                                          isSelectedLocalEn ? 'ar' : 'en');
                                },
                                child: Tooltip(
                                  message: resources.string.language,
                                  child: ImageWidget(
                                          path: isSelectedLocalEn
                                              ? DrawableAssets.icLangAr
                                              : DrawableAssets.icLangEn,
                                          width: 20,
                                          height: 20,
                                          backgroundTint:
                                              resources.color.colorWhite,
                                          padding: EdgeInsets.all(
                                              resources.dimen.dp10))
                                      .loadImageWithMoreTapArea,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  //?.call(AppBarItem.user);
                                },
                                child: Tooltip(
                                  message: resources.string.userProfile,
                                  child: ImageWidget(
                                          path: DrawableAssets.icUserCircle,
                                          width: 20,
                                          height: 20,
                                          backgroundTint:
                                              resources.color.colorWhite,
                                          padding: EdgeInsets.all(
                                              resources.dimen.dp10))
                                      .loadImageWithMoreTapArea,
                                ),
                              ),
                              Text(UserCredentialsEntity.details().name ?? "",
                                  style: context.textFontWeight600
                                      .onFontSize(resources.fontSize.dp12)
                                      .onColor(resources.color.colorWhite))
                            ],
                          ),
                        )
                    ],
                  ),
                  SizedBox(
                    height: resources.dimen.dp60,
                  ),
                  if (true) ...[
                    ValueListenableBuilder(
                        valueListenable: _onDataChange,
                        builder: (context, onDataChange, child) {
                          return isDesktop(context)
                              ? Padding(
                                  padding: EdgeInsets.all(resources.dimen.dp20),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Flexible(
                                            flex: 6,
                                            child: Column(
                                              children: [
                                                getLineChart(
                                                    context,
                                                    _dashboardEntity
                                                            ?.ticketsByMonth ??
                                                        []),
                                                SizedBox(
                                                  height: resources.dimen.dp20,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: _getDelayedCasesWidget(
                                                          _dashboardEntity
                                                                  ?.delayedTickets ??
                                                              []),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          resources.dimen.dp20,
                                                    ),
                                                    Expanded(
                                                      child: _getTopResolversWidget(
                                                          _dashboardEntity
                                                                  ?.topResolvers ??
                                                              []),
                                                    )
                                                  ],
                                                )
                                              ],
                                            )),
                                        SizedBox(
                                          width: resources.dimen.dp20,
                                        ),
                                        if (UserCredentialsEntity.details()
                                                .userType
                                                ?.isAdmin() ??
                                            false)
                                          Flexible(
                                              flex: 4,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: _getByPriorityWidget(
                                                            _dashboardEntity
                                                                    ?.ticketsByPriority ??
                                                                []),
                                                      ),
                                                      SizedBox(
                                                        width: resources
                                                            .dimen.dp20,
                                                      ),
                                                      Expanded(
                                                        child: _getByIssutypeWidget(
                                                            _dashboardEntity
                                                                    ?.ticketsByIssueType ??
                                                                []),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        resources.dimen.dp20,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: getPieChart(
                                                            context,
                                                            _dashboardEntity
                                                                    ?.ticketsByCategory ??
                                                                []),
                                                      ),
                                                      SizedBox(
                                                        width: resources
                                                            .dimen.dp20,
                                                      ),
                                                      Expanded(
                                                        child: _getByOpenDayWidget(
                                                            _dashboardEntity
                                                                    ?.ticketsByOpenDay ??
                                                                []),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ))
                                      ],
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    getLineChart(context,
                                        _dashboardEntity?.ticketsByMonth ?? []),
                                    SizedBox(
                                      height: resources.dimen.dp20,
                                    ),
                                    if (UserCredentialsEntity.details()
                                                .userType ==
                                            UserType.superAdmin ||
                                        UserCredentialsEntity.details()
                                                .userType ==
                                            UserType.itAdmin)
                                      getPieChart(
                                          context,
                                          _dashboardEntity?.ticketsByCategory ??
                                              [])
                                  ],
                                );
                        }),
                  ],
                  SizedBox(
                    height: resources.dimen.dp20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
