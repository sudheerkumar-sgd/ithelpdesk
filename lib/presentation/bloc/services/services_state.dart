part of 'services_bloc.dart';

abstract class ServicesState extends Equatable {}

class Init extends ServicesState {
  @override
  List<Object?> get props => [];
}

class OnLoading extends ServicesState {
  @override
  List<Object?> get props => [];
}

class OnDashboardSuccess extends ServicesState {
  final ApiEntity<DashboardEntity> dashboardEntity;

  OnDashboardSuccess({required this.dashboardEntity});
  @override
  List<Object?> get props => [dashboardEntity];
}

class OnCreateTicketSuccess extends ServicesState {
  final String createTicketResponse;

  OnCreateTicketSuccess({required this.createTicketResponse});
  @override
  List<Object?> get props => [createTicketResponse];
}

class OnUpdateTicket extends ServicesState {
  final ApiEntity<TicketEntity> onUpdateTicketResult;

  OnUpdateTicket({required this.onUpdateTicketResult});
  @override
  List<Object?> get props => [onUpdateTicketResult];
}

class OnExportExcel extends ServicesState {
  final bool response;

  OnExportExcel({required this.response});
  @override
  List<Object?> get props => [response];
}

class OnMostUsedServicesSuccess extends ServicesState {
  final ApiEntity<MostUsedServicesEntity> mostUsedServicesEntity;

  OnMostUsedServicesSuccess({required this.mostUsedServicesEntity});
  @override
  List<Object?> get props => [mostUsedServicesEntity];
}

class OnFavoriteSuccess extends ServicesState {
  final List<ServiceEntity> favoriteServices;

  OnFavoriteSuccess({required this.favoriteServices});
  @override
  List<Object?> get props => [favoriteServices];
}

class OnECCategoriesSuccess extends ServicesState {
  final ApiEntity<ECCategoriesListEntity> executiveCouncilListEntity;

  OnECCategoriesSuccess({required this.executiveCouncilListEntity});
  @override
  List<Object?> get props => [executiveCouncilListEntity];
}

class OnECProblemSubmit extends ServicesState {
  final ApiEntity<BaseEntity> onECProblemSubmitResponse;

  OnECProblemSubmit({required this.onECProblemSubmitResponse});
  @override
  List<Object?> get props => [onECProblemSubmitResponse];
}

class OnUploadPoliceAttachment extends ServicesState {
  final String response;

  OnUploadPoliceAttachment({required this.response});
  @override
  List<Object?> get props => [response];
}

class OnSubmitReportCase extends ServicesState {
  final ApiEntity<ReportCaseResponseEntity> reportCaseResponseEntity;

  OnSubmitReportCase({required this.reportCaseResponseEntity});
  @override
  List<Object?> get props => [reportCaseResponseEntity];
}

class OnOTPSubmitResponse extends ServicesState {
  final ApiEntity<ReportCaseResponseEntity> reportCaseResponseEntity;

  OnOTPSubmitResponse({required this.reportCaseResponseEntity});
  @override
  List<Object?> get props => [reportCaseResponseEntity];
}

class OnResendOTPResponse extends ServicesState {
  final ApiEntity<ReportCaseResponseEntity> reportCaseResponseEntity;

  OnResendOTPResponse({required this.reportCaseResponseEntity});
  @override
  List<Object?> get props => [reportCaseResponseEntity];
}

class OnServiceDetailsResponse extends ServicesState {
  final ApiEntity<ServiceDetailsEntity> serviceDetailsEntity;

  OnServiceDetailsResponse({required this.serviceDetailsEntity});
  @override
  List<Object?> get props => [serviceDetailsEntity];
}

class OnEmailSubmitSuccess extends ServicesState {
  final ApiEntity<EmailSendResponseEntity> emailSubmitSuccess;

  OnEmailSubmitSuccess({required this.emailSubmitSuccess});

  @override
  List<Object?> get props => [emailSubmitSuccess];
}

class OnUpdateTicketSuccess extends ServicesState {
  final String updateTicketResponse;

  OnUpdateTicketSuccess({required this.updateTicketResponse});
  @override
  List<Object?> get props => [updateTicketResponse];
}

class OnApiError extends ServicesState {
  final String message;

  OnApiError({required this.message});
  @override
  List<Object?> get props => [message];
}
