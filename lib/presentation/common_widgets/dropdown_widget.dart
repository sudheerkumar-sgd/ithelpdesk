// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';
import 'package:ithelpdesk/res/drawables/drawable_assets.dart';

const double defaultHeight = 27;

class DropDownWidget<T> extends StatelessWidget {
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
  final ValueNotifier<bool> _onItemChanged = ValueNotifier(false);
  final Color? fillColor;
  final bool isMandetory;
  DropDownWidget(
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
              return DropdownButtonFormField<T>(
                padding:
                    EdgeInsets.symmetric(vertical: context.resources.dimen.dp2),
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
                  errorStyle: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                hint: Text(
                  hintText,
                  style: context.textFontWeight400
                      .onFontSize(context.resources.fontSize.dp12)
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
                icon: Padding(
                  padding: context.resources.isLocalEn
                      ? const EdgeInsets.only(right: 10.0)
                      : const EdgeInsets.only(left: 10.0),
                  child: ImageWidget(
                    path: DrawableAssets.icChevronDown,
                  ).loadImage,
                ),
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
                    child: Center(
                      child: Text(
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        value.toString(),
                        style: context.textFontWeight400
                            .onFontFamily(
                                fontFamily: fontFamily.isNotEmpty
                                    ? fontFamily
                                    : context.resources.isLocalEn
                                        ? fontFamilyEN
                                        : fontFamilyAR)
                            .onHeight(1.7),
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
      ],
    );
  }
}
