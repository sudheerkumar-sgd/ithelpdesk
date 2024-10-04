part of 'user_bloc.dart';

abstract class UserState extends Equatable {}

class Init extends UserState {
  @override
  List<Object?> get props => [];
}

class OnLoginLoading extends UserState {
  @override
  List<Object?> get props => [];
}

class OnLoginSuccess extends UserState {
  final ApiEntity<LoginEntity> loginEntity;

  OnLoginSuccess({required this.loginEntity});
  @override
  List<Object?> get props => [loginEntity];
}

class OnUserDataSuccess extends UserState {
  final ApiEntity<UserEntity> userEntity;

  OnUserDataSuccess({required this.userEntity});
  @override
  List<Object?> get props => [userEntity];
}

class OnUpdateFirbaseTokenResponse extends UserState {
  final ApiEntity<UpdateFirbaseTokenEntity> updateFirbaseTokenEntity;

  OnUpdateFirbaseTokenResponse({required this.updateFirbaseTokenEntity});
  @override
  List<Object?> get props => [updateFirbaseTokenEntity];
}

class UpdateVactionStatus extends UserState {
  final String updateVactionStatus;

  UpdateVactionStatus({required this.updateVactionStatus});
  @override
  List<Object?> get props => [updateVactionStatus];
}

class OnLoginApiError extends UserState {
  final String message;

  OnLoginApiError({required this.message});
  @override
  List<Object?> get props => [message];
}
