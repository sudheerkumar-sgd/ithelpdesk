// ignore_for_file: must_be_immutable
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dropdown_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/report_list_widget.dart';
import 'package:ithelpdesk/presentation/requests/create_new_request.dart';
import 'package:ithelpdesk/presentation/requests/view_request.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';
import 'package:ithelpdesk/res/drawables/drawable_assets.dart';

class UserHomeScreen extends BaseScreenWidget {
  UserHomeScreen({super.key});
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

  Widget getLineChart(
      BuildContext context, List<TicketsByMonthEntity> ticketsByMonthEntity) {
    final resources = context.resources;
    final years = [
      _selectedYear.value,
      _selectedYear.value - 1,
      _selectedYear.value - 2
    ];
    final lineChartData = List<FlSpot>.empty(growable: true);
    final tilesData = List<Widget>.empty(growable: true);
    for (var i = 0; i < 12; i++) {
      final currentMonth = DateTime.now().month;
      final startMonth = ((currentMonth + i) % 12) + 1;
      final monthData = ticketsByMonthEntity
          .where((month) => month.month == startMonth)
          .firstOrNull;
      if (monthData != null) {
        lineChartData
            .add(FlSpot(double.parse('${i + 1}'), monthData.count ?? 0));
        tilesData.add(Expanded(
          child: Text(textAlign: TextAlign.right, '${monthData.month}'),
        ));
      } else {
        lineChartData.add(FlSpot(double.parse('${i + 1}'), 0));
        tilesData.add(Expanded(
          child: Text(textAlign: TextAlign.right, '$startMonth'),
        ));
      }
    }
    return Container(
      height: 350,
      color: resources.color.colorWhite,
      padding: EdgeInsets.all(resources.dimen.dp15),
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
                    border: Border(
                        left: BorderSide(
                            color: resources.color.sideBarItemUnselected),
                        bottom: BorderSide(
                            color: resources.color.sideBarItemUnselected))),
                lineBarsData: [
                  LineChartBarData(
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
              'name': 'Support',
              'count': ticketsByCategoryEntity[i].count ?? 0,
              'color': Colors.orange
            };
            categoryData.add(item);
            totalCount = (ticketsByCategoryEntity[i].count ?? 0) + totalCount;
          }
        case 2:
          {
            var item = {
              'name': 'IT Requests',
              'count': ticketsByCategoryEntity[i].count ?? 0,
              'color': Colors.green
            };
            categoryData.add(item);
            totalCount = (ticketsByCategoryEntity[i].count ?? 0) + totalCount;
          }
        case 3:
          {
            var item = {
              'name': 'Eservice',
              'count': ticketsByCategoryEntity[i].count ?? 0,
              'color': Colors.blue
            };
            categoryData.add(item);
            totalCount = (ticketsByCategoryEntity[i].count ?? 0) + totalCount;
          }
        case 4:
          {
            var item = {
              'name': 'Application',
              'count': ticketsByCategoryEntity[i].count ?? 0,
              'color': Colors.cyan
            };
            categoryData.add(item);
            totalCount = (ticketsByCategoryEntity[i].count ?? 0) + totalCount;
          }
      }
    }
    return Container(
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
                        value: (categoryData[index]['count'] ?? 0) as double,
                        color: (categoryData[index]['color'] ?? Colors.yellow)
                            as Color,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text.rich(
                                  textAlign: TextAlign.start,
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

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    Future.delayed(Duration.zero, () {
      _servicesBloc.getDashboardData(
          requestParams: {"userId": UserCredentialsEntity.details().id});
    });
    _selectedYear.value = DateTime.now().year;
    final requestTypesRows = isDesktop(context) ? 1 : 2;
    final requestTypesColumns = isDesktop(context) ? 4 : 2;
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
    ];

    final ticketsHeaderData = isDesktop(context)
        ? [
            'ID',
            'EmployeeName',
            'Category',
            'Subject',
            'Status',
            'Priority',
            'Assignee',
            'Dept',
            'CreateDate'
          ]
        : ['ID', 'Category', 'Subject', 'Status', 'Priority', 'CreateDate'];
    final ticketsTableColunwidths = isDesktop(context)
        ? {
            0: const FlexColumnWidth(1),
            1: const FlexColumnWidth(3),
            2: const FlexColumnWidth(2),
            3: const FlexColumnWidth(4),
            4: const FlexColumnWidth(2),
            5: const FlexColumnWidth(2),
            6: const FlexColumnWidth(2),
            7: const FlexColumnWidth(1),
            8: const FlexColumnWidth(3),
          }
        : {
            0: const FlexColumnWidth(1),
            1: const FlexColumnWidth(4),
            2: const FlexColumnWidth(2),
            3: const FlexColumnWidth(2),
            4: const FlexColumnWidth(2),
          };
    return SafeArea(
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
          child: Padding(
            padding: EdgeInsets.all(resources.dimen.dp20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Text.rich(
                          TextSpan(
                              text: '${resources.string.supportSummary}\n',
                              style: context.textFontWeight600,
                              children: [
                                TextSpan(
                                    text:
                                        '${resources.string.supportSummaryDes}\n',
                                    style: context.textFontWeight400
                                        .onFontSize(resources.fontSize.dp12)
                                        .onColor(resources.color.textColorLight)
                                        .onHeight(1))
                              ]),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: LayoutBuilder(builder: (context, size) {
                          printLog(size.maxWidth);
                          return InkWell(
                            onTap: () {
                              CreateNewRequest.start(context);
                            },
                            child: ActionButtonWidget(
                              width: size.maxWidth < 210 ? 100 : null,
                              text: size.maxWidth > 210
                                  ? resources.string.createNewRequest
                                  : resources.string.create,
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.maxWidth > 210
                                      ? context.resources.dimen.dp30
                                      : context.resources.dimen.dp10,
                                  vertical: context.resources.dimen.dp7),
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                  SizedBox(
                    height: resources.dimen.dp20,
                  ),
                  ValueListenableBuilder(
                      valueListenable: _onDataChange,
                      builder: (context, onDataChange, child) {
                        return Column(
                          children: [
                            for (var i = 0; i < requestTypesRows; i++) ...[
                              Row(
                                children:
                                    List.generate(requestTypesColumns, (index) {
                                  final newIndex =
                                      index + (i * requestTypesColumns);
                                  return Expanded(
                                    child: InkWell(
                                      child: Container(
                                        color: resources.color.colorWhite,
                                        margin: EdgeInsets.only(
                                          left: index == requestTypesColumns - 1
                                              ? resources.dimen.dp15
                                              : index == 0
                                                  ? 0
                                                  : index ==
                                                          requestTypesColumns -
                                                              2
                                                      ? resources.dimen.dp15
                                                      : resources.dimen.dp5,
                                          right: index < requestTypesColumns - 2
                                              ? index == 0
                                                  ? resources.dimen.dp15
                                                  : resources.dimen.dp5
                                              : index < requestTypesColumns - 1
                                                  ? resources.dimen.dp5
                                                  : 0,
                                          top: i > 0 ? resources.dimen.dp20 : 0,
                                        ),
                                        padding: EdgeInsets.all(
                                            resources.dimen.dp10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: ImageWidget(
                                                      path: _requestTypes[
                                                                  newIndex]
                                                              ['icon_path']
                                                          .toString(),
                                                      width: 20,
                                                      height: 20)
                                                  .loadImage,
                                            ),
                                            Text(
                                              _requestTypes[newIndex]['count']
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: context.textFontWeight700
                                                  .onFontSize(
                                                      resources.fontSize.dp20)
                                                  .onFontFamily(
                                                      fontFamily: fontFamilyEN),
                                            ),
                                            Text(
                                              _requestTypes[newIndex]['name']
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.visible,
                                              style: context.textFontWeight600
                                                  .onFontSize(
                                                      resources.fontSize.dp10)
                                                  .onHeight(1.1),
                                            ),
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
                  SizedBox(
                    height: resources.dimen.dp20,
                  ),
                  if (UserCredentialsEntity.details().userType ==
                      UserType.superAdmin) ...[
                    ValueListenableBuilder(
                        valueListenable: _onDataChange,
                        builder: (context, onDataChange, child) {
                          return isDesktop(context)
                              ? Row(
                                  children: [
                                    Flexible(
                                        flex: 4,
                                        child: getLineChart(
                                            context,
                                            _dashboardEntity?.ticketsByMonth ??
                                                [])),
                                    SizedBox(
                                      width: resources.dimen.dp20,
                                    ),
                                    Flexible(
                                        flex: 2,
                                        child: getPieChart(
                                            context,
                                            _dashboardEntity
                                                    ?.ticketsByCategory ??
                                                []))
                                  ],
                                )
                              : Column(
                                  children: [
                                    getLineChart(context,
                                        _dashboardEntity?.ticketsByMonth ?? []),
                                    SizedBox(
                                      height: resources.dimen.dp20,
                                    ),
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
                      Text(
                        'Filter by Date: ',
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
                                              : 'Start Date',
                                          children: const [
                                            WidgetSpan(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5.0),
                                                child: Icon(
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
                                                List<String>.empty(
                                                    growable: true)
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
                                            'Please Select Start Date');
                                      }
                                    },
                                    child: Text.rich(
                                      TextSpan(
                                          text: value.length > 1
                                              ? value[1]
                                              : 'End Date',
                                          children: const [
                                            WidgetSpan(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5.0),
                                                child: Icon(
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
                      if (isDesktop(context)) ...[
                        SizedBox(
                          width: resources.dimen.dp20,
                        ),
                        Text(
                          '${resources.string.status}:',
                          style: context.textFontWeight600
                              .onFontSize(resources.fontSize.dp10),
                        ),
                        SizedBox(
                          width: resources.dimen.dp20,
                        ),
                        DropDownWidget<StatusType>(
                          width: 120,
                          list: getStatusTypes(),
                          borderRadius: 15,
                          iconSize: 16,
                          selectedValue: filteredStatus,
                          fontStyle: context.textFontWeight400
                              .onFontSize(resources.fontSize.dp10),
                          callback: (p0) {
                            filteredStatus = p0 ?? StatusType.all;
                            _onDataChange.value = !(_onDataChange.value);
                          },
                        )
                      ],
                    ],
                  ),
                  if (!isDesktop(context)) ...[
                    SizedBox(
                      height: resources.dimen.dp10,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: DropDownWidget<String>(
                        width: 120,
                        list: const ['All Status', '', 'Priority', 'Status'],
                        labelText: resources.string.status,
                        borderRadius: 15,
                        iconSize: 16,
                        selectedValue: 'All Status',
                        labelfontStyle: context.textFontWeight600
                            .onFontSize(resources.fontSize.dp10),
                        fontStyle: context.textFontWeight400
                            .onFontSize(resources.fontSize.dp10),
                      ),
                    )
                  ],
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
                              if (selectTicketCategory == 2) {
                                ticketsData =
                                    _dashboardEntity?.assignedTickets ?? [];
                                selectTicketCategory = 1;
                                _onDataChange.value = !_onDataChange.value;
                              }
                            },
                            child: ActionButtonWidget(
                              text: "Assigned Tickets",
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
                                if (selectTicketCategory == 1) {
                                  ticketsData =
                                      _dashboardEntity?.myTickets ?? [];
                                  selectTicketCategory = 2;
                                  _onDataChange.value = !_onDataChange.value;
                                }
                              },
                              child: ActionButtonWidget(
                                text: "My Tickets",
                                padding: EdgeInsets.symmetric(
                                    vertical: resources.dimen.dp7,
                                    horizontal: resources.dimen.dp20),
                                decoration: BackgroundBoxDecoration(
                                  boxColor: selectTicketCategory == 2
                                      ? resources.color.viewBgColor
                                      : resources.color.colorWhite,
                                  radious: 0,
                                  boarderWidth: resources.dimen.dp1,
                                  boarderColor: selectTicketCategory == 1
                                      ? resources.color.colorGray9E9E9E
                                      : resources.color.viewBgColor,
                                ).roundedCornerBox,
                                textColor: selectTicketCategory == 2
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
                                : _servicesBloc
                                    .getTticketsByUser(requestParams: {
                                    'isUserTickets': selectTicketCategory == 2,
                                    'startDate': _filteredDates.value.length < 2
                                        ? null
                                        : _filteredDates.value[0],
                                    'endDate': _filteredDates.value.length < 2
                                        ? null
                                        : _filteredDates.value[1],
                                    'status': filteredStatus
                                  }),
                            builder: (context, snapShot) {
                              final filterTickets =
                                  (snapShot.data?.entity?.items ?? []);
                              // .where((ticket) =>
                              //     ticket.status != StatusType.closed &&
                              //     ticket.status != StatusType.reject)
                              // .toList();
                              return filterTickets.isNotEmpty
                                  ? ReportListWidget(
                                      ticketsHeaderData: ticketsHeaderData,
                                      ticketsData: filterTickets,
                                      ticketsTableColunwidths:
                                          ticketsTableColunwidths,
                                      onTicketSelected: (ticket) {
                                        ViewRequest.start(context, ticket);
                                      },
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Text(
                                        'No Tickets',
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
      ),
    ));
  }

  @override
  doDispose() {}
}
