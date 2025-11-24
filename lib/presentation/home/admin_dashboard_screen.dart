// ignore_for_file: must_be_immutable
import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/common/log.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/domain/entities/api_entity.dart';
import 'package:ithelpdesk/domain/entities/dashboard_entity.dart';
import 'package:ithelpdesk/domain/entities/master_data_entities.dart';
import 'package:ithelpdesk/domain/entities/user_credentials_entity.dart';
import 'package:ithelpdesk/injection_container.dart';
import 'package:ithelpdesk/presentation/bloc/services/services_bloc.dart';
import 'package:ithelpdesk/presentation/common_widgets/action_button_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/alert_dialog_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dropdown_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/report_list_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/tooltip_widget.dart';
import 'package:ithelpdesk/presentation/requests/create_new_request.dart';
import 'package:ithelpdesk/presentation/requests/view_request.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';
import 'package:ithelpdesk/res/drawables/drawable_assets.dart';

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

  final ValueNotifier<int> _selectedYear = ValueNotifier(2024);

  final ValueNotifier<List<String>> _filteredDates = ValueNotifier([]);

  StatusType filteredStatus = StatusType.all;

  Future<ApiEntity<ListEntity>> _getDashboradTickets() {
    final tickets = ApiEntity<ListEntity>();
    final listEntity = ListEntity();
    listEntity.items = ticketsData;
    tickets.entity = listEntity;
    return Future.value(tickets);
  }

  Future<ApiEntity<ListEntity>> _getAllTickets() async {
    var dateFormat = DateFormat('dd-MMM-yyyy HH:mm');
    var startTime = DateFormat('yyyy/MM/dd').parse(_filteredDates.value[0]);
    var endTime = DateFormat('yyyy/MM/dd').parse(_filteredDates.value[1]);
    final alltickets = await _servicesBloc.getTticketsByUser(requestParams: {
      'ticketType': selectTicketCategory,
      'startDate': dateFormat.format(startTime),
      'endDate': dateFormat.format(endTime),
    });
    final tickets = ApiEntity<ListEntity>();
    final listEntity = ListEntity();
    listEntity.items = alltickets.entity?.ticketsList ?? [];
    tickets.entity = listEntity;
    return Future.value(tickets);
  }

  Widget getLineChart(
      BuildContext context, List<TicketsByMonthEntity> ticketsByMonthEntity) {
    final resources = context.resources;
    final currentYear = DateTime.now().year;
    final years = [
      currentYear,
      currentYear - 1,
      currentYear - 2,
      currentYear - 3
    ];
    final lineChartData = List<FlSpot>.empty(growable: true);
    final tilesData = List<Widget>.empty(growable: true);
    for (var i = 0; i < 12; i++) {
      final currentMonth =
          _selectedYear.value == DateTime.now().year ? DateTime.now().month : 0;
      final startMonth = ((currentMonth + i) % 12) + 1;
      final monthData = ticketsByMonthEntity
          .where((month) => month.month == startMonth)
          .firstOrNull;
      if (monthData != null) {
        lineChartData
            .add(FlSpot(double.parse('${i + 1}'), monthData.count ?? 0));
        tilesData.add(Expanded(
          child: Text(
              textAlign: TextAlign.right,
              monthName(monthData.month?.toInt() ?? 1)),
        ));
      } else {
        lineChartData.add(FlSpot(double.parse('${i + 1}'), 0));
        tilesData.add(Expanded(
          child: Text(textAlign: TextAlign.right, monthName(startMonth)),
        ));
      }
    }
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
                      text: '${resources.string.ticketsSummary}\n',
                      style: context.textFontWeight600
                          .onFontSize(resources.fontSize.dp12),
                      children: [
                        TextSpan(
                            text: '${resources.string.ticketsSummaryDes}\n',
                            style: context.textFontWeight400
                                .onFontSize(resources.fontSize.dp10)
                                .onColor(resources.color.textColorLight)
                                .onHeight(1))
                      ]),
                ),
              ),
              DropDownWidget<int>(
                width: 80,
                height: 28,
                list: years,
                iconSize: 20,
                selectedValue: _selectedYear.value,
                fontStyle: context.textFontWeight400
                    .onFontSize(resources.fontSize.dp10),
                callback: (p0) {
                  _selectedYear.value = p0 ?? 2025;
                  _servicesBloc.getDashboardData(requestParams: {
                    "userId": UserCredentialsEntity.details().id,
                    'year': p0 ?? 0
                  });
                },
              )
            ],
          ),
          SizedBox(
            height: resources.dimen.dp20,
          ),
          Expanded(
            child: LineChart(
              LineChartData(
                backgroundColor: resources.color.colorWhite,
                titlesData: FlTitlesData(
                    topTitles: const AxisTitles(),
                    rightTitles: const AxisTitles(),
                    bottomTitles: AxisTitles(
                      axisNameWidget: Row(
                        children: tilesData,
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
      height: 250,
      width: double.infinity,
      decoration: BackgroundBoxDecoration(
              boxColor: resources.color.colorWhite,
              radious: resources.dimen.dp10)
          .roundedBoxWithShadow,
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
                      text: '${resources.string.itHelpdeskSupportTickets}\n',
                      style: context.textFontWeight400
                          .onFontSize(resources.fontSize.dp10)
                          .onColor(resources.color.textColorLight)
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
                            color: resources.color.sideBarItemUnselected),
                        bottom: BorderSide(
                            color: resources.color.sideBarItemUnselected))),
                sections: List.generate(
                    categoryData.length,
                    (index) => PieChartSectionData(
                        radius: 20,
                        value: (categoryData[index]['count'] ?? 0) as double,
                        color: (categoryData[index]['color'] ?? Colors.yellow)
                            as Color,
                        title:
                            '${((categoryData[index]['count'] / totalCount) * 100).toStringAsFixed(0)}%',
                        titleStyle: context.textFontWeight600
                            .onFontSize(10)
                            .onFontFamily(fontFamily: fontFamilyEN)
                            .onColor(resources.color.colorWhite))),
              ), // Optional
            ),
          ),
          SizedBox(
            height: resources.dimen.dp20,
          ),
          Row(
            children: List.generate(
                categoryData.length,
                (index) => Expanded(
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
                                      text:
                                          '${((categoryData[index]['count'] / totalCount) * 100).toStringAsFixed(0)}%\n'
                                              .toString(),
                                      style: context.textFontWeight700
                                          .onFontSize(resources.fontSize.dp12),
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
                    )),
          ),
        ],
      ),
    );
  }

  Widget _getByPriorityWidget() {
    final resources = context.resources;
    final data = [
      {
        "label": "High",
        "count": 123,
        "color": resources.color.dashboardSecondary
      },
      {
        "label": "Medium",
        "count": 34,
        "color": resources.color.dashboardSecondary
      },
      {
        "label": "Low",
        "count": 45,
        "color": resources.color.dashboardSecondary
      },
      {
        "label": "Unassigned",
        "count": 23,
        "color": resources.color.dashboardSecondary
      },
    ];
    final maxValue =
        data.map((e) => e["count"] as int).reduce((a, b) => a > b ? a : b);
    return Container(
      height: 250,
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
            '${resources.string.category}\n',
            style: context.textFontWeight600.onFontSize(
              resources.fontSize.dp12,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (int i = 0; i < data.length; i++)
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Count bubble
                    TooltipWidget(text: data[i]['count'].toString()),

                    const SizedBox(height: 6),

                    // Animated Bar
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOut,
                      height:
                          ((data[i]['count'] as int) / maxValue) * (250 * 0.5),
                      width: 24,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(18)),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            (data[i]['color'] as Color).withAlpha(50),
                            (data[i]['color'] as Color).withAlpha(255),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Label
                    Text(
                      data[i]['label'].toString(),
                      style: context.textFontWeight600.onFontSize(10),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getByIssutypeWidget() {
    final resources = context.resources;
    final data = [
      {
        "issue_type": "Customer",
        "count": 123,
      },
      {
        "issue_type": "Employee",
        "count": 34,
      },
      {
        "issue_type": "System",
        "count": 45,
      },
      {
        "issue_type": "Bugs",
        "count": 23,
      },
      {
        "issue_type": "Others",
        "count": 23,
      },
    ];
    return Container(
        height: 250,
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
              '${resources.string.category}\n',
              style: context.textFontWeight700.onFontSize(
                resources.fontSize.dp12,
              ),
            ),
            for (int i = 0; i < data.length; i++)
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
                      child: Text(data[i]['issue_type'].toString(),
                          style: context.textFontWeight700
                              .onFontSize(resources.fontSize.dp10)
                              .onColor(const Color(0xFF14213D))),
                    ),
                    Text(data[i]['count'].toString(),
                        style: context.textFontWeight700
                            .onFontSize(resources.fontSize.dp12)
                            .onColor(resources.color.dashboardSecondary)),
                  ]),
                ),
              )
          ],
        ));
  }

  Widget _getByOpenDayWidget() {
    final resources = context.resources;
    return Container(
        height: 250,
        width: double.infinity,
        decoration: BackgroundBoxDecoration(
          boxColor: resources.color.colorWhite,
          radious: resources.dimen.dp10,
        ).roundedBoxWithShadow);
  }

  Widget _getDelayedCasesWidget() {
    final resources = context.resources;
    return Container(
        height: 150,
        width: double.infinity,
        decoration: BackgroundBoxDecoration(
          boxColor: resources.color.colorWhite,
          radious: resources.dimen.dp10,
        ).roundedBoxWithShadow);
  }

  Widget _getTopResolversWidget() {
    final resources = context.resources;
    return Container(
        height: 150,
        width: double.infinity,
        decoration: BackgroundBoxDecoration(
          boxColor: resources.color.colorWhite,
          radious: resources.dimen.dp10,
        ).roundedBoxWithShadow);
  }

  Timer? _resizeTimer;
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      _servicesBloc.getDashboardData(
          requestParams: UserCredentialsEntity.details().id != null
              ? {"userId": UserCredentialsEntity.details().id}
              : {});
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
    _selectedYear.value = DateTime.now().year;
    final requestTypesRows = isDesktop(context) ? 1 : 2;
    final requestTypesColumns = isDesktop(context) ? 5 : 2;
    _requestTypes = [
      {
        'name': resources.string.notAssignedRequests,
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
        'icon_path': DrawableAssets.icClosedRequests,
        'count': 0
      },
      {
        'name': resources.string.noOfRequests,
        'icon_path': DrawableAssets.icNoOfRequests,
        'count': 0
      },
      {
        'name': resources.string.noOfRequests,
        'icon_path': DrawableAssets.icNoOfRequests,
        'count': 0
      },
    ];
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
                  _dashboardEntity?.notAssignedRequests ?? 0;
              _requestTypes[1]['count'] = _dashboardEntity?.openRequests ?? 0;
              _requestTypes[2]['count'] = _dashboardEntity?.closedRequests ?? 0;
              _requestTypes[3]['count'] = _dashboardEntity?.totalRequests ?? 0;
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
                            top: topBannerHeight * .3,
                            right: resources.dimen.dp20,
                            bottom: resources.dimen.dp20),
                        child: Text.rich(
                          TextSpan(
                              text: '${resources.string.supportSummary}\n',
                              style: context.textFontWeight600
                                  .onColor(resources.color.colorWhite),
                              children: [
                                TextSpan(
                                    text:
                                        '${resources.string.supportSummaryDes}\n',
                                    style: context.textFontWeight400
                                        .onFontSize(resources.fontSize.dp12)
                                        .onColor(resources.color.colorWhite)
                                        .onHeight(1))
                              ]),
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
                                for (var i = 0; i < requestTypesRows; i++) ...[
                                  Row(
                                    children: List.generate(requestTypesColumns,
                                        (index) {
                                      final newIndex =
                                          index + (i * requestTypesColumns);
                                      return Expanded(
                                        child: InkWell(
                                          child: Container(
                                            decoration: BackgroundBoxDecoration(
                                                    boxColor: resources
                                                        .color.colorWhite,
                                                    radious:
                                                        resources.dimen.dp10)
                                                .roundedCornerBox,
                                            margin: isSelectedLocalEn
                                                ? EdgeInsets.only(
                                                    right: index <
                                                            requestTypesColumns -
                                                                1
                                                        ? resources.dimen.dp15
                                                        : 0,
                                                  )
                                                : EdgeInsets.only(
                                                    left: index <
                                                            requestTypesColumns -
                                                                1
                                                        ? resources.dimen.dp15
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
                                                    textAlign: TextAlign.start,
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
                                                                .onHeight(1.1),
                                                          )
                                                        ]),
                                                  ),
                                                ),
                                                ImageWidget(
                                                        path: _requestTypes[
                                                                    newIndex]
                                                                ['icon_path']
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
                                ],
                              ],
                            );
                          }),
                    ),
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
                                                    child:
                                                        _getDelayedCasesWidget(),
                                                  ),
                                                  SizedBox(
                                                    width: resources.dimen.dp20,
                                                  ),
                                                  Expanded(
                                                    child:
                                                        _getTopResolversWidget(),
                                                  )
                                                ],
                                              )
                                            ],
                                          )),
                                      SizedBox(
                                        width: resources.dimen.dp20,
                                      ),
                                      if (UserCredentialsEntity.details()
                                                  .userType ==
                                              UserType.superAdmin ||
                                          UserCredentialsEntity.details()
                                                  .userType ==
                                              UserType.itAdmin)
                                        Flexible(
                                            flex: 4,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child:
                                                          _getByPriorityWidget(),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          resources.dimen.dp20,
                                                    ),
                                                    Expanded(
                                                      child:
                                                          _getByIssutypeWidget(),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: resources.dimen.dp20,
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
                                                      width:
                                                          resources.dimen.dp20,
                                                    ),
                                                    Expanded(
                                                      child:
                                                          _getByOpenDayWidget(),
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: resources.string.latestTickets,
                          style: context.textFontWeight600
                              .onFontSize(resources.fontSize.dp12),
                          //children: [
                          // TextSpan(
                          //     text: '',
                          //     style: context.textFontWeight400
                          //         .onFontSize(resources.fontSize.dp10)
                          //         .onColor(resources.color.textColorLight)
                          //         .onHeight(1))
                          //]
                        ),
                      ),
                    ),
                    SizedBox(
                      width: resources.dimen.dp20,
                    ),
                    Text(
                      '${resources.string.filterByDate}: ',
                      style: context.textFontWeight600
                          .onFontSize(resources.fontSize.dp10),
                    ),
                    SizedBox(
                      width: resources.dimen.dp10,
                    ),
                    ValueListenableBuilder(
                        valueListenable: _filteredDates,
                        builder: (context, value, child) {
                          return Container(
                            decoration: BackgroundBoxDecoration(
                                    radious: resources.dimen.dp15,
                                    boarderColor:
                                        resources.color.sideBarItemUnselected)
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
                                            firstDate: DateTime.now().add(
                                                const Duration(days: -365)),
                                            lastDate: DateTime.now())
                                        .then((dateTime) {
                                      if (dateTime != null) {
                                        _filteredDates.value =
                                            List<String>.empty(growable: true)
                                              ..add(getDateByformat(
                                                  'yyyy/MM/dd', dateTime));
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
                                                  ? const EdgeInsets.only(
                                                      left: 5.0)
                                                  : const EdgeInsets.only(
                                                      right: 5.0),
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
                                              firstDate: getDateTimeByString(
                                                  'yyyy/MM/dd', value[0]),
                                              lastDate: DateTime.now())
                                          .then((dateTime) {
                                        if (dateTime != null) {
                                          _filteredDates.value =
                                              List<String>.empty(growable: true)
                                                ..add(value[0])
                                                ..add(getDateByformat(
                                                    'yyyy/MM/dd', dateTime));
                                          _onDataChange.value =
                                              !_onDataChange.value;
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
                                                  ? const EdgeInsets.only(
                                                      left: 5.0)
                                                  : const EdgeInsets.only(
                                                      right: 5.0),
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
                                    if (_filteredDates.value.isNotEmpty) {
                                      _filteredDates.value = List.empty();
                                      _onDataChange.value =
                                          !(_onDataChange.value);
                                    }
                                  },
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
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
                  height: resources.dimen.dp20,
                ),
                ValueListenableBuilder(
                    valueListenable: _onDataChange,
                    builder: (context, value, child) {
                      return Row(children: [
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            if (selectTicketCategory != 1) {
                              ticketsData =
                                  _dashboardEntity?.assignedTickets ?? [];
                              selectTicketCategory = 1;
                              _onDataChange.value = !_onDataChange.value;
                            }
                          },
                          child: ActionButtonWidget(
                            text: resources.string.assignedTickets,
                            padding: EdgeInsets.symmetric(
                                vertical: resources.dimen.dp7,
                                horizontal: resources.dimen.dp20),
                            decoration: BackgroundBoxDecoration(
                                    boxColor: selectTicketCategory == 1
                                        ? resources.color.viewBgColor
                                        : resources.color.colorWhite,
                                    radious: 0,
                                    boarderWidth: resources.dimen.dp1,
                                    boarderColor: selectTicketCategory != 1
                                        ? resources.color.colorGray9E9E9E
                                        : resources.color.viewBgColor)
                                .roundedCornerBox,
                            textColor: selectTicketCategory == 1
                                ? resources.color.colorWhite
                                : resources.color.textColor,
                          ),
                        )),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (selectTicketCategory != 2) {
                                ticketsData = _dashboardEntity?.myTickets ?? [];
                                selectTicketCategory = 2;
                                _onDataChange.value = !_onDataChange.value;
                              }
                            },
                            child: ActionButtonWidget(
                              text: resources.string.myTickets,
                              padding: EdgeInsets.symmetric(
                                  vertical: resources.dimen.dp7,
                                  horizontal: resources.dimen.dp20),
                              decoration: BackgroundBoxDecoration(
                                boxColor: selectTicketCategory == 2
                                    ? resources.color.viewBgColor
                                    : resources.color.colorWhite,
                                radious: 0,
                                boarderWidth: resources.dimen.dp1,
                                boarderColor: selectTicketCategory == 2
                                    ? resources.color.viewBgColor
                                    : resources.color.colorGray9E9E9E,
                              ).roundedCornerBox,
                              textColor: selectTicketCategory == 2
                                  ? resources.color.colorWhite
                                  : resources.color.textColor,
                            ),
                          ),
                        ),
                        if (_dashboardEntity?.teamTickets.isNotEmpty == true)
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                if (selectTicketCategory != 3) {
                                  ticketsData =
                                      _dashboardEntity?.teamTickets ?? [];
                                  selectTicketCategory = 3;
                                  _onDataChange.value = !_onDataChange.value;
                                }
                              },
                              child: ActionButtonWidget(
                                text: 'Team Tickets',
                                padding: EdgeInsets.symmetric(
                                    vertical: resources.dimen.dp7,
                                    horizontal: resources.dimen.dp20),
                                decoration: BackgroundBoxDecoration(
                                  boxColor: selectTicketCategory == 3
                                      ? resources.color.viewBgColor
                                      : resources.color.colorWhite,
                                  radious: 0,
                                  boarderWidth: resources.dimen.dp1,
                                  boarderColor: selectTicketCategory == 3
                                      ? resources.color.viewBgColor
                                      : resources.color.colorGray9E9E9E,
                                ).roundedCornerBox,
                                textColor: selectTicketCategory == 3
                                    ? resources.color.colorWhite
                                    : resources.color.textColor,
                              ),
                            ),
                          ),
                        if (_dashboardEntity?.historyTickets.isNotEmpty == true)
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                if (selectTicketCategory != 4) {
                                  ticketsData =
                                      _dashboardEntity?.historyTickets ?? [];
                                  selectTicketCategory = 4;
                                  _onDataChange.value = !_onDataChange.value;
                                }
                              },
                              child: ActionButtonWidget(
                                text: 'Ticket History',
                                padding: EdgeInsets.symmetric(
                                    vertical: resources.dimen.dp7,
                                    horizontal: resources.dimen.dp20),
                                decoration: BackgroundBoxDecoration(
                                  boxColor: selectTicketCategory == 4
                                      ? resources.color.viewBgColor
                                      : resources.color.colorWhite,
                                  radious: 0,
                                  boarderWidth: resources.dimen.dp1,
                                  boarderColor: selectTicketCategory == 4
                                      ? resources.color.viewBgColor
                                      : resources.color.colorGray9E9E9E,
                                ).roundedCornerBox,
                                textColor: selectTicketCategory == 4
                                    ? resources.color.colorWhite
                                    : resources.color.textColor,
                              ),
                            ),
                          )
                      ]);
                    }),
                ValueListenableBuilder(
                    valueListenable: _onDataChange,
                    builder: (context, onDataChange, child) {
                      return FutureBuilder(
                          future: (_filteredDates.value.length < 2 &&
                                  filteredStatus == StatusType.all)
                              ? _getDashboradTickets()
                              : _getAllTickets(),
                          builder: (context, snapShot) {
                            final filterTickets =
                                List.from(snapShot.data?.entity?.items ?? []);

                            // .where((ticket) =>
                            //     ticket.status != StatusType.closed &&
                            //     ticket.status != StatusType.reject)
                            // .toList();
                            return filterTickets.isNotEmpty
                                ? ReportListWidget(
                                    ticketsData: filterTickets,
                                    onTicketSelected: (ticket) {
                                      ViewRequest.start(context, ticket,
                                          isMyTicket:
                                              selectTicketCategory == 2);
                                    },
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Text(
                                      resources.string.noTickets,
                                      style: context.textFontWeight600,
                                    ),
                                  );
                          });
                    })
              ],
            ),
          ),
        ),
      ),
    ));
  }

  @override
  doDispose() {}
}
