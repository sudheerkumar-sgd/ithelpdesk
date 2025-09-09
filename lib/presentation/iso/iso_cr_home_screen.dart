// ignore_for_file: must_be_immutable
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
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dropdown_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/report_list_widget.dart';
import 'package:ithelpdesk/presentation/iso/iso_system_cr_screen.dart';
import 'package:ithelpdesk/presentation/requests/create_new_request.dart';
import 'package:ithelpdesk/presentation/requests/view_request.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';
import 'package:ithelpdesk/res/drawables/drawable_assets.dart';

class IsoCrHomeScreen extends BaseScreenWidget {
  IsoCrHomeScreen({super.key});
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

  Future<ApiEntity<ListEntity>> _getCRTickets() async {
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

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    Future.delayed(Duration.zero, () {
      _servicesBloc.getDashboardData(
          requestParams: UserCredentialsEntity.details().id != null
              ? {"userId": UserCredentialsEntity.details().id}
              : {});
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
                              IsoSystemCrScreen.start(context);
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
                                        margin: isSelectedLocalEn
                                            ? EdgeInsets.only(
                                                left: index ==
                                                        requestTypesColumns - 1
                                                    ? resources.dimen.dp15
                                                    : index == 0
                                                        ? 0
                                                        : index ==
                                                                requestTypesColumns -
                                                                    2
                                                            ? resources
                                                                .dimen.dp15
                                                            : resources
                                                                .dimen.dp5,
                                                right: index <
                                                        requestTypesColumns - 2
                                                    ? index == 0
                                                        ? resources.dimen.dp15
                                                        : resources.dimen.dp5
                                                    : index <
                                                            requestTypesColumns -
                                                                1
                                                        ? resources.dimen.dp5
                                                        : 0,
                                                top: i > 0
                                                    ? resources.dimen.dp20
                                                    : 0,
                                              )
                                            : EdgeInsets.only(
                                                right: index ==
                                                        requestTypesColumns - 1
                                                    ? resources.dimen.dp15
                                                    : index == 0
                                                        ? 0
                                                        : index ==
                                                                requestTypesColumns -
                                                                    2
                                                            ? resources
                                                                .dimen.dp15
                                                            : resources
                                                                .dimen.dp5,
                                                left: index <
                                                        requestTypesColumns - 2
                                                    ? index == 0
                                                        ? resources.dimen.dp15
                                                        : resources.dimen.dp5
                                                    : index <
                                                            requestTypesColumns -
                                                                1
                                                        ? resources.dimen.dp5
                                                        : 0,
                                                top: i > 0
                                                    ? resources.dimen.dp20
                                                    : 0,
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
                      builder: (context, onDataChange, child) {
                        return FutureBuilder(
                            future: (_filteredDates.value.length < 2 &&
                                    filteredStatus == StatusType.all)
                                ? _getDashboradTickets()
                                : _getCRTickets(),
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
      ),
    ));
  }

  @override
  doDispose() {}
}
