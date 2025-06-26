import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/domain/entities/user_credentials_entity.dart';
import 'package:ithelpdesk/presentation/bloc/user/user_bloc.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';

import '../../injection_container.dart';

class ProfileScreenWidget extends BaseScreenWidget {
  final String? userName;
  ProfileScreenWidget({this.userName, super.key});
  final UserBloc _userBloc = sl<UserBloc>();
  @override
  Widget build(BuildContext context) {
    final resources = context.resources;

    return BlocProvider(
      create: (context) => _userBloc,
      child: Padding(
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
              FutureBuilder(
                  future:
                      _userBloc.getUserData(int.tryParse(userName ?? '') != null
                          ? {'id': int.parse(userName ?? '0')}
                          : {
                              'userName': userName ??
                                  UserCredentialsEntity.details().username,
                            }),
                  builder: (context, snapShot) {
                    final userEntity = snapShot.data;
                    return Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                            text:
                                                '${resources.string.fullName}\n',
                                            style: context.textFontWeight400
                                                .onFontSize(
                                                    resources.fontSize.dp10),
                                            children: [
                                              TextSpan(
                                                  text: userEntity?.name ?? '',
                                                  style: context
                                                      .textFontWeight600
                                                      .onFontSize(resources
                                                          .fontSize.dp12))
                                            ]),
                                      ),
                                      SizedBox(
                                        height: resources.dimen.dp15,
                                      ),
                                      Text.rich(
                                        TextSpan(
                                            text: '${resources.string.title}\n',
                                            style: context.textFontWeight400
                                                .onFontSize(
                                                    resources.fontSize.dp10),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      userEntity?.designation ??
                                                          '',
                                                  style: context
                                                      .textFontWeight600
                                                      .onFontSize(resources
                                                          .fontSize.dp12))
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                                // Expanded(
                                //     flex: 1,
                                //     child: Container(
                                //       margin:
                                //           EdgeInsets.all(resources.dimen.dp5),
                                //       decoration: BackgroundBoxDecoration(
                                //         boxColor: resources
                                //             .color.sideBarItemUnselected,
                                //       ).circularBox,
                                //     ))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: resources.dimen.dp15,
                          ),
                          if ((userEntity?.manager ?? '').isNotEmpty) ...[
                            Text(
                              resources.string.managerName,
                              style: context.textFontWeight400
                                  .onFontSize(resources.fontSize.dp10),
                            ),
                            Text(userEntity?.manager ?? '',
                                style: context.textFontWeight600
                                    .onFontSize(resources.fontSize.dp12)),
                            SizedBox(
                              height: resources.dimen.dp15,
                            ),
                          ],
                          // SizedBox(
                          //   height: resources.dimen.dp5,
                          // ),
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       flex: 1,
                          //       child: Text(
                          //         resources.string.yearOfService,
                          //         style: context.textFontWeight400
                          //             .onFontSize(resources.fontSize.dp10),
                          //       ),
                          //     ),
                          //     Expanded(
                          //       flex: 3,
                          //       child: Text('8.0',
                          //           style: context.textFontWeight600
                          //               .onFontSize(resources.fontSize.dp12)),
                          //     )
                          //   ],
                          // ),
                          Text(
                            resources.string.emailID,
                            style: context.textFontWeight400
                                .onFontSize(resources.fontSize.dp10),
                          ),
                          Text(userEntity?.email ?? '',
                              style: context.textFontWeight600
                                  .onFontSize(resources.fontSize.dp12)),
                          SizedBox(
                            height: resources.dimen.dp15,
                          ),
                          Text(
                            resources.string.department,
                            style: context.textFontWeight400
                                .onFontSize(resources.fontSize.dp10),
                          ),
                          Text(userEntity?.department ?? '',
                              style: context.textFontWeight600
                                  .onFontSize(resources.fontSize.dp12)),
                          SizedBox(
                            height: resources.dimen.dp15,
                          ),
                          Text(
                            resources.string.telephoneExt,
                            style: context.textFontWeight400
                                .onFontSize(resources.fontSize.dp10),
                          ),
                          Text(userEntity?.contactNumber ?? '',
                              style: context.textFontWeight600
                                  .onFontSize(resources.fontSize.dp12)),
                        ],
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
