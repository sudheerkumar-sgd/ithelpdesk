import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/common/log.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';
import 'package:ithelpdesk/res/drawables/drawable_assets.dart';

class DropdownMenuWidget<T> extends StatelessWidget {
  final List<T> items;
  DropdownMenuWidget({required this.items, super.key});
  final ValueNotifier<T?> _onValueSelected = ValueNotifier(null);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      printLog(constraints);
      return PopupMenuButton(
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
                        'Select',
                        style: context.textFontWeight500,
                      ),
                    ),
                    ImageWidget(path: DrawableAssets.icChevronDown).loadImage
                  ],
                ),
              );
            }),
        onSelected: (value) {
          if (value == "profile") {
            // add desired output
          } else if (value == "settings") {
            // add desired output
          } else if (value == "logout") {
            // add desired output
          }
          _onValueSelected.value = value;
        },
        itemBuilder: (BuildContext context) => items
            .map((item) => PopupMenuItem(
                  value: item,
                  child: Expanded(
                    child: Text(
                      item.toString(),
                      style: context.textFontWeight500,
                    ),
                  ),
                ))
            .toList(),
      );
    });
  }
}
