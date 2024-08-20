import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';

import '../../../res/drawables/background_box_decoration.dart';
import 'multi_upload_attachment_widget.dart';
import 'right_icon_text_widget.dart';

class TicketActionWidget extends StatelessWidget {
  final String message;
  final String title;
  final bool isCommentRequired;
  TicketActionWidget(
      {required this.message,
      this.title = '',
      this.isCommentRequired = true,
      super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentsController = TextEditingController();

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
              RightIconTextWidget(
                hintText: 'Add Your Comment',
                fillColor: context.resources.color.colorWhite,
                textController: _commentsController,
                maxLines: 2,
                borderSide: BorderSide(
                    color: context.resources.color.sideBarItemUnselected,
                    width: 1),
                borderRadius: 0,
                isValid: (value) {
                  if (value.isEmpty) {
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
                      .copyWith(height: 1),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              width: context.resources.dimen.dp20,
            ),
            InkWell(
              onTap: () {
                if (!isCommentRequired ||
                    _formKey.currentState?.validate() == true) {
                  final files = multiUploadAttachmentWidget
                      .getSelectedFilesData()
                      .map((file) {
                    return MultipartFile.fromBytes(file['fileBytes'],
                        filename: file['fileName']);
                  }).toList();
                  Navigator.pop(context,
                      {'comments': _commentsController.text, 'files': files});
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: context.resources.dimen.dp20,
                    vertical: context.resources.dimen.dp7),
                decoration: BackgroundBoxDecoration(
                        boxColor: context.resources.color.viewBgColorLight,
                        radious: context.resources.dimen.dp15)
                    .roundedCornerBox,
                child: Text(
                  context.resources.string.submit,
                  style: context.textFontWeight400
                      .onFontSize(context.resources.fontSize.dp12)
                      .onColor(context.resources.color.colorWhite)
                      .copyWith(height: 1),
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
