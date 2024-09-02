import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'image_widget.dart';
import 'dart:html' as html;

class AttachmentPreviewWidget extends StatelessWidget {
  final String fileName;
  const AttachmentPreviewWidget({required this.fileName, super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (fileName.contains('.pdf')) {
        Navigator.pop(context);
        html.window.open('$getImageBaseUrl$fileName', '_blank');
      }
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        fileName.contains('.pdf')
            ? SfPdfViewer.network(
                '$getImageBaseUrl$fileName',
              )
            : ImageWidget(path: '$getImageBaseUrl$fileName').loadImage,
      ],
    );
  }
}
