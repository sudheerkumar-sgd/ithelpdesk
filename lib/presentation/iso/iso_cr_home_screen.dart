// ignore_for_file: must_be_immutable
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/common/log.dart';
import 'package:ithelpdesk/core/config/flavor_config.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/constants/data_constants.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/string_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/domain/entities/api_entity.dart';
import 'package:ithelpdesk/domain/entities/iso_entity.dart';
import 'package:ithelpdesk/domain/entities/single_data_entity.dart';
import 'package:ithelpdesk/domain/entities/user_credentials_entity.dart';
import 'package:ithelpdesk/injection_container.dart';
import 'package:ithelpdesk/presentation/bloc/iso/iso_bloc.dart';
import 'package:ithelpdesk/presentation/bloc/services/services_bloc.dart';
import 'package:ithelpdesk/presentation/common_widgets/action_button_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/date_range_filter_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dropdown_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dynamic_report_column_config.dart';
import 'package:ithelpdesk/presentation/common_widgets/dynamic_report_list_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/multi_select_dialog_widget.dart';
import 'package:ithelpdesk/presentation/iso/iso_system_cr_screen.dart';
import 'package:ithelpdesk/presentation/iso/iso_view_request_screen.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';

class IsoCrHomeScreen extends BaseScreenWidget {
  IsoCrHomeScreen({super.key});
  late FocusNode requestStatusFocusNode;
  final ISOBloc _isoBloc = sl<ISOBloc>();

  final ValueNotifier<bool> _onDataChange = ValueNotifier(false);
  //List<Map<String, Object>> _requestTypes = [];
  int selectTicketCategory = 1;
  final ValueNotifier<int> _selectedYear = ValueNotifier(2024);
  //final ValueNotifier<List<String>> _filteredDates = ValueNotifier([]);
  StatusType filteredStatus = StatusType.all;
  int index = 0;
  final List<int> _filteredRequestStatus = List<int>.empty(growable: true);
  final List<int> _filteredCurrentSteps = List<int>.empty(growable: true);
  String? _sortByField;
  bool _sortAscending = true;
  DynamicReportHeaderEntity? _sortHeader;
  Map<String, dynamic>? filteredData;

  final ValueNotifier<List<String>> filteredDates = ValueNotifier([]);
  int? _selectedCategory = 0;

  Widget _getFilters(BuildContext context) {
    final resources = context.resources;
    final categories = [
      resources.string.all,
      isSelectedLocalEn ? 'My Requests' : 'الطلبات الخاصة بي',
      isSelectedLocalEn ? 'Pending Approval' : 'تحت المراجعة',
    ];
    return Wrap(
      alignment: WrapAlignment.end,
      runSpacing: resources.dimen.dp10,
      runAlignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        DateRangeFilterWidget(
          filteredDates: filteredDates,
          onChanged: () {
            if (context.mounted) {
              index = 0;
              _onDataChange.value = !_onDataChange.value;
            }
          },
        ),
        SizedBox(
          width: resources.dimen.dp20,
        ),
        SizedBox(
          width: 200,
          child: Row(
            children: [
              Text(
                resources.string.category,
                style: context.textFontWeight600
                    .onFontSize(resources.fontSize.dp10),
              ),
              SizedBox(
                width: resources.dimen.dp5,
              ),
              Expanded(
                child: DropDownWidget<String>(
                  height: 32,
                  list: categories,
                  selectedValue: categories[_selectedCategory ?? 0],
                  iconSize: 20,
                  fontStyle: context.textFontWeight400
                      .onFontSize(resources.fontSize.dp12),
                  callback: (p0) {
                    _selectedCategory = categories.indexOf(p0 ?? 'All');
                    index = 0;
                    _onDataChange.value = !_onDataChange.value;
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: resources.dimen.dp10,
        ),
        InkWell(
          onTap: () async {
            if (context.mounted) {
              Dialogs.loader(context);
            }
            final allTicketsResponse = await _getCRTickets(forReport: true);
            await sl<ServicesBloc>().exportToExcel(
                allTicketsResponse.entity?.requests ?? [],
                title: 'ISO Requests');
            if (context.mounted) {
              Dialogs.dismiss(context);
            }
          },
          child: ActionButtonWidget(
              text: 'Excel',
              radious: resources.dimen.dp15,
              textSize: resources.fontSize.dp10,
              padding: EdgeInsets.symmetric(
                  vertical: resources.dimen.dp5,
                  horizontal: resources.dimen.dp15),
              color: resources.color.sideBarItemSelected),
        ),
        SizedBox(
          width: resources.dimen.dp10,
        ),
        InkWell(
          onTap: () {
            _printData(context);
          },
          child: ActionButtonWidget(
            text: 'PDF',
            padding: EdgeInsets.symmetric(
                vertical: resources.dimen.dp5,
                horizontal: resources.dimen.dp15),
            radious: resources.dimen.dp15,
            textSize: resources.fontSize.dp10,
            color: resources.color.sideBarItemSelected,
          ),
        ),
      ],
    );
  }

  Future<void> _printData(BuildContext context) async {
    Dialogs.loader(context);
    final allRequestsResponse = await _getCRTickets(forReport: true);
    final allRequests = allRequestsResponse.entity?.requests ?? [];
    List<String> headers = List.empty(growable: true);
    if (allRequests.isNotEmpty) {
      allRequests.first.toJson().forEach((k, v) {
        if (!headers.contains(k.capitalize())) {
          headers.add(k.capitalize());
        }
      });
    }
    String tableHeader = '<tr>';
    for (var item in headers) {
      tableHeader = '$tableHeader\n <td>$item</td>';
    }
    tableHeader = '$tableHeader\n</tr>';
    String tableBody = '';
    for (var item in allRequests) {
      tableBody = '$tableBody\n<tr>';
      item.toJson().forEach((k, v) {
        tableBody =
            '$tableBody\n <td>${k == 'TicketNo' ? '''<a href="${FlavorConfig.isProduction() ? "https://ithelpdesk.uaqgov.ae" : "http://localhost:50768"}/ticket/$v" target="_blank"> $v </a>''' : v}</td>';
      });
      tableBody = '$tableBody\n</tr>';
    }
    printData(
        title: "ISO Requests",
        headerData: tableHeader,
        bodyData: tableBody,
        count: allRequests.length);
    if (context.mounted) Dialogs.dismiss(context);
  }

  List<Widget> _getFilterBar(BuildContext context) {
    final resources = context.resources;
    return [
      if (UserCredentialsEntity.details().userType != UserType.user) ...[
        SizedBox(
          width: resources.dimen.dp20,
          height: resources.dimen.dp10,
        ),
        isDesktop(context)
            ? Expanded(
                child: _getFilters(context),
              )
            : _getFilters(context)
      ],
    ];
  }

  List<DynamicReportHeaderEntity> _getDefaultTicketsHeaderData() {
    final labels =
        crRequestReport.map((field) => field['Name']!.toString()).toList();
    return buildReportHeadersFromKeys(
      labels,
      reportFields: crRequestReport,
    );
  }

  List<DynamicReportHeaderEntity> _getTicketsHeaderData(
    List<dynamic> tickets,
  ) {
    if (tickets.isEmpty) {
      return _getDefaultTicketsHeaderData();
    }
    final firstTicket = tickets.first as CRRequestEntity;
    return buildReportHeadersFromKeys(
      firstTicket.toJson().keys.toList(),
      reportFields: firstTicket.workflowFieldEntity?.reportFields,
    );
  }

  (DateTime? fromDate, DateTime? toDate) _getDateRangeFilter() {
    final dates = filteredDates.value;
    if (dates.isEmpty) {
      return (null, null);
    }
    final fromDate = getDateTimeByString('yyyy/MM/dd', dates[0]);
    DateTime? toDate;
    if (dates.length > 1) {
      toDate = getDateTimeByString('yyyy/MM/dd', dates[1]);
    }
    return (fromDate, toDate);
  }

  Map<String, dynamic> _getRequestParams({bool forReport = false}) {
    final requestParams = <String, dynamic>{'index': index};
    requestParams['forReport'] = forReport;
    if (_filteredRequestStatus.isNotEmpty) {
      requestParams['requestStatus'] = _filteredRequestStatus.join(',');
    }
    if (_filteredCurrentSteps.isNotEmpty) {
      requestParams['currentStep'] = _filteredCurrentSteps.join(',');
    }
    final (fromDate, toDate) = _getDateRangeFilter();
    if (fromDate != null) {
      requestParams['fromDate'] = fromDate;
    }
    if (toDate != null) {
      requestParams['toDate'] = toDate;
    }
    requestParams['viewType'] = _selectedCategory;
    return requestParams;
  }

  Future<ApiEntity<CRRequestDataEntity>> _getCRTickets(
      {bool forReport = false}) async {
    final response = await _isoBloc.getRequests(
        requestParams: _getRequestParams(forReport: forReport));
    final requestData = ApiEntity<CRRequestDataEntity>();
    if (response is OnISOApiResponse) {
      final crRequestDataEntity =
          cast<CRRequestDataEntity>(response.response.entity);
      requestData.entity = crRequestDataEntity;
    }
    return Future.value(requestData);
  }

  List<dynamic> _applyClientSort(
    List<dynamic> tickets,
    List<DynamicReportHeaderEntity> headers,
  ) {
    if (_sortByField == null) {
      return tickets;
    }
    final header = _sortHeader ??
        headers.firstWhere(
          (item) => item.resolvedFieldKey == _sortByField,
          orElse: () => DynamicReportHeaderEntity(
            label: '',
            fieldKey: _sortByField,
          ),
        );
    return sortReportData(tickets, header, ascending: _sortAscending);
  }

  Future<void> _handleColumnHeaderTap(
    BuildContext context,
    DynamicReportHeaderEntity header,
  ) async {
    if (header.hasSort) {
      final fieldKey = header.resolvedFieldKey;
      if (_sortByField == fieldKey) {
        _sortAscending = !_sortAscending;
      } else {
        _sortByField = fieldKey;
        _sortHeader = header;
        _sortAscending = true;
      }
      _onDataChange.value = !_onDataChange.value;
      return;
    }

    if (header.filterType == DynamicReportFilterType.requestStatus) {
      final selected = await Dialogs.showDialogWithClose(
        context,
        MultiSelectDialogWidget<RequestStatus>(
          list: RequestStatus.values,
          selectedItems: RequestStatus.values
              .where((status) => _filteredRequestStatus.contains(status.value))
              .toList(),
        ),
        maxWidth: isDesktop(context) ? 250 : null,
        showClose: false,
      );
      if (selected is List<RequestStatus>) {
        _filteredRequestStatus
          ..clear()
          ..addAll(selected.map((status) => status.value));
        index = 0;
        _onDataChange.value = !_onDataChange.value;
      }
      return;
    }

    if (header.filterType == DynamicReportFilterType.currentStep) {
      final selected = await Dialogs.showDialogWithClose(
        context,
        MultiSelectDialogWidget<NameIDEntity>(
          list: isoCrCurrentStepFilters,
          selectedItems: isoCrCurrentStepFilters
              .where((step) =>
                  step.id != null && _filteredCurrentSteps.contains(step.id))
              .toList(),
        ),
        maxWidth: isDesktop(context) ? 300 : null,
        showClose: false,
      );
      if (selected is List<NameIDEntity>) {
        _filteredCurrentSteps
          ..clear()
          ..addAll(selected.map((step) => step.id).whereType<int>());
        index = 0;
        _onDataChange.value = !_onDataChange.value;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    // Future.delayed(Duration.zero, () {
    //   _getCRTickets();
    // });
    _selectedYear.value = DateTime.now().year;
    //final requestTypesRows = isDesktop(context) ? 1 : 2;
    //final requestTypesColumns = isDesktop(context) ? 4 : 2;
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
                              text: isSelectedLocalEn
                                  ? 'IT ISO Requests\n'
                                  : 'طلبات IT ISO\n',
                              style: context.textFontWeight600,
                              children: [
                                TextSpan(
                                    text: isSelectedLocalEn
                                        ? 'The dashboard about the IT ISO Requests'
                                        : 'لوحة المعلومات حول طلبات IT ISO',
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
                              IsoSystemCrScreen.start(context).then((value) {
                                if (value == true) {
                                  _onDataChange.value = !_onDataChange.value;
                                }
                              });
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
                  isDesktop(context)
                      ? Row(
                          children: _getFilterBar(context),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _getFilterBar(context),
                        ),
                  SizedBox(
                    height: resources.dimen.dp20,
                  ),
                  ValueListenableBuilder(
                      valueListenable: _onDataChange,
                      builder: (context, onDataChange, child) {
                        return FutureBuilder(
                            future: _getCRTickets(),
                            builder: (context, snapShot) {
                              if (snapShot.connectionState ==
                                  ConnectionState.waiting) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    top: resources.dimen.dp40,
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              final tickets = List.from(
                                  snapShot.data?.entity?.requests ?? []);
                              final ticketsHeaderData =
                                  _getTicketsHeaderData(tickets);
                              final displayTickets =
                                  _applyClientSort(tickets, ticketsHeaderData);
                              final reportTableColunwidths =
                                  <int, FlexColumnWidth>{};
                              ticketsHeaderData.asMap().forEach((index, value) {
                                reportTableColunwidths[index] =
                                    const FlexColumnWidth(4);
                              });
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  DynamicReportListWidget(
                                    reportData: displayTickets,
                                    ticketsTableColunwidths:
                                        reportTableColunwidths,
                                    activeSortFieldKey: _sortByField,
                                    sortAscending: _sortAscending,
                                    page: tickets.isEmpty ? 1 : index ~/ 10 + 1,
                                    totalPagecount: tickets.isEmpty
                                        ? 0
                                        : snapShot.data?.entity?.totalPage ?? 1,
                                    ticketsHeaderData: ticketsHeaderData,
                                    onColumnHeaderTap: _handleColumnHeaderTap,
                                    onRowSelected: (item) {
                                      if (item is CRRequestEntity) {
                                        ISOViewRequestScreen.start(
                                          context,
                                          item.requestId ?? 0,
                                        );
                                      }
                                    },
                                    onColumnClick: (key, item) {},
                                    onPageChange: (page) {
                                      index = (page - 1) * 10;
                                      _onDataChange.value =
                                          !_onDataChange.value;
                                    },
                                  ),
                                  if (tickets.isEmpty &&
                                      snapShot.connectionState ==
                                          ConnectionState.done)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Text(
                                        isSelectedLocalEn
                                            ? 'No Requests'
                                            : 'لا توجد طلبات',
                                        textAlign: TextAlign.center,
                                        style: context.textFontWeight600
                                            .onFontSize(
                                                resources.fontSize.dp16),
                                      ),
                                    ),
                                ],
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
