import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/common/log.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';
import 'package:ithelpdesk/res/drawables/drawable_assets.dart';

class DropdownMenuWidget<T> extends StatelessWidget {
  final List<T> items;
  final String titleText;
  final Function(T)? onItemSelected;
  DropdownMenuWidget(
      {required this.items,
      required this.titleText,
      this.onItemSelected,
      super.key});
  final ValueNotifier<T?> _onValueSelected = ValueNotifier(null);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      printLog(constraints);
      return PopupMenuButton(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        constraints: BoxConstraints.tightFor(width: constraints.maxWidth),
        child: ValueListenableBuilder(
            valueListenable: _onValueSelected,
            builder: (context, value, child) {
              return Container(
                padding: EdgeInsets.symmetric(
                    vertical: context.resources.dimen.dp5,
                    horizontal: context.resources.dimen.dp10),
                decoration: BackgroundBoxDecoration(
                        boarderColor:
                            context.resources.color.dividerColorB3B8BF,
                        radious: 0,
                        boarderWidth: context.resources.dimen.dp1)
                    .roundedCornerBox,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        titleText,
                        style: context.textFontWeight500,
                      ),
                    ),
                    ImageWidget(path: DrawableAssets.icChevronDown).loadImage
                  ],
                ),
              );
            }),
        onSelected: (value) {
          _onValueSelected.value = value;
          onItemSelected?.call(value);
        },
        itemBuilder: (BuildContext context) => items
            .map((item) => PopupMenuItem(
                  value: item,
                  child: Text(
                    item.toString(),
                    style: context.textFontWeight500,
                  ),
                ))
            .toList(),
      );
    });
  }
}
