import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/action_button_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dropdown_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/multi_upload_attachment_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/right_icon_text_widget.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';
import 'package:page_transition/page_transition.dart';

class CreateNewRequest extends BaseScreenWidget {
  static start(BuildContext context) {
    Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeft, child: CreateNewRequest()),
    );
  }

  CreateNewRequest({super.key});
  final ValueNotifier _ticketCategory = ValueNotifier(-1);

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    final categories = [
      resources.string.supportITRequest,
      resources.string.itISOCRS,
      resources.string.eservices,
      resources.string.system
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
                Text.rich(
                  TextSpan(
                      text: '${resources.string.createNewRequest}\n',
                      style: context.textFontWeight600,
                      children: [
                        TextSpan(
                            text: '${resources.string.createNewRequestDes}\n',
                            style: context.textFontWeight400
                                .onFontSize(resources.fontSize.dp10)
                                .onColor(resources.color.textColorLight)
                                .onHeight(1))
                      ]),
                ),
                SizedBox(
                  height: resources.dimen.dp20,
                ),
                Text.rich(
                  TextSpan(
                      text: '${resources.string.step}1',
                      style: context.textFontWeight600,
                      children: [
                        WidgetSpan(
                            child: SizedBox(
                          width: resources.dimen.dp10,
                        )),
                        TextSpan(
                            text: resources.string.step1Des,
                            style: context.textFontWeight400
                                .onFontSize(resources.fontSize.dp10)
                                .onColor(resources.color.textColorLight)
                                .onHeight(1))
                      ]),
                ),
                SizedBox(
                  height: resources.dimen.dp10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: resources.dimen.dp15,
                      horizontal: resources.dimen.dp20),
                  color: resources.color.colorWhite,
                  child: ValueListenableBuilder(
                      valueListenable: _ticketCategory,
                      builder: (context, value, child) {
                        return Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  _ticketCategory.value = 0;
                                },
                                child: ActionButtonWidget(
                                  text: resources.string.supportITRequest,
                                  decoration: value != 0
                                      ? BackgroundBoxDecoration(
                                              boxColor:
                                                  resources.color.colorWhite,
                                              boarderColor: resources
                                                  .color.textColorLight,
                                              boarderWidth: resources.dimen.dp1,
                                              radious: 0)
                                          .roundedCornerBox
                                      : null,
                                  textColor: value != 0
                                      ? resources.color.textColor
                                      : null,
                                  textSize: resources.dimen.dp12,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: context.resources.dimen.dp20,
                                      vertical: context.resources.dimen.dp7),
                                  radious: 0,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: resources.dimen.dp20,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  _ticketCategory.value = 1;
                                },
                                child: ActionButtonWidget(
                                  text: resources.string.itISOCRS,
                                  decoration: value != 1
                                      ? BackgroundBoxDecoration(
                                              boxColor:
                                                  resources.color.colorWhite,
                                              boarderColor: resources
                                                  .color.textColorLight,
                                              boarderWidth: resources.dimen.dp1,
                                              radious: 0)
                                          .roundedCornerBox
                                      : null,
                                  textColor: value != 1
                                      ? resources.color.textColor
                                      : null,
                                  textSize: resources.dimen.dp12,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: context.resources.dimen.dp20,
                                      vertical: context.resources.dimen.dp7),
                                  radious: 0,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: resources.dimen.dp20,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  _ticketCategory.value = 2;
                                },
                                child: ActionButtonWidget(
                                  text: resources.string.eservices,
                                  decoration: value != 2
                                      ? BackgroundBoxDecoration(
                                              boxColor:
                                                  resources.color.colorWhite,
                                              boarderColor: resources
                                                  .color.textColorLight,
                                              boarderWidth: resources.dimen.dp1,
                                              radious: 0)
                                          .roundedCornerBox
                                      : null,
                                  textColor: value != 2
                                      ? resources.color.textColor
                                      : null,
                                  textSize: resources.dimen.dp12,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: context.resources.dimen.dp20,
                                      vertical: context.resources.dimen.dp7),
                                  radious: 0,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: resources.dimen.dp20,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  _ticketCategory.value = 3;
                                },
                                child: ActionButtonWidget(
                                  text: resources.string.system,
                                  decoration: value != 3
                                      ? BackgroundBoxDecoration(
                                              boxColor:
                                                  resources.color.colorWhite,
                                              boarderColor: resources
                                                  .color.textColorLight,
                                              boarderWidth: resources.dimen.dp1,
                                              radious: 0)
                                          .roundedCornerBox
                                      : null,
                                  textColor: value != 3
                                      ? resources.color.textColor
                                      : null,
                                  textSize: resources.dimen.dp12,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: context.resources.dimen.dp20,
                                      vertical: context.resources.dimen.dp7),
                                  radious: 0,
                                ),
                              ),
                            )
                          ],
                        );
                      }),
                ),
                SizedBox(
                  height: resources.dimen.dp20,
                ),
                Text.rich(
                  TextSpan(
                      text: '${resources.string.step}2',
                      style: context.textFontWeight600,
                      children: [
                        WidgetSpan(
                            child: SizedBox(
                          width: resources.dimen.dp10,
                        )),
                        TextSpan(
                            text: resources.string.step2Des,
                            style: context.textFontWeight400
                                .onFontSize(resources.fontSize.dp10)
                                .onColor(resources.color.textColorLight)
                                .onHeight(1))
                      ]),
                ),
                SizedBox(
                  height: resources.dimen.dp10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: resources.dimen.dp15,
                      horizontal: resources.dimen.dp20),
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
                            width: resources.dimen.dp40,
                          ),
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
                            color:
                                context.resources.color.sideBarItemUnselected,
                            width: 1),
                        borderRadius: 0,
                      ),
                      SizedBox(
                        height: resources.dimen.dp10,
                      ),
                      RightIconTextWidget(
                        labelText: resources.string.subject,
                        fillColor: resources.color.colorWhite,
                        borderSide: BorderSide(
                            color:
                                context.resources.color.sideBarItemUnselected,
                            width: 1),
                        borderRadius: 0,
                      ),
                      SizedBox(
                        height: resources.dimen.dp10,
                      ),
                      RightIconTextWidget(
                        labelText: resources.string.description,
                        fillColor: resources.color.colorWhite,
                        maxLines: 8,
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
                Text.rich(
                  TextSpan(
                      text: '${resources.string.step}3',
                      style: context.textFontWeight600,
                      children: [
                        WidgetSpan(
                            child: SizedBox(
                          width: resources.dimen.dp10,
                        )),
                        TextSpan(
                            text: resources.string.step3Des,
                            style: context.textFontWeight400
                                .onFontSize(resources.fontSize.dp10)
                                .onColor(resources.color.textColorLight)
                                .onHeight(1))
                      ]),
                ),
                SizedBox(
                  height: resources.dimen.dp10,
                ),
                Container(
                    padding: EdgeInsets.symmetric(
                        vertical: resources.dimen.dp15,
                        horizontal: resources.dimen.dp20),
                    color: resources.color.colorWhite,
                    child: MultiUploadAttachmentWidget(
                      hintText: resources.string.uploadFile,
                      fillColor: resources.color.colorWhite,
                      borderSide: BorderSide(
                          color: context.resources.color.sideBarItemUnselected,
                          width: 1),
                      borderRadius: 0,
                    )),
                SizedBox(
                  height: resources.dimen.dp20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        _ticketCategory.value = 2;
                      },
                      child: ActionButtonWidget(
                        text: resources.string.clear,
                        color: resources.color.colorWhite,
                        textColor: resources.color.textColor,
                        padding: EdgeInsets.symmetric(
                            horizontal: context.resources.dimen.dp40,
                            vertical: context.resources.dimen.dp7),
                      ),
                    ),
                    SizedBox(
                      width: resources.dimen.dp20,
                    ),
                    InkWell(
                      onTap: () {},
                      child: ActionButtonWidget(
                        text: resources.string.submit,
                        padding: EdgeInsets.symmetric(
                            horizontal: context.resources.dimen.dp40,
                            vertical: context.resources.dimen.dp7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
