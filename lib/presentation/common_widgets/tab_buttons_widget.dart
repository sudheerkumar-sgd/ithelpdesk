import 'package:flutter/material.dart';
import 'package:smartuaq/core/constants/constants.dart';
import 'package:smartuaq/core/extensions/build_context_extension.dart';
import 'package:smartuaq/core/extensions/text_style_extension.dart';

import '../../../res/drawables/background_box_decoration.dart';

class TabsButtonsWidget extends StatelessWidget {
  final ValueNotifier<int> selectedIndex;
  final List<Map> buttons;
  const TabsButtonsWidget(
      {required this.buttons, required this.selectedIndex, super.key});

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return ValueListenableBuilder(
        valueListenable: selectedIndex,
        builder: (context, value, widget) {
          return SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: List.generate(
                buttons.length,
                (index) {
                  final name = buttons[index]['name'];
                  final count = buttons[index]['count'] ?? 0;
                  return InkWell(
                    onTap: () {
                      selectedIndex.value = index;
                    },
                    child: count > 0
                        ? Stack(
                            fit: StackFit.passthrough,
                            children: [
                              Container(
                                margin:
                                    EdgeInsets.only(top: resources.dimen.dp10),
                                padding: EdgeInsets.symmetric(
                                    vertical: resources.dimen.dp2,
                                    horizontal: context.resources.dimen.dp15),
                                decoration: BackgroundBoxDecoration(
                                  boxColor: value == index
                                      ? buttons[index]['select_color']
                                      : buttons[index]['unselect_color'],
                                  radious: context.resources.dimen.dp10,
                                ).roundedCornerBox,
                                child: Text(
                                  name,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.textFontWeight400
                                      .onColor(value == index
                                          ? resources.color.colorWhite
                                          : resources.color.textColor)
                                      .onFontSize(
                                          context.resources.fontSize.dp12),
                                ),
                              ),
                              Align(
                                  alignment: isSelectedLocalEn
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  child: Visibility(
                                    visible: count > 0,
                                    child: Container(
                                      width: resources.dimen.dp20,
                                      height: resources.dimen.dp20,
                                      decoration: ShapeDecoration(
                                          shape: const CircleBorder(),
                                          color: resources.color.bgGradientEnd),
                                      child: Text('$count',
                                          textAlign: TextAlign.center,
                                          style: context.textFontWeight600
                                              .onColor(context
                                                  .resources.color.colorWhite)
                                              .onFontFamily(
                                                  fontFamily: fontFamilyEN)
                                              .onFontSize(context
                                                  .resources.fontSize.dp13)),
                                    ),
                                  )),
                            ],
                          )
                        : InkWell(
                            onTap: () {
                              selectedIndex.value = index;
                            },
                            child: Container(
                              margin:
                                  EdgeInsets.only(top: resources.dimen.dp10),
                              padding: EdgeInsets.symmetric(
                                  vertical: resources.dimen.dp2,
                                  horizontal: context.resources.dimen.dp12),
                              decoration: BackgroundBoxDecoration(
                                boxColor: value == index
                                    ? buttons[index]['select_color']
                                    : buttons[index]['unselect_color'],
                                radious: context.resources.dimen.dp10,
                              ).roundedCornerBox,
                              child: Text(
                                name,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: context.textFontWeight400
                                    .onColor(value == index
                                        ? resources.color.colorWhite
                                        : resources.color.textColor)
                                    .onFontSize(
                                        context.resources.fontSize.dp12),
                              ),
                            ),
                          ),
                  );
                },
              ),
            ),
          );
        });
  }
}
