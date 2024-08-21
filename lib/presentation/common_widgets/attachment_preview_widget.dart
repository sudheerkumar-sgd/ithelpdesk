import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'image_widget.dart';

class AttachmentPreviewWidget extends StatelessWidget {
  final String fileName;
  const AttachmentPreviewWidget({required this.fileName, super.key});

  @override
  Widget build(BuildContext context) {
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
