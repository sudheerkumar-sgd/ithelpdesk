import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';
import 'package:ithelpdesk/res/drawables/drawable_assets.dart';

class HappinessMeterWidget extends StatelessWidget {
  final String happinessMeterQuestion;
  const HappinessMeterWidget({required this.happinessMeterQuestion, super.key});

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: resources.dimen.dp20,
        ),
        Text(
          happinessMeterQuestion,
          style: context.textFontWeight600.onColor(resources.color.viewBgColor),
        ),
        SizedBox(
          height: resources.dimen.dp20,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          InkWell(
            onTap: () {
              Dialogs.dismiss(context, value: 3);
            },
            child: ImageWidget(
                    path: DrawableAssets.icNotHappy,
                    padding: const EdgeInsets.all(10))
                .loadImageWithMoreTapArea,
          ),
          InkWell(
            onTap: () {
              Dialogs.dismiss(context, value: 2);
            },
            child: ImageWidget(
                    path: DrawableAssets.icHappy,
                    padding: const EdgeInsets.all(10))
                .loadImageWithMoreTapArea,
          ),
          InkWell(
            onTap: () {
              Dialogs.dismiss(context, value: 1);
            },
            child: ImageWidget(
                    path: DrawableAssets.icSatisfied,
                    padding: const EdgeInsets.all(10))
                .loadImageWithMoreTapArea,
          ),
        ]),
        SizedBox(
          height: resources.dimen.dp10,
        ),
      ],
    );
  }
}
