// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:smartuaq/core/constants/constants.dart';
import 'package:smartuaq/core/extensions/build_context_extension.dart';
import 'package:smartuaq/core/extensions/text_style_extension.dart';
import 'package:smartuaq/domain/entities/request_form_entities.dart';
import 'package:smartuaq/presentation/common_widgets/dialog_upload_attachment.dart';
import 'package:smartuaq/presentation/common_widgets/image_widget.dart';
import 'package:smartuaq/presentation/utils/dialogs.dart';
import 'package:smartuaq/res/drawables/drawable_assets.dart';

const double defaultHeight = 27;

class UploadAttachmentWidget extends StatelessWidget {
  final double height;
  final bool isEnabled;
  final String labelText;
  final String hintText;
  final String errorMessage;
  final String? suffixIconPath;
  final int maxLengthValidation;
  final String fontFamily;
  final FocusNode? focusNode;
  final bool isMandetory;
  final TextEditingController textController = TextEditingController();
  final BorderSide borderSide;
  final Color? fillColor;
  final Function(UploadResponseEntity?)? onSelected;
  final Function? suffixIconClick;
  final UploadOptions? fileType;
  final List<String> allowedExtensions;
  final int maxSize;
  UploadResponseEntity? selectedFileData;
  UploadAttachmentWidget(
      {this.height = defaultHeight,
      this.isEnabled = true,
      this.labelText = '',
      this.hintText = '',
      this.errorMessage = '',
      this.suffixIconPath = DrawableAssets.icUpload,
      this.maxLengthValidation = 0,
      this.fontFamily = '',
      this.focusNode,
      this.isMandetory = false,
      this.fillColor,
      this.borderSide = BorderSide.none,
      this.onSelected,
      this.suffixIconClick,
      this.fileType,
      this.allowedExtensions = const [],
      this.selectedFileData,
      this.maxSize = 1,
      super.key});
  final ValueNotifier<bool> _isUploadChanged = ValueNotifier(false);
  Future<void> _showSelectFileOptions(BuildContext context, int from) async {
    Dialogs.showBottomSheetDialogTransperrent(
        context,
        DialogUploadAttachmentWidget(
          fileType: fileType ?? UploadOptions.any,
          allowedExtensions: allowedExtensions,
          maxSize: maxSize,
        ), callback: (value) {
      if (value != null) {
        selectedFileData ??= UploadResponseEntity();
        selectedFileData?.documentData =
            'data:image/png;base64,${value['fileNamebase64data']}';
        selectedFileData?.documentName = value['fileName'];
        onSelected?.call(selectedFileData);
        textController.text = value['fileName'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    textController.text = selectedFileData?.documentName ?? '';
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
        ValueListenableBuilder(
            valueListenable: _isUploadChanged,
            builder: (context, isChanged, widget) {
              return InkWell(
                onTap: () {
                  if (isEnabled) {
                    _showSelectFileOptions(context, 1);
                  }
                },
                child: TextFormField(
                  enabled: false,
                  controller: textController,
                  textAlignVertical: TextAlignVertical.center,
                  focusNode: focusNode,
                  validator: (value) {
                    if (errorMessage.isNotEmpty &&
                        (value == null ||
                            value.isEmpty ||
                            value.length < maxLengthValidation)) {
                      return errorMessage.isNotEmpty ? errorMessage : null;
                    }
                    return null;
                  },
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
                    fillColor:
                        fillColor ?? context.resources.color.textFieldFillColor,
                    border: OutlineInputBorder(
                      borderSide: borderSide,
                      borderRadius: BorderRadius.all(
                        Radius.circular(context.resources.dimen.dp10),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: borderSide,
                      borderRadius: BorderRadius.all(
                        Radius.circular(context.resources.dimen.dp10),
                      ),
                    ),
                    errorStyle: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  style: fontFamily.isNotEmpty
                      ? context.textFontWeight400
                          .onFontFamily(fontFamily: fontFamilyEN)
                          .onFontSize(context.resources.fontSize.dp12)
                      : context.textFontWeight400
                          .onFontSize(context.resources.fontSize.dp12),
                ),
              );
            }),
      ],
    );
  }
}
