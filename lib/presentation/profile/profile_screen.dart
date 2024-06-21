import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';
import 'package:ithelpdesk/res/drawables/drawable_assets.dart';

class ProfileScreen extends BaseScreenWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.resources.color.appScaffoldBg,
      body: Padding(
        padding: EdgeInsets.all(resources.dimen.dp20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                resources.string.userProfile,
                style: context.textFontWeight700
                    .onFontSize(resources.fontSize.dp14),
              ),
              SizedBox(
                height: resources.dimen.dp20,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: resources.dimen.dp15,
                    horizontal: resources.dimen.dp20),
                color: resources.color.colorWhite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                      text: '${resources.string.fullName}\n',
                                      style: context.textFontWeight400
                                          .onFontSize(resources.fontSize.dp10),
                                      children: [
                                        TextSpan(
                                            text: 'Abdul Muneeb',
                                            style: context.textFontWeight600
                                                .onFontSize(
                                                    resources.fontSize.dp12))
                                      ]),
                                ),
                                SizedBox(
                                  height: resources.dimen.dp20,
                                ),
                                Text.rich(
                                  TextSpan(
                                      text: '${resources.string.title}\n',
                                      style: context.textFontWeight400
                                          .onFontSize(resources.fontSize.dp10),
                                      children: [
                                        TextSpan(
                                            text: 'Designer',
                                            style: context.textFontWeight600
                                                .onFontSize(
                                                    resources.fontSize.dp12))
                                      ]),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.all(resources.dimen.dp5),
                                decoration: BackgroundBoxDecoration(
                                  boxColor:
                                      resources.color.sideBarItemUnselected,
                                ).circularBox,
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: resources.dimen.dp20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            resources.string.managerName,
                            style: context.textFontWeight400
                                .onFontSize(resources.fontSize.dp10),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text('Mooza binyeem',
                              style: context.textFontWeight600
                                  .onFontSize(resources.fontSize.dp12)),
                        )
                      ],
                    ),
                    SizedBox(
                      height: resources.dimen.dp5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            resources.string.yearOfService,
                            style: context.textFontWeight400
                                .onFontSize(resources.fontSize.dp10),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text('8.0',
                              style: context.textFontWeight600
                                  .onFontSize(resources.fontSize.dp12)),
                        )
                      ],
                    ),
                    SizedBox(
                      height: resources.dimen.dp50,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            resources.string.emailID,
                            style: context.textFontWeight400
                                .onFontSize(resources.fontSize.dp10),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text('moozabinyeem@gmail.com',
                              style: context.textFontWeight600
                                  .onFontSize(resources.fontSize.dp12)),
                        )
                      ],
                    ),
                    SizedBox(
                      height: resources.dimen.dp5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            resources.string.department,
                            style: context.textFontWeight400
                                .onFontSize(resources.fontSize.dp10),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text('Smart UAQ',
                              style: context.textFontWeight600
                                  .onFontSize(resources.fontSize.dp12)),
                        )
                      ],
                    ),
                    SizedBox(
                      height: resources.dimen.dp5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            resources.string.telephoneExt,
                            style: context.textFontWeight400
                                .onFontSize(resources.fontSize.dp10),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text('05553495999',
                              style: context.textFontWeight600
                                  .onFontSize(resources.fontSize.dp12)),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
