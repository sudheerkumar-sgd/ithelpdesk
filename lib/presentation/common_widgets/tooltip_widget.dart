import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/tooltip_painter.dart';

class TooltipWidget extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final EdgeInsets? padding;

  const TooltipWidget(
      {super.key, required this.text, this.textStyle, this.padding});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TooltipPainter(),
      child: Container(
        padding: padding ?? const EdgeInsets.all(5),
        alignment: Alignment.center,
        child: Text(
          text,
          style: textStyle ??
              context.textFontWeight400
                  .onColor(Colors.white)
                  .onFontSize(10)
                  .onHeight(1.2)
                  .onFontFamily(fontFamily: fontFamilyEN),
        ),
      ),
    );
  }
}
