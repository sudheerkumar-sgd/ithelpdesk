import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';

class ActionButtonWidget extends StatelessWidget {
  final String text;
  final double? width;
  final Color? color;
  final Color? textColor;
  final double? textSize;
  final TextStyle? textStyle;
  final int? maxLines;
  final Decoration? decoration;
  final double? radious;
  final EdgeInsets? padding;
  const ActionButtonWidget(
      {required this.text,
      this.width,
      this.color,
      this.padding,
      this.radious,
      this.decoration,
      this.textColor,
      this.textSize,
      this.textStyle,
      this.maxLines,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding ??
          EdgeInsets.symmetric(
              horizontal: context.resources.dimen.dp100,
              vertical: context.resources.dimen.dp7),
      decoration: decoration ??
          BackgroundBoxDecoration(
            boxColor: color ?? context.resources.color.viewBgColor,
            radious: radious ?? context.resources.dimen.dp10,
          ).roundedCornerBox,
      child: Text(
        text,
        maxLines: maxLines,
        style: (textStyle ?? context.textFontWeight600)
            .onFontSize(textSize ?? context.resources.fontSize.dp14)
            .onColor(textColor ?? context.resources.color.colorWhite),
        textAlign: TextAlign.center,
      ),
    );
  }
}
