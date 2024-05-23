import 'package:equatable/equatable.dart';
import 'package:smartuaq/domain/entities/login_entity.dart';
import 'package:smartuaq/domain/usecase/login_usecase.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/api_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginBloc extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;
  LoginBloc({required this.loginUseCase}) : super(Init());

  Future<void> doLogin(Map<String, dynamic> requestParams) async {
    emit(OnLoginLoading());
    final result = await loginUseCase.doLogin(requestParams: requestParams);
    emit(result.fold((l) => OnLoginApiError(message: _getErrorMessage(l)),
        (r) => OnLoginSuccess(loginEntity: r)));
  }

  Future<void> doLoginWithCredentials(
      Map<String, dynamic> requestParams) async {
    emit(OnLoginLoading());
    final result =
        await loginUseCase.doLoginWithCredentials(requestParams: requestParams);
    emit(result.fold((l) => OnLoginApiError(message: _getErrorMessage(l)),
        (r) => OnLoginSuccess(loginEntity: r)));
  }

  Future<void> getUserData(Map<String, dynamic> requestParams) async {
    emit(OnLoginLoading());
    final result = await loginUseCase.getUserData(requestParams: requestParams);
    emit(result.fold((l) => OnLoginApiError(message: _getErrorMessage(l)),
        (r) => OnUserDataSuccess(userEntity: r)));
  }

  Future<void> updateFirbaseToken(Map<String, dynamic> requestParams) async {
    //emit(OnLoginLoading());
    final result =
        await loginUseCase.updateFirbaseToken(requestParams: requestParams);
    emit(result.fold((l) => OnLoginApiError(message: _getErrorMessage(l)),
        (r) => OnUpdateFirbaseTokenResponse(updateFirbaseTokenEntity: r)));
  }

  String _getErrorMessage(Failure failure) {
    return failure.errorMessage;
  }
}
