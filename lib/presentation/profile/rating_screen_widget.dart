// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ithelpdesk/presentation/common_widgets/rating/ticket_rating_form_widget.dart';

class RatingScreenWidget extends StatelessWidget {
  String ticketID;
  RatingScreenWidget({required this.ticketID, super.key});

  @override
  Widget build(BuildContext context) {
    return TicketRatingFormWidget(
      ticketId: ticketID,
      navigateHomeOnSuccess: true,
    );
  }
}
