import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';

import '../../../res/drawables/background_box_decoration.dart';

class ConformDialogWidget extends StatelessWidget {
  final String message;
  final String title;
  const ConformDialogWidget(
      {required this.message, this.title = '', super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(context.resources.dimen.dp15))),
      child: Padding(
        padding: EdgeInsets.all(context.resources.dimen.dp20),
        child: Column(
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
                            boxColor:
                                context.resources.color.sideBarItemUnselected,
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
                    Navigator.pop(context, 'yes');
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
        ),
      ),
    );
  }
}
