// ignore_for_file: must_be_immutable
import 'package:dartz/dartz.dart';
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
import 'package:ithelpdesk/domain/entities/iso_entity.dart';
import 'package:ithelpdesk/domain/entities/master_data_entities.dart';
import 'package:ithelpdesk/domain/entities/user_credentials_entity.dart';
import 'package:ithelpdesk/injection_container.dart';
import 'package:ithelpdesk/presentation/bloc/iso/iso_bloc.dart';
import 'package:ithelpdesk/presentation/bloc/services/services_bloc.dart';
import 'package:ithelpdesk/presentation/common_widgets/action_button_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/alert_dialog_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dropdown_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dynamic_report_list_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/report_list_widget.dart';
import 'package:ithelpdesk/presentation/iso/iso_system_cr_screen.dart';
import 'package:ithelpdesk/presentation/iso/iso_view_request_screen.dart';
import 'package:ithelpdesk/presentation/requests/create_new_request.dart';
import 'package:ithelpdesk/presentation/requests/view_request.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';
import 'package:ithelpdesk/res/drawables/drawable_assets.dart';

class IsoCrHomeScreen extends BaseScreenWidget {
  IsoCrHomeScreen({super.key});
  late FocusNode requestStatusFocusNode;
  final ISOBloc _isoBloc = sl<ISOBloc>();

  final ValueNotifier<bool> _onDataChange = ValueNotifier(false);
  //List<Map<String, Object>> _requestTypes = [];
  int selectTicketCategory = 1;
  final ValueNotifier<int> _selectedYear = ValueNotifier(2024);
  final ValueNotifier<List<String>> _filteredDates = ValueNotifier([]);
  StatusType filteredStatus = StatusType.all;

  Future<ApiEntity<ListEntity>> _getCRTickets() async {
    var dateFormat = DateFormat('dd-MMM-yyyy HH:mm');
    //var startTime = DateFormat('yyyy/MM/dd').parse(_filteredDates.value[0]);
    //var endTime = DateFormat('yyyy/MM/dd').parse(_filteredDates.value[1]);
    final response = await _isoBloc.getRequests(requestParams: {
      //'ticketType': selectTicketCategory,
      //'startDate': dateFormat.format(startTime),
      //'endDate': dateFormat.format(endTime),
    });
    final tickets = ApiEntity<ListEntity>();
    if (response is OnISOApiResponse) {
      final listEntity = ListEntity();
      listEntity.items =
          cast<ListEntity?>(response.response.entity)?.items ?? [];
      tickets.entity = listEntity;
    }
    return Future.value(tickets);
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    Future.delayed(Duration.zero, () {
      _getCRTickets();
    });
    _selectedYear.value = DateTime.now().year;
    final requestTypesRows = isDesktop(context) ? 1 : 2;
    final requestTypesColumns = isDesktop(context) ? 4 : 2;
    // _requestTypes = [
    //   {
    //     'name': resources.string.notAssignedRequests,
    //     'icon_path': DrawableAssets.icNotAssignedRequests,
    //     'count': 0
    //   },
    //   {
    //     'name': resources.string.openRequests,
    //     'icon_path': DrawableAssets.icOpenRequests,
    //     'count': 0
    //   },
    //   {
    //     'name': resources.string.closedRequests,
    //     'icon_path': DrawableAssets.icClosedRequests,
    //     'count': 0
    //   },
    //   {
    //     'name': resources.string.noOfRequests,
    //     'icon_path': DrawableAssets.icNoOfRequests,
    //     'count': 0
    //   },
    // ];
    return SelectionArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.resources.color.appScaffoldBg,
      body: BlocProvider(
        create: (context) => _isoBloc,
        child: BlocListener<ISOBloc, ISOApiState>(
          listener: (context, state) {},
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
                              text: 'IT ISO Requests\n',
                              style: context.textFontWeight600,
                              children: [
                                TextSpan(
                                    text:
                                        'The dashboard about the IT ISO Requests',
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

                  // ValueListenableBuilder(
                  //     valueListenable: _onDataChange,
                  //     builder: (context, onDataChange, child) {
                  //       return Column(
                  //         children: [
                  //           for (var i = 0; i < requestTypesRows; i++) ...[
                  //             Row(
                  //               children:
                  //                   List.generate(requestTypesColumns, (index) {
                  //                 final newIndex =
                  //                     index + (i * requestTypesColumns);
                  //                 return Expanded(
                  //                   child: InkWell(
                  //                     child: Container(
                  //                       color: resources.color.colorWhite,
                  //                       margin: isSelectedLocalEn
                  //                           ? EdgeInsets.only(
                  //                               left: index ==
                  //                                       requestTypesColumns - 1
                  //                                   ? resources.dimen.dp15
                  //                                   : index == 0
                  //                                       ? 0
                  //                                       : index ==
                  //                                               requestTypesColumns -
                  //                                                   2
                  //                                           ? resources
                  //                                               .dimen.dp15
                  //                                           : resources
                  //                                               .dimen.dp5,
                  //                               right: index <
                  //                                       requestTypesColumns - 2
                  //                                   ? index == 0
                  //                                       ? resources.dimen.dp15
                  //                                       : resources.dimen.dp5
                  //                                   : index <
                  //                                           requestTypesColumns -
                  //                                               1
                  //                                       ? resources.dimen.dp5
                  //                                       : 0,
                  //                               top: i > 0
                  //                                   ? resources.dimen.dp20
                  //                                   : 0,
                  //                             )
                  //                           : EdgeInsets.only(
                  //                               right: index ==
                  //                                       requestTypesColumns - 1
                  //                                   ? resources.dimen.dp15
                  //                                   : index == 0
                  //                                       ? 0
                  //                                       : index ==
                  //                                               requestTypesColumns -
                  //                                                   2
                  //                                           ? resources
                  //                                               .dimen.dp15
                  //                                           : resources
                  //                                               .dimen.dp5,
                  //                               left: index <
                  //                                       requestTypesColumns - 2
                  //                                   ? index == 0
                  //                                       ? resources.dimen.dp15
                  //                                       : resources.dimen.dp5
                  //                                   : index <
                  //                                           requestTypesColumns -
                  //                                               1
                  //                                       ? resources.dimen.dp5
                  //                                       : 0,
                  //                               top: i > 0
                  //                                   ? resources.dimen.dp20
                  //                                   : 0,
                  //                             ),
                  //                       padding: EdgeInsets.all(
                  //                           resources.dimen.dp10),
                  //                       child: Column(
                  //                         crossAxisAlignment:
                  //                             CrossAxisAlignment.center,
                  //                         children: [
                  //                           Align(
                  //                             alignment: Alignment.topRight,
                  //                             child: ImageWidget(
                  //                                     path: _requestTypes[
                  //                                                 newIndex]
                  //                                             ['icon_path']
                  //                                         .toString(),
                  //                                     width: 20,
                  //                                     height: 20)
                  //                                 .loadImage,
                  //                           ),
                  //                           Text(
                  //                             _requestTypes[newIndex]['count']
                  //                                 .toString(),
                  //                             textAlign: TextAlign.center,
                  //                             style: context.textFontWeight700
                  //                                 .onFontSize(
                  //                                     resources.fontSize.dp20)
                  //                                 .onFontFamily(
                  //                                     fontFamily: fontFamilyEN),
                  //                           ),
                  //                           Text(
                  //                             _requestTypes[newIndex]['name']
                  //                                 .toString(),
                  //                             textAlign: TextAlign.center,
                  //                             maxLines: 2,
                  //                             overflow: TextOverflow.visible,
                  //                             style: context.textFontWeight600
                  //                                 .onFontSize(
                  //                                     resources.fontSize.dp10)
                  //                                 .onHeight(1.1),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 );
                  //               }),
                  //             ),
                  //           ],
                  //         ],
                  //       );
                  //     }),

                  SizedBox(
                    height: resources.dimen.dp20,
                  ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  // Expanded(
                  //   child: Text.rich(
                  //     TextSpan(
                  //       text: 'Latest Requests',
                  //       style: context.textFontWeight600
                  //           .onFontSize(resources.fontSize.dp12),
                  //       //children: [
                  //       // TextSpan(
                  //       //     text: '',
                  //       //     style: context.textFontWeight400
                  //       //         .onFontSize(resources.fontSize.dp10)
                  //       //         .onColor(resources.color.textColorLight)
                  //       //         .onHeight(1))
                  //       //]
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: resources.dimen.dp20,
                  // ),
                  // Text(
                  //   '${resources.string.filterByDate}: ',
                  //   style: context.textFontWeight600
                  //       .onFontSize(resources.fontSize.dp10),
                  // ),
                  // SizedBox(
                  //   width: resources.dimen.dp10,
                  // ),
                  // ValueListenableBuilder(
                  //     valueListenable: _filteredDates,
                  //     builder: (context, value, child) {
                  //       return Container(
                  //         decoration: BackgroundBoxDecoration(
                  //                 radious: resources.dimen.dp15,
                  //                 boarderColor:
                  //                     resources.color.sideBarItemUnselected)
                  //             .roundedCornerBox,
                  //         padding: EdgeInsets.symmetric(
                  //           vertical: resources.dimen.dp5,
                  //         ),
                  //         child: Row(
                  //           children: [
                  //             SizedBox(
                  //               width: resources.dimen.dp10,
                  //             ),
                  //             InkWell(
                  //               onTap: () {
                  //                 showDatePicker(
                  //                         context: context,
                  //                         firstDate: DateTime.now().add(
                  //                             const Duration(days: -365)),
                  //                         lastDate: DateTime.now())
                  //                     .then((dateTime) {
                  //                   if (dateTime != null) {
                  //                     _filteredDates.value =
                  //                         List<String>.empty(growable: true)
                  //                           ..add(getDateByformat(
                  //                               'yyyy/MM/dd', dateTime));
                  //                   }
                  //                 });
                  //               },
                  //               child: Text.rich(
                  //                 TextSpan(
                  //                     text: value.isNotEmpty
                  //                         ? value[0]
                  //                         : resources.string.startDate,
                  //                     children: [
                  //                       WidgetSpan(
                  //                         child: Padding(
                  //                           padding: isSelectedLocalEn
                  //                               ? const EdgeInsets.only(
                  //                                   left: 5.0)
                  //                               : const EdgeInsets.only(
                  //                                   right: 5.0),
                  //                           child: const Icon(
                  //                             Icons.calendar_month_sharp,
                  //                             size: 16,
                  //                           ),
                  //                         ),
                  //                       )
                  //                     ]),
                  //                 style: context.textFontWeight400
                  //                     .onFontSize(resources.fontSize.dp10),
                  //               ),
                  //             ),
                  //             SizedBox(
                  //               width: resources.dimen.dp10,
                  //             ),
                  //             InkWell(
                  //               onTap: () {
                  //                 if (value.isNotEmpty) {
                  //                   showDatePicker(
                  //                           context: context,
                  //                           firstDate: getDateTimeByString(
                  //                               'yyyy/MM/dd', value[0]),
                  //                           lastDate: DateTime.now())
                  //                       .then((dateTime) {
                  //                     if (dateTime != null) {
                  //                       _filteredDates.value =
                  //                           List<String>.empty(
                  //                               growable: true)
                  //                             ..add(value[0])
                  //                             ..add(getDateByformat(
                  //                                 'yyyy/MM/dd', dateTime));
                  //                       _onDataChange.value =
                  //                           !_onDataChange.value;
                  //                     }
                  //                   });
                  //                 } else {
                  //                   Dialogs.showInfoDialog(
                  //                       context,
                  //                       PopupType.fail,
                  //                       resources.string.pleaseSelect +
                  //                           resources.string.startDate);
                  //                 }
                  //               },
                  //               child: Text.rich(
                  //                 TextSpan(
                  //                     text: value.length > 1
                  //                         ? value[1]
                  //                         : resources.string.endDate,
                  //                     children: [
                  //                       WidgetSpan(
                  //                         child: Padding(
                  //                           padding: isSelectedLocalEn
                  //                               ? const EdgeInsets.only(
                  //                                   left: 5.0)
                  //                               : const EdgeInsets.only(
                  //                                   right: 5.0),
                  //                           child: const Icon(
                  //                             Icons.calendar_month_sharp,
                  //                             size: 16,
                  //                           ),
                  //                         ),
                  //                       )
                  //                     ]),
                  //                 style: context.textFontWeight400
                  //                     .onFontSize(resources.fontSize.dp10),
                  //               ),
                  //             ),
                  //             SizedBox(
                  //               width: resources.dimen.dp5,
                  //             ),
                  //             InkWell(
                  //               onTap: () {
                  //                 if (_filteredDates.value.isNotEmpty) {
                  //                   _filteredDates.value = List.empty();
                  //                   _onDataChange.value =
                  //                       !(_onDataChange.value);
                  //                 }
                  //               },
                  //               child: const Padding(
                  //                 padding:
                  //                     EdgeInsets.symmetric(horizontal: 5),
                  //                 child: Icon(
                  //                   Icons.clear,
                  //                   size: 16,
                  //                 ),
                  //               ),
                  //             ),
                  //             SizedBox(
                  //               width: resources.dimen.dp5,
                  //             ),
                  //           ],
                  //         ),
                  //       );
                  //     }),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: resources.dimen.dp20,
                  // ),
                  ValueListenableBuilder(
                      valueListenable: _onDataChange,
                      builder: (context, onDataChange, child) {
                        return FutureBuilder(
                            future: _getCRTickets(),
                            builder: (context, snapShot) {
                              final filterTickets =
                                  List.from(snapShot.data?.entity?.items ?? []);
                              if (filterTickets.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Text(
                                    resources.string.noTickets,
                                    style: context.textFontWeight600,
                                  ),
                                );
                              }
                              final reportHeaderData =
                                  filterTickets.first.toJson().keys.toList();
                              final reportTableColunwidths =
                                  <int, FlexColumnWidth>{};
                              reportHeaderData.asMap().forEach((index, value) {
                                reportTableColunwidths[index] =
                                    const FlexColumnWidth(4);
                              });
                              return filterTickets.isNotEmpty
                                  ? DynamicReportListWidget(
                                      reportData: filterTickets,
                                      ticketsTableColunwidths:
                                          reportTableColunwidths,
                                      totalPagecount: 1,
                                      ticketsHeaderData: reportHeaderData,
                                      onRowSelected: (item) {
                                        if (item is CRRequestEntity) {
                                          ISOViewRequestScreen.start(
                                            context,
                                            item.requestId ?? 0,
                                          );
                                        }
                                      },
                                      onColumnClick: (key, item) {},
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
