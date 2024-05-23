part of 'login_bloc.dart';

abstract class LoginState extends Equatable {}

class Init extends LoginState {
  @override
  List<Object?> get props => [];
}

class OnLoginLoading extends LoginState {
  @override
  List<Object?> get props => [];
}

class OnLoginSuccess extends LoginState {
  final ApiEntity<LoginEntity> loginEntity;

  OnLoginSuccess({required this.loginEntity});
  @override
  List<Object?> get props => [loginEntity];
}

class OnUserDataSuccess extends LoginState {
  final ApiEntity<UserEntity> userEntity;

  OnUserDataSuccess({required this.userEntity});
  @override
  List<Object?> get props => [userEntity];
}

class OnUpdateFirbaseTokenResponse extends LoginState {
  final ApiEntity<UpdateFirbaseTokenEntity> updateFirbaseTokenEntity;

  OnUpdateFirbaseTokenResponse({required this.updateFirbaseTokenEntity});
  @override
  List<Object?> get props => [updateFirbaseTokenEntity];
}

class OnLoginApiError extends LoginState {
  final String message;

  OnLoginApiError({required this.message});
  @override
  List<Object?> get props => [message];
}
