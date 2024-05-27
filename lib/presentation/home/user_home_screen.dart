// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/action_button_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/res/resources.dart';

class UserHomeScreen extends BaseScreenWidget {
  UserHomeScreen({super.key});
  late FocusNode requestStatusFocusNode;

  void onRequestValueChanged(String value) {
    if (value.trim().length == 6) {
      requestStatusFocusNode.canRequestFocus = !requestStatusFocusNode.hasFocus;
    }
  }

  @override
  Widget build(BuildContext context) {
    Resources resources = context.resources;
    return SafeArea(
        child: Scaffold(
      backgroundColor: context.resources.color.appScaffoldBg,
      body: Padding(
        padding: EdgeInsets.all(resources.dimen.dp20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                      text: '${resources.string.supportSummary}\n',
                      style: context.textFontWeight600,
                      children: [
                        TextSpan(
                            text: '${resources.string.supportSummaryDes}\n',
                            style: context.textFontWeight400
                                .onFontSize(resources.fontSize.dp12)
                                .onColor(resources.color.textColorLight)
                                .onHeight(1))
                      ]),
                ),
                ActionButtonWidget(
                  text: resources.string.createNewRequest,
                  padding: EdgeInsets.symmetric(
                      horizontal: context.resources.dimen.dp30,
                      vertical: context.resources.dimen.dp7),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }

  @override
  doDispose() {}
}
