import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ithelpdesk/core/error/failures.dart';
import 'package:ithelpdesk/domain/entities/api_entity.dart';
import 'package:ithelpdesk/domain/entities/request_form_entities.dart';
import 'package:ithelpdesk/domain/usecase/requests_usecase.dart';

import '../../../domain/entities/user_entity.dart';
part 'requests_state.dart';

class RequestsBloc extends Cubit<RequestsState> {
  final RequestsUseCase requestsUseCase;
  RequestsBloc({required this.requestsUseCase}) : super(Init());

  Future<void> getRequestFormData(
      {required String serviceId,
      required Map<String, dynamic> requestParams}) async {
    emit(OnRequestsLoading());
    final result = await requestsUseCase.getRequestFormData(
        serviceId: serviceId, requestParams: requestParams);
    emit(result.fold((l) => OnRequestDataApiError(message: _getErrorMessage(l)),
        (r) => OnRequestsDataResponse(requestsData: r)));
  }

  Future<List<DropdownItemEntity>> getAccountTypes(
      {required String apiUrl}) async {
    final result = await requestsUseCase
        .getAccountTypes(apiUrl: apiUrl, requestParams: {});
    return result.fold((l) {
      return [];
    }, (r) {
      return r.entity?.items ?? [];
    });
  }

  Future<UploadResponseEntity> uploadaAttachment(
      {required requestParams}) async {
    final result =
        await requestsUseCase.uploadAttachment(requestParams: requestParams);
    return result.fold((l) {
      return UploadResponseEntity();
    }, (r) {
      return r.entity ?? UploadResponseEntity();
    });
  }

  Future<void> submitFormData(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnRequestsLoading());
    final result =
        await requestsUseCase.submitRequest(requestParams: requestParams);
    emit(result.fold((l) => OnRequestDataApiError(message: _getErrorMessage(l)),
        (r) => OnSubmitDataResponse(submitResponse: r)));
  }

  Future<PaymentResponseEntity> getPaymentView({
    required Map<String, dynamic> requestParams,
  }) async {
    final result =
        await requestsUseCase.requestPaymnetView(requestParams: requestParams);
    return result.fold((l) => PaymentResponseEntity(),
        (r) => r.entity ?? PaymentResponseEntity());
  }

  Future<PaymentResponseEntity> updateRequestStatus({
    required Map<String, dynamic> requestParams,
  }) async {
    final result =
        await requestsUseCase.updateRequestStatus(requestParams: requestParams);
    return result.fold((l) => PaymentResponseEntity(),
        (r) => r.entity ?? PaymentResponseEntity());
  }

  Future<HappinessMeterEntity> getHappinessMeterData({
    required String url,
    Map<String, dynamic>? requestParams,
  }) async {
    final result = await requestsUseCase.getHappinessMeterData(url: url);
    return result.fold((l) => HappinessMeterEntity(),
        (r) => r.entity ?? HappinessMeterEntity());
  }

  Future<HappinessMeterEntity> submitHappinessMeterData({
    required Map<String, dynamic> requestParams,
  }) async {
    final result = await requestsUseCase.submitHappinessMeterData(
        requestParams: requestParams);
    return result.fold((l) => HappinessMeterEntity(),
        (r) => r.entity ?? HappinessMeterEntity());
  }

  String _getErrorMessage(Failure failure) {
    return failure.errorMessage;
  }

  Future<UserEntity> getUserData(Map<String, dynamic> requestParams) async {
    emit(OnRequestsLoading());
    final result =
        await requestsUseCase.getUserData(requestParams: requestParams);
    return result.fold((l) {
      return UserEntity();
    }, (r) {
      return r.entity ?? UserEntity();
    });
  }
}
