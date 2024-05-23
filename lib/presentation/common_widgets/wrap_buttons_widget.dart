import 'package:flutter/material.dart';
import 'package:smartuaq/core/extensions/build_context_extension.dart';
import 'package:smartuaq/core/extensions/text_style_extension.dart';

class WrapButtonsWidget extends StatelessWidget {
  final ValueNotifier<int> selectedIndex;
  final List<Map> buttons;
  const WrapButtonsWidget(
      {required this.buttons, required this.selectedIndex, super.key});

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return ValueListenableBuilder(
        valueListenable: selectedIndex,
        builder: (context, value, widget) {
          return Wrap(
            spacing: resources.dimen.dp10,
            children: List.generate(
              buttons.length,
              (index) {
                final name = buttons[index]['name'];
                return InkWell(
                  onTap: () {
                    selectedIndex.value = index;
                  },
                  child: Chip(
                    backgroundColor: value == index
                        ? buttons[index]['select_color']
                        : buttons[index]['unselect_color'],
                    label: Text(
                      name,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: context.textFontWeight400
                          .onColor(value == index
                              ? resources.color.colorWhite
                              : resources.color.textColor)
                          .onFontSize(context.resources.fontSize.dp12),
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}
