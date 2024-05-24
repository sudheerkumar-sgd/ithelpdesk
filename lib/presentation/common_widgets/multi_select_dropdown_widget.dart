// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/item_attachment.dart';
import 'package:ithelpdesk/presentation/common_widgets/multi_select_dialog_widget.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';
import 'package:ithelpdesk/res/drawables/drawable_assets.dart';

const double defaultHeight = 27;

class MultiSelectDropDownWidget<T> extends StatelessWidget {
  final double height;
  final bool isEnabled;
  final String labelText;
  final String hintText;
  final String errorMessage;
  final TextEditingController? textController;
  final String? suffixIconPath;
  final String fontFamily;
  final List<T> list;
  Function(List<T>?)? callback;
  final ValueNotifier<bool> _onItemChanged = ValueNotifier(false);
  final Color? fillColor;
  final bool isMandetory;
  final List<T> selectedItems;
  MultiSelectDropDownWidget(
      {required this.list,
      this.height = defaultHeight,
      this.isEnabled = true,
      this.labelText = '',
      this.hintText = '',
      this.errorMessage = '',
      this.textController,
      this.suffixIconPath,
      this.fontFamily = '',
      this.fillColor,
      this.isMandetory = false,
      this.selectedItems = const [],
      this.callback,
      super.key});

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText.isNotEmpty) ...[
          Text.rich(TextSpan(
              text: labelText,
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp14),
              children: [
                if (isMandetory)
                  TextSpan(
                    text: ' *',
                    style: context.textFontWeight400
                        .onFontSize(context.resources.fontSize.dp14)
                        .onColor(Theme.of(context).colorScheme.error),
                  )
              ])),
          SizedBox(
            height: context.resources.dimen.dp4,
          ),
        ],
        InkWell(
          onTap: () {
            if (list.isNotEmpty) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return MultiSelectDialogWidget(
                      list: list,
                      selectedItems: selectedItems,
                    );
                  }).then((value) {
                selectedItems.clear();
                selectedItems.addAll(value);
                _onItemChanged.value = !_onItemChanged.value;
                callback?.call(selectedItems);
              });
            }
          },
          child: Container(
            padding: EdgeInsets.only(
                left: context.resources.dimen.dp10,
                top: context.resources.dimen.dp5,
                right: context.resources.dimen.dp15,
                bottom: context.resources.dimen.dp5),
            decoration: BackgroundBoxDecoration(
                    boxColor: fillColor ?? const Color(0xFFF7F6F6),
                    radious: context.resources.dimen.dp10)
                .roundedCornerBox,
            child: Row(
              children: [
                ValueListenableBuilder(
                    valueListenable: _onItemChanged,
                    builder: (context, isChanged, widget) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: context.resources.dimen.dp5,
                              right: context.resources.dimen.dp15,
                              bottom: context.resources.dimen.dp5),
                          child: selectedItems.isNotEmpty
                              ? Wrap(
                                  runSpacing: resources.dimen.dp10,
                                  spacing: resources.dimen.dp10,
                                  children: List.generate(
                                      selectedItems.length,
                                      (index) => ItemAttachment(
                                            id: index,
                                            name:
                                                selectedItems[index].toString(),
                                            wrapContent: true,
                                            callBack: (value) {
                                              selectedItems.removeAt(value);
                                              _onItemChanged.value =
                                                  !_onItemChanged.value;
                                            },
                                          )),
                                )
                              : Text(
                                  hintText,
                                  style: context.textFontWeight400
                                      .onFontSize(
                                          context.resources.fontSize.dp12)
                                      .onColor(
                                          context.resources.color.colorD6D6D6),
                                ),
                        ),
                      );
                    }),
                SizedBox(
                  width: context.resources.dimen.dp15,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: resources.dimen.dp8),
                  child: ImageWidget(
                          path: DrawableAssets.icChevronDown,
                          backgroundTint: resources.color.viewBgColor)
                      .loadImage,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
