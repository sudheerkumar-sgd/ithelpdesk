import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';

class ItemServiceSteps extends StatelessWidget {
  final int? stepCount;
  final String stepText;
  final String stepSubText;
  final Color? stepColor;
  final bool? isLastStep;
  final String? attachmentText;
  final Function? attachmentCallback;
  const ItemServiceSteps(
      {this.stepCount,
      required this.stepText,
      this.stepColor,
      this.stepSubText = '',
      this.isLastStep = false,
      this.attachmentText,
      this.attachmentCallback,
      super.key});

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BackgroundBoxDecoration(
                  boxColor: stepColor ?? resources.color.colorLightBg,
                ).circularBox,
              ),
              if (isLastStep == false) ...[
                SizedBox(
                  height: resources.dimen.dp10,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: resources.color.sideBarItemUnselected,
                ),
              ]
            ],
          ),
          SizedBox(
            width: resources.dimen.dp10,
          ),
          Expanded(
            child: Text.rich(TextSpan(
                text: stepText,
                style: context.textFontWeight700
                    .onFontSize(resources.fontSize.dp12)
                    .onHeight(1.2),
                children: [
                  if (stepSubText.isNotEmpty)
                    TextSpan(
                      text: '\n$stepSubText',
                      style: context.textFontWeight500
                          .onFontSize(resources.fontSize.dp10)
                          .onHeight(1.2),
                    )
                ])),
          ),
        ],
      ),
    );
  }
}
