part of 'iso_bloc.dart';

abstract class ISOApiState extends Equatable {}

class Init extends ISOApiState {
  @override
  List<Object?> get props => [];
}

class OnISOApiLoading extends ISOApiState {
  @override
  List<Object?> get props => [];
}

class OnISOApiResponse extends ISOApiState {
  final ApiEntity<BaseEntity> response;

  OnISOApiResponse({required this.response});
  @override
  List<Object?> get props => [response];
}

class OnISOApiError extends ISOApiState {
  final String message;

  OnISOApiError({required this.message});
  @override
  List<Object?> get props => [message];
}
