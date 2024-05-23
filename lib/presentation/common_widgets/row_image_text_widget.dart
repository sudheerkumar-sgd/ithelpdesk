import 'package:flutter/material.dart';
import 'package:smartuaq/core/constants/constants.dart';
import 'package:smartuaq/core/extensions/build_context_extension.dart';
import 'package:smartuaq/core/extensions/text_style_extension.dart';
import 'package:smartuaq/presentation/common_widgets/image_widget.dart';
import 'package:smartuaq/res/drawables/background_box_decoration.dart';
import 'package:smartuaq/res/drawables/drawable_assets.dart';

class RowImageTextWidget extends StatelessWidget {
  final String text;
  final String imagePath;
  final String expandImagePath;
  final String collapseImagePath;
  final Widget? expandWidget;
  final ValueNotifier<bool> _isExpanded = ValueNotifier(false);
  RowImageTextWidget(
      {required this.text,
      this.imagePath = '',
      this.expandImagePath = DrawableAssets.icChevronDownExpand,
      this.collapseImagePath = DrawableAssets.icChevronUpExpand,
      this.expandWidget,
      super.key});

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return InkWell(
      onTap: expandWidget != null
          ? () {
              _isExpanded.value = !_isExpanded.value;
            }
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            if (imagePath.isNotEmpty) ...[
              Container(
                  padding: EdgeInsets.all(resources.dimen.dp10),
                  decoration: BackgroundBoxDecoration(
                          boxColor: resources.color.appScaffoldBg2)
                      .circularBox,
                  child: ImageWidget(path: imagePath).loadImage),
              SizedBox(
                width: context.resources.dimen.dp10,
              ),
            ],
            Expanded(
              child: Text(
                text,
                style: context.textFontWeight500
                    .onFontSize(resources.fontSize.dp16),
              ),
            ),
            if (expandWidget != null)
              ValueListenableBuilder(
                  valueListenable: _isExpanded,
                  builder: (context, value, child) {
                    return ImageWidget(
                            path: value ? collapseImagePath : expandImagePath)
                        .loadImage;
                  }),
            if (expandWidget == null)
              ImageWidget(path: expandImagePath, isLocalEn: isSelectedLocalEn)
                  .loadImage
          ]),
          if (expandWidget != null) ...[
            ValueListenableBuilder(
                valueListenable: _isExpanded,
                builder: (context, value, child) {
                  return Visibility(
                      visible: value, child: expandWidget ?? const SizedBox());
                })
          ]
        ],
      ),
    );
  }
}
