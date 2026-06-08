part of 'rating_bloc.dart';

abstract class RatingState extends Equatable {}

class RatingInit extends RatingState {
  @override
  List<Object?> get props => [];
}

class RatingLoading extends RatingState {
  @override
  List<Object?> get props => [];
}

class RatingFeedbackLoaded extends RatingState {
  final int apiStatus;
  final int rating;
  final String? comment;
  final String? description;

  RatingFeedbackLoaded({
    required this.apiStatus,
    required this.rating,
    this.comment,
    this.description,
  });

  bool get canSubmitRating => apiStatus == 210;

  bool get isAlreadySubmitted => apiStatus == 200;

  @override
  List<Object?> get props => [apiStatus, rating, comment, description];
}

class RatingSubmitSuccess extends RatingState {
  final String message;

  RatingSubmitSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class RatingError extends RatingState {
  final String message;

  RatingError({required this.message});

  @override
  List<Object?> get props => [message];
}
