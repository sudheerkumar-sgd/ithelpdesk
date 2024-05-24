import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';

const double defaultHeight = 40;

class SearchTextfieldWidget extends StatelessWidget {
  final double height;
  final String? hintText;
  final String errorMessage;
  final TextInputType? textInputType;
  final TextEditingController? textController;
  final String? prefixIconPath;
  final FocusNode? focusNode;
  final bool isEnabled;
  const SearchTextfieldWidget(
      {this.height = defaultHeight,
      this.hintText,
      this.errorMessage = '',
      this.textController,
      this.prefixIconPath,
      this.textInputType,
      this.focusNode,
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
              focusNode: focusNode,
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
                hintText:
                    hintText ?? context.resources.string.whatareyoulookingfor,
                hintStyle: context.textFontWeight400
                    .onFontSize(context.resources.fontSize.dp12)
                    .onFontFamily(
                        fontFamily: context.resources.isLocalEn
                            ? fontFamilyEN
                            : fontFamilyAR)
                    .onColor(context.resources.color.colorD6D6D6),
                prefixIconConstraints:
                    BoxConstraints(maxHeight: height, minHeight: height),
                prefixIcon: (prefixIconPath ?? '').isNotEmpty
                    ? Padding(
                        padding: context.resources.isLocalEn
                            ? const EdgeInsets.only(left: 15.0, right: 10.0)
                            : const EdgeInsets.only(right: 15.0, left: 10.0),
                        child: ImageWidget(
                                path: prefixIconPath ?? '',
                                colorFilter: ColorFilter.mode(
                                    context.resources.color.viewBgColorLight,
                                    BlendMode.srcIn))
                            .loadImage,
                      )
                    : null,
                fillColor: context.resources.color.colorWhite,
                border: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0XFF9E9E9E), width: 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(context.resources.dimen.dp10),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0XFF9E9E9E), width: 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(context.resources.dimen.dp10),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0XFF9E9E9E), width: 1),
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
