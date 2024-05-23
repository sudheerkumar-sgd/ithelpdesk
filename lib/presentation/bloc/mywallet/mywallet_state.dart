part of 'mywallet_bloc.dart';

abstract class MyWalletState extends Equatable {}

class Init extends MyWalletState {
  @override
  List<Object?> get props => [];
}

class OnMyWalletLoading extends MyWalletState {
  @override
  List<Object?> get props => [];
}

class OnFinesResponse extends MyWalletState {
  final ApiEntity<FinesListEntity> finesResponse;

  OnFinesResponse({required this.finesResponse});
  @override
  List<Object?> get props => [finesResponse];
}

class OnVerifyResponse extends MyWalletState {
  final ApiEntity<DocumentVerifyEntity> verifyResponse;

  OnVerifyResponse({required this.verifyResponse});
  @override
  List<Object?> get props => [verifyResponse];
}

class OnMyRequestDetailsResponse extends MyWalletState {
  final ApiEntity<RequestsEntity> requestDetails;

  OnMyRequestDetailsResponse({required this.requestDetails});
  @override
  List<Object?> get props => [requestDetails];
}

class OnGetDocumentResponse extends MyWalletState {
  final ApiEntity<DocumentVerifyEntity> getDocumentResponse;

  OnGetDocumentResponse({required this.getDocumentResponse});
  @override
  List<Object?> get props => [getDocumentResponse];
}

class OnPaymentsResponse extends MyWalletState {
  final ApiEntity<PaymentsListEntity> payments;

  OnPaymentsResponse({required this.payments});
  @override
  List<Object?> get props => [payments];
}

class OnMyDocumentsResponse extends MyWalletState {
  final ApiEntity<MyDocumentsListEntity> documents;

  OnMyDocumentsResponse({required this.documents});
  @override
  List<Object?> get props => [documents];
}

class OnMyWalletApiError extends MyWalletState {
  final String message;

  OnMyWalletApiError({required this.message});
  @override
  List<Object?> get props => [message];
}
