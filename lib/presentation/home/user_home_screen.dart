// ignore_for_file: must_be_immutable

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/domain/entities/dashboard_entity.dart';
import 'package:ithelpdesk/presentation/common_widgets/action_button_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dropdown_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';
import 'package:ithelpdesk/res/drawables/drawable_assets.dart';

class UserHomeScreen extends BaseScreenWidget {
  UserHomeScreen({super.key});
  late FocusNode requestStatusFocusNode;

  void onRequestValueChanged(String value) {
    if (value.trim().length == 6) {
      requestStatusFocusNode.canRequestFocus = !requestStatusFocusNode.hasFocus;
    }
  }

  List<Widget> _getTicketData(BuildContext context, TicketEntity ticketEntity) {
    final list = List<Widget>.empty(growable: true);
    ticketEntity.toJson().forEach((key, value) {
      list.add(Padding(
        padding: EdgeInsets.symmetric(vertical: context.resources.dimen.dp20),
        child: Text(
          '$value',
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textFontWeight600
              .onFontSize(context.resources.fontSize.dp10),
        ),
      ));
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    final requestTypes = [
      {
        'name': resources.string.notAssignedRequests,
        'icon_path': DrawableAssets.icNotAssignedRequests,
        'count': 4
      },
      {
        'name': resources.string.openRequests,
        'icon_path': DrawableAssets.icOpenRequests,
        'count': 13
      },
      {
        'name': resources.string.closedRequests,
        'icon_path': DrawableAssets.icClosedRequests,
        'count': 9
      },
      {
        'name': resources.string.noOfRequests,
        'icon_path': DrawableAssets.icNoOfRequests,
        'count': 25
      },
    ];
    final categoryData = [
      {'name': 'Support', 'count': 30, 'color': Colors.orange},
      {'name': 'IT Requests', 'count': 40, 'color': Colors.green},
      {'name': 'Eservice', 'count': 20, 'color': Colors.blue},
      {'name': 'System', 'count': 10, 'color': Colors.red},
    ];
    final ticketsHeaderData = [
      'ID',
      'EmployeeName',
      'Subject',
      'Status',
      'Priority',
      'Assignee',
      'Department',
      'CreateDate'
    ];
    final ticketsTableColunwidths = {
      0: const FlexColumnWidth(1),
      1: const FlexColumnWidth(3),
      2: const FlexColumnWidth(4),
      3: const FlexColumnWidth(2),
      4: const FlexColumnWidth(1),
      5: const FlexColumnWidth(2),
      6: const FlexColumnWidth(3),
      7: const FlexColumnWidth(2),
      8: const FlexColumnWidth(2),
    };
    final ticketsData = [
      TicketEntity(1, 'Ujjawal Jha', 'Network Notworking', 'pending', 'high',
          'Syed', 'SGD', '12-05-2023'),
      TicketEntity(2, 'Ujjawal Jha', 'Network Notworking', 'pending', 'high',
          'Mustak', 'SGD', '12-05-2023'),
      TicketEntity(3, 'Mustak', 'Network Notworking', 'pending', 'high',
          'Akbar', 'SGD', '12-05-2023'),
      TicketEntity(4, 'Ujjawal Jha', 'Network Notworking', 'pending', 'high',
          'Syed', 'SGD', '12-05-2023'),
      TicketEntity(5, 'Kamran', 'Network Notworking', 'pending', 'high', 'Syed',
          'SGD', '12-05-2023'),
      TicketEntity(6, 'Sudheer Kumar A', 'Network Notworking', 'pending',
          'high', 'Tarek', 'SGD', '12-05-2023'),
      TicketEntity(7, 'Tarek', 'Network Notworking', 'pending', 'high', 'Syed',
          'SGD', '12-05-2023'),
      TicketEntity(8, 'Ibrahim', 'Network Notworking', 'pending', 'high',
          'Mooza', 'SGD', '12-05-2023'),
      TicketEntity(9, 'Anu Chandrika Surat', 'Network Notworking', 'pending',
          'high', 'Syed', 'SGD', '12-05-2023'),
      TicketEntity(10, 'Mooza Binyeem', 'Network Notworking', 'pending', 'high',
          'Syed', 'SGD', '12-05-2023'),
      TicketEntity(11, 'Abdul Muneeb', 'Network Notworking', 'pending', 'high',
          'Syed', 'SGD', '12-05-2023'),
    ];
    return SafeArea(
        child: Scaffold(
      backgroundColor: context.resources.color.appScaffoldBg,
      body: Padding(
        padding: EdgeInsets.all(resources.dimen.dp20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text.rich(
                    TextSpan(
                        text: '${resources.string.supportSummary}\n',
                        style: context.textFontWeight600,
                        children: [
                          TextSpan(
                              text: '${resources.string.supportSummaryDes}\n',
                              style: context.textFontWeight400
                                  .onFontSize(resources.fontSize.dp12)
                                  .onColor(resources.color.textColorLight)
                                  .onHeight(1))
                        ]),
                  ),
                  ActionButtonWidget(
                    text: resources.string.createNewRequest,
                    padding: EdgeInsets.symmetric(
                        horizontal: context.resources.dimen.dp30,
                        vertical: context.resources.dimen.dp7),
                  )
                ],
              ),
              SizedBox(
                height: resources.dimen.dp20,
              ),
              Row(
                children: List.generate(
                    requestTypes.length,
                    (index) => Expanded(
                          child: InkWell(
                            child: Container(
                              color: resources.color.colorWhite,
                              margin: index < requestTypes.length - 1
                                  ? EdgeInsets.only(right: resources.dimen.dp20)
                                  : null,
                              padding: EdgeInsets.all(resources.dimen.dp10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: ImageWidget(
                                            path: requestTypes[index]
                                                    ['icon_path']
                                                .toString(),
                                            width: 20,
                                            height: 20)
                                        .loadImage,
                                  ),
                                  Text(
                                    requestTypes[index]['count'].toString(),
                                    textAlign: TextAlign.center,
                                    style: context.textFontWeight700,
                                  ),
                                  Text(
                                    requestTypes[index]['name'].toString(),
                                    textAlign: TextAlign.center,
                                    style: context.textFontWeight600
                                        .onFontSize(resources.fontSize.dp10)
                                        .onHeight(1.1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
              ),
              SizedBox(
                height: resources.dimen.dp20,
              ),
              Row(
                children: [
                  Flexible(
                    flex: 4,
                    child: Container(
                      height: 350,
                      color: resources.color.colorWhite,
                      padding: EdgeInsets.all(resources.dimen.dp15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text.rich(
                                TextSpan(
                                    text:
                                        '${resources.string.ticketsSummary}\n',
                                    style: context.textFontWeight600
                                        .onFontSize(resources.fontSize.dp12),
                                    children: [
                                      TextSpan(
                                          text:
                                              '${resources.string.ticketsSummaryDes}\n',
                                          style: context.textFontWeight400
                                              .onFontSize(
                                                  resources.fontSize.dp10)
                                              .onColor(resources
                                                  .color.textColorLight)
                                              .onHeight(1))
                                    ]),
                              ),
                              SizedBox(
                                width: 100,
                                child: DropDownWidget<String>(
                                  list: const ['2022', '2023', '2024'],
                                  selectedValue: '2024',
                                  height: 20,
                                  fillColor: resources.color.colorWhite,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: resources.dimen.dp20,
                          ),
                          SizedBox(
                            height: 250,
                            child: LineChart(
                              LineChartData(
                                backgroundColor: resources.color.colorWhite,
                                titlesData: const FlTitlesData(
                                  topTitles: AxisTitles(),
                                  rightTitles: AxisTitles(),
                                ),
                                borderData: FlBorderData(
                                    show: true,
                                    border: Border(
                                        left: BorderSide(
                                            color: resources
                                                .color.sideBarItemUnselected),
                                        bottom: BorderSide(
                                            color: resources
                                                .color.sideBarItemUnselected))),
                                lineBarsData: [
                                  LineChartBarData(
                                      show: true,
                                      spots: const [
                                        FlSpot(0, 0),
                                        FlSpot(1, 10),
                                        FlSpot(2, 25),
                                        FlSpot(3, 50),
                                        FlSpot(4, 100),
                                        FlSpot(5, 50),
                                        FlSpot(6, 10),
                                        FlSpot(7, 70),
                                        FlSpot(8, 80),
                                        FlSpot(9, 10),
                                        FlSpot(10, 50),
                                        FlSpot(11, 30),
                                        FlSpot(12, 10),
                                      ],
                                      preventCurveOvershootingThreshold: 12,
                                      isCurved: true,
                                      preventCurveOverShooting: true,
                                      barWidth: 2),
                                ],
                              ), // Optional
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: resources.dimen.dp20,
                  ),
                  Flexible(
                      flex: 2,
                      child: Container(
                        height: 350,
                        width: double.infinity,
                        color: resources.color.colorWhite,
                        padding: EdgeInsets.all(resources.dimen.dp15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                  text: '${resources.string.category}\n',
                                  style: context.textFontWeight600
                                      .onFontSize(resources.fontSize.dp12),
                                  children: [
                                    TextSpan(
                                        text:
                                            '${resources.string.itHelpdeskSupportTickets}\n',
                                        style: context.textFontWeight400
                                            .onFontSize(resources.fontSize.dp10)
                                            .onColor(
                                                resources.color.textColorLight)
                                            .onHeight(1))
                                  ]),
                            ),
                            Expanded(
                              child: PieChart(
                                PieChartData(
                                  borderData: FlBorderData(
                                      show: true,
                                      border: Border(
                                          left: BorderSide(
                                              color: resources
                                                  .color.sideBarItemUnselected),
                                          bottom: BorderSide(
                                              color: resources.color
                                                  .sideBarItemUnselected))),
                                  sections: List.generate(
                                      categoryData.length,
                                      (index) => PieChartSectionData(
                                          value: (categoryData[index]
                                                  ['count'] ??
                                              0) as double,
                                          color: (categoryData[index]
                                                  ['color'] ??
                                              Colors.yellow) as Color,
                                          title: '')),
                                ), // Optional
                              ),
                            ),
                            Row(
                              children: List.generate(
                                  categoryData.length,
                                  (index) => Expanded(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text.rich(
                                                    textAlign: TextAlign.start,
                                                    maxLines: 2,
                                                    TextSpan(
                                                        text:
                                                            '${categoryData[index]['count']}%\n'
                                                                .toString(),
                                                        style: context
                                                            .textFontWeight700
                                                            .onFontSize(
                                                                resources
                                                                    .fontSize
                                                                    .dp10),
                                                        children: [
                                                          TextSpan(
                                                              text: categoryData[
                                                                          index]
                                                                      ['name']
                                                                  .toString(),
                                                              style: context
                                                                  .textFontWeight400
                                                                  .onFontSize(
                                                                      resources
                                                                          .fontSize
                                                                          .dp8))
                                                        ])),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
              SizedBox(
                height: resources.dimen.dp20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                          text: '${resources.string.latestTickets}\n',
                          style: context.textFontWeight600
                              .onFontSize(resources.fontSize.dp12),
                          children: [
                            TextSpan(
                                text: '${resources.string.latestTicketsDes}\n',
                                style: context.textFontWeight400
                                    .onFontSize(resources.fontSize.dp10)
                                    .onColor(resources.color.textColorLight)
                                    .onHeight(1))
                          ]),
                    ),
                  ),
                  Text(
                    '${resources.string.sortBy}: ',
                    style: context.textFontWeight600
                        .onFontSize(resources.fontSize.dp10),
                  ),
                  SizedBox(
                    width: 60,
                    child: DropDownWidget<String>(
                      list: const ['2022', '2023', '2024'],
                      selectedValue: '2024',
                      fillColor: resources.color.colorWhite,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: resources.dimen.dp20,
              ),
              Table(
                columnWidths: ticketsTableColunwidths,
                children: [
                  TableRow(
                      children: List.generate(
                          ticketsHeaderData.length,
                          (index) => Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: resources.dimen.dp10),
                                child: Text(
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
              )
            ],
          ),
        ),
      ),
    ));
  }

  @override
  doDispose() {}
}
