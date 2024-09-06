// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';

const double defaultHeight = 27;

class DropdownSearchMenuWidget<T> extends StatelessWidget {
  final double? height;
  final double? width;
  final bool isEnabled;
  final String labelText;
  final String hintText;
  final String errorMessage;
  final TextEditingController? textController;
  final String? suffixIconPath;
  final String fontFamily;
  final TextStyle? fontStyle;
  final TextStyle? labelfontStyle;
  final List<T> list;
  T? selectedValue;
  Function(T?)? callback;
  final Color? fillColor;
  final bool isMandetory;
  final double? iconSize;
  final double? borderRadius;
  DropdownSearchMenuWidget(
      {required this.list,
      this.height,
      this.width,
      this.isEnabled = true,
      this.labelText = '',
      this.hintText = '',
      this.errorMessage = '',
      this.textController,
      this.suffixIconPath,
      this.fontFamily = '',
      this.fontStyle,
      this.labelfontStyle,
      this.fillColor,
      this.isMandetory = false,
      this.selectedValue,
      this.iconSize,
      this.borderRadius,
      this.callback,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText.isNotEmpty) ...[
          Text.rich(TextSpan(
              text: labelText,
              style: labelfontStyle ??
                  context.textFontWeight400
                      .onFontSize(context.resources.fontSize.dp14),
              children: [
                if (isMandetory)
                  TextSpan(
                    text: ' *',
                    style: labelfontStyle ??
                        context.textFontWeight400
                            .onFontSize(context.resources.fontSize.dp14)
                            .onColor(Theme.of(context).colorScheme.error),
                  )
              ])),
          SizedBox(
            height: context.resources.dimen.dp4,
          ),
        ],
        LayoutBuilder(builder: (context, constraints) {
          return DropdownMenu(
            width: constraints.maxWidth,
            //controller: textEditingController,
            hintText: hintText,
            requestFocusOnTap: true,
            enableFilter: true,
            //focusNode: focusNode,
            textStyle: context.textFontWeight500
                .onFontFamily(fontFamily: fontFamilyEN),
            inputDecorationTheme: InputDecorationTheme(
              constraints: const BoxConstraints(maxHeight: 32),
              isDense: true,
              filled: true,
              contentPadding: EdgeInsets.symmetric(
                  vertical: context.resources.dimen.dp7,
                  horizontal: context.resources.dimen.dp10),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(
                  Radius.circular(context.resources.dimen.dp20),
                ),
              ),
            ),
            leadingIcon: Icon(
              Icons.search,
              color: context.resources.color.viewBgColor,
            ),
            trailingIcon: const SizedBox(),
            onSelected: (dynamic item) {
              callback?.call(item);
            },
            dropdownMenuEntries:
                list.map<DropdownMenuEntry<dynamic>>((dynamic item) {
              return DropdownMenuEntry<dynamic>(
                  value: item,
                  label: item.toString(),
                  style: ButtonStyle(
                      textStyle: WidgetStateProperty.all(context
                          .textFontWeight500
                          .onFontFamily(fontFamily: fontFamilyEN))));
            }).toList(),
          );
        }),
      ],
    );
  }
}
