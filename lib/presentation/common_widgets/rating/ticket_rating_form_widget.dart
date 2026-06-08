import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ithelpdesk/core/config/app_routes.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/injection_container.dart';
import 'package:ithelpdesk/presentation/bloc/rating/rating_bloc.dart';
import 'package:ithelpdesk/presentation/common_widgets/alert_dialog_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/right_icon_text_widget.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';
import 'package:ithelpdesk/res/drawables/drawable_assets.dart';
import 'package:ithelpdesk/res/resources.dart';

class TicketRatingFormWidget extends StatefulWidget {
  final String ticketId;
  final bool navigateHomeOnSuccess;
  final int? initialRating;
  final VoidCallback? onSubmitted;

  const TicketRatingFormWidget({
    required this.ticketId,
    this.navigateHomeOnSuccess = false,
    this.initialRating,
    this.onSubmitted,
    super.key,
  });

  @override
  State<TicketRatingFormWidget> createState() => _TicketRatingFormWidgetState();
}

class _TicketRatingFormWidgetState extends State<TicketRatingFormWidget> {
  final RatingBloc _ratingBloc = sl<RatingBloc>();
  final ValueNotifier<int> _rating = ValueNotifier<int>(0);
  final TextEditingController _tellUsMoreController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialRating != null && widget.initialRating! > 0) {
      _rating.value = widget.initialRating!;
    }
    _ratingBloc.loadFeedback(widget.ticketId);
  }

  @override
  void dispose() {
    _tellUsMoreController.dispose();
    _rating.dispose();
    _ratingBloc.close();
    super.dispose();
  }

  void _submitFeedback() {
    if (_rating.value == 0) return;
    _isSubmitting = true;
    _ratingBloc.submitFeedback(
      ticketId: widget.ticketId,
      rating: _rating.value,
      comment: _tellUsMoreController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return BlocProvider.value(
      value: _ratingBloc,
      child: BlocListener<RatingBloc, RatingState>(
        listener: (context, state) {
          if (state is RatingLoading && _isSubmitting) {
            Dialogs.loader(context);
          } else if (state is RatingSubmitSuccess) {
            _isSubmitting = false;
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
                              text: state.message,
                              style: context.textFontWeight400
                                  .onFontSize(context.resources.fontSize.dp12)
                                  .onFontFamily(fontFamily: fontFamilyEN))
                        ]))).then((_) {
              if (!context.mounted) return;
              if (widget.navigateHomeOnSuccess) {
                context.go(AppRoutes.initialRoute);
              } else {
                Navigator.of(context).pop();
              }
              widget.onSubmitted?.call();
            });
          } else if (state is RatingError && _isSubmitting) {
            _isSubmitting = false;
            if (Navigator.of(context, rootNavigator: true).canPop()) {
              Navigator.of(context, rootNavigator: true).pop();
            }
            Dialogs.showInfoDialog(context, PopupType.fail, state.message);
          }
        },
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Container(
              margin: EdgeInsets.only(top: resources.dimen.dp20),
              padding: EdgeInsets.symmetric(
                  vertical: resources.dimen.dp15,
                  horizontal: resources.dimen.dp20),
              decoration: BackgroundBoxDecoration(
                      boxColor: resources.color.colorWhite,
                      radious: resources.dimen.dp10)
                  .roundedCornerBox,
              child: BlocBuilder<RatingBloc, RatingState>(
                builder: (context, state) {
                  if (state is RatingLoading || state is RatingInit) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is RatingFeedbackLoaded) {
                    if (state.canSubmitRating) {
                      return _buildRatingForm(context, resources);
                    }
                    if (state.isAlreadySubmitted) {
                      return Text(
                        isSelectedLocalEn
                            ? 'Rating already submitted'
                            : 'تم إرسال التقييم بالفعل',
                        style: context.textFontWeight500
                            .onFontSize(context.resources.fontSize.dp14),
                      );
                    }
                    return Text(
                      state.description ?? '',
                      style: context.textFontWeight500
                          .onFontSize(context.resources.fontSize.dp14),
                    );
                  }
                  if (state is RatingError) {
                    return Text(
                      state.message,
                      style: context.textFontWeight500
                          .onFontSize(context.resources.fontSize.dp14),
                    );
                  }
                  return Text(
                    isSelectedLocalEn
                        ? 'Something went wrong, Please try again'
                        : 'حدث خطأ ما، يرجى المحاولة مرة أخرى',
                    style: context.textFontWeight500
                        .onFontSize(context.resources.fontSize.dp14),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingForm(BuildContext context, Resources resources) {
    return Column(
      children: [
        SizedBox(height: resources.dimen.dp20),
        Text(
          resources.string.feedBackRatingTitle,
          textAlign: TextAlign.center,
          style: context.textFontWeight600
              .onFontSize(context.resources.fontSize.dp17)
              .onColor(resources.color.viewBgColor),
        ),
        SizedBox(height: context.resources.dimen.dp20),
        Text.rich(
          TextSpan(
              text: resources.string.feedBackRatingTitleDes.substring(
                0,
                resources.string.feedBackRatingTitleDes.indexOf('00000'),
              ),
              children: [
                TextSpan(
                    text: ' ${widget.ticketId} ',
                    style: context.textFontWeight600
                        .onColor(resources.color.viewBgColor)
                        .onFontFamily(fontFamily: fontFamilyEN)),
                TextSpan(
                    text: resources.string.feedBackRatingTitleDes.substring(
                        resources.string.feedBackRatingTitleDes
                                .indexOf('00000') +
                            5),
                    style: context.textFontWeight500),
              ]),
          textAlign: TextAlign.center,
          style: context.textFontWeight500,
        ),
        SizedBox(height: context.resources.dimen.dp20),
        Text(
          resources.string.howWasYourExperience,
          textAlign: TextAlign.center,
          style: context.textFontWeight600
              .onFontSize(context.resources.fontSize.dp16),
        ),
        SizedBox(height: context.resources.dimen.dp20),
        ValueListenableBuilder(
            valueListenable: _rating,
            builder: (context, value, child) {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) => InkWell(
                      onTap: () => _rating.value = index + 1,
                      child: ImageWidget(
                              path: DrawableAssets.icStar,
                              padding: const EdgeInsets.all(5),
                              backgroundTint: value > index
                                  ? resources.color.viewBgColor
                                  : null)
                          .loadImageWithMoreTapArea,
                    ),
                  ));
            }),
        SizedBox(height: context.resources.dimen.dp25),
        RightIconTextWidget(
          hintText: resources.string.tellUsMore,
          textController: _tellUsMoreController,
          maxLines: 4,
        ),
        SizedBox(height: context.resources.dimen.dp25),
        InkWell(
          onTap: _submitFeedback,
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: context.resources.dimen.dp20,
                vertical: context.resources.dimen.dp7),
            decoration: BackgroundBoxDecoration(
                    boxColor: context.resources.color.viewBgColorLight,
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
        SizedBox(height: context.resources.dimen.dp25),
      ],
    );
  }
}
