import 'package:equatable/equatable.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/data/local/user_data_db.dart';
import 'package:ithelpdesk/domain/entities/base_entity.dart';
import 'package:ithelpdesk/domain/entities/login_entity.dart';
import 'package:ithelpdesk/domain/entities/requests_entity.dart';
import 'package:ithelpdesk/domain/entities/services_entity.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/api_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecase/services_usecase.dart';
import 'package:rxdart/rxdart.dart';

part 'services_state.dart';

class ServicesBloc extends Cubit<ServicesState> {
  final ServicesUseCase servicesUseCase;
  ServicesBloc({required this.servicesUseCase}) : super(Init());

  final BehaviorSubject<ApiEntity<ServiceCategoryListEntity>> _allServices =
      BehaviorSubject<ApiEntity<ServiceCategoryListEntity>>();
  final BehaviorSubject<ApiEntity<MostUsedServicesEntity>> _mostUsedServices =
      BehaviorSubject<ApiEntity<MostUsedServicesEntity>>();

  Future<void> getServices() async {
    emit(OnLoading());
    final result = await servicesUseCase.getAllServices(requestParams: {});
    _allServices.sink.add(result.fold((l) => ApiEntity(), (r) => r));
    emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)), (r) {
      isServicesLoaded = true;
      return OnServicesSuccess(serviceCategoriesEntity: r);
    }));
  }

  Future<void> getNotifications() async {
    emit(OnLoading());
    final result = await servicesUseCase.getNotifications(requestParams: {});
    emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)),
        (r) => OnNotificationsResponse(notifications: r)));
  }

  Future<void> clearNotifications() async {
    emit(OnLoading());
    final result = await servicesUseCase.clearNotifications(requestParams: {});
    emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)),
        (r) => OnNotificationsResponse(notifications: r)));
  }

  Future<void> saveFavoritesdData(
      {required UserDataDB userDB,
      required List<ServiceEntity> favorites,
      bool doEmitResponse = true}) async {
    final result = await servicesUseCase.saveFavoritesData(
        userDB: userDB, toBeAddfavorites: favorites);
    if (doEmitResponse) {
      emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)),
          (r) => OnFavoriteSuccess(favoriteServices: r)));
    }
  }

  Future<void> removeFavoritesdData(
      {required UserDataDB userDB,
      required ServiceEntity favoriteEntity,
      bool doEmitResponse = true}) async {
    final result = await servicesUseCase.removeFavoritesData(
        userDB: userDB, favoriteEntity: favoriteEntity);
    if (doEmitResponse) {
      emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)),
          (r) => OnFavoriteSuccess(favoriteServices: r)));
    }
  }

  Future<void> getServicesFromLocal() async {
    final result =
        await servicesUseCase.getServicesDataFromLocal(requestParams: {});
    _allServices.sink.add(result.fold((l) => ApiEntity(), (r) => r));
    emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)),
        (r) => OnServicesSuccess(serviceCategoriesEntity: r)));
  }

  Future<void> getMostUsedServices({bool? fromLocal}) async {
    final result = fromLocal ?? false
        ? await servicesUseCase.getMostUsedServicesFromLocal(requestParams: {})
        : await servicesUseCase.getMostUsedServices(requestParams: {});
    _mostUsedServices.sink.add(result.fold((l) => ApiEntity(), (r) => r));

    emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)),
        (r) => OnMostUsedServicesSuccess(mostUsedServicesEntity: r)));
  }

  Stream<List<ServiceEntity>> get getMostUsedServicesList =>
      Rx.combineLatest2(_allServices.stream, _mostUsedServices.stream,
          (ApiEntity<ServiceCategoryListEntity> allServices,
              ApiEntity<MostUsedServicesEntity> mostUsedServices) {
        List<ServiceEntity> services = [];
        List<ServiceEntity> result = [];
        allServices.entity?.serviceCategories.forEach((element) {
          services.addAll(element.services);
        });
        if (mostUsedServices.entity?.mostUsedServices.isNotEmpty == true) {
          mostUsedServices.entity?.mostUsedServices.add(233);
        }
        for (int i = 0; i < services.length; i++) {
          if (mostUsedServices.entity?.mostUsedServices
                  .contains(services[i].id) ==
              true) {
            result.add(services[i]);
          }
        }
        return result;
      });
  Future<ECCategoriesListEntity> getECCategories() async {
    final result = await servicesUseCase.getECCategories(requestParams: {});
    return result.fold((l) {
      return ECCategoriesListEntity();
    }, (r) {
      return r.entity ?? ECCategoriesListEntity();
    });
  }

  Future<void> submitECProblem(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnLoading());
    final result =
        await servicesUseCase.submitECProblem(requestParams: requestParams);
    emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)),
        (r) => OnECProblemSubmit(onECProblemSubmitResponse: r)));
  }

  Future<void> submitReportCase(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnLoading());
    final result =
        await servicesUseCase.submitReportCase(requestParams: requestParams);
    emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)),
        (r) => OnSubmitReportCase(reportCaseResponseEntity: r)));
  }

  Future<void> submitOTPReportCase(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnLoading());
    final result =
        await servicesUseCase.submitOTPReportCase(requestParams: requestParams);
    emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)),
        (r) => OnOTPSubmitResponse(reportCaseResponseEntity: r)));
  }

  Future<void> resendOTPReportCase(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnLoading());
    final result =
        await servicesUseCase.resendOTPReportCase(requestParams: requestParams);
    emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)),
        (r) => OnResendOTPResponse(reportCaseResponseEntity: r)));
  }

  Future<void> uploadPoliceAttachment({required String content}) async {
    emit(OnLoading());
    final result =
        await servicesUseCase.uploadPoliceAttachment(content: content);
    emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)),
        (r) => OnUploadPoliceAttachment(response: r)));
  }

  Future<ServicesState> getEstablishments(
      {required Map<String, dynamic> requestParams}) async {
    final result =
        await servicesUseCase.getEstablishmets(requestParams: requestParams);
    return result.fold((l) => OnApiError(message: _getErrorMessage(l)),
        (r) => OnEstablishmentsSuccess(establishments: r));
  }

  Future<void> getServiceDetails(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnLoading());
    final result =
        await servicesUseCase.getServiceDetails(requestParams: requestParams);
    emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)),
        (r) => OnServiceDetailsResponse(serviceDetailsEntity: r)));
  }

  Future<void> sendEmailSupport(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnLoading());
    final result =
        await servicesUseCase.sendEmailSupport(requestParams: requestParams);
    emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)),
        (r) => OnEmailSubmitSuccess(emailSubmitSuccess: r)));
  }

  String _getErrorMessage(Failure failure) {
    return failure.errorMessage;
  }
}
