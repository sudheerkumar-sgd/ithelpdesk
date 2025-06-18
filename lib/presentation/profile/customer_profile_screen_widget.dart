import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';

class CustomerProfileScreenWidget extends BaseScreenWidget {
  final String? userName;
  final String? userNumber;
  final String? userEmail;
  const CustomerProfileScreenWidget(
      {this.userName, this.userNumber, this.userEmail, super.key});
  @override
  Widget build(BuildContext context) {
    final resources = context.resources;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(resources.dimen.dp20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resources.string.userProfile,
              style:
                  context.textFontWeight700.onFontSize(resources.fontSize.dp14),
            ),
            SizedBox(
              height: resources.dimen.dp20,
            ),
            Text.rich(
              TextSpan(
                  text: '${resources.string.fullName}\n',
                  style: context.textFontWeight400
                      .onFontSize(resources.fontSize.dp10),
                  children: [
                    TextSpan(
                        text: userName ?? '',
                        style: context.textFontWeight600
                            .onFontSize(resources.fontSize.dp12))
                  ]),
            ),
            SizedBox(
              height: resources.dimen.dp15,
            ),
            Text(
              resources.string.emailID,
              style:
                  context.textFontWeight400.onFontSize(resources.fontSize.dp10),
            ),
            Text(userEmail ?? '',
                style: context.textFontWeight600
                    .onFontSize(resources.fontSize.dp12)),
            SizedBox(
              height: resources.dimen.dp15,
            ),
            Text(
              resources.string.department,
              style:
                  context.textFontWeight400.onFontSize(resources.fontSize.dp10),
            ),
            Text("External User",
                style: context.textFontWeight600
                    .onFontSize(resources.fontSize.dp12)),
            SizedBox(
              height: resources.dimen.dp15,
            ),
            Text(
              resources.string.telephoneExt,
              style:
                  context.textFontWeight400.onFontSize(resources.fontSize.dp10),
            ),
            Text(userNumber ?? '',
                style: context.textFontWeight600
                    .onFontSize(resources.fontSize.dp12))
          ],
        ),
      ),
    );
  }
}
