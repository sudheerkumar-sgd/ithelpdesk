import 'package:equatable/equatable.dart';
import 'package:ithelpdesk/domain/entities/base_entity.dart';
import 'package:ithelpdesk/domain/entities/dashboard_entity.dart';
import 'package:ithelpdesk/domain/entities/master_data_entities.dart';
import 'package:ithelpdesk/domain/entities/requests_entity.dart';
import 'package:ithelpdesk/domain/entities/services_entity.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/api_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecase/services_usecase.dart';

part 'services_state.dart';

class ServicesBloc extends Cubit<ServicesState> {
  final ServicesUseCase servicesUseCase;
  ServicesBloc({required this.servicesUseCase}) : super(Init());

  Future<void> getDashboardData(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnLoading());
    final result =
        await servicesUseCase.getDashboardData(requestParams: requestParams);
    emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)), (r) {
      return OnDashboardSuccess(dashboardEntity: r);
    }));
  }

  Future<void> createRequest(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnLoading());
    final result =
        await servicesUseCase.createRequest(requestParams: requestParams);
    emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)), (r) {
      return OnCreateTicketSuccess(ticketsEntity: r);
    }));
  }

  Future<ListEntity> getTicketHistory(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnLoading());
    final result =
        await servicesUseCase.getTicketHistory(requestParams: requestParams);
    return result.fold((l) => ListEntity(), (r) {
      return r.entity ?? ListEntity();
    });
  }

  String _getErrorMessage(Failure failure) {
    return failure.errorMessage;
  }
}
