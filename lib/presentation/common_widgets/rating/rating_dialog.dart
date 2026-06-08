import 'package:flutter/material.dart';
import 'package:ithelpdesk/presentation/common_widgets/rating/ticket_rating_form_widget.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';

class RatingDialog {
  static Future<void> show(
    BuildContext context, {
    required String ticketId,
    bool navigateHomeOnSuccess = false,
    int? initialRating,
    VoidCallback? onSubmitted,
  }) {
    return Dialogs.showDialogWithClose(
      context,
      TicketRatingFormWidget(
        ticketId: ticketId,
        navigateHomeOnSuccess: navigateHomeOnSuccess,
        initialRating: initialRating,
        onSubmitted: onSubmitted,
      ),
      maxWidth: 550,
    );
  }
}
