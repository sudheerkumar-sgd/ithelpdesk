import 'package:dartz/dartz.dart';
import 'package:ithelpdesk/core/error/failures.dart';
import 'package:ithelpdesk/data/model/api_response_model.dart';
import 'package:ithelpdesk/data/model/ibtaker_model.dart';
import 'package:ithelpdesk/data/model/iso_model.dart';
import 'package:ithelpdesk/data/model/master_data_models.dart';
import 'package:ithelpdesk/data/model/single_data_model.dart';
import 'package:ithelpdesk/data/remote/api_urls.dart';
import 'package:ithelpdesk/domain/entities/api_entity.dart';
import 'package:ithelpdesk/domain/entities/ibtaker_entity.dart';
import 'package:ithelpdesk/domain/entities/iso_entity.dart';
import 'package:ithelpdesk/domain/entities/master_data_entities.dart';
import 'package:ithelpdesk/domain/entities/single_data_entity.dart';
import 'package:ithelpdesk/domain/repository/apis_repository.dart';
import 'package:ithelpdesk/domain/usecase/base_usecase.dart';

class ISOUseCase extends BaseUseCase {
  final ApisRepository apisRepository;
  ISOUseCase({required this.apisRepository});

  @override
  ApisRepository getApisRepository() {
    return apisRepository;
  }

  Future<Either<Failure, ApiEntity<SingleDataEntity>>> createISORequest(
      {required String apiUrl,
      required Map<String, dynamic> requestParams}) async {
    var apiResponse =
        await apisRepository.postWithMultipartData<SingleDataModel>(
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

  Future<Either<Failure, ApiEntity<CRRequestDataEntity>>> getCRRequests(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<CRRequestDataModel>(
      apiUrl: getCRRequestsApiUrl,
      requestParams: requestParams,
      responseModel: CRRequestDataModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<CRRequestDataEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<CRRequestEntity>>> getCRRequestDetails(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<CRRequestModel>(
      apiUrl: getCRRequestDetailsApiUrl,
      requestParams: requestParams,
      responseModel: CRRequestModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<CRRequestEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<ListEntity>>> getCRTransferEmployees(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<ListModel>(
      apiUrl: crTransferEmployeesApiUrl,
      requestParams: requestParams,
      responseModel: ListModel.fromEmployeesJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<ListEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<IbtakerListDataEntity>>>
      getMyAndTeamIbtakerIdeas(
          {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<IbtakerListDataModel>(
      apiUrl: myAndTeamIbtakerIdeasApiUrl,
      requestParams: requestParams,
      responseModel: IbtakerListDataModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<IbtakerListDataEntity>();
      return Right(apiResponseEntity);
    });
  }
}
