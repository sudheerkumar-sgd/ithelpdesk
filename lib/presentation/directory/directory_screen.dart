import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/domain/entities/directory_entity.dart';
import 'package:ithelpdesk/presentation/bloc/master_data/master_data_bloc.dart';
import 'package:ithelpdesk/presentation/bloc/user/user_bloc.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dropdown_widget.dart';

import '../../core/constants/constants.dart';
import '../../domain/entities/master_data_entities.dart';
import '../../injection_container.dart';
import '../../res/drawables/background_box_decoration.dart';

class DirectoryScreen extends BaseScreenWidget {
  DirectoryScreen({super.key});
  final UserBloc _userDataBloc = sl<UserBloc>();
  final MasterDataBloc _masterDataBloc = sl<MasterDataBloc>();
  final ValueNotifier<DepartmentEntity?> _selectedDepartment =
      ValueNotifier(null);
  Widget _getFilters(BuildContext context) {
    final resources = context.resources;
    return Wrap(
      alignment: WrapAlignment.end,
      runSpacing: resources.dimen.dp10,
      runAlignment: WrapAlignment.start,
      children: const [
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
        // SizedBox(
        //   width: resources.dimen.dp10,
        // ),
        // InkWell(
        //   onTap: () {},
        //   child: ActionButtonWidget(
        //       text: resources.string.download,
        //       radious: resources.dimen.dp15,
        //       textSize: resources.fontSize.dp10,
        //       padding: EdgeInsets.symmetric(
        //           vertical: resources.dimen.dp5,
        //           horizontal: resources.dimen.dp15),
        //       color: resources.color.sideBarItemUnselected),
        // ),
        // SizedBox(
        //   width: resources.dimen.dp10,
        // ),
        // InkWell(
        //   onTap: () {},
        //   child: ActionButtonWidget(
        //     text: resources.string.print,
        //     padding: EdgeInsets.symmetric(
        //         vertical: resources.dimen.dp5,
        //         horizontal: resources.dimen.dp15),
        //     radious: resources.dimen.dp15,
        //     textSize: resources.fontSize.dp10,
        //     color: resources.color.sideBarItemUnselected,
        //   ),
        // ),
      ],
    );
  }

  List<Widget> _getFilterBar(BuildContext context) {
    final resources = context.resources;
    return [
      SizedBox(
        width: 250,
        child: Row(
          children: [
            Text(
              resources.string.department,
              style:
                  context.textFontWeight600.onFontSize(resources.fontSize.dp10),
            ),
            SizedBox(
              width: resources.dimen.dp10,
            ),
            Expanded(
              child: FutureBuilder(
                  future: _masterDataBloc.getDepartments(requestParams: {}),
                  builder: (context, snapShot) {
                    final items = snapShot.data?.items ?? [];
                    if (items.isNotEmpty) {
                      final departmentEntity = DepartmentEntity();
                      departmentEntity.id = 0;
                      departmentEntity.name = "ALL";
                      departmentEntity.shortName = "ALL";
                      items.insert(0, departmentEntity);
                    }
                    return DropDownWidget(
                      height: 28,
                      list: snapShot.data?.items ?? [],
                      hintText: resources.string.selectDepartment,
                      iconSize: 20,
                      selectedValue: _selectedDepartment.value,
                      fontStyle: context.textFontWeight400
                          .onFontSize(resources.fontSize.dp10),
                      callback: (p0) {
                        _selectedDepartment.value = p0.id == 0 ? null : p0;
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
      SizedBox(
        width: resources.dimen.dp20,
        height: resources.dimen.dp10,
      ),
      isDesktop(context)
          ? Expanded(
              child: _getFilters(context),
            )
          : _getFilters(context)
    ];
  }

  List<Widget> _getDirectoryItem(
      BuildContext context, DirectoryEntity directoryEntity, int index) {
    final list = List<Widget>.empty(growable: true);
    (isDesktop(context)
            ? directoryEntity.toJson(showActionButtons: false)
            : directoryEntity.toMobileJson(showActionButtons: false))
        .forEach((key, value) {
      list.add(InkWell(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: context.resources.dimen.dp20,
              horizontal: context.resources.dimen.dp5),
          child: Text(
            key.toString().toLowerCase() == 'id' ? '$index' : '$value',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: (key.toString().toLowerCase().contains('date') ||
                    key.toString().toLowerCase().contains('id'))
                ? context.textFontWeight600
                    .onFontSize(context.resources.fontSize.dp10)
                    .onFontFamily(fontFamily: fontFamilyEN)
                : context.textFontWeight600
                    .onFontSize(context.resources.fontSize.dp10),
          ),
        ),
      ));
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    final ticketsHeaderData = [
      'ID',
      resources.string.employeeName,
      resources.string.designation,
      resources.string.department,
      resources.string.emailID,
    ];
    final ticketsTableColunwidths = {
      0: const FlexColumnWidth(1),
      1: const FlexColumnWidth(3),
      2: const FlexColumnWidth(3),
      3: const FlexColumnWidth(3),
      4: const FlexColumnWidth(3),
      5: const FlexColumnWidth(3),
    };

    return SelectionArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: BlocProvider(
          create: (context) => _userDataBloc,
          child: Padding(
            padding: EdgeInsets.all(resources.dimen.dp20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                        text: '${resources.string.itSupportDirecotry}\n',
                        style: context.textFontWeight600
                            .onFontSize(resources.fontSize.dp12),
                        children: [
                          TextSpan(
                              text:
                                  '${resources.string.itSupportDirecotryDes}\n',
                              style: context.textFontWeight400
                                  .onFontSize(resources.fontSize.dp10)
                                  .onColor(resources.color.textColorLight)
                                  .onHeight(1))
                        ]),
                  ),
                  SizedBox(
                    height: resources.dimen.dp20,
                  ),
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
                  FutureBuilder(
                      future: _userDataBloc
                          .getDirectoryEmployees(requestParams: {}),
                      builder: (context, snapShot) {
                        return ValueListenableBuilder(
                            valueListenable: _selectedDepartment,
                            builder: (context, value, child) {
                              final items = value != null
                                  ? (snapShot.data?.items ?? [])
                                      .where((item) =>
                                          (item as DirectoryEntity)
                                              .department ==
                                          value.shortName)
                                      .toList()
                                  : (snapShot.data?.items ?? []);
                              return Table(
                                columnWidths: ticketsTableColunwidths,
                                children: [
                                  TableRow(
                                      children: List.generate(
                                          ticketsHeaderData.length,
                                          (index) => Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        resources.dimen.dp10),
                                                child: Text(
                                                  ticketsHeaderData[index],
                                                  textAlign: TextAlign.center,
                                                  style: context
                                                      .textFontWeight600
                                                      .onColor(resources
                                                          .color.textColorLight)
                                                      .onFontSize(resources
                                                          .fontSize.dp10),
                                                ),
                                              ))),
                                  for (var i = 0; i < items.length; i++) ...[
                                    TableRow(
                                        decoration: BackgroundBoxDecoration(
                                                boxColor:
                                                    resources.color.colorWhite,
                                                boxBorder: Border(
                                                    top: BorderSide(
                                                        color: resources.color
                                                            .appScaffoldBg,
                                                        width: 5),
                                                    bottom: BorderSide(
                                                        color: resources.color
                                                            .appScaffoldBg,
                                                        width: 5)))
                                            .roundedCornerBox,
                                        children: _getDirectoryItem(
                                            context,
                                            items[i] as DirectoryEntity,
                                            i + 1)),
                                  ]
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
    );
  }
}
