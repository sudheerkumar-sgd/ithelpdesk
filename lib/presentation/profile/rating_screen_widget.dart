// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/config/app_routes.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/domain/entities/user_credentials_entity.dart';
import 'package:ithelpdesk/presentation/bloc/services/services_bloc.dart';
import 'package:ithelpdesk/presentation/common_widgets/alert_dialog_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/right_icon_text_widget.dart';
import 'package:ithelpdesk/res/drawables/drawable_assets.dart';
import 'package:ithelpdesk/res/resources.dart';

import '../../../res/drawables/background_box_decoration.dart';
import '../../injection_container.dart';
import '../utils/dialogs.dart';

class RatingScreenWidget extends StatelessWidget {
  String ticketID;
  RatingScreenWidget({required this.ticketID, super.key});
  final ValueNotifier<int> _rating = ValueNotifier<int>(0);
  final ServicesBloc _servicesBloc = sl<ServicesBloc>();

  @override
  Widget build(BuildContext context) {
    Resources resources = context.resources;
    _rating.value = 0;
    final tellUsMoreController = TextEditingController();
    return BlocProvider(
      create: (context) => _servicesBloc,
      child: BlocListener<ServicesBloc, ServicesState>(
        listener: (context, state) {
          if (state is OnLoading) {
            Dialogs.loader(context);
          } else if (state is OnUpdateTicketSuccess) {
            Navigator.of(context, rootNavigator: true).pop();
            Dialogs.showInfoDialog(context, PopupType.success, '',
                customMessageBody: SelectableText.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                        text: '${resources.string.updatedSuccessfully}: \n',
                        style: context.textFontWeight400
                            .onFontSize(context.resources.fontSize.dp12),
                        children: [
                          TextSpan(
                              text: state.updateTicketResponse,
                              style: context.textFontWeight400
                                  .onFontSize(context.resources.fontSize.dp12)
                                  .onFontFamily(fontFamily: fontFamilyEN))
                        ]))).then((v) {
              if (context.mounted) {
                context.go(AppRoutes.initialRoute);
              }
            });
          } else if (state is OnApiError) {
            Navigator.of(context, rootNavigator: true).pop();
            Dialogs.showInfoDialog(context, PopupType.fail, state.message);
          }
        },
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500, // Set your desired fixed width
            ),
            child: Container(
              margin: EdgeInsets.only(top: resources.dimen.dp20),
              padding: EdgeInsets.symmetric(
                  vertical: resources.dimen.dp15,
                  horizontal: resources.dimen.dp20),
              decoration: BackgroundBoxDecoration(
                      boxColor: resources.color.colorWhite,
                      radious: resources.dimen.dp10)
                  .roundedCornerBox,
              child: Column(
                children: [
                  SizedBox(
                    height: resources.dimen.dp20,
                  ),
                  Text(
                    resources.string.feedBackRatingTitle,
                    textAlign: TextAlign.center,
                    style: context.textFontWeight600
                        .onFontSize(context.resources.fontSize.dp17)
                        .onColor(resources.color.viewBgColor),
                  ),
                  SizedBox(
                    height: context.resources.dimen.dp20,
                  ),
                  Text.rich(
                    TextSpan(
                        text: resources.string.feedBackRatingTitleDes.substring(
                          0,
                          resources.string.feedBackRatingTitleDes
                              .indexOf('00000'),
                        ),
                        children: [
                          TextSpan(
                              text: ' $ticketID ',
                              style: context.textFontWeight600
                                  .onColor(resources.color.viewBgColor)
                                  .onFontFamily(fontFamily: fontFamilyEN)),
                          TextSpan(
                              text: resources.string.feedBackRatingTitleDes
                                  .substring(resources
                                          .string.feedBackRatingTitleDes
                                          .indexOf('00000') +
                                      5),
                              style: context.textFontWeight500),
                        ]),
                    textAlign: TextAlign.center,
                    style: context.textFontWeight500,
                  ),
                  // Text(
                  //   resources.string.feedBackRatingTitleDes
                  //       .replaceAll('00000', ' ${data['ticketID'] ?? ''} '),
                  //   textAlign: TextAlign.center,
                  //   style: context.textFontWeight400
                  //       .onFontSize(context.resources.fontSize.dp12),
                  // ),
                  SizedBox(
                    height: context.resources.dimen.dp20,
                  ),
                  Text(
                    resources.string.howWasYourExperience,
                    textAlign: TextAlign.center,
                    style: context.textFontWeight600
                        .onFontSize(context.resources.fontSize.dp16),
                  ),
                  SizedBox(
                    height: context.resources.dimen.dp20,
                  ),
                  ValueListenableBuilder(
                      valueListenable: _rating,
                      builder: (context, value, child) {
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  _rating.value = 1;
                                },
                                child: ImageWidget(
                                        path: DrawableAssets.icStar,
                                        padding: const EdgeInsets.all(5),
                                        backgroundTint: value > 0
                                            ? resources.color.viewBgColor
                                            : null)
                                    .loadImageWithMoreTapArea,
                              ),
                              InkWell(
                                onTap: () {
                                  _rating.value = 2;
                                },
                                child: ImageWidget(
                                        path: DrawableAssets.icStar,
                                        padding: const EdgeInsets.all(5),
                                        backgroundTint: value > 1
                                            ? resources.color.viewBgColor
                                            : null)
                                    .loadImageWithMoreTapArea,
                              ),
                              InkWell(
                                onTap: () {
                                  _rating.value = 3;
                                },
                                child: ImageWidget(
                                        path: DrawableAssets.icStar,
                                        padding: const EdgeInsets.all(5),
                                        backgroundTint: value > 2
                                            ? resources.color.viewBgColor
                                            : null)
                                    .loadImageWithMoreTapArea,
                              ),
                              InkWell(
                                onTap: () {
                                  _rating.value = 4;
                                },
                                child: ImageWidget(
                                        path: DrawableAssets.icStar,
                                        padding: const EdgeInsets.all(5),
                                        backgroundTint: value > 3
                                            ? resources.color.viewBgColor
                                            : null)
                                    .loadImageWithMoreTapArea,
                              ),
                              InkWell(
                                onTap: () {
                                  _rating.value = 5;
                                },
                                child: ImageWidget(
                                        path: DrawableAssets.icStar,
                                        padding: const EdgeInsets.all(5),
                                        backgroundTint: value > 4
                                            ? resources.color.viewBgColor
                                            : null)
                                    .loadImageWithMoreTapArea,
                              ),
                            ]);
                      }),
                  SizedBox(
                    height: context.resources.dimen.dp25,
                  ),
                  RightIconTextWidget(
                    hintText: resources.string.tellUsMore,
                    textController: tellUsMoreController,
                    maxLines: 4,
                  ),
                  SizedBox(
                    height: context.resources.dimen.dp25,
                  ),
                  InkWell(
                    onTap: () {
                      if (_rating.value != 0) {
                        _servicesBloc.submitTicketFeedback(requestParams: {
                          "rating": _rating.value,
                          "comment": tellUsMoreController.text,
                          "userID": UserCredentialsEntity.details().id,
                          "feedbackFrom": 1,
                          "ticketID": ticketID
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.resources.dimen.dp20,
                          vertical: context.resources.dimen.dp7),
                      decoration: BackgroundBoxDecoration(
                              boxColor:
                                  context.resources.color.viewBgColorLight,
                              radious: context.resources.dimen.dp15)
                          .roundedCornerBox,
                      child: Text(
                        resources.string.submit,
                        style: context.textFontWeight600
                            .onFontSize(context.resources.fontSize.dp14)
                            .onColor(context.resources.color.colorWhite),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: context.resources.dimen.dp25,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
