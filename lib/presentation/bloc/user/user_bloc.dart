import 'package:equatable/equatable.dart';
import 'package:ithelpdesk/domain/usecase/user_usecase.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/api_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user_entity.dart';

part 'user_state.dart';

class UserBloc extends Cubit<UserState> {
  final UserUseCase userUseCase;
  UserBloc({required this.userUseCase}) : super(Init());

  Future<void> doLogin(Map<String, dynamic> requestParams) async {
    emit(OnLoginLoading());
    final result = await userUseCase.doLogin(requestParams: requestParams);
    emit(result.fold((l) => OnLoginApiError(message: _getErrorMessage(l)),
        (r) => OnLoginSuccess(loginEntity: r)));
  }

  Future<void> doLoginWithCredentials(
      Map<String, dynamic> requestParams) async {
    emit(OnLoginLoading());
    final result =
        await userUseCase.doLoginWithCredentials(requestParams: requestParams);
    emit(result.fold((l) => OnLoginApiError(message: _getErrorMessage(l)),
        (r) => OnLoginSuccess(loginEntity: r)));
  }

  Future<UserEntity> getUserData(Map<String, dynamic> requestParams) async {
    final result = await userUseCase.getUserData(requestParams: requestParams);
    return result.fold((l) => UserEntity(), (r) => r.entity ?? UserEntity());
  }

  Future<void> updateFirbaseToken(Map<String, dynamic> requestParams) async {
    //emit(OnLoginLoading());
    final result =
        await userUseCase.updateFirbaseToken(requestParams: requestParams);
    emit(result.fold((l) => OnLoginApiError(message: _getErrorMessage(l)),
        (r) => OnUpdateFirbaseTokenResponse(updateFirbaseTokenEntity: r)));
  }

  String _getErrorMessage(Failure failure) {
    return failure.errorMessage;
  }
}