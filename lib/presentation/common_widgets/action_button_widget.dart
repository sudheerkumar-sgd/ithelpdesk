import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';

class ActionButtonWidget extends StatelessWidget {
  final String text;
  final double? width;
  final Color? color;
  final EdgeInsets? padding;
  const ActionButtonWidget(
      {required this.text, this.width, this.color, this.padding, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding ??
          EdgeInsets.symmetric(
              horizontal: context.resources.dimen.dp100,
              vertical: context.resources.dimen.dp7),
      decoration: BackgroundBoxDecoration(
              boxColor: color ?? context.resources.color.viewBgColor,
              radious: context.resources.dimen.dp15)
          .roundedCornerBox,
      child: Text(
        text,
        style: context.textFontWeight600
            .onFontSize(context.resources.fontSize.dp14)
            .onColor(context.resources.color.colorWhite),
        textAlign: TextAlign.center,
      ),
    );
  }
}
