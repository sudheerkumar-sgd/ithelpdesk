import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ithelpdesk/core/error/failures.dart';
import 'package:ithelpdesk/domain/entities/services_entity.dart';
import 'package:ithelpdesk/domain/entities/user_credentials_entity.dart';
import 'package:ithelpdesk/domain/usecase/services_usecase.dart';

part 'rating_state.dart';

class RatingBloc extends Cubit<RatingState> {
  final ServicesUseCase servicesUseCase;

  RatingBloc({required this.servicesUseCase}) : super(RatingInit());

  Future<void> loadFeedback(String ticketId) async {
    emit(RatingLoading());
    final result = await servicesUseCase.getUserTicketFeedback(
      requestParams: {'ticketID': ticketId},
    );
    emit(result.fold(
      (failure) => RatingError(message: _getErrorMessage(failure)),
      (response) {
        final feedback = response.entity;
        return RatingFeedbackLoaded(
          apiStatus: response.apiStatus ?? 0,
          rating: feedback?.rating ?? 0,
          comment: feedback?.comment,
          description: response.description,
        );
      },
    ));
  }

  Future<void> submitFeedback({
    required String ticketId,
    required int rating,
    required String comment,
  }) async {
    emit(RatingLoading());
    final result = await servicesUseCase.submitTicketFeedback(
      requestParams: {
        'rating': rating,
        'comment': comment,
        'userID': UserCredentialsEntity.details().id,
        'feedbackFrom': 1,
        'ticketID': ticketId,
      },
    );
    emit(result.fold(
      (failure) => RatingError(message: _getErrorMessage(failure)),
      (response) => RatingSubmitSuccess(message: response.entity?.value ?? ''),
    ));
  }

  Future<List<PendingRatingTicketEntity>> getPendingRatingTickets() async {
    final result = await servicesUseCase.getPendingRatingTickets();
    return result.fold((failure) => [], (response) {
      return (response.entity?.items ?? [])
          .map((item) => item as PendingRatingTicketEntity)
          .toList();
    });
  }

  String _getErrorMessage(Failure failure) {
    return failure.errorMessage;
  }
}
