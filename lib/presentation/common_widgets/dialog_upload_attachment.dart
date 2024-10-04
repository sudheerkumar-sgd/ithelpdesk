import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/constants/data_constants.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/alert_dialog_widget.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';
import '../../../../res/drawables/background_box_decoration.dart';

enum UploadOptions { any, takephoto, image, file }

class DialogUploadAttachmentWidget extends StatelessWidget {
  final UploadOptions fileType;
  final List<String> allowedExtensions;
  final int maxSize;
  const DialogUploadAttachmentWidget(
      {this.fileType = UploadOptions.any,
      this.allowedExtensions = const [],
      this.maxSize = 5,
      super.key});

  _getFile(BuildContext context, UploadOptions selectedOption) async {
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
    // } else {
    //   try {
    //     final ImagePicker picker = ImagePicker();
    //     final XFile? pickedFile = await picker.pickImage(
    //       source: selectedOption == UploadOptions.takephoto
    //           ? ImageSource.camera
    //           : ImageSource.gallery,
    //       maxWidth: 1024,
    //       maxHeight: 1024,
    //     );
    //     fileName = pickedFile?.name ?? '';
    //     filePath = pickedFile?.path ?? '';
    //   } catch (e) {
    //     printLog(e.toString());
    //   }
    // }
    if (filePath.isNotEmpty) {
      File file = File(filePath);
      if (file.lengthSync() <= maxSize * maxUploadFilesize) {
        final bytes = file.readAsBytesSync();
        final data = {
          'fileName': fileName,
          'fileType': fileName.substring(
              fileName.lastIndexOf('.') == -1 ? 0 : fileName.lastIndexOf('.')),
          'fileNamebase64data': base64.encode(bytes),
        };
        if (context.mounted) {
          Navigator.pop(context, data);
        }
      } else if (context.mounted) {
        Dialogs.showInfoDialog(context, PopupType.fail,
            "Upload file should not be more then $maxSize mb");
      }
    } else if (fileBytes?.isNotEmpty == true) {
      if ((fileBytes?.lengthInBytes ?? 0) <= maxSize * maxUploadFilesize) {
        final data = {
          'fileName': fileName,
          'fileType': fileName.substring(
              fileName.lastIndexOf('.') == -1 ? 0 : fileName.lastIndexOf('.')),
          'fileNamebase64data': base64.encode(fileBytes!),
        };
        if (context.mounted) {
          Navigator.pop(context, data);
        }
      } else if (context.mounted) {
        Dialogs.showInfoDialog(context, PopupType.fail,
            "Upload file should not be more then $maxSize mb");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (fileType == UploadOptions.any ||
            fileType == UploadOptions.takephoto)
          InkWell(
            onTap: () {
              _getFile(context, UploadOptions.takephoto);
            },
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(
                  horizontal: context.resources.dimen.dp30,
                  vertical: context.resources.dimen.dp5),
              padding: EdgeInsets.symmetric(
                  vertical: context.resources.dimen.dp15,
                  horizontal: context.resources.dimen.dp10),
              decoration: BackgroundBoxDecoration(
                boxColor: context.resources.color.colorWhite,
                radious: context.resources.dimen.dp15,
              ).roundedCornerBox,
              child: Text(
                'Take Photo',
                textAlign: TextAlign.center,
                style: context.textFontWeight600,
              ),
            ),
          ),
        if (fileType == UploadOptions.any || fileType == UploadOptions.image)
          InkWell(
            onTap: () {
              _getFile(context, UploadOptions.image);
            },
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(
                  horizontal: context.resources.dimen.dp30,
                  vertical: context.resources.dimen.dp5),
              padding: EdgeInsets.symmetric(
                  vertical: context.resources.dimen.dp15,
                  horizontal: context.resources.dimen.dp10),
              decoration: BackgroundBoxDecoration(
                boxColor: context.resources.color.colorWhite,
                radious: context.resources.dimen.dp15,
              ).roundedCornerBox,
              child: Text(
                'Upload Image',
                textAlign: TextAlign.center,
                style: context.textFontWeight600,
              ),
            ),
          ),
        if (fileType == UploadOptions.any || fileType == UploadOptions.file)
          InkWell(
            onTap: () {
              _getFile(context, UploadOptions.file);
            },
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(
                  horizontal: context.resources.dimen.dp30,
                  vertical: context.resources.dimen.dp5),
              padding: EdgeInsets.symmetric(
                  vertical: context.resources.dimen.dp15,
                  horizontal: context.resources.dimen.dp10),
              decoration: BackgroundBoxDecoration(
                boxColor: context.resources.color.colorWhite,
                radious: context.resources.dimen.dp15,
              ).roundedCornerBox,
              child: Text(
                'Upload File',
                textAlign: TextAlign.center,
                style: context.textFontWeight600,
              ),
            ),
          ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(
                left: context.resources.dimen.dp30,
                top: context.resources.dimen.dp5,
                right: context.resources.dimen.dp30,
                bottom: context.resources.dimen.dp20),
            padding: EdgeInsets.symmetric(
                vertical: context.resources.dimen.dp15,
                horizontal: context.resources.dimen.dp10),
            decoration: BackgroundBoxDecoration(
              boxColor: context.resources.color.colorWhite,
              radious: context.resources.dimen.dp15,
            ).roundedCornerBox,
            child: Text(
              'Cancel',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: context.textFontWeight600
                  .onColor(context.resources.color.colorBlue356DCE),
            ),
          ),
        ),
      ],
    );
  }
}
