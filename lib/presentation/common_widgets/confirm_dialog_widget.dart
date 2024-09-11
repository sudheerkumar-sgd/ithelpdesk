import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';

import '../../../res/drawables/background_box_decoration.dart';
import '../../core/constants/constants.dart';
import '../../res/drawables/drawable_assets.dart';

class ConformDialogWidget extends StatelessWidget {
  final String message;
  final String title;
  final String? actionButtonText;
  const ConformDialogWidget(
      {required this.message,
      this.title = '',
      this.actionButtonText,
      super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: ImageWidget(
                      path: DrawableAssets.icCross,
                      padding: EdgeInsets.only(
                          left: isSelectedLocalEn
                              ? context.resources.dimen.dp5
                              : 0,
                          right: isSelectedLocalEn
                              ? 0
                              : context.resources.dimen.dp5,
                          top: context.resources.dimen.dp5,
                          bottom: context.resources.dimen.dp15))
                  .loadImageWithMoreTapArea,
            ),
          ),
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
                  Navigator.pop(context, 'yes');
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
                    actionButtonText ?? context.resources.string.submit,
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
      ),
    );
  }
}
