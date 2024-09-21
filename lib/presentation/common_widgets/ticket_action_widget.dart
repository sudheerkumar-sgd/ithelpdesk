// ignore_for_file: must_be_immutable

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/string_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/dropdown_widget.dart';

import '../../../res/drawables/background_box_decoration.dart';
import 'multi_upload_attachment_widget.dart';
import 'right_icon_text_widget.dart';

class TicketActionWidget extends StatelessWidget {
  final String message;
  final String title;
  final bool isCommentRequired;
  final bool showIssueType;
  TicketActionWidget(
      {required this.message,
      this.title = '',
      this.isCommentRequired = true,
      this.showIssueType = false,
      super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentsController = TextEditingController();
  IssueType? issueType;

  @override
  Widget build(BuildContext context) {
    final multiUploadAttachmentWidget = MultiUploadAttachmentWidget(
      hintText: context.resources.string.uploadFile,
      fillColor: context.resources.color.colorWhite,
      borderSide: BorderSide(
          color: context.resources.color.sideBarItemUnselected, width: 1),
      borderRadius: 0,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title.isNotEmpty) ...[
          Text(
            title,
            style: context.textFontWeight600
                .onFontSize(context.resources.fontSize.dp17),
          ),
          SizedBox(
            height: context.resources.dimen.dp20,
          )
        ],
        SelectableText(
          message,
          textAlign: TextAlign.center,
          style: context.textFontWeight600
              .onFontSize(context.resources.fontSize.dp14),
        ),
        SizedBox(
          height: context.resources.dimen.dp25,
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              if (showIssueType) ...[
                DropDownWidget(
                  list: const [
                    IssueType.customer,
                    IssueType.employee,
                    IssueType.system,
                    IssueType.other,
                  ],
                  labelText: context.resources.string.issueType,
                  hintText: context.resources.string.issueType,
                  errorMessage: context.resources.string.issueType
                      .withPrefix(context.resources.string.pleaseSelect),
                  borderRadius: 0,
                  fillColor: context.resources.color.colorWhite,
                  callback: (p0) {
                    issueType = p0;
                  },
                ),
                SizedBox(
                  height: context.resources.dimen.dp10,
                ),
              ],
              RightIconTextWidget(
                hintText: 'Add Your Comment',
                fillColor: context.resources.color.colorWhite,
                textController: _commentsController,
                maxLines: 4,
                borderSide: BorderSide(
                    color: context.resources.color.sideBarItemUnselected,
                    width: 1),
                borderRadius: 0,
                isValid: (value) {
                  if (value.isEmpty && isCommentRequired) {
                    return 'Please Enter Comments';
                  }
                },
              ),
              SizedBox(
                height: context.resources.dimen.dp10,
              ),
              multiUploadAttachmentWidget
            ],
          ),
        ),
        SizedBox(
          height: context.resources.dimen.dp20,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: context.resources.dimen.dp20,
                    vertical: context.resources.dimen.dp7),
                decoration: BackgroundBoxDecoration(
                        boxColor: context.resources.color.sideBarItemUnselected,
                        radious: context.resources.dimen.dp15)
                    .roundedCornerBox,
                child: Text(
                  context.resources.string.cancel,
                  style: context.textFontWeight400
                      .onFontSize(context.resources.fontSize.dp12)
                      .onColor(context.resources.color.textColor)
                      .copyWith(height: 1.2),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              width: context.resources.dimen.dp20,
            ),
            InkWell(
              onTap: () {
                if (_formKey.currentState?.validate() == true) {
                  final files = multiUploadAttachmentWidget
                      .getSelectedFilesData()
                      .map((file) {
                    return MultipartFile.fromBytes(file['fileBytes'],
                        filename: file['fileName']);
                  }).toList();
                  Navigator.pop(context, {
                    'comments': _commentsController.text,
                    'files': files,
                    'issueType': issueType
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: context.resources.dimen.dp20,
                    vertical: context.resources.dimen.dp7),
                decoration: BackgroundBoxDecoration(
                        boxColor: context.resources.color.viewBgColor,
                        radious: context.resources.dimen.dp15)
                    .roundedCornerBox,
                child: Text(
                  context.resources.string.submit,
                  style: context.textFontWeight400
                      .onFontSize(context.resources.fontSize.dp12)
                      .onColor(context.resources.color.colorWhite)
                      .copyWith(height: 1.2),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
