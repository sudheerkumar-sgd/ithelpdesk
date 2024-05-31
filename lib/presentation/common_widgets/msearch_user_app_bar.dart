import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/search_textfield_widget.dart';
import 'package:ithelpdesk/res/drawables/drawable_assets.dart';

class MSearchUserAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String userName;
  final EdgeInsets? padding;
  static final _formKey = GlobalKey<FormState>();
  const MSearchUserAppBarWidget(
      {required this.userName, this.padding, super.key});

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
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
              SizedBox(
                width: resources.dimen.dp10,
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: const SearchTextfieldWidget(
                    prefixIconPath: DrawableAssets.icSearch,
                  ),
                ),
              ),
              SizedBox(
                width: resources.dimen.dp10,
              ),
              ImageWidget(
                      path: DrawableAssets.icNotification,
                      width: 20,
                      height: 20,
                      padding: EdgeInsets.all(resources.dimen.dp10))
                  .loadImageWithMoreTapArea,
              ImageWidget(
                      path: DrawableAssets.icUserCircle,
                      width: 20,
                      height: 20,
                      backgroundTint: resources.color.textColorLight,
                      padding: EdgeInsets.all(resources.dimen.dp10))
                  .loadImageWithMoreTapArea,
              // Text(userName,
              //     style: context.textFontWeight600
              //         .onFontSize(resources.fontSize.dp12)
              //         .onColor(resources.color.textColorLight))
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
