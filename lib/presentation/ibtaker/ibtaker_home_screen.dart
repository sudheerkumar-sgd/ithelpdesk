// ignore_for_file: must_be_immutable
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/string_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/domain/entities/api_entity.dart';
import 'package:ithelpdesk/domain/entities/ibtaker_entity.dart';
import 'package:ithelpdesk/domain/entities/master_data_entities.dart';
import 'package:ithelpdesk/injection_container.dart';
import 'package:ithelpdesk/presentation/bloc/iso/iso_bloc.dart';
import 'package:ithelpdesk/presentation/common_widgets/action_button_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dynamic_report_column_config.dart';
import 'package:ithelpdesk/presentation/common_widgets/dynamic_report_list_widget.dart';
import 'package:ithelpdesk/presentation/ibtaker/ibtaker_details_screen.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';

import '../common_widgets/alert_dialog_widget.dart';

class _IbtakerStatusTab {
  const _IbtakerStatusTab({
    required this.apiStatus,
    required this.count,
  });
  final IbtakerStatus apiStatus;
  final int count;
}

class IbtakerHomeScreen extends StatefulWidget {
  const IbtakerHomeScreen({super.key});

  @override
  State<IbtakerHomeScreen> createState() => _IbtakerHomeScreenState();
}

class _IbtakerHomeScreenState extends State<IbtakerHomeScreen> {
  final ISOBloc _isoBloc = sl<ISOBloc>();
  final ValueNotifier<bool> _onTabDataChange = ValueNotifier(false);
  final ValueNotifier<bool> _onDataChange = ValueNotifier(false);
  final ValueNotifier<bool> _onSearchChange = ValueNotifier(false);
  final ValueNotifier<List<String>> _filteredDates = ValueNotifier([]);
  final TextEditingController _searchController = TextEditingController();
  int _pageNumber = 1;
  final int _pageSize = 20;
  String _search = '';
  int? _statusFilter;
  int _ibtakerType = 1;
  List<_IbtakerStatusTab> _statusTabs = const [
    _IbtakerStatusTab(apiStatus: IbtakerStatus.all, count: 0),
    _IbtakerStatusTab(apiStatus: IbtakerStatus.submitted, count: 0),
    _IbtakerStatusTab(apiStatus: IbtakerStatus.approved, count: 0),
    _IbtakerStatusTab(apiStatus: IbtakerStatus.rejected, count: 0),
    _IbtakerStatusTab(apiStatus: IbtakerStatus.transfered, count: 0),
    _IbtakerStatusTab(apiStatus: IbtakerStatus.hold, count: 0),
    _IbtakerStatusTab(apiStatus: IbtakerStatus.closed, count: 0),
  ];

  Map<String, dynamic> _buildRequestParams({required int pageNumber}) {
    final m = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': _pageSize,
      'ibtakerType': _ibtakerType,
    };
    if (_statusFilter != null && _statusFilter != -1) {
      m['status'] = _statusFilter;
    }
    if (_search.isNotEmpty) {
      m['search'] = _search;
    }
    if (_filteredDates.value.length == 2) {
      final dateFormat = DateFormat('dd-MMM-yyyy HH:mm');
      final startTime = DateFormat('yyyy/MM/dd').parse(_filteredDates.value[0]);
      final endTime = DateFormat('yyyy/MM/dd').parse(_filteredDates.value[1]);
      m['startDate'] = dateFormat.format(startTime);
      m['endDate'] = dateFormat.format(endTime);
    }
    return m;
  }

  void _updateStatusTabs(IbtakerListDataEntity entity) {
    final tabs = <_IbtakerStatusTab>[
      _IbtakerStatusTab(
        apiStatus: IbtakerStatus.all,
        count: entity.totalCount ?? entity.ideas.length,
      ),
      ...entity.countByStatus.map(
        (e) => _IbtakerStatusTab(
          apiStatus: IbtakerStatus.fromId(e.statusValue),
          count: e.count ?? 0,
        ),
      )
    ];
    _statusTabs = tabs;
  }

  void _selectStatusFilter(int? status) {
    if (_statusFilter == status) return;
    setState(() {
      _statusFilter = status;
      _pageNumber = 1;
    });
    _onDataChange.value = !_onDataChange.value;
  }

  void _selectIbtakerType(int ibtakerType) {
    if (_ibtakerType == ibtakerType) return;
    setState(() {
      _ibtakerType = ibtakerType;
      _pageNumber = 1;
    });
    _onDataChange.value = !_onDataChange.value;
  }

  Widget _buildTypeTab(
    BuildContext context, {
    required String label,
    required int type,
  }) {
    final resources = context.resources;
    final isSelected = _ibtakerType == type;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _selectIbtakerType(type),
          borderRadius: BorderRadius.circular(resources.dimen.dp8),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: resources.dimen.dp15,
              vertical: resources.dimen.dp10,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? resources.color.sideBarItemSelected
                  : resources.color.colorWhite,
              borderRadius: BorderRadius.circular(resources.dimen.dp8),
              border: Border.all(
                color: isSelected
                    ? resources.color.sideBarItemSelected
                    : resources.color.sideBarItemUnselected,
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: context.textFontWeight600
                  .onFontSize(resources.fontSize.dp11)
                  .onColor(
                    isSelected
                        ? resources.color.colorWhite
                        : resources.color.textColor,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeTabs(BuildContext context) {
    final resources = context.resources;
    return Row(
      children: [
        _buildTypeTab(
          context,
          label: isSelectedLocalEn ? 'Internal' : 'داخلي',
          type: 1,
        ),
        SizedBox(width: resources.dimen.dp8),
        _buildTypeTab(
          context,
          label: isSelectedLocalEn ? 'External' : 'خارجي',
          type: 2,
        ),
      ],
    );
  }

  Widget _buildStatusTabs(BuildContext context) {
    final resources = context.resources;
    return Row(
      children: [
        for (var i = 0; i < _statusTabs.length; i++) ...[
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () =>
                    _selectStatusFilter(_statusTabs[i].apiStatus.value),
                borderRadius: BorderRadius.circular(resources.dimen.dp8),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: resources.dimen.dp15,
                    vertical: resources.dimen.dp10,
                  ),
                  decoration: BoxDecoration(
                    color: _statusFilter == _statusTabs[i].apiStatus.value
                        ? resources.color.sideBarItemSelected
                        : resources.color.colorWhite,
                    borderRadius: BorderRadius.circular(resources.dimen.dp8),
                    border: Border.all(
                      color: _statusFilter == _statusTabs[i].apiStatus.value
                          ? resources.color.sideBarItemSelected
                          : resources.color.sideBarItemUnselected,
                    ),
                  ),
                  child: Text(
                    textAlign: TextAlign.center,
                    '${_statusTabs[i].apiStatus.toString()} (${_statusTabs[i].count})',
                    style: context.textFontWeight600
                        .onFontSize(resources.fontSize.dp11)
                        .onColor(
                          _statusFilter == _statusTabs[i].apiStatus.value
                              ? resources.color.colorWhite
                              : resources.color.textColor,
                        ),
                  ),
                ),
              ),
            ),
          ),
          if (i < _statusTabs.length - 1) SizedBox(width: resources.dimen.dp8),
        ],
      ],
    );
  }

  Future<ApiEntity<IbtakerListDataEntity>> _loadIdeas() async {
    final response = await _isoBloc.getMyAndTeamIbtakerIdeas(
        requestParams: _buildRequestParams(pageNumber: _pageNumber));
    final data = ApiEntity<IbtakerListDataEntity>();
    if (response is OnISOApiResponse) {
      data.entity = cast<IbtakerListDataEntity>(response.response.entity);
      if (data.entity != null) {
        _updateStatusTabs(data.entity!);
        _onTabDataChange.value = !_onTabDataChange.value;
      }
    }
    return Future.value(data);
  }

  Future<List<IbtakerIdeaEntity>> _fetchAllIdeasForExport() async {
    final all = <IbtakerIdeaEntity>[];
    var page = 1;
    var totalPages = 1;
    do {
      final response = await _isoBloc.getMyAndTeamIbtakerIdeas(
          requestParams: _buildRequestParams(pageNumber: page));
      if (response is OnISOApiResponse) {
        final entity = cast<IbtakerListDataEntity>(response.response.entity);
        all.addAll(entity.ideas);
        totalPages = entity.totalPages ?? 1;
      } else {
        break;
      }
      page++;
    } while (page <= totalPages);
    return all;
  }

  String _escapeHtml(String s) {
    return s
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;');
  }

  Future<void> _exportToExcel(BuildContext context) async {
    if (!context.mounted) return;
    Dialogs.loader(context);
    final ideas = await _fetchAllIdeasForExport();
    if (!context.mounted) return;
    Dialogs.dismiss(context);
    if (ideas.isEmpty) {
      Dialogs.showInfoDialog(
        context,
        PopupType.fail,
        isSelectedLocalEn ? 'No data to export' : 'لا توجد بيانات للتصدير',
      );
      return;
    }
    await exportToExcel(ExportDataEntity()
      ..title = 'IbtakerIdeas'
      ..date = getDateByformat('dd/MM/yyyy', DateTime.now())
      ..columns = ideas.first.toExcel().keys.toList()
      ..rows = ideas);
  }

  Future<void> _exportToPdf(BuildContext context) async {
    if (!context.mounted) return;
    Dialogs.loader(context);
    final ideas = await _fetchAllIdeasForExport();
    if (!context.mounted) return;
    Dialogs.dismiss(context);
    if (ideas.isEmpty) {
      Dialogs.showInfoDialog(
        context,
        PopupType.fail,
        isSelectedLocalEn ? 'No data to export' : 'لا توجد بيانات للتصدير',
      );
      return;
    }
    final headers = ideas.first.toExcel().keys.toList();
    var tableHeader = '<tr>';
    for (final h in headers) {
      tableHeader = '$tableHeader\n <th>${_escapeHtml(h.capitalize())}</th>';
    }
    tableHeader = '$tableHeader\n</tr>';
    var tableBody = '';
    for (final idea in ideas) {
      tableBody = '$tableBody\n<tr>';
      idea.toExcel().forEach((k, v) {
        tableBody = '$tableBody\n <td>${_escapeHtml('${v ?? ''}')}</td>';
      });
      tableBody = '$tableBody\n</tr>';
    }
    await printData(
      title: 'Ibtaker ideas',
      headerData: tableHeader,
      bodyData: tableBody,
      count: ideas.length,
    );
  }

  Widget _buildDateFilters(BuildContext context) {
    final resources = context.resources;
    return ValueListenableBuilder<List<String>>(
      valueListenable: _filteredDates,
      builder: (context, value, child) {
        return Container(
          decoration: BackgroundBoxDecoration(
                  radious: resources.dimen.dp15,
                  boarderColor: resources.color.sideBarItemUnselected)
              .roundedCornerBox,
          padding: EdgeInsets.symmetric(vertical: resources.dimen.dp5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: resources.dimen.dp10),
              InkWell(
                onTap: () {
                  showDatePicker(
                    context: context,
                    firstDate: DateTime.now().add(const Duration(days: -365)),
                    lastDate: DateTime.now(),
                  ).then((dateTime) {
                    if (dateTime != null) {
                      _filteredDates.value = List<String>.empty(growable: true)
                        ..add(getDateByformat('yyyy/MM/dd', dateTime));
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
                              ? const EdgeInsets.only(left: 5.0)
                              : const EdgeInsets.only(right: 5.0),
                          child: const Icon(
                            Icons.calendar_month_sharp,
                            size: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                  style: context.textFontWeight400
                      .onFontSize(resources.fontSize.dp10),
                ),
              ),
              SizedBox(width: resources.dimen.dp10),
              InkWell(
                onTap: () {
                  if (value.isNotEmpty) {
                    showDatePicker(
                      context: context,
                      initialDate: getDateTimeByString('yyyy/MM/dd', value[0]),
                      firstDate: getDateTimeByString('yyyy/MM/dd', value[0]),
                      lastDate: DateTime.now(),
                    ).then((dateTime) {
                      if (dateTime != null) {
                        _filteredDates.value =
                            List<String>.empty(growable: true)
                              ..add(value[0])
                              ..add(getDateByformat('yyyy/MM/dd',
                                  dateTime.add(const Duration(hours: 24))));
                        _pageNumber = 1;
                        _onDataChange.value = !_onDataChange.value;
                      }
                    });
                  } else {
                    Dialogs.showInfoDialog(
                      context,
                      PopupType.fail,
                      resources.string.pleaseSelect +
                          resources.string.startDate,
                    );
                  }
                },
                child: Text.rich(
                  TextSpan(
                    text:
                        value.length > 1 ? value[1] : resources.string.endDate,
                    children: [
                      WidgetSpan(
                        child: Padding(
                          padding: isSelectedLocalEn
                              ? const EdgeInsets.only(left: 5.0)
                              : const EdgeInsets.only(right: 5.0),
                          child: const Icon(
                            Icons.calendar_month_sharp,
                            size: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                  style: context.textFontWeight400
                      .onFontSize(resources.fontSize.dp10),
                ),
              ),
              SizedBox(width: resources.dimen.dp5),
              InkWell(
                onTap: () {
                  if (_filteredDates.value.isNotEmpty) {
                    _filteredDates.value = List.empty();
                    _pageNumber = 1;
                    _onDataChange.value = !_onDataChange.value;
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Icon(Icons.clear, size: 16),
                ),
              ),
              SizedBox(width: resources.dimen.dp5),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _onDataChange.dispose();
    _filteredDates.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Ibtaker report',
                    style: context.textFontWeight600,
                  ),
                  SizedBox(height: resources.dimen.dp20),
                  _buildTypeTabs(context),
                  SizedBox(height: resources.dimen.dp20),
                  ValueListenableBuilder(
                      valueListenable: _onTabDataChange,
                      builder: (context, value, child) {
                        return _buildStatusTabs(context);
                      }),
                  SizedBox(height: resources.dimen.dp20),
                  Row(
                    children: [
                      Text(
                        _statusTabs
                            .firstWhere(
                              (e) => e.apiStatus.value == _statusFilter,
                              orElse: () => _statusTabs.first,
                            )
                            .apiStatus
                            .toString(),
                        style: context.textFontWeight600
                            .onColor(resources.color.viewBgColor),
                      ),
                      SizedBox(width: resources.dimen.dp20),
                      const Spacer(),
                      Wrap(
                        alignment: WrapAlignment.start,
                        runSpacing: resources.dimen.dp10,
                        spacing: resources.dimen.dp10,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            '${resources.string.filterByDate}: ',
                            style: context.textFontWeight600
                                .onColor(resources.color.viewBgColor),
                          ),
                          _buildDateFilters(context),
                          InkWell(
                            onTap: () => _exportToExcel(context),
                            child: ActionButtonWidget(
                              text: 'Excel',
                              radious: resources.dimen.dp15,
                              textSize: resources.fontSize.dp10,
                              padding: EdgeInsets.symmetric(
                                vertical: resources.dimen.dp5,
                                horizontal: resources.dimen.dp15,
                              ),
                              color: resources.color.sideBarItemSelected,
                            ),
                          ),
                          InkWell(
                            onTap: () => _exportToPdf(context),
                            child: ActionButtonWidget(
                              text: 'PDF',
                              radious: resources.dimen.dp15,
                              textSize: resources.fontSize.dp10,
                              padding: EdgeInsets.symmetric(
                                vertical: resources.dimen.dp5,
                                horizontal: resources.dimen.dp15,
                              ),
                              color: resources.color.sideBarItemSelected,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _onSearchChange.value = !_onSearchChange.value;
                            },
                            icon: const Icon(Icons.search),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: resources.dimen.dp20),
                  ValueListenableBuilder(
                      valueListenable: _onSearchChange,
                      builder: (context, value, child) {
                        return value
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: TextFormField(
                                  controller: _searchController,
                                  textInputAction: TextInputAction.search,
                                  onFieldSubmitted: (value) {
                                    _search = value.trim();
                                    _pageNumber = 1;
                                    _onDataChange.value = !_onDataChange.value;
                                  },
                                  decoration: InputDecoration(
                                    hintText: isSelectedLocalEn
                                        ? 'Search ideas'
                                        : 'ابحث في الأفكار',
                                    prefixIcon: const Icon(Icons.search),
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        _searchController.clear();
                                        _search = '';
                                        _pageNumber = 1;
                                        _onDataChange.value =
                                            !_onDataChange.value;
                                      },
                                      child: const Icon(Icons.clear),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                resources.dimen.dp10))),
                                    isDense: true,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink();
                      }),
                  ValueListenableBuilder(
                      valueListenable: _onDataChange,
                      builder: (context, _, __) {
                        return FutureBuilder(
                            future: _loadIdeas(),
                            builder: (context, snapShot) {
                              final ideas = snapShot.data?.entity?.ideas ?? [];
                              if (ideas.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: Text(
                                    isSelectedLocalEn
                                        ? 'No ideas found'
                                        : 'لا توجد أفكار',
                                    style: context.textFontWeight600
                                        .onFontSize(resources.fontSize.dp16),
                                  ),
                                );
                              }
                              final reportLabels =
                                  ideas.first.toJson().keys.toList();
                              final ticketsHeaderData =
                                  buildReportHeadersFromKeys(reportLabels);
                              final reportTableColunwidths =
                                  <int, FlexColumnWidth>{};
                              ticketsHeaderData.asMap().forEach((index, value) {
                                reportTableColunwidths[index] =
                                    const FlexColumnWidth(4);
                              });
                              return DynamicReportListWidget(
                                reportData: ideas,
                                ticketsTableColunwidths: reportTableColunwidths,
                                page: snapShot.data?.entity?.pageNumber ?? 1,
                                totalPagecount:
                                    snapShot.data?.entity?.totalPages ?? 1,
                                ticketsHeaderData: ticketsHeaderData,
                                onRowSelected: (item) {
                                  if (item is IbtakerIdeaEntity) {
                                    IbtakerDetailsScreen.start(context, item)
                                        .then((value) {
                                      if (value == true) {
                                        _onDataChange.value =
                                            !_onDataChange.value;
                                      }
                                    });
                                  }
                                },
                                onColumnClick: (key, item) {},
                                onPageChange: (page) {
                                  _pageNumber = page;
                                  _onDataChange.value = !_onDataChange.value;
                                },
                              );
                            });
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
