import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';
import 'package:ithelpdesk/res/drawables/drawable_assets.dart';

class ItemAttachment extends StatelessWidget {
  final String name;
  final int id;
  final Function(int)? callBack;

  const ItemAttachment(
      {this.id = 0, required this.name, this.callBack, super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BackgroundBoxDecoration(
              boarderColor: context.resources.color.bottomSheetIconUnSelected)
          .roundedCornerBox,
      child: Row(
        children: [
          SizedBox(
            width: context.resources.dimen.dp5,
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 3.0),
              child: Text(
                name,
                style: context.textFontWeight400
                    .onFontSize(context.resources.fontSize.dp12)
                    .onFontFamily(fontFamily: fontFamilyEN)
                    .copyWith(height: 1),
              ),
            ),
          ),
          SizedBox(
            width: context.resources.dimen.dp10,
          ),
          InkWell(
            onTap: () {
              callBack!(id);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ImageWidget(
                      width: 13, height: 13, path: DrawableAssets.icClose)
                  .loadImage,
            ),
          ),
        ],
      ),
    );
  }
}
