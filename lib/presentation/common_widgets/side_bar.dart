import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/domain/entities/user_credentials_entity.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';
import 'package:ithelpdesk/res/drawables/drawable_assets.dart';

class SideBar extends StatelessWidget {
  final int seletedItem;
  final Function(int) onItemSelected;
  SideBar({required this.onItemSelected, this.seletedItem = 0, super.key});
  final ValueNotifier _selectedIndex = ValueNotifier(0);
  final ValueNotifier _onCRClick = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    _selectedIndex.value = seletedItem;
    return Drawer(
        backgroundColor: resources.color.colorWhite,
        elevation: 1,
        child: ValueListenableBuilder(
            valueListenable: _selectedIndex,
            builder: (context, index, child) {
              return ListView(children: <Widget>[
                SizedBox(
                  height: resources.dimen.dp20,
                ),
                SizedBox(
                  height: 50,
                  child: InkWell(
                    onTap: () {
                      _selectedIndex.value = 0;
                      onItemSelected(0);
                    },
                    child: ImageWidget(
                            path: DrawableAssets.icLogo,
                            padding: const EdgeInsets.symmetric(horizontal: 20))
                        .loadImageWithMoreTapArea,
                  ),
                ),
                SizedBox(
                  height: resources.dimen.dp20,
                ),
                if (UserCredentialsEntity.details().userType?.isAdmin() ??
                    false) ...[
                  ListTile(
                    onTap: () {
                      _selectedIndex.value = 5;
                      onItemSelected(5);
                    },
                    leading: SizedBox(
                      width: 40,
                      height: 40,
                      child: ImageWidget(
                              path: DrawableAssets.icHome,
                              backgroundTint: index == 5
                                  ? resources.color.sideBarItemSelected
                                  : resources.color.sideBarItemUnselected,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5))
                          .loadImageWithMoreTapArea,
                    ),
                    title: Text(
                      isSelectedLocalEn ? 'Dashboard' : 'لوحة القيادة',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textFontWeight600
                          .onFontSize(resources.fontSize.dp12),
                    ),
                  ),
                  SizedBox(
                    height: resources.dimen.dp10,
                  ),
                ],
                if (UserCredentialsEntity.details().userType !=
                    UserType.superAdmin) ...[
                  ListTile(
                    onTap: () {
                      _selectedIndex.value = 0;
                      onItemSelected(0);
                    },
                    selected: true,
                    leading: SizedBox(
                      width: 40,
                      height: 40,
                      child: ImageWidget(
                              path: DrawableAssets.icHome,
                              backgroundTint: index == 0
                                  ? resources.color.sideBarItemSelected
                                  : resources.color.sideBarItemUnselected,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5))
                          .loadImageWithMoreTapArea,
                    ),
                    title: Text(
                      resources.string.home,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textFontWeight600
                          .onFontSize(resources.fontSize.dp12),
                    ),
                  ),
                  SizedBox(
                    height: resources.dimen.dp10,
                  )
                ],
                ListTile(
                  onTap: () {
                    _selectedIndex.value = 1;
                    onItemSelected(1);
                  },
                  leading: SizedBox(
                    width: 40,
                    height: 40,
                    child: ImageWidget(
                            path: DrawableAssets.icReport,
                            backgroundTint: index == 1
                                ? resources.color.sideBarItemSelected
                                : resources.color.sideBarItemUnselected,
                            padding: const EdgeInsets.symmetric(horizontal: 5))
                        .loadImageWithMoreTapArea,
                  ),
                  title: Text(
                    resources.string.report,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textFontWeight600
                        .onFontSize(resources.fontSize.dp12),
                  ),
                ),
                if (UserCredentialsEntity.details().isoUser == true) ...[
                  SizedBox(
                    height: resources.dimen.dp10,
                  ),
                  ListTile(
                    onTap: () {
                      _selectedIndex.value = 2;
                      onItemSelected(2);
                    },
                    leading: SizedBox(
                      width: 40,
                      height: 40,
                      child: ImageWidget(
                              path: DrawableAssets.icReport,
                              backgroundTint: index == 2
                                  ? resources.color.sideBarItemSelected
                                  : resources.color.sideBarItemUnselected,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5))
                          .loadImageWithMoreTapArea,
                    ),
                    title: Text(
                      isSelectedLocalEn ? 'IT ISO Requests' : 'คำขอ ISO IT',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textFontWeight600
                          .onFontSize(resources.fontSize.dp12),
                    ),
                  )
                ],
                // ValueListenableBuilder(
                //     valueListenable: _onCRClick,
                //     builder: (context, onCRClick, child) {
                //       return onCRClick
                //           ? ListTile(
                //               leading: const SizedBox(),
                //               title: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   InkWell(
                //                     onTap: () {
                //                       onItemSelected(2);
                //                     },
                //                     child: Padding(
                //                       padding: const EdgeInsets.symmetric(
                //                           vertical: 5.0),
                //                       child: Text(
                //                         'ISO - System',
                //                         style: context.textFontWeight600,
                //                       ),
                //                     ),
                //                   ),
                //                   InkWell(
                //                       onTap: () {},
                //                       child: Padding(
                //                           padding: const EdgeInsets.symmetric(
                //                               vertical: 5.0),
                //                           child: Text(
                //                             'ISO - Network',
                //                             style: context.textFontWeight600,
                //                           ))),
                //                   InkWell(
                //                       onTap: () {},
                //                       child: Padding(
                //                           padding: const EdgeInsets.symmetric(
                //                               vertical: 5.0),
                //                           child: Text(
                //                             'ISO - DBA',
                //                             style: context.textFontWeight600,
                //                           ))),
                //                 ],
                //               ),
                //             )
                //           : const SizedBox.shrink();
                //     }),
                SizedBox(
                  height: resources.dimen.dp10,
                ),
                ListTile(
                  onTap: () {
                    _selectedIndex.value = 3;
                    onItemSelected(3);
                  },
                  leading: SizedBox(
                    width: 40,
                    height: 40,
                    child: ImageWidget(
                            path: DrawableAssets.icDirectory,
                            backgroundTint: index == 3
                                ? resources.color.sideBarItemSelected
                                : resources.color.sideBarItemUnselected,
                            padding: const EdgeInsets.symmetric(horizontal: 5))
                        .loadImageWithMoreTapArea,
                  ),
                  title: Text(
                    resources.string.directory,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textFontWeight600
                        .onFontSize(resources.fontSize.dp12),
                  ),
                ),
                SizedBox(
                  height: resources.dimen.dp10,
                ),
                ListTile(
                  onTap: () {
                    _selectedIndex.value = 4;
                    onItemSelected(4);
                  },
                  leading: SizedBox(
                    width: 40,
                    height: 40,
                    child: ImageWidget(
                            path: DrawableAssets.icUser,
                            backgroundTint: index == 4
                                ? resources.color.sideBarItemSelected
                                : resources.color.sideBarItemUnselected,
                            padding: const EdgeInsets.symmetric(horizontal: 5))
                        .loadImageWithMoreTapArea,
                  ),
                  title: Text(
                    resources.string.profile,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textFontWeight600
                        .onFontSize(resources.fontSize.dp12),
                  ),
                )
              ]);
            }));
  }

  selectItem(int index) {
    _selectedIndex.value = index;
    onItemSelected(3);
  }
}
