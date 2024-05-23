import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smartuaq/core/enum/enum.dart';
import 'package:smartuaq/core/error/failures.dart';
import 'package:smartuaq/domain/entities/api_entity.dart';
import 'package:smartuaq/domain/entities/mywallet_entity.dart';
import 'package:smartuaq/domain/entities/request_form_entities.dart';
import 'package:smartuaq/domain/entities/requests_entity.dart';
import 'package:smartuaq/domain/usecase/mywallet_usecase.dart';
part 'mywallet_state.dart';

class MyWalletBloc extends Cubit<MyWalletState> {
  final MyWalletUseCase myWalletUseCase;
  MyWalletBloc({required this.myWalletUseCase}) : super(Init());

  final BehaviorSubject<List<RequestsEntity>> _complemtedRequests =
      BehaviorSubject<List<RequestsEntity>>();
  final BehaviorSubject<List<RequestsEntity>> _rejectedRequests =
      BehaviorSubject<List<RequestsEntity>>();
  final BehaviorSubject<List<RequestsEntity>> _pendingRequests =
      BehaviorSubject<List<RequestsEntity>>();
  final BehaviorSubject<List<RequestsEntity>> _allMDRequests =
      BehaviorSubject<List<RequestsEntity>>();
  final BehaviorSubject<List<RequestsEntity>> _pendingDEDRequests =
      BehaviorSubject<List<RequestsEntity>>();
  final BehaviorSubject<List<RequestsEntity>> _pendingMDRequests =
      BehaviorSubject<List<RequestsEntity>>();
  final BehaviorSubject<double> _totalInduvidualFine =
      BehaviorSubject<double>();
  final BehaviorSubject<double> _totalEstFine = BehaviorSubject<double>();

  Future<void> getMyFine({required Map<String, dynamic> requestParams}) async {
    final result =
        await myWalletUseCase.getMyTotalFine(requestParams: requestParams);
    _totalInduvidualFine.sink
        .add(result.fold((l) => 0, (r) => (r.entity?.totalFines ?? 0)));
  }

  Future<void> getMyEstFine(
      {required Map<String, dynamic> requestParams}) async {
    if ((requestParams['establishments'] is List) &&
        (requestParams['establishments'] as List).isEmpty) {
      _totalEstFine.sink.add(0);
    } else {
      final result =
          await myWalletUseCase.getMyEstFinesList(requestParams: requestParams);
      _totalEstFine.sink
          .add(result.fold((l) => 0, (r) => (r.entity?.totalFines ?? 0)));
    }
  }

  Future<void> getMyFinesList(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnMyWalletLoading());
    final result =
        await myWalletUseCase.getMyTotalFine(requestParams: requestParams);
    emit(result.fold((l) => OnMyWalletApiError(message: _getErrorMessage(l)),
        (r) => OnFinesResponse(finesResponse: r)));
  }

  Future<void> getMyEstFinesList(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnMyWalletLoading());
    final result =
        await myWalletUseCase.getMyEstFinesList(requestParams: requestParams);
    emit(result.fold((l) => OnMyWalletApiError(message: _getErrorMessage(l)),
        (r) => OnFinesResponse(finesResponse: r)));
  }

  Future<void> getMyActionDEDRequests(
      {required Map<String, dynamic> requestParams}) async {
    final result =
        await myWalletUseCase.getMyDEDRequests(requestParams: requestParams);
    _pendingDEDRequests.sink
        .add(result.fold((l) => [], (r) => r.entity?.requests ?? []));
  }

  Future<void> getMyActionMDRequests(
      {required Map<String, dynamic> requestParams}) async {
    final result =
        await myWalletUseCase.getMyRequests(requestParams: requestParams);
    _pendingMDRequests.sink.add(result.fold(
        (l) => [],
        (r) => (r.entity?.requests ?? [])
            .where((e) => e.isPendingForAction)
            .toList()));
  }

  Future<void> getAllMyDEDRequests(
      {required Map<String, dynamic> requestParams}) async {
    final result =
        await myWalletUseCase.getMyDEDRequests(requestParams: requestParams);
    if (requestParams['status'] == RequestStatusEnum.completed.value) {
      _complemtedRequests.sink
          .add(result.fold((l) => [], (r) => (r.entity?.requests ?? [])));
    } else if (requestParams['status'] == RequestStatusEnum.rejected.value) {
      _rejectedRequests.sink
          .add(result.fold((l) => [], (r) => (r.entity?.requests ?? [])));
    } else if (requestParams['status'] == RequestStatusEnum.pending.value) {
      _pendingRequests.sink
          .add(result.fold((l) => [], (r) => r.entity?.requests ?? []));
    }
  }

  Future<ApiEntity<RequestsEntity>> getMyRequestStatus({
    required Map<String, dynamic> requestParams,
  }) async {
    final result =
        await myWalletUseCase.getRequestDetails(requestParams: requestParams);
    return result.fold((l) => ApiEntity<RequestsEntity>(), (r) => r);
  }

  Future<void> getMyRequestDetails({
    required Map<String, dynamic> requestParams,
  }) async {
    final result =
        await myWalletUseCase.getRequestDetails(requestParams: requestParams);
    emit(result.fold((l) => OnMyWalletApiError(message: _getErrorMessage(l)),
        (r) => OnMyRequestDetailsResponse(requestDetails: r)));
  }

  Future<void> verifyDocument(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnMyWalletLoading());
    final result =
        await myWalletUseCase.verifyDocument(requestParams: requestParams);
    emit(result.fold((l) => OnMyWalletApiError(message: _getErrorMessage(l)),
        (r) => OnVerifyResponse(verifyResponse: r)));
  }

  Future<void> getDocument(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnMyWalletLoading());
    final result =
        await myWalletUseCase.getDocument(requestParams: requestParams);
    emit(result.fold((l) => OnMyWalletApiError(message: _getErrorMessage(l)),
        (r) => OnGetDocumentResponse(getDocumentResponse: r)));
  }

  Future<String> getDocumentStream(
      {required Map<String, dynamic> requestParams}) async {
    final result =
        await myWalletUseCase.getDocument(requestParams: requestParams);
    return result.fold((l) => l.errorMessage, (r) {
      return r.entity?.documentData ?? '';
    });
  }

  Future<String> getUserDocumentStream(
      {required Map<String, dynamic> requestParams}) async {
    final result =
        await myWalletUseCase.getUserDocument(requestParams: requestParams);
    return result.fold((l) => l.errorMessage, (r) {
      return r.entity?.documentData ?? '';
    });
  }

  Future<void> getMyRequestsList(
      {required Map<String, dynamic> requestParams}) async {
    final result =
        await myWalletUseCase.getMyRequests(requestParams: requestParams);
    _allMDRequests.sink
        .add(result.fold((l) => [], (r) => r.entity?.requests ?? []));
  }

  Future<void> getMyPaymentsList({
    required Map<String, dynamic> requestParams,
  }) async {
    final result =
        await myWalletUseCase.getPaymentsList(requestParams: requestParams);
    emit(result.fold((l) => OnMyWalletApiError(message: _getErrorMessage(l)),
        (r) => OnPaymentsResponse(payments: r)));
  }

  Future<void> getMyDocumentsList({
    required Map<String, dynamic> requestParams,
  }) async {
    final result =
        await myWalletUseCase.getMyDocuments(requestParams: requestParams);
    emit(result.fold((l) => OnMyWalletApiError(message: _getErrorMessage(l)),
        (r) => OnMyDocumentsResponse(documents: r)));
  }

  Future<void> getMyLicensesList({
    required Map<String, dynamic> requestParams,
  }) async {
    final result =
        await myWalletUseCase.getMyLicenses(requestParams: requestParams);
    emit(result.fold((l) => OnMyWalletApiError(message: _getErrorMessage(l)),
        (r) => OnMyDocumentsResponse(documents: r)));
  }

  Future<void> getMyPermitsList({
    required Map<String, dynamic> requestParams,
  }) async {
    final result =
        await myWalletUseCase.getMyPermits(requestParams: requestParams);
    emit(result.fold((l) => OnMyWalletApiError(message: _getErrorMessage(l)),
        (r) => OnMyDocumentsResponse(documents: r)));
  }

  Future<PaymentResponseEntity> getPaymentView({
    required Map<String, dynamic> requestParams,
  }) async {
    final result =
        await myWalletUseCase.requestPaymnetView(requestParams: requestParams);
    return result.fold((l) => PaymentResponseEntity(),
        (r) => r.entity ?? PaymentResponseEntity());
  }

  Future<PaymentResponseEntity> updateRequestStatus({
    required Map<String, dynamic> requestParams,
  }) async {
    final result =
        await myWalletUseCase.updateRequestStatus(requestParams: requestParams);
    return result.fold((l) => PaymentResponseEntity(),
        (r) => r.entity ?? PaymentResponseEntity());
  }

  Stream<List<RequestsEntity>> get getRequestsList => Rx.combineLatest4(
          _complemtedRequests.stream,
          _rejectedRequests.stream,
          _pendingRequests.stream,
          _allMDRequests.stream, (List<RequestsEntity> complemtedRequests,
              List<RequestsEntity> rejectedRequests,
              List<RequestsEntity> pendingRequests,
              List<RequestsEntity> allMDRequests) {
        List<RequestsEntity> requests = [];
        requests.addAll(pendingRequests);
        requests.addAll(complemtedRequests);
        requests.addAll(rejectedRequests);
        requests.addAll(allMDRequests);
        requests.sort(
            (a, b) => (b.creationDate ?? '').compareTo(a.creationDate ?? ''));
        return requests;
      });
  Stream<List<RequestsEntity>> get getActionRequestsList =>
      Rx.combineLatest2(_pendingDEDRequests.stream, _pendingMDRequests.stream,
          (List<RequestsEntity> pendingDEDRequests,
              List<RequestsEntity> pendingMDRequests) {
        List<RequestsEntity> requests = [];
        requests.addAll(pendingDEDRequests);
        requests.addAll(pendingMDRequests);
        requests.sort(
            (a, b) => (b.creationDate ?? '').compareTo(a.creationDate ?? ''));
        return requests;
      });

  Stream<List<RequestsEntity>> get getDEDRequestsList => Rx.combineLatest3(
          _complemtedRequests.stream,
          _rejectedRequests.stream,
          _pendingRequests.stream, (List<RequestsEntity> complemtedRequests,
              List<RequestsEntity> rejectedRequests,
              List<RequestsEntity> pendingRequests) {
        List<RequestsEntity> requests = [];
        requests.addAll(pendingRequests);
        requests.addAll(complemtedRequests);
        requests.addAll(rejectedRequests);
        requests.sort(
            (a, b) => (b.creationDate ?? '').compareTo(a.creationDate ?? ''));
        return requests;
      });
  Stream<double> get getTotalFine =>
      Rx.combineLatest2(_totalInduvidualFine.stream, _totalEstFine.stream, (
        double totalInduvidualFine,
        double totalEstFine,
      ) {
        return totalInduvidualFine + totalEstFine;
      });
  String _getErrorMessage(Failure failure) {
    return failure.errorMessage;
  }
}
