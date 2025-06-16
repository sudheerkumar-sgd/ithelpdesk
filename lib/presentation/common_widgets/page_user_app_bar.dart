import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';
import 'package:ithelpdesk/res/drawables/drawable_assets.dart';

import '../../core/constants/constants.dart';

class PageUserAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String userName;
  final EdgeInsets? padding;
  const PageUserAppBarWidget({required this.userName, this.padding, super.key});

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              SizedBox(
                height: 40,
                child: InkWell(
                  hoverColor: Colors.transparent,
                  onTap: () {},
                  child: ImageWidget(
                    path: DrawableAssets.icLogo,
                  ).loadImage,
                ),
              ),
              SizedBox(
                width: resources.dimen.dp10,
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  resources.setLocal(language: isSelectedLocalEn ? 'ar' : 'en');
                },
                child: Tooltip(
                  message: resources.string.language,
                  child: ImageWidget(
                          path: isSelectedLocalEn
                              ? DrawableAssets.icLangAr
                              : DrawableAssets.icLangEn,
                          width: 20,
                          height: 20,
                          padding: EdgeInsets.all(resources.dimen.dp10))
                      .loadImageWithMoreTapArea,
                ),
              ),
              Tooltip(
                message: resources.string.userProfile,
                child: ImageWidget(
                        path: DrawableAssets.icUserCircle,
                        width: 20,
                        height: 20,
                        backgroundTint: resources.color.textColorLight,
                        padding: EdgeInsets.all(resources.dimen.dp10))
                    .loadImageWithMoreTapArea,
              ),
              // Text(userName,
              //     style: context.textFontWeight600
              //         .onFontSize(resources.fontSize.dp12)
              //         .onColor(resources.color.textColorLight))
              SizedBox(
                width: resources.dimen.dp20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
