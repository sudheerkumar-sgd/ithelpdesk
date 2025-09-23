import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ithelpdesk/domain/entities/api_entity.dart';
import 'package:ithelpdesk/domain/entities/base_entity.dart';
import 'package:ithelpdesk/domain/usecase/iso_usecase.dart';

part 'iso_state.dart';

class ISOBloc extends Cubit<ISOApiState> {
  final ISOUseCase isoUseCase;
  ISOBloc({required this.isoUseCase}) : super(Init());

  Future<ISOApiState> createISORequest(
      {required String apiUrl,
      required Map<String, dynamic> requestParams,
      bool emitResponse = false}) async {
    if (emitResponse) {
      emit(OnISOApiLoading());
    }
    final result = await isoUseCase.createISORequest(
        apiUrl: apiUrl, requestParams: requestParams);
    final apiState =
        result.fold((l) => OnISOApiError(message: l.errorMessage), (r) {
      return OnISOApiResponse(response: r);
    });
    if (emitResponse) {
      emit(apiState);
    }
    return apiState;
  }

  Future<ISOApiState> getRequests(
      {required Map<String, dynamic> requestParams,
      bool emitResponse = false}) async {
    if (emitResponse) {
      emit(OnISOApiLoading());
    }
    final result = await isoUseCase.getCRRequests(requestParams: requestParams);
    final apiState =
        result.fold((l) => OnISOApiError(message: l.errorMessage), (r) {
      return OnISOApiResponse(response: r);
    });
    if (emitResponse) {
      emit(apiState);
    }
    return apiState;
  }

  Future<ISOApiState> getRequestsDetails(
      {required Map<String, dynamic> requestParams,
      bool emitResponse = false}) async {
    if (emitResponse) {
      emit(OnISOApiLoading());
    }
    final result =
        await isoUseCase.getCRRequestDetails(requestParams: requestParams);
    final apiState =
        result.fold((l) => OnISOApiError(message: l.errorMessage), (r) {
      return OnISOApiResponse(response: r);
    });
    if (emitResponse) {
      emit(apiState);
    }
    return apiState;
  }

  Future<ISOApiState> getCRTransferEmployees(
      {required Map<String, dynamic> requestParams,
      bool emitResponse = false}) async {
    if (emitResponse) {
      emit(OnISOApiLoading());
    }
    final result =
        await isoUseCase.getCRTransferEmployees(requestParams: requestParams);
    final apiState =
        result.fold((l) => OnISOApiError(message: l.errorMessage), (r) {
      return OnISOApiResponse(response: r);
    });
    if (emitResponse) {
      emit(apiState);
    }
    return apiState;
  }
}
