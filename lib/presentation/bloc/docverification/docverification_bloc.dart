import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ithelpdesk/core/error/failures.dart';
import 'package:ithelpdesk/domain/entities/api_entity.dart';
import 'package:ithelpdesk/domain/entities/mywallet_entity.dart';
import 'package:ithelpdesk/domain/usecase/docverification_usecase.dart';
part 'docverification_state.dart';

class DocVerificationBloc extends Cubit<DocVerificationState> {
  final DocVerificationUseCase docVerificationUseCase;
  DocVerificationBloc({required this.docVerificationUseCase}) : super(Init());

  Future<void> verifyDocument(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnDocVerificationLoading());
    final result = await docVerificationUseCase.verifyDocument(
        requestParams: requestParams);
    emit(result.fold(
        (l) => OnDocVerificationApiError(message: _getErrorMessage(l)),
        (r) => OnVerifyResponse(verifyResponse: r)));
  }

  Future<void> getDocument(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnDocVerificationLoading());
    final result =
        await docVerificationUseCase.getDocument(requestParams: requestParams);
    emit(result.fold(
        (l) => OnDocVerificationApiError(message: _getErrorMessage(l)),
        (r) => OnGetDocumentResponse(getDocumentResponse: r)));
  }

  Future<String> getSessionId() async {
    final result = await docVerificationUseCase.getSessionId();
    return result.fold((l) => _getErrorMessage(l), (r) => r);
  }

  Future<String> sendOTP({required Map<String, dynamic> requestParams}) async {
    final result =
        await docVerificationUseCase.sendOTP(requestParams: requestParams);
    return result.fold((l) => '', (r) => r);
  }

  Future<String> verifyOTP(
      {required Map<String, dynamic> requestParams}) async {
    final result =
        await docVerificationUseCase.verifyOTP(requestParams: requestParams);
    return result.fold((l) => _getErrorMessage(l), (r) => r);
  }

  String _getErrorMessage(Failure failure) {
    return failure.errorMessage;
  }
}
