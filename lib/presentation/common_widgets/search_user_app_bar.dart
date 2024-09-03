import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/search_textfield_widget.dart';
import 'package:ithelpdesk/res/drawables/drawable_assets.dart';

import '../requests/view_request.dart';

class SearchUserAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String userName;
  final EdgeInsets? padding;
  final Function(AppBarItem)? onItemTap;
  SearchUserAppBarWidget(
      {required this.userName, this.padding, this.onItemTap, super.key});
  final ValueNotifier _isAvailable = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(child: SearchDropDownWidget(
                onSearchItemSelected: (item) {
                  ViewRequest.start(context, item);
                },
              )),
              SizedBox(
                width: screenSize.width * .10,
              ),
              ValueListenableBuilder(
                  valueListenable: _isAvailable,
                  builder: (context, value, child) {
                    return Tooltip(
                      message: resources.string.vacation,
                      child: Switch(
                          activeColor: resources.color.viewBgColor,
                          value: value,
                          onChanged: (value) {
                            _isAvailable.value = value;
                          }),
                    );
                  }),
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
              InkWell(
                onTap: () {
                  onItemTap?.call(AppBarItem.user);
                },
                child: Tooltip(
                  message: resources.string.userProfile,
                  child: ImageWidget(
                          path: DrawableAssets.icUserCircle,
                          width: 20,
                          height: 20,
                          backgroundTint: resources.color.textColorLight,
                          padding: EdgeInsets.all(resources.dimen.dp10))
                      .loadImageWithMoreTapArea,
                ),
              ),
              Text(userName,
                  style: context.textFontWeight600
                      .onFontSize(resources.fontSize.dp12)
                      .onColor(resources.color.textColorLight))
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
