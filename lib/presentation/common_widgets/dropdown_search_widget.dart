// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:smartuaq/core/extensions/build_context_extension.dart';
import 'package:smartuaq/core/extensions/text_style_extension.dart';
import 'package:smartuaq/presentation/common_widgets/right_icon_text_widget.dart';
import 'package:smartuaq/res/drawables/drawable_assets.dart';

const double defaultHeight = 27;

class DropdownSearchWidget<T extends Object> extends StatelessWidget {
  final double height;
  final bool isEnabled;
  final String labelText;
  final String hintText;
  final String errorMessage;
  final TextEditingController? textController;
  final String? suffixIconPath;
  final String fontFamily;
  final List<T> list;
  T? selectedValue;
  Function(T?)? callback;
  final Color? fillColor;
  final bool isMandetory;
  DropdownSearchWidget(
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
      this.selectedValue,
      this.callback,
      super.key});

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return LayoutBuilder(builder: (context, constraints) {
      return Autocomplete<T>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return list;
          }
          return list.where((T option) {
            return option
                .toString()
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase());
          });
        },
        fieldViewBuilder:
            (context, textEditingController, focusNode, onFieldSubmitted) {
          return RightIconTextWidget(
            isEnabled: true,
            height: resources.dimen.dp27,
            labelText: labelText,
            hintText: hintText,
            errorMessage: errorMessage,
            textController: textEditingController,
            suffixIconPath: DrawableAssets.icChevronDown,
            focusNode: focusNode,
          );
        },
        optionsViewBuilder: (context, onSelected, options) => Align(
          alignment: Alignment.topLeft,
          child: Material(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(4.0)),
            ),
            child: SizedBox(
              height: 52.0 * options.length,
              width: constraints.biggest.width,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                shrinkWrap: false,
                itemBuilder: (BuildContext context, int index) {
                  final T option = options.elementAt(index);
                  return InkWell(
                    onTap: () => onSelected(option),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        option.toString(),
                        style: context.textFontWeight400,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        onSelected: (T selection) {
          callback!(selection);
        },
      );
    });
  }
}
