import 'package:dartz/dartz.dart';
import 'package:ithelpdesk/core/error/failures.dart';
import 'package:ithelpdesk/data/model/api_response_model.dart';
import 'package:ithelpdesk/data/model/dashboard_model.dart';
import 'package:ithelpdesk/data/model/master_data_models.dart';
import 'package:ithelpdesk/data/model/single_data_model.dart';
import 'package:ithelpdesk/data/remote/api_urls.dart';
import 'package:ithelpdesk/domain/entities/api_entity.dart';
import 'package:ithelpdesk/domain/entities/dashboard_entity.dart';
import 'package:ithelpdesk/domain/entities/master_data_entities.dart';
import 'package:ithelpdesk/domain/repository/apis_repository.dart';
import 'package:ithelpdesk/domain/usecase/base_usecase.dart';

import '../entities/single_data_entity.dart';

class ServicesUseCase extends BaseUseCase {
  final ApisRepository apisRepository;
  ServicesUseCase({required this.apisRepository});

  @override
  ApisRepository getApisRepository() {
    return apisRepository;
  }

  Future<Either<Failure, ApiEntity<DashboardEntity>>> getDashboardData(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<DashboardModel>(
      apiUrl: dashboardApiUrl,
      requestParams: requestParams,
      responseModel: DashboardModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<DashboardEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<SingleDataEntity>>> createRequest(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.post<SingleDataModel>(
      apiUrl: createTicketApiUrl,
      requestParams: requestParams,
      responseModel: SingleDataModel.fromCreateRequest,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<SingleDataEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<ListEntity>>> getTicketHistory(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<ListModel>(
      apiUrl: ticketHistoryApiUrl,
      requestParams: requestParams,
      responseModel: ListModel.fromTicketHistoryJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<ListEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<ListEntity>>> getTicketComments(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<ListModel>(
      apiUrl: ticketCommentsApiUrl,
      requestParams: requestParams,
      responseModel: ListModel.fromTicketHistoryJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<ListEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<ListEntity>>> getTticketsByUser(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<ListModel>(
      apiUrl: ticketsByUserApiUrl,
      requestParams: requestParams,
      responseModel: ListModel.fromTicketsJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<ListEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<SingleDataEntity>>> updateTicketByStatus(
      {required String apiUrl,
      required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.post<SingleDataModel>(
      apiUrl: apiUrl,
      requestParams: requestParams,
      responseModel: SingleDataModel.fromCreateRequest,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<SingleDataEntity>();
      return Right(apiResponseEntity);
    });
  }
}
