import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/config/flavor_config.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/string_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/data/remote/api_urls.dart';
import 'package:ithelpdesk/domain/entities/master_data_entities.dart';
import 'package:ithelpdesk/domain/entities/single_data_entity.dart';
import 'package:ithelpdesk/domain/entities/user_entity.dart';
import 'package:ithelpdesk/presentation/bloc/master_data/master_data_bloc.dart';
import 'package:ithelpdesk/presentation/bloc/services/services_bloc.dart';
import 'package:ithelpdesk/presentation/common_widgets/action_button_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/date_range_filter_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dropdown_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/multi_select_dialog_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/report_list_widget.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';

import '../../domain/entities/dashboard_entity.dart';
import '../../domain/entities/user_credentials_entity.dart';
import '../../injection_container.dart';
import '../requests/view_request.dart';

// ignore: must_be_immutable
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final ServicesBloc _servicesBloc = sl<ServicesBloc>();
  final _masterDataBloc = sl<MasterDataBloc>();
  List<TicketEntity> tickets = List.empty(growable: true);
  List<UserEntity> assigniedEmployees = List.empty(growable: true);

  int? index;

  int? totalPagecount;

  final ValueNotifier<bool> _onFilterChange = ValueNotifier(false);

  int? _selectedCategory = 0;

  String? selectedStatus;

  Map<String, dynamic>? filteredData;

  final ValueNotifier<List<String>> filteredDates = ValueNotifier([]);
  final List<int> _selectedEmployees = [];
  final List<int> _selectedDepartments = [];
  final List<int> _selectedCategories = [];
  final List<int> _filteredStatus = [];
  final List<int> _filteredIssueType = [];
  final List<int> _filteredPriorities = [];
  final List<int> _filteredRatings = [];
  bool _chargeable = false;
  List<dynamic>? _employees;
  List<dynamic>? _departments;

  Widget _getFilters(BuildContext context) {
    final resources = context.resources;
    final categories = [
      resources.string.all,
      resources.string.assignedTickets,
      resources.string.myTickets,
      resources.string.employeeTickets,
      isSelectedLocalEn
          ? 'First Contact Resolved Tickets'
          : 'التذاكر المحلولة بالاتصال الأول',
      isSelectedLocalEn ? 'Rating Tickets' : 'تذاكر التقييم',
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
              _updateTickets(context);
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
                    _employees = null;
                    if ((_selectedCategory ?? 0) != 5) {
                      _filteredRatings.clear();
                    }
                    _updateTickets(context);
                  },
                ),
              ),
            ],
          ),
        ),
        // ValueListenableBuilder(
        //     valueListenable: _selectedCategory,
        //     builder: (context, category, child) {
        //       return (category == 0 || category == 3)
        //           ? SizedBox(
        //               width: 250,
        //               child: Row(
        //                 children: [
        //                   SizedBox(
        //                     width: resources.dimen.dp20,
        //                   ),
        //                   Text(
        //                     resources.string.employee,
        //                     style: context.textFontWeight600
        //                         .onFontSize(resources.fontSize.dp10),
        //                   ),
        //                   SizedBox(
        //                     width: resources.dimen.dp5,
        //                   ),
        //                   Expanded(
        //                     child: FutureBuilder(
        //                         future: _masterDataBloc.getAssignedEmployees(
        //                             requestParams: {},
        //                             apiUrl: assignedEmployeesByUserApiUrl),
        //                         builder: (context, snapShot) {
        //                           final items = snapShot.data?.items ?? [];
        //                           if (items.isNotEmpty) {
        //                             final employee = UserEntity();
        //                             employee.id = 0;
        //                             employee.name = resources.string.all;
        //                             _selectedEmployee.value = employee;
        //                             items.insert(0, employee);
        //                           }
        //                           return DropDownWidget(
        //                             isEnabled: true,
        //                             height: 32,
        //                             iconSize: 20,
        //                             selectedValue: _selectedEmployee.value,
        //                             fontStyle: context.textFontWeight400
        //                                 .onFontSize(resources.fontSize.dp12),
        //                             list: items,
        //                             callback: (value) {
        //                               _selectedEmployee.value = value;
        //                             },
        //                           );
        //                         }),
        //                   ),
        //                 ],
        //               ),
        //             )
        //           : const SizedBox();
        //     }),
        // SizedBox(
        //   width: resources.dimen.dp10,
        // ),
        // SizedBox(
        //   width: 200,
        //   child: Row(
        //     children: [
        //       Text(
        //         resources.string.status,
        //         style: context.textFontWeight600
        //             .onFontSize(resources.fontSize.dp10),
        //       ),
        //       SizedBox(
        //         width: resources.dimen.dp10,
        //       ),
        //       Expanded(
        //         child: DropDownWidget(
        //           height: 32,
        //           list: statusTypes,
        //           iconSize: 20,
        //           selectedValue: selectedStatus ?? statusTypes[0],
        //           fontStyle: context.textFontWeight400
        //               .onFontSize(resources.fontSize.dp12),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // SizedBox(
        //   width: resources.dimen.dp10,
        // ),
        // SizedBox(
        //   width: 120,
        //   child: Row(
        //     children: [
        //       Text(
        //         resources.string.export,
        //         style: context.textFontWeight600
        //             .onFontSize(resources.fontSize.dp10),
        //       ),
        //       SizedBox(
        //         width: resources.dimen.dp5,
        //       ),
        //       Expanded(
        //         child: DropDownWidget(
        //           height: 28,
        //           list: const [
        //             'exl',
        //             'pdf',
        //           ],
        //           iconSize: 20,
        //           fontStyle: context.textFontWeight400
        //               .onFontSize(resources.fontSize.dp10),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        SizedBox(
          width: resources.dimen.dp10,
        ),
        InkWell(
          onTap: () async {
            if (context.mounted) {
              Dialogs.loader(context);
            }
            final allTicketsResponse = await _servicesBloc.getTticketsByUser(
                requestParams: _getFilteredData(null));
            final excelTickets =
                allTicketsResponse.entity?.ticketsList ?? [];
            if ((_selectedCategory ?? 0) == 5) {
              for (final ticket in excelTickets) {
                ticket.rating ??= 0;
              }
            }
            await _servicesBloc.exportToExcel(excelTickets);
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
    final allTicketsResponse = await _servicesBloc.getTticketsByUser(
        requestParams: _getFilteredData(null));
    final allTickets = allTicketsResponse.entity?.ticketsList ?? [];
    List<String> headers = List.empty(growable: true);
    final includeRating = (_selectedCategory ?? 0) == 5;
    if (tickets.isNotEmpty) {
      tickets.first
          .toITCategotyPrintJson(includeRating: includeRating)
          .forEach((k, v) {
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
    for (var item in allTickets) {
      tableBody = '$tableBody\n<tr>';
      item.toITCategotyPrintJson(includeRating: includeRating).forEach((k, v) {
        tableBody =
            '$tableBody\n <td>${k == 'TicketNo' ? '''<a href="${FlavorConfig.isProduction() ? "https://ithelpdesk.uaqgov.ae" : "http://localhost:50768"}/ticket/$v" target="_blank"> $v </a>''' : v}</td>';
      });
      tableBody = '$tableBody\n</tr>';
    }
    printData(
        title: "Tickets",
        headerData: tableHeader,
        bodyData: tableBody,
        count: allTickets.length);
    if (context.mounted) Dialogs.dismiss(context);
  }

  List<Widget> _getFilterBar(BuildContext context) {
    final resources = context.resources;
    return [
      Text(
        resources.string.report,
        style: context.textFontWeight600,
      ),
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

  _updateTickets(
    BuildContext context,
  ) async {
    if ((index ?? 0) == 0) {
      tickets.clear();
    }
    Dialogs.loader(context);
    final newTickets = await _servicesBloc.getTticketsByUser(
        requestParams: _getFilteredData(index ?? 0));
    if (context.mounted) {
      Dialogs.dismiss(context);
      tickets.addAll(newTickets.entity?.ticketsList ?? []);
      assigniedEmployees.clear();
      assigniedEmployees.addAll(newTickets.entity?.assigniedEmployees ?? []);
      totalPagecount = newTickets.entity?.totalCount;
      _onFilterChange.value = !_onFilterChange.value;
    }
  }

  Map<String, dynamic> _getFilteredData(int? index) {
    String? startDate;
    String? endDate;
    if (filteredDates.value.isNotEmpty) {
      var dateFormat = DateFormat('dd-MMM-yyyy HH:mm');
      var startTime = DateFormat('yyyy/MM/dd').parse(filteredDates.value[0]);
      var endTime = DateFormat('yyyy/MM/dd').parse(filteredDates.value[1]);
      startDate = dateFormat.format(startTime);
      endDate = dateFormat.format(endTime);
    }
    Map<String, dynamic> requestParams = {
      'ticketType': (_selectedCategory ?? 0) + 1,
      'index': index,
      'category': (filteredData?['categories'] is List)
          ? (filteredData?['categories'].join(', '))
          : null,
      'department': (filteredData?['departments'] is List)
          ? (filteredData?['departments'].join(', '))
          : null,
      'status': (filteredData?['status'] is List)
          ? (filteredData?['status'].join(', '))
          : null,
      'issueType': (filteredData?['issueType'] is List)
          ? (filteredData?['issueType'].join(', '))
          : null,
      'priority': (filteredData?['priority'] is List)
          ? (filteredData?['priority'].join(', '))
          : null,
      'employees': (filteredData?['employees'] is List)
          ? (filteredData?['employees'].join(', '))
          : null,
      'chargeable': filteredData?['chargeable'] ?? false,
      'startDate': startDate,
      'endDate': endDate,
      'rating': _filteredRatings.isNotEmpty ? _filteredRatings.join(',') : null,
    };
    requestParams.removeWhere((key, value) => value == null);
    return requestParams;
  }

  Timer? _resizeTimer;
  @override
  void initState() {
    _resizeTimer?.cancel();
    // _resizeTimer = Timer(const Duration(milliseconds: 400), () {
    //   if (tickets.isEmpty && mounted) {
    //     _updateTickets(context);
    //   }
    // });
    Future.delayed(Duration.zero, () {
      if (mounted) {
        _updateTickets(context);
      }
    });

    _resizeTimer = Timer(const Duration(minutes: 15), () {
      if (!mounted) return;
      _updateTickets(context);
    });

    super.initState();
  }

  @override
  void dispose() {
    _resizeTimer?.cancel();
    _resizeTimer = null;
    super.dispose();
  }

  void _applyColumnFilters() {
    index = 0;
    filteredData = {
      'categories': _selectedCategories,
      'status': _filteredStatus,
      'issueType': _filteredIssueType,
      'employees': _selectedEmployees,
      'departments': _selectedDepartments,
      'chargeable': _chargeable,
      'priority': _filteredPriorities,
      'rating': _filteredRatings,
    };
    _updateTickets(context);
  }

  Future<void> _openMultiSelect<T>(
    BuildContext context, {
    required List<T> list,
    required List<T> selected,
    required void Function(List<T> value) onConfirm,
    double? maxWidth,
  }) async {
    final value = await Dialogs.showDialogWithClose(
        context,
        MultiSelectDialogWidget<T>(
          list: list,
          selectedItems: selected,
        ),
        maxWidth: maxWidth ?? (isDesktop(context) ? 250 : null),
        showClose: false);
    if (value is List<T>) {
      onConfirm(value);
      _applyColumnFilters();
    }
  }

  Future<List> _getEmployees() async {
    if (_employees != null) return _employees!;
    final result = await _masterDataBloc.getAssignedEmployees(
        requestParams: {'ticketsCategory': (_selectedCategory ?? 0) + 1},
        apiUrl: assignedEmployeesByUserApiUrl);
    _employees = result.items;
    return _employees!;
  }

  Future<List> _getDepartments() async {
    if (_departments != null) return _departments!;
    final result = await _masterDataBloc.getDepartments(requestParams: {});
    _departments = result.items;
    final externalDpt = DepartmentEntity()
      ..id = 0
      ..shortName = 'External'
      ..name = 'External';
    _departments?.add(externalDpt);
    return _departments!;
  }

  int _compareCreatedOn(TicketEntity a, TicketEntity b) {
    return getDateTimeByString('dd-MMM-yyyy HH:mm', a.createdOn ?? '')
        .microsecondsSinceEpoch
        .compareTo(getDateTimeByString('dd-MMM-yyyy HH:mm', b.createdOn ?? '')
            .microsecondsSinceEpoch);
  }

  List<TableColumn<TicketEntity>> _tableColumns(BuildContext context) {
    final resources = context.resources;
    Widget cell(TicketEntity ticket, dynamic value, {bool numeric = false}) =>
        ticketTableCell(
          context,
          value,
          numeric: numeric,
          onTap: () => ViewRequest.start(context, ticket),
        );
    final ratingItems = List.generate(5, (i) => NameIDEntity(i + 1, '${i + 1}'));
    final ratingColumn = TableColumn<TicketEntity>(
      key: 'rating',
      title: isSelectedLocalEn ? 'Rating' : 'التقييم',
      weight: 2,
      onHeaderTap: () => _openMultiSelect<NameIDEntity>(
            context,
            list: ratingItems,
            selected: ratingItems
                .where((item) => _filteredRatings.contains(item.id))
                .toList(),
            onConfirm: (value) {
              _filteredRatings
                ..clear()
                ..addAll(value.map((item) => item.id as int));
            },
          ),
      cell: (ticket) =>
          cell(ticket, (ticket.rating ?? 0) > 0 ? ticket.rating : ''),
    );
    if (!isDesktop(context)) {
      return [
        TableColumn(
          key: 'id',
          title: resources.string.id,
          weight: 2,
          cell: (ticket) => cell(ticket, ticket.id ?? '', numeric: true),
        ),
        TableColumn(
          key: 'subject',
          title: resources.string.subject,
          weight: 4,
          cell: (ticket) => cell(
              ticket,
              isSelectedLocalEn
                  ? ticket.subject ?? ''
                  : ticket.subjectAr ?? (ticket.subject ?? '')),
        ),
        TableColumn(
          key: 'status',
          title: resources.string.status,
          weight: 2,
          onHeaderTap: () => _openMultiSelect<StatusType>(
                context,
                list: getStatusTypes(),
                selected: getStatusTypes()
                    .where((e) => _filteredStatus.contains(e.value))
                    .toList(),
                onConfirm: (value) {
                  _filteredStatus
                    ..clear()
                    ..addAll(value.map((e) => e.value));
                },
              ),
          cell: (ticket) => cell(ticket, ticket.status),
        ),
        TableColumn(
          key: 'priority',
          title: resources.string.priority,
          weight: 2,
          onHeaderTap: () => _openMultiSelect<PriorityType>(
                context,
                list: getPriorityTypes(),
                selected: getPriorityTypes()
                    .where((e) => _filteredPriorities.contains(e.value))
                    .toList(),
                onConfirm: (value) {
                  _filteredPriorities
                    ..clear()
                    ..addAll(value.map((e) => e.value));
                },
              ),
          cell: (ticket) => cell(ticket, ticket.priority),
        ),
        TableColumn(
          key: 'updateDate',
          title: resources.string.updateDate,
          weight: 2,
          sortable: true,
          compare: _compareCreatedOn,
          cell: (ticket) => cell(
              ticket, ticket.updatedOn ?? ticket.createdOn ?? '',
              numeric: true),
        ),
        if ((_selectedCategory ?? 0) == 5) ratingColumn,
      ];
    }
    return [
      TableColumn(
        key: 'id',
        title: resources.string.id,
        weight: 2,
        cell: (ticket) => cell(ticket, ticket.id ?? '', numeric: true),
      ),
      TableColumn(
        key: 'employeeName',
        title: resources.string.employeeName,
        weight: 3,
        cell: (ticket) => cell(ticket, ticket.creator ?? ''),
      ),
      TableColumn(
        key: 'category',
        title: resources.string.category,
        weight: 2,
        onHeaderTap: () {
          final items = [
            NameIDEntity(1, "IT Support", nameAr: "الدعم الفني"),
            NameIDEntity(2, "ISO CR", nameAr: "نماذج طلبات التغيير"),
            NameIDEntity(3, "Eservices", nameAr: "الخدمات"),
            NameIDEntity(4, "Application", nameAr: "الانظمة"),
          ];
          return _openMultiSelect<NameIDEntity>(
            context,
            list: items,
            selected:
                items.where((item) => _selectedCategories.contains(item.id)).toList(),
            maxWidth: isDesktop(context) ? 400 : null,
            onConfirm: (value) {
              _selectedCategories
                ..clear()
                ..addAll(value.map((item) => item.id as int));
            },
          );
        },
        cell: (ticket) => cell(
            ticket,
            isSelectedLocalEn
                ? ticket.categoryName ?? ''
                : ticket.categoryNameAr ?? (ticket.categoryName ?? '')),
      ),
      TableColumn(
        key: 'subject',
        title: resources.string.subject,
        weight: 3,
        cell: (ticket) => cell(
            ticket,
            isSelectedLocalEn
                ? ticket.subject ?? ''
                : ticket.subjectAr ?? (ticket.subject ?? '')),
      ),
      TableColumn(
        key: 'status',
        title: resources.string.status,
        weight: 2,
        onHeaderTap: () => _openMultiSelect<StatusType>(
              context,
              list: getStatusTypes(),
              selected: getStatusTypes()
                  .where((e) => _filteredStatus.contains(e.value))
                  .toList(),
              onConfirm: (value) {
                _filteredStatus
                  ..clear()
                  ..addAll(value.map((e) => e.value));
              },
            ),
        cell: (ticket) => cell(ticket, ticket.status),
      ),
      TableColumn(
        key: 'issueType',
        title: resources.string.issueType,
        weight: 2,
        onHeaderTap: () => _openMultiSelect<IssueType>(
              context,
              list: IssueType.values,
              selected: IssueType.values
                  .where((e) => _filteredIssueType.contains(e.value))
                  .toList(),
              onConfirm: (value) {
                _filteredIssueType
                  ..clear()
                  ..addAll(value.map((e) => e.value));
              },
            ),
        cell: (ticket) => cell(ticket, ticket.issueType?.toString() ?? ''),
      ),
      TableColumn(
        key: 'chargeable',
        title: resources.string.chargeable,
        weight: 2,
        onHeaderTap: () {
          final items = [NameIDEntity(1, "Yes")];
          return _openMultiSelect<NameIDEntity>(
            context,
            list: items,
            selected: _chargeable ? items : [],
            maxWidth: isDesktop(context) ? 400 : null,
            onConfirm: (value) {
              _chargeable = value.isNotEmpty;
            },
          );
        },
        cell: (ticket) =>
            cell(ticket, ticket.isChargeable == true ? 'Yes' : 'No'),
      ),
      TableColumn(
        key: 'priority',
        title: resources.string.priority,
        weight: 2,
        onHeaderTap: () => _openMultiSelect<PriorityType>(
              context,
              list: getPriorityTypes(),
              selected: getPriorityTypes()
                  .where((e) => _filteredPriorities.contains(e.value))
                  .toList(),
              onConfirm: (value) {
                _filteredPriorities
                  ..clear()
                  ..addAll(value.map((e) => e.value));
              },
            ),
        cell: (ticket) => cell(ticket, ticket.priority),
      ),
      TableColumn(
        key: 'assignee',
        title: resources.string.assignee,
        weight: 2,
        onHeaderTap: () async {
          final items = await _getEmployees();
          if (!context.mounted) return;
          await _openMultiSelect(
            context,
            list: items,
            selected: items
                .where((item) => _selectedEmployees.contains(item.id))
                .toList(),
            maxWidth: isDesktop(context) ? 400 : null,
            onConfirm: (value) {
              _selectedEmployees
                ..clear()
                ..addAll(value.map((item) => (item.id ?? 0) as int));
            },
          );
        },
        cell: (ticket) => cell(ticket, ticket.assignedTo ?? ''),
      ),
      TableColumn(
        key: 'department',
        title: resources.string.department,
        weight: 2,
        onHeaderTap: () async {
          final items = await _getDepartments();
          if (!context.mounted) return;
          await _openMultiSelect(
            context,
            list: items,
            selected: items
                .where((item) => _selectedDepartments.contains(item.id))
                .toList(),
            maxWidth: isDesktop(context) ? 400 : null,
            onConfirm: (value) {
              _selectedDepartments
                ..clear()
                ..addAll(value.map((item) => (item.id ?? 0) as int));
            },
          );
        },
        cell: (ticket) => cell(ticket, ticket.departmentName ?? ''),
      ),
      TableColumn(
        key: 'createDate',
        title: resources.string.createDate,
        weight: 3,
        sortable: true,
        compare: _compareCreatedOn,
        cell: (ticket) => cell(ticket, ticket.createdOn ?? '', numeric: true),
      ),
      TableColumn(
        key: 'updateDate',
        title: resources.string.updateDate,
        weight: 3,
        sortable: true,
        compare: _compareCreatedOn,
        cell: (ticket) => cell(ticket, ticket.updatedOn ?? '', numeric: true),
      ),
      if ((_selectedCategory ?? 0) == 5) ratingColumn,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return SelectionArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: context.resources.color.appScaffoldBg,
        body: BlocProvider(
          create: (context) => _servicesBloc,
          child: Padding(
            padding: EdgeInsets.all(resources.dimen.dp20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    valueListenable: _onFilterChange,
                    builder: (context, value, child) {
                      return ValueListenableBuilder(
                          valueListenable: _onFilterChange,
                          builder: (context, value, child) {
                            return ReportListWidget<TicketEntity>(
                              ticketsData: tickets,
                              columns: _tableColumns(context),
                              pageIndex: (index ?? 0) + 1,
                              totalPagecount: totalPagecount ?? 0,
                              onPageChange: (page) {
                                index = (index ?? 0) + page;
                                if (page == 1 &&
                                    (index ?? 0) >=
                                        (tickets.length / 20).ceil()) {
                                  _updateTickets(context);
                                }
                              },
                            );
                          });
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
