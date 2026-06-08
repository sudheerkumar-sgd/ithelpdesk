import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/injection_container.dart';
import 'package:ithelpdesk/presentation/bloc/rating/rating_bloc.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/rating/rating_comment_tooltip.dart';
import 'package:ithelpdesk/presentation/common_widgets/rating/rating_dialog.dart';
import 'package:ithelpdesk/res/drawables/drawable_assets.dart';

class TicketRatingWidget extends StatefulWidget {
  final String ticketId;
  final bool canRate;
  final ValueNotifier<bool>? refreshNotifier;
  final VoidCallback? onRated;

  const TicketRatingWidget({
    required this.ticketId,
    this.canRate = false,
    this.refreshNotifier,
    this.onRated,
    super.key,
  });

  @override
  State<TicketRatingWidget> createState() => _TicketRatingWidgetState();
}

class _TicketRatingWidgetState extends State<TicketRatingWidget> {
  final RatingBloc _ratingBloc = sl<RatingBloc>();

  @override
  void initState() {
    super.initState();
    _ratingBloc.loadFeedback(widget.ticketId);
    widget.refreshNotifier?.addListener(_reloadFeedback);
  }

  @override
  void dispose() {
    widget.refreshNotifier?.removeListener(_reloadFeedback);
    _ratingBloc.close();
    super.dispose();
  }

  void _reloadFeedback() {
    _ratingBloc.loadFeedback(widget.ticketId);
  }

  void _openRatingDialog(int selectedRating) {
    RatingDialog.show(
      context,
      ticketId: widget.ticketId,
      initialRating: selectedRating,
      onSubmitted: () {
        _ratingBloc.loadFeedback(widget.ticketId);
        widget.onRated?.call();
      },
    );
  }

  Widget _buildStarsRow({
    required int filledCount,
    required bool interactive,
  }) {
    final resources = context.resources;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) => InkWell(
          onTap: interactive ? () => _openRatingDialog(index + 1) : null,
          child: ImageWidget(
                  width: 20,
                  path: DrawableAssets.icStar,
                  padding: const EdgeInsets.all(5),
                  backgroundTint:
                      filledCount > index ? resources.color.viewBgColor : null)
              .loadImageWithMoreTapArea,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return BlocProvider.value(
      value: _ratingBloc,
      child: BlocBuilder<RatingBloc, RatingState>(
        builder: (context, state) {
          if (state is RatingLoading || state is RatingInit) {
            return const SizedBox();
          }
          if (state is RatingFeedbackLoaded && state.rating > 0) {
            return Padding(
              padding: EdgeInsets.only(top: resources.dimen.dp10),
              child: RatingCommentTooltip(
                comment: state.comment,
                child: _buildStarsRow(
                  filledCount: state.rating,
                  interactive: false,
                ),
              ),
            );
          }
          if (widget.canRate &&
              state is RatingFeedbackLoaded &&
              state.canSubmitRating) {
            return Padding(
              padding: EdgeInsets.only(top: resources.dimen.dp10),
              child: Column(
                children: [
                  Text(
                    resources.string.howWasYourExperience,
                    textAlign: TextAlign.center,
                    style: context.textFontWeight500
                        .onFontSize(resources.fontSize.dp12),
                  ),
                  SizedBox(height: resources.dimen.dp5),
                  _buildStarsRow(filledCount: 0, interactive: true),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
