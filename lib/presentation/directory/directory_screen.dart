import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/domain/entities/directory_entity.dart';
import 'package:ithelpdesk/presentation/common_widgets/action_button_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dropdown_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/report_list_widget.dart';

class DirectoryScreen extends BaseScreenWidget {
  const DirectoryScreen({super.key});

  Widget _getFilters(BuildContext context) {
    final resources = context.resources;
    return Wrap(
      alignment: WrapAlignment.end,
      runSpacing: resources.dimen.dp10,
      runAlignment: WrapAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Row(
            children: [
              Text(
                resources.string.export,
                style: context.textFontWeight600
                    .onFontSize(resources.fontSize.dp10),
              ),
              SizedBox(
                width: resources.dimen.dp5,
              ),
              Expanded(
                child: DropDownWidget(
                  height: 28,
                  list: const [
                    'exl',
                    'pdf',
                  ],
                  iconSize: 20,
                  fontStyle: context.textFontWeight400
                      .onFontSize(resources.fontSize.dp10),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: resources.dimen.dp10,
        ),
        InkWell(
          onTap: () {},
          child: ActionButtonWidget(
              text: resources.string.download,
              radious: resources.dimen.dp15,
              textSize: resources.fontSize.dp10,
              padding: EdgeInsets.symmetric(
                  vertical: resources.dimen.dp5,
                  horizontal: resources.dimen.dp15),
              color: resources.color.sideBarItemUnselected),
        ),
        SizedBox(
          width: resources.dimen.dp10,
        ),
        InkWell(
          onTap: () {},
          child: ActionButtonWidget(
            text: resources.string.print,
            padding: EdgeInsets.symmetric(
                vertical: resources.dimen.dp5,
                horizontal: resources.dimen.dp15),
            radious: resources.dimen.dp15,
            textSize: resources.fontSize.dp10,
            color: resources.color.sideBarItemUnselected,
          ),
        ),
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
              child: DropDownWidget(
                height: 28,
                list: const [
                  'Smart Uaq',
                  'MD',
                  'DED',
                ],
                hintText: resources.string.selectDepartment,
                iconSize: 20,
                fontStyle: context.textFontWeight400
                    .onFontSize(resources.fontSize.dp10),
              ),
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
    final ticketsData = [
      DirectoryEntity(
        1,
        'Ujjawal Jha',
        'It Support',
        'Smart uaq',
        'UjjawalJha@gmail.com',
      ),
      DirectoryEntity(
        1,
        'Ujjawal Jha',
        'It Support',
        'Smart uaq',
        'UjjawalJha@gmail.com',
      ),
      DirectoryEntity(
        1,
        'Ujjawal Jha',
        'It Support',
        'Smart uaq',
        'UjjawalJha@gmail.com',
      ),
      DirectoryEntity(
        1,
        'Ujjawal Jha',
        'It Support',
        'Smart uaq',
        'UjjawalJha@gmail.com',
      ),
      DirectoryEntity(
        1,
        'Ujjawal Jha',
        'It Support',
        'Smart uaq',
        'UjjawalJha@gmail.com',
      ),
      DirectoryEntity(
        1,
        'Ujjawal Jha',
        'It Support',
        'Smart uaq',
        'UjjawalJha@gmail.com',
      ),
      DirectoryEntity(
        1,
        'Ujjawal Jha',
        'It Support',
        'Smart uaq',
        'UjjawalJha@gmail.com',
      ),
      DirectoryEntity(
        1,
        'Ujjawal Jha',
        'It Support',
        'Smart uaq',
        'UjjawalJha@gmail.com',
      ),
      DirectoryEntity(
        1,
        'Ujjawal Jha',
        'It Support',
        'Smart uaq',
        'UjjawalJha@gmail.com',
      ),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.resources.color.appScaffoldBg,
      body: Padding(
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
                          text: '${resources.string.itSupportDirecotryDes}\n',
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
              ReportListWidget(
                ticketsHeaderData: ticketsHeaderData,
                ticketsData: ticketsData,
                ticketsTableColunwidths: ticketsTableColunwidths,
                showActionButtons: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
