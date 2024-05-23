part of 'docverification_bloc.dart';

abstract class DocVerificationState extends Equatable {}

class Init extends DocVerificationState {
  @override
  List<Object?> get props => [];
}

class OnDocVerificationLoading extends DocVerificationState {
  @override
  List<Object?> get props => [];
}

class OnVerifyResponse extends DocVerificationState {
  final ApiEntity<DocumentVerifyEntity> verifyResponse;

  OnVerifyResponse({required this.verifyResponse});
  @override
  List<Object?> get props => [verifyResponse];
}

class OnGetDocumentResponse extends DocVerificationState {
  final ApiEntity<DocumentVerifyEntity> getDocumentResponse;

  OnGetDocumentResponse({required this.getDocumentResponse});
  @override
  List<Object?> get props => [getDocumentResponse];
}

class OnDocVerificationApiError extends DocVerificationState {
  final String message;

  OnDocVerificationApiError({required this.message});
  @override
  List<Object?> get props => [message];
}
