import 'package:flutter/material.dart';
import 'package:smartuaq/core/common/common_utils.dart';
import 'package:smartuaq/core/constants/constants.dart';
import 'package:smartuaq/core/extensions/build_context_extension.dart';
import 'package:smartuaq/core/extensions/text_style_extension.dart';
import 'package:smartuaq/presentation/common_widgets/image_widget.dart';
import 'package:smartuaq/res/drawables/drawable_assets.dart';

class BackAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final EdgeInsets padding;
  final bool isProfileScreen;
  final Function? onBackPressed;
  const BackAppBarWidget(
      {required this.title,
      this.padding = const EdgeInsets.all(0),
      this.isProfileScreen = false,
      this.onBackPressed,
      super.key});

  @override
  State<BackAppBarWidget> createState() => _BackAppBarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class _BackAppBarWidgetState extends State<BackAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return Container(
      padding: widget.padding,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              widget.onBackPressed != null
                  ? widget.onBackPressed?.call()
                  : Navigator.pop(context);
            },
            child: ImageWidget(
              path: DrawableAssets.icArrowLeft,
              boxType: BoxFit.none,
              isLocalEn: resources.isLocalEn,
            ).loadImage,
          ),
          SizedBox(
            width: resources.dimen.dp10,
          ),
          Expanded(
              child: Text(
            widget.title,
            overflow: TextOverflow.clip,
            maxLines: 2,
            style: context.textFontWeight600
                .onColor(resources.color.viewBgColor)
                .onFontSize(resources.fontSize.dp16)
                .onHeight(1.2),
          )),
          Align(
            alignment: Alignment.center,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    context.resources.setLocal();
                  },
                  child: Container(
                    padding: EdgeInsets.all(context.resources.dimen.dp5),
                    child: ImageWidget(
                            path: context.resources.isLocalEn
                                ? DrawableAssets.icLangAr
                                : DrawableAssets.icLangEn,
                            colorFilter: ColorFilter.mode(
                                context.resources.color.textColor,
                                BlendMode.srcIn))
                        .loadImage,
                  ),
                ),
                SizedBox(
                  width: context.resources.dimen.dp5,
                ),
                InkWell(
                  onTap: () {
                    if (userToken.isNotEmpty && !widget.isProfileScreen) {
                    } else {
                      logout(context);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(context.resources.dimen.dp5),
                    child: ImageWidget(
                            path: userToken.isNotEmpty
                                ? (widget.isProfileScreen
                                    ? DrawableAssets.icLogout
                                    : DrawableAssets.icUserCircle)
                                : DrawableAssets.icLogin,
                            colorFilter: ColorFilter.mode(
                                context.resources.color.textColor,
                                BlendMode.srcIn))
                        .loadImage,
                  ),
                ),
                // if (userToken.isNotEmpty) ...[
                //   SizedBox(
                //     width: context.resources.dimen.dp5,
                //   ),
                //   InkWell(
                //     onTap: () {},
                //     child: Container(
                //       padding: EdgeInsets.all(context.resources.dimen.dp5),
                //       child: ImageWidget(
                //               path: DrawableAssets.icNotification,
                //               colorFilter: ColorFilter.mode(
                //                   context.resources.color.textColor,
                //                   BlendMode.srcIn))
                //           .loadImage,
                //     ),
                //   ),
                // ]
              ],
            ),
          )
        ],
      ),
    );
  }
}
