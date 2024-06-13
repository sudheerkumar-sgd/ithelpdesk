import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/common/log.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dropdown_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/item_service_steps.dart';
import 'package:ithelpdesk/presentation/common_widgets/right_icon_text_widget.dart';
import 'package:page_transition/page_transition.dart';

class ViewRequest extends BaseScreenWidget {
  static start(BuildContext context) {
    Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeft, child: ViewRequest()),
    );
  }

  ViewRequest({super.key});
  final ValueNotifier _subjectChanged = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    const value = 2;
    final steps = [
      {
        'name': 'Sudheer Kumar Akula',
        'title': 'service created',
        'date': '23 March 2024, 11:00 AM'
      },
      {
        'name': 'Mohammed Kamran',
        'title': 'Assigned manually ',
        'date': '23 March 2024, 11:00 AM'
      },
      {
        'name': 'Noushad',
        'title': 'Forwarded to SGD Eservice',
        'date': '23 March 2024, 11:00 AM'
      },
      {
        'name': 'Mooza Binyeem',
        'title': 'Changed Sub Category to Eservice',
        'date': '23 March 2024, 11:00 AM'
      },
    ];
    return Scaffold(
        backgroundColor: resources.color.appScaffoldBg,
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: resources.dimen.dp15, vertical: resources.dimen.dp20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text.rich(
                        TextSpan(
                            text: 'Reset Password - UAQGOV-ITHD- 10520\n',
                            style: context.textFontWeight600,
                            children: [
                              TextSpan(
                                  text:
                                      'Created by Mooza BinYeem on 27-Mar-2024 at 11:13 AM',
                                  style: context.textFontWeight400
                                      .onFontSize(resources.fontSize.dp10)
                                      .onColor(resources.color.textColorLight)
                                      .onHeight(1))
                            ]),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: resources.dimen.dp20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'status:',
                              style: context.textFontWeight600,
                            ),
                            SizedBox(
                              width: resources.dimen.dp5,
                            ),
                            Text(
                              'PENDING',
                              style: context.textFontWeight700
                                  .onColor(resources.color.pending),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: resources.dimen.dp10,
                ),
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(3),
                    1: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: resources.dimen.dp15,
                              horizontal: resources.dimen.dp20),
                          color: resources.color.colorWhite,
                          child: LayoutBuilder(builder: (context, size) {
                            printLog('${size.biggest}');
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: DropDownWidget(
                                      list: const [
                                        'Reset Password',
                                        'System Update',
                                        'Network access'
                                      ],
                                      labelText: resources.string.subCategory,
                                      borderRadius: 0,
                                      fillColor: resources.color.colorWhite,
                                    )),
                                    SizedBox(
                                      width: value == 2
                                          ? resources.dimen.dp20
                                          : resources.dimen.dp40,
                                    ),
                                    if (value == 2) ...[
                                      Expanded(
                                          child: DropDownWidget(
                                        list: const ['High', 'Medium', 'Low'],
                                        labelText: resources.string.issueType,
                                        borderRadius: 0,
                                        fillColor: resources.color.colorWhite,
                                      )),
                                      SizedBox(width: resources.dimen.dp20),
                                    ],
                                    Expanded(
                                        child: DropDownWidget(
                                      list: const ['High', 'Medium', 'Low'],
                                      labelText: resources.string.priority,
                                      borderRadius: 0,
                                      fillColor: resources.color.colorWhite,
                                    )),
                                  ],
                                ),
                                SizedBox(
                                  height: resources.dimen.dp10,
                                ),
                                RightIconTextWidget(
                                  labelText:
                                      resources.string.contactNoTelephoneExt,
                                  fillColor: resources.color.colorWhite,
                                  borderSide: BorderSide(
                                      color: context.resources.color
                                          .sideBarItemUnselected,
                                      width: 1),
                                  borderRadius: 0,
                                ),
                                SizedBox(
                                  height: resources.dimen.dp10,
                                ),
                                if (value == 2) ...[
                                  DropDownWidget(
                                    list: const ['High', 'Medium', 'Low'],
                                    labelText: resources.string.serviceName,
                                    borderRadius: 0,
                                    fillColor: resources.color.colorWhite,
                                  ),
                                  SizedBox(
                                    height: resources.dimen.dp10,
                                  ),
                                  RightIconTextWidget(
                                    labelText: resources.string.requestNo,
                                    fillColor: resources.color.colorWhite,
                                    borderSide: BorderSide(
                                        color: context.resources.color
                                            .sideBarItemUnselected,
                                        width: 1),
                                    borderRadius: 0,
                                  ),
                                  SizedBox(
                                    height: resources.dimen.dp10,
                                  ),
                                ],
                                DropDownWidget(
                                  list: const [
                                    'High',
                                    'Medium',
                                    'Low',
                                    'other'
                                  ],
                                  labelText: resources.string.subject,
                                  borderRadius: 0,
                                  fillColor: resources.color.colorWhite,
                                  callback: (value) {
                                    _subjectChanged.value = value;
                                  },
                                ),
                                ValueListenableBuilder(
                                    valueListenable: _subjectChanged,
                                    builder: (context, value, child) {
                                      return value == 'other'
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  top: resources.dimen.dp10),
                                              child: RightIconTextWidget(
                                                fillColor:
                                                    resources.color.colorWhite,
                                                borderSide: BorderSide(
                                                    color: context
                                                        .resources
                                                        .color
                                                        .sideBarItemUnselected,
                                                    width: 1),
                                                borderRadius: 0,
                                              ),
                                            )
                                          : const SizedBox();
                                    }),
                                SizedBox(
                                  height: resources.dimen.dp10,
                                ),
                                RightIconTextWidget(
                                  labelText: resources.string.description,
                                  fillColor: resources.color.colorWhite,
                                  maxLines: 8,
                                  borderSide: BorderSide(
                                      color: context.resources.color
                                          .sideBarItemUnselected,
                                      width: 1),
                                  borderRadius: 0,
                                ),
                              ],
                            );
                          }),
                        ),
                        TableCell(
                            verticalAlignment: TableCellVerticalAlignment.fill,
                            child: Container(
                              color: resources.color.colorWhite,
                              padding: EdgeInsets.symmetric(
                                  vertical: resources.dimen.dp15,
                                  horizontal: resources.dimen.dp20),
                              margin:
                                  EdgeInsets.only(left: resources.dimen.dp20),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    resources.string.latestUpdate,
                                    style: context.textFontWeight600,
                                  ),
                                  SizedBox(
                                    height: resources.dimen.dp20,
                                  ),
                                  for (int i = 0; i < steps.length; i++) ...[
                                    ItemServiceSteps(
                                      stepColor: i < steps.length - 1
                                          ? resources.color.colorGreen26B757
                                          : resources.color.pending,
                                      stepText: steps[i]['name'] ?? '',
                                      stepSubText:
                                          '${steps[i]['title']}\n23 March 2024, 11:00 AM',
                                      isLastStep: i == steps.length - 1,
                                    )
                                  ]
                                ],
                              ),
                            ))
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
