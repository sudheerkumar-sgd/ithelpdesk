// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/constants/data_constants.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/alert_dialog_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dialog_upload_attachment.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/item_attachment.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';
import 'package:ithelpdesk/res/drawables/drawable_assets.dart';

import '../../domain/entities/master_data_entities.dart';

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
      this.maxSize = 5,
      super.key});
  final ValueNotifier<bool> _isUploadChanged = ValueNotifier(false);
  final _uploadFiles = List<Map>.empty(growable: true);
  Future<void> _showSelectFileOptions(BuildContext context, int from) async {
    final value = await _getFile(context, UploadOptions.file);
    if (value != null) {
      selectedFileData ??= UploadResponseEntity();
      selectedFileData?.documentData =
          'data:image/png;base64,${value['fileNamebase64data']}';
      selectedFileData?.documentName = value['fileName'];
      onSelected?.call(selectedFileData);
      _uploadFiles.add(value);
      _isUploadChanged.value = !_isUploadChanged.value;
    }
  }

  Future<Map<String, dynamic>?> _getFile(
      BuildContext context, UploadOptions selectedOption) async {
    String fileName = '';
    String filePath = '';
    Uint8List? fileBytes;
    // if (selectedOption == UploadOptions.file) {
    FilePickerResult? result;
    if (allowedExtensions.isNotEmpty) {
      result = await FilePicker.platform.pickFiles(
          type: FileType.custom, allowedExtensions: allowedExtensions);
    } else {
      result = await FilePicker.platform.pickFiles();
    }
    if (result != null) {
      fileName = result.files.first.name;
      if (!kIsWeb) {
        filePath = result.files.first.path ?? '';
      } else {
        fileBytes = result.files.first.bytes;
      }
    }
    if (filePath.isNotEmpty) {
      File file = File(filePath);
      if (file.lengthSync() <= maxSize * maxUploadFilesize) {
        //final bytes = file.readAsBytesSync();
        return {
          'filePath': filePath,
          'fileName': fileName,
          'fileType': fileName.substring(
              fileName.lastIndexOf('.') == -1 ? 0 : fileName.lastIndexOf('.')),
        };
      } else if (context.mounted) {
        Dialogs.showInfoDialog(context, PopupType.fail,
            "Upload file should not be more then $maxSize mb");
      }
    } else if (fileBytes?.isNotEmpty == true) {
      if ((fileBytes?.lengthInBytes ?? 0) <= maxSize * maxUploadFilesize) {
        return {
          'fileBytes': fileBytes,
          'filePath': filePath,
          'fileName': fileName,
          'fileType': fileName.substring(
              fileName.lastIndexOf('.') == -1 ? 0 : fileName.lastIndexOf('.')),
        };
      } else if (context.mounted) {
        Dialogs.showInfoDialog(context, PopupType.fail,
            "Upload file should not be more then $maxSize mb");
      }
    }

    return null;
  }

  List<Map> getSelectedFilesData() {
    return _uploadFiles;
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
