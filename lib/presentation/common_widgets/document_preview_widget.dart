import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:smartuaq/core/common/file_utils.dart';
import 'package:smartuaq/core/extensions/build_context_extension.dart';
import 'package:smartuaq/core/extensions/text_style_extension.dart';
import 'package:smartuaq/presentation/common_widgets/alert_dialog_widget.dart';
import 'package:smartuaq/presentation/utils/dialogs.dart';
import 'package:smartuaq/res/drawables/background_box_decoration.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:share_plus/share_plus.dart';

class DocumentPreviewWidget extends StatelessWidget {
  static String base64DataTemp = '';
  final String base64Data;
  final String fileName;
  const DocumentPreviewWidget(
      {required this.base64Data, required this.fileName, super.key});
  void _onShareXFile(BuildContext context, Uint8List fileData) async {
    final box = context.findRenderObject() as RenderBox?;
    final path = await FileUtiles.createCacheFileFromBase64Data(
      fileData,
      fileName: fileName,
    );
    Share.shareXFiles(
      [
        XFile(
          path,
          name: '$fileName.pdf',
          mimeType: 'application/pdf',
        ),
      ],
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    base64DataTemp = base64Data;
    final fileData = base64.decode(base64Data.replaceAll(RegExp(r'\s+'), ''));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                _onShareXFile(context, fileData);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: resources.dimen.dp2,
                    horizontal: resources.dimen.dp20),
                decoration: BackgroundBoxDecoration(
                        boxColor: resources.color.viewBgColor,
                        radious: resources.dimen.dp10)
                    .roundedCornerBox,
                child: Text(
                  resources.string.share,
                  textAlign: TextAlign.center,
                  style: context.textFontWeight400
                      .onFontSize(resources.fontSize.dp12)
                      .onColor(resources.color.colorWhite),
                ),
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () async {
                Dialogs.loader(context);
                final path = await FileUtiles.saveFileToFolder(fileData,
                    fileName: fileName, fileType: 'application/pdf');
                if (context.mounted) {
                  Navigator.of(context, rootNavigator: true).pop();
                  if (path.isNotEmpty) {
                    Dialogs.showInfoDialog(context, PopupType.success,
                        resources.string.documentSuccessfullySaved);
                  }
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: resources.dimen.dp2,
                    horizontal: resources.dimen.dp15),
                decoration: BackgroundBoxDecoration(
                        boxColor: resources.color.viewBgColor,
                        radious: resources.dimen.dp10)
                    .roundedCornerBox,
                child: Text(
                  resources.string.download,
                  textAlign: TextAlign.center,
                  style: context.textFontWeight400
                      .onFontSize(resources.fontSize.dp12)
                      .onColor(resources.color.colorWhite),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: resources.dimen.dp20,
        ),
        Expanded(
          child: Container(
            decoration: BackgroundBoxDecoration(
                    boxColor: resources.color.colorWhite,
                    radious: resources.dimen.dp15,
                    shadowBlurRadius: resources.dimen.dp10,
                    shadowColor: resources.color.dividerColorB3B8BF)
                .roundedCornerBoxWithShadow,
            child: ClipRRect(
              borderRadius:
                  BorderRadius.all(Radius.circular(resources.dimen.dp10)),
              child: SfPdfViewer.memory(
                fileData,
                canShowSignaturePadDialog: false,
                canShowHyperlinkDialog: false,
              ),
            ),
          ),
        )
      ],
    );
  }
}
