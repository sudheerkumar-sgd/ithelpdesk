import 'package:flutter/material.dart';
import 'package:smartuaq/core/common/common_utils.dart';
import 'package:smartuaq/core/constants/constants.dart';
import 'package:smartuaq/core/extensions/build_context_extension.dart';
import 'package:smartuaq/core/extensions/string_extension.dart';
import 'package:smartuaq/core/extensions/text_style_extension.dart';
import 'package:smartuaq/presentation/common_widgets/image_widget.dart';
import 'package:smartuaq/res/drawables/drawable_assets.dart';

class UserAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final String wish;
  final String title;
  final bool showSearch;
  final EdgeInsets padding;
  const UserAppBarWidget(
      {this.wish = '',
      required this.title,
      this.showSearch = false,
      this.padding = const EdgeInsets.all(0),
      super.key});

  @override
  State<UserAppBarWidget> createState() => _UserAppBarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class _UserAppBarWidgetState extends State<UserAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.wish.isNotEmpty) ...[
                  Text(
                    widget.wish,
                    style: context.textFontWeight400
                        .onColor(context.resources.color.viewBgColor)
                        .copyWith(height: 1),
                  ),
                ],
                Expanded(
                  child: Text(
                    widget.title.trim().capitalize(),
                    overflow: TextOverflow.clip,
                    maxLines: 2,
                    style: context.textFontWeight600
                        .onColor(context.resources.color.viewBgColor)
                        .onFontSize(widget.wish.isNotEmpty
                            ? context.resources.fontSize.dp14
                            : context.resources.fontSize.dp16)
                        .copyWith(height: widget.wish.isNotEmpty ? 1 : 1.2),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: context.resources.dimen.dp5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.showSearch) ...[
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(context.resources.dimen.dp5),
                    child: ImageWidget(
                      path: DrawableAssets.icSearch,
                    ).loadImage,
                  ),
                ),
                SizedBox(
                  width: context.resources.dimen.dp5,
                ),
              ],
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
                  if (userToken.isNotEmpty) {
                  } else {
                    logout(context);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(context.resources.dimen.dp5),
                  child: ImageWidget(
                          path: userToken.isNotEmpty
                              ? DrawableAssets.icUserCircle
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
              //     onTap: () {
              //       NotificationsScreen.start(context);
              //     },
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
          )
        ],
      ),
    );
  }
}
