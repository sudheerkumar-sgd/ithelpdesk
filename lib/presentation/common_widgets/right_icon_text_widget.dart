import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';

const double defaultHeight = 27;

class RightIconTextWidget extends StatelessWidget {
  final double height;
  final bool isEnabled;
  final String labelText;
  final String hintText;
  final String errorMessage;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final TextEditingController? textController;
  final String? suffixIconPath;
  final int? maxLines;
  final int? maxLength;
  final int maxLengthValidation;
  final String fontFamily;
  final FocusNode? focusNode;
  final bool isMandetory;
  final BorderSide borderSide;
  final double? borderRadius;
  final Color? fillColor;
  final Function(String)? onChanged;
  final Function? suffixIconClick;
  final Function(String)? isValid;
  final String? regex;
  final AutovalidateMode? autovalidateMode;
  const RightIconTextWidget(
      {this.height = defaultHeight,
      this.isEnabled = true,
      this.labelText = '',
      this.hintText = '',
      this.errorMessage = '',
      this.textController,
      this.suffixIconPath,
      this.textInputType,
      this.textInputAction,
      this.maxLines = 1,
      this.maxLength,
      this.maxLengthValidation = 0,
      this.fontFamily = '',
      this.focusNode,
      this.isMandetory = false,
      this.fillColor,
      this.borderSide = BorderSide.none,
      this.borderRadius,
      this.onChanged,
      this.suffixIconClick,
      this.regex,
      this.isValid,
      this.autovalidateMode,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
            visible: labelText.isNotEmpty,
            child: Text.rich(TextSpan(
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
                ]))),
        SizedBox(
          height: context.resources.dimen.dp4,
        ),
        Align(
          alignment: Alignment.center,
          child: TextFormField(
            readOnly: !isEnabled,
            maxLines: maxLines,
            maxLength: maxLength,
            keyboardType: textInputType,
            inputFormatters: textInputType == TextInputType.number
                ? [FilteringTextInputFormatter.digitsOnly]
                : null,
            obscureText:
                textInputType == TextInputType.visiblePassword ? true : false,
            textInputAction: textInputAction,
            controller: textController,
            textAlignVertical: TextAlignVertical.center,
            focusNode: focusNode,
            autovalidateMode: autovalidateMode,
            validator: (value) {
              if (isValid != null) {
                return isValid?.call(value ?? '');
              } else if (errorMessage.isNotEmpty &&
                  (value == null ||
                      value.trim().isEmpty ||
                      value.trim().length < maxLengthValidation ||
                      !RegExp(regex ?? '').hasMatch(value))) {
                return errorMessage.isNotEmpty ? errorMessage : null;
              }
              return null;
            },
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              isDense: true,
              counterText: '',
              contentPadding: EdgeInsets.symmetric(
                  vertical: context.resources.dimen.dp10,
                  horizontal: context.resources.dimen.dp10),
              hintText: hintText,
              hintStyle: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)
                  .onFontFamily(
                      fontFamily: context.resources.isLocalEn
                          ? fontFamilyEN
                          : fontFamilyAR)
                  .onColor(context.resources.color.colorD6D6D6),
              suffixIconConstraints:
                  BoxConstraints(maxHeight: height, minHeight: height),
              suffixIcon: (suffixIconPath ?? '').isNotEmpty
                  ? InkWell(
                      onTap: () {
                        suffixIconClick?.call();
                      },
                      child: Padding(
                        padding: context.resources.isLocalEn
                            ? const EdgeInsets.only(right: 15.0)
                            : const EdgeInsets.only(left: 15.0),
                        child: ImageWidget(
                          path: suffixIconPath ?? '',
                        ).loadImage,
                      ),
                    )
                  : null,
              fillColor: isEnabled
                  ? (fillColor ?? context.resources.color.textFieldFillColor)
                  : context.resources.color.dividerColorB3B8BF,
              border: OutlineInputBorder(
                borderSide: borderSide,
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius ?? context.resources.dimen.dp10),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: borderSide,
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius ?? context.resources.dimen.dp10),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: borderSide,
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius ?? context.resources.dimen.dp10),
                ),
              ),
              errorStyle: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            style: fontFamily.isNotEmpty
                ? context.textFontWeight400
                    .onFontFamily(fontFamily: fontFamily)
                    .onFontSize(context.resources.fontSize.dp12)
                : context.textFontWeight400
                    .onFontSize(context.resources.fontSize.dp12),
          ),
        ),
      ],
    );
  }
}
