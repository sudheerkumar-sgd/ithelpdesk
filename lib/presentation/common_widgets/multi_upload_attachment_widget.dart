// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/domain/entities/request_form_entities.dart';
import 'package:ithelpdesk/presentation/common_widgets/dialog_upload_attachment.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/item_attachment.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';
import 'package:ithelpdesk/res/drawables/drawable_assets.dart';

const double defaultHeight = 27;

class MultiUploadAttachmentWidget extends StatelessWidget {
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
  final BorderSide borderSide;
  final Color? fillColor;
  final double? borderRadius;
  final Function(UploadResponseEntity?)? onSelected;
  final Function? suffixIconClick;
  final UploadOptions? fileType;
  final List<String> allowedExtensions;
  final int maxSize;
  UploadResponseEntity? selectedFileData;
  MultiUploadAttachmentWidget(
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
      this.borderRadius,
      this.onSelected,
      this.suffixIconClick,
      this.fileType,
      this.allowedExtensions = const [],
      this.selectedFileData,
      this.maxSize = 1,
      super.key});
  final ValueNotifier<bool> _isUploadChanged = ValueNotifier(false);
  final _uploadFiles = [];
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
        _uploadFiles.add(value);
        _isUploadChanged.value = !_isUploadChanged.value;
      }
    });
  }

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
        ValueListenableBuilder(
            valueListenable: _isUploadChanged,
            builder: (context, isChanged, widget) {
              return InkWell(
                onTap: () {
                  if (isEnabled) {
                    _showSelectFileOptions(context, 1);
                  }
                },
                child: Row(
                  children: [
                    ValueListenableBuilder(
                        valueListenable: _isUploadChanged,
                        builder: (context, isChanged, widget) {
                          return Expanded(
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: context.resources.dimen.dp10,
                                  top: context.resources.dimen.dp5,
                                  right: context.resources.dimen.dp15,
                                  bottom: context.resources.dimen.dp5),
                              decoration: BackgroundBoxDecoration(
                                      boxColor:
                                          context.resources.color.colorWhite,
                                      radious: 0,
                                      boarderColor: context.resources.color
                                          .sideBarItemUnselected,
                                      boarderWidth: 1)
                                  .roundedCornerBox,
                              child: _uploadFiles.isNotEmpty
                                  ? Wrap(
                                      runSpacing: context.resources.dimen.dp10,
                                      spacing: context.resources.dimen.dp10,
                                      children: List.generate(
                                          _uploadFiles.length,
                                          (index) => ItemAttachment(
                                                id: index,
                                                wrapContent: true,
                                                name: _uploadFiles[index]
                                                    ['fileName'],
                                                callBack: (value) {
                                                  _uploadFiles.removeAt(value);
                                                  _isUploadChanged.value =
                                                      !_isUploadChanged.value;
                                                },
                                              )),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        _showSelectFileOptions(context, 1);
                                      },
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: context.resources.dimen.dp5,
                                          ),
                                          Expanded(
                                            child: Text(
                                              context
                                                  .resources.string.uploadFile,
                                              style: context.textFontWeight400
                                                  .onFontSize(context
                                                      .resources.fontSize.dp12)
                                                  .onColor(context.resources
                                                      .color.colorD6D6D6)
                                                  .onFontFamily(
                                                      fontFamily:
                                                          isSelectedLocalEn
                                                              ? fontFamilyEN
                                                              : fontFamilyAR)
                                                  .copyWith(height: 1),
                                            ),
                                          ),
                                          SizedBox(
                                            width: context.resources.dimen.dp10,
                                          ),
                                          ImageWidget(
                                                  width: 13,
                                                  height: 13,
                                                  path: DrawableAssets.icUpload,
                                                  backgroundTint: context
                                                      .resources
                                                      .color
                                                      .viewBgColor)
                                              .loadImage,
                                        ],
                                      ),
                                    ),
                            ),
                          );
                        }),
                    SizedBox(
                      width: context.resources.dimen.dp10,
                    ),
                    InkWell(
                      onTap: () {
                        _showSelectFileOptions(context, 1);
                      },
                      child: ImageWidget(
                              width: 36,
                              height: 36,
                              path: DrawableAssets.icPlusCircle,
                              backgroundTint:
                                  context.resources.color.viewBgColor)
                          .loadImage,
                    ),
                  ],
                ),
              );
            }),
      ],
    );
  }
}
