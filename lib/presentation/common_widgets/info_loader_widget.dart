import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';

class InfoLoaderWidget extends StatelessWidget {
  final String message;
  const InfoLoaderWidget({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(context.resources.dimen.dp15))),
      insetPadding: EdgeInsets.symmetric(
          horizontal: getScrrenSize(context).width * 0.30,
          vertical: context.resources.dimen.dp20),
      child: Padding(
        padding: EdgeInsets.all(context.resources.dimen.dp20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
              child: SizedBox(
                  width: 40, height: 40, child: CircularProgressIndicator()),
            ),
            SizedBox(
              height: context.resources.dimen.dp20,
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12),
            ),
          ],
        ),
      ),
    );
  }
}
