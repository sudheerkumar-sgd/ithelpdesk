import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';

const double defaultHeight = 20;

class SearchTextfieldWidget extends StatelessWidget {
  final double height;
  final String? hintText;
  final String errorMessage;
  final TextInputType? textInputType;
  final TextEditingController? textController;
  final String? prefixIconPath;
  final bool isEnabled;
  const SearchTextfieldWidget(
      {this.height = defaultHeight,
      this.hintText,
      this.errorMessage = '',
      this.textController,
      this.prefixIconPath,
      this.textInputType,
      this.isEnabled = true,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: TextFormField(
              enabled: isEnabled,
              maxLines: 1,
              keyboardType: textInputType,
              controller: textController,
              textAlignVertical: TextAlignVertical.center,
              validator: (value) {
                if (errorMessage.isNotEmpty &&
                    (value == null || value.isEmpty)) {
                  return errorMessage.isNotEmpty ? errorMessage : null;
                }
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                    vertical: context.resources.dimen.dp10,
                    horizontal: context.resources.dimen.dp15),
                hintText: hintText ?? context.resources.string.searchHere,
                hintStyle: context.textFontWeight400
                    .onFontSize(context.resources.fontSize.dp12)
                    .onFontFamily(
                        fontFamily: context.resources.isLocalEn
                            ? fontFamilyEN
                            : fontFamilyAR)
                    .onColor(context.resources.color.hintColor),
                prefixIconConstraints:
                    BoxConstraints(maxHeight: height, minHeight: height),
                prefixIcon: (prefixIconPath ?? '').isNotEmpty
                    ? Padding(
                        padding: context.resources.isLocalEn
                            ? const EdgeInsets.only(left: 5.0, right: 5.0)
                            : const EdgeInsets.only(right: 5.0, left: 5.0),
                        child: ImageWidget(
                          path: prefixIconPath ?? '',
                        ).loadImage,
                      )
                    : null,
                fillColor: const Color(0xFFF7F8F9),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(context.resources.dimen.dp10),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(context.resources.dimen.dp10),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(context.resources.dimen.dp10),
                  ),
                ),
                errorStyle: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              style: context.textFontWeight400
                  .onFontFamily(fontFamily: fontFamilyEN)
                  .onFontSize(context.resources.fontSize.dp12)),
        ),
      ],
    );
  }
}
