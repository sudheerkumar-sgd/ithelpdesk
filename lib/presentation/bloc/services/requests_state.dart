part of 'requests_bloc.dart';

abstract class RequestsState extends Equatable {}

class Init extends RequestsState {
  @override
  List<Object?> get props => [];
}

class OnRequestsLoading extends RequestsState {
  @override
  List<Object?> get props => [];
}

class OnRequestsDataResponse extends RequestsState {
  final ApiEntity<RequestsDataEntity> requestsData;

  OnRequestsDataResponse({required this.requestsData});
  @override
  List<Object?> get props => [requestsData];
}

class OnSubmitDataResponse extends RequestsState {
  final ApiEntity<SubmitResponseEntity> submitResponse;

  OnSubmitDataResponse({required this.submitResponse});
  @override
  List<Object?> get props => [submitResponse];
}

class OnRequestDataApiError extends RequestsState {
  final String message;

  OnRequestDataApiError({required this.message});
  @override
  List<Object?> get props => [message];
}
