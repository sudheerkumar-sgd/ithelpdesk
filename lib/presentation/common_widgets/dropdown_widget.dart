// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';

const double defaultHeight = 27;

class DropDownWidget<T> extends StatelessWidget {
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
  final List<T> list;
  T? selectedValue;
  Function(T?)? callback;
  final ValueNotifier<bool> _onItemChanged = ValueNotifier(false);
  final Color? fillColor;
  final bool isMandetory;
  final double? iconSize;
  DropDownWidget(
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
      this.fillColor,
      this.isMandetory = false,
      this.selectedValue,
      this.iconSize,
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
        ValueListenableBuilder(
            valueListenable: _onItemChanged,
            builder: (context, onItemChanged, widget) {
              return SizedBox(
                width: width,
                height: height,
                child: DropdownButtonFormField<T>(
                  padding: EdgeInsets.symmetric(
                      vertical: context.resources.dimen.dp2),
                  isExpanded: true,
                  isDense: true,
                  decoration: InputDecoration(
                    filled: true,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                        vertical: context.resources.dimen.dp7,
                        horizontal: context.resources.dimen.dp10),
                    fillColor: fillColor ?? const Color(0xFFF7F6F6),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: context.resources.color.sideBarItemUnselected,
                          width: 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(context.resources.dimen.dp10),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: context.resources.color.sideBarItemUnselected,
                          width: 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(context.resources.dimen.dp10),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: context.resources.color.sideBarItemUnselected,
                          width: 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(context.resources.dimen.dp10),
                      ),
                    ),
                    errorStyle: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  hint: Text(
                    hintText,
                    style: context.textFontWeight400
                        .onFontSize(context.resources.fontSize.dp10)
                        .onFontFamily(
                            fontFamily: context.resources.isLocalEn
                                ? fontFamilyEN
                                : fontFamilyAR)
                        .onColor(context.resources.color.colorD6D6D6),
                  ),
                  validator: (value) {
                    if (value == null || value.toString().isEmpty) {
                      return errorMessage.isNotEmpty ? errorMessage : null;
                    }
                    return null;
                  },
                  value: selectedValue,
                  iconSize: iconSize ?? 24,
                  style: context.textFontWeight400
                      .onFontFamily(
                          fontFamily: fontFamily.isNotEmpty
                              ? fontFamily
                              : context.resources.isLocalEn
                                  ? fontFamilyEN
                                  : fontFamilyAR)
                      .onFontSize(context.resources.fontSize.dp12),
                  onChanged: isEnabled
                      ? (T? value) {
                          _onItemChanged.value = !_onItemChanged.value;
                          selectedValue = value;
                          callback!(value);
                        }
                      : null,
                  items: list.map<DropdownMenuItem<T>>((T value) {
                    return DropdownMenuItem<T>(
                      value: value,
                      child: Text(
                        overflow: TextOverflow.clip,
                        value.toString(),
                        style: fontStyle ??
                            context.textFontWeight400.onFontFamily(
                                fontFamily: fontFamily.isNotEmpty
                                    ? fontFamily
                                    : context.resources.isLocalEn
                                        ? fontFamilyEN
                                        : fontFamilyAR),
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
      ],
    );
  }
}
