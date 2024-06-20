import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/action_button_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dropdown_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/item_service_steps.dart';
import 'package:ithelpdesk/presentation/common_widgets/right_icon_text_widget.dart';
import 'package:ithelpdesk/presentation/requests/widgets/ticket_transfer_widget.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';
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
  final ValueNotifier _isChargeable = ValueNotifier(false);

  Widget _getDataForm(BuildContext context, int ticketType) {
    final resources = context.resources;
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: resources.dimen.dp15, horizontal: resources.dimen.dp20),
      color: resources.color.colorWhite,
      child: Column(
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
                width: ticketType == 2
                    ? resources.dimen.dp20
                    : resources.dimen.dp40,
              ),
              if (ticketType == 2) ...[
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
            labelText: resources.string.contactNoTelephoneExt,
            fillColor: resources.color.colorWhite,
            borderSide: BorderSide(
                color: context.resources.color.sideBarItemUnselected, width: 1),
            borderRadius: 0,
          ),
          SizedBox(
            height: resources.dimen.dp10,
          ),
          if (ticketType == 2) ...[
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
                  color: context.resources.color.sideBarItemUnselected,
                  width: 1),
              borderRadius: 0,
            ),
            SizedBox(
              height: resources.dimen.dp10,
            ),
          ],
          DropDownWidget(
            list: const ['High', 'Medium', 'Low', 'other'],
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
                        padding: EdgeInsets.only(top: resources.dimen.dp10),
                        child: RightIconTextWidget(
                          fillColor: resources.color.colorWhite,
                          borderSide: BorderSide(
                              color:
                                  context.resources.color.sideBarItemUnselected,
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
                color: context.resources.color.sideBarItemUnselected, width: 1),
            borderRadius: 0,
          ),
        ],
      ),
    );
  }

  Widget _getStatusWidget(
      BuildContext context, List<Map<String, String>> steps) {
    final resources = context.resources;
    return Container(
      color: resources.color.colorWhite,
      padding: EdgeInsets.symmetric(
          vertical: resources.dimen.dp15, horizontal: resources.dimen.dp20),
      margin:
          EdgeInsets.only(left: isDesktop(context) ? resources.dimen.dp20 : 0),
      child: Column(
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
              stepSubText: '${steps[i]['title']}\n23 March 2024, 11:00 AM',
              isLastStep: i == steps.length - 1,
            )
          ]
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    const ticketType = 2;
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
    final actionButtons = [
      {
        'name': resources.string.returnText,
        'color': resources.color.colorWhite,
      },
      {
        'name': resources.string.transfer,
        'color': resources.color.pending,
      },
      {
        'name': resources.string.close,
        'color': resources.color.colorGreen26B757,
      },
      {
        'name': resources.string.hold,
        'color': resources.color.viewBgColor,
      },
      {
        'name': resources.string.reject,
        'color': resources.color.rejected,
      },
      {
        'name': '',
        'color': resources.color.colorWhite,
      },
    ];
    final actionButtonRows = isDesktop(context) ? 1 : 2;
    final actionButtonColumns = isDesktop(context) ? 5 : 3;
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
                      flex: isDesktop(context) ? 1 : 0,
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
                IntrinsicHeight(
                  child: isDesktop(context)
                      ? Row(
                          children: [
                            Expanded(
                              child: _getDataForm(context, ticketType),
                            ),
                            SizedBox(
                              width: 280,
                              child: _getStatusWidget(context, steps),
                            )
                          ],
                        )
                      : Column(
                          children: [
                            _getStatusWidget(context, steps),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            _getDataForm(context, ticketType),
                          ],
                        ),
                ),
                SizedBox(
                  height: resources.dimen.dp20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: resources.dimen.dp15,
                      horizontal: resources.dimen.dp20),
                  color: resources.color.colorWhite,
                  child: Column(
                    children: [
                      ValueListenableBuilder(
                          valueListenable: _isChargeable,
                          builder: (context, value, child) {
                            return CheckboxListTile(
                                contentPadding: const EdgeInsets.all(0),
                                title: Text(
                                  '${resources.string.chargeable}(50 AED)',
                                  style: context.textFontWeight400
                                      .onColor(resources.color.viewBgColor),
                                ),
                                side: BorderSide(
                                  color: resources.color.viewBgColor,
                                  width: 1.5,
                                ),
                                visualDensity: const VisualDensity(
                                    horizontal: -4, vertical: -4),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                value: value,
                                onChanged: (isChecked) {
                                  _isChargeable.value = isChecked;
                                });
                          }),
                      SizedBox(
                        height: resources.dimen.dp10,
                      ),
                      RightIconTextWidget(
                        labelText: resources.string.comments,
                        fillColor: resources.color.colorWhite,
                        maxLines: 4,
                        borderSide: BorderSide(
                            color:
                                context.resources.color.sideBarItemUnselected,
                            width: 1),
                        borderRadius: 0,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: resources.dimen.dp20,
                ),
                Column(
                  children: [
                    for (int c = 0; c < actionButtonRows; c++) ...[
                      Row(
                        children: [
                          for (int r = 0; r < actionButtonColumns; r++) ...[
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Dialogs.showDialogWithClose(
                                      context, TicketTransferWidget(),
                                      maxWidth: 350);
                                },
                                child: ActionButtonWidget(
                                  text: (actionButtons[
                                                  r + (c * actionButtonColumns)]
                                              ['name'] ??
                                          '')
                                      .toString(),
                                  color: actionButtons[
                                          r + (c * actionButtonColumns)]
                                      ['color'] as Color,
                                  radious: 0,
                                  textColor:
                                      r == 0 ? resources.color.textColor : null,
                                  textSize: resources.fontSize.dp12,
                                  padding: EdgeInsets.symmetric(
                                      vertical: resources.dimen.dp7,
                                      horizontal: resources.dimen.dp10),
                                ),
                              ),
                            ),
                            if (r < actionButtonColumns - 1) ...[
                              SizedBox(
                                width: resources.dimen.dp10,
                              ),
                            ]
                          ]
                        ],
                      ),
                      if (c < actionButtonRows - 1) ...[
                        SizedBox(
                          height: resources.dimen.dp20,
                        ),
                      ]
                    ]
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
