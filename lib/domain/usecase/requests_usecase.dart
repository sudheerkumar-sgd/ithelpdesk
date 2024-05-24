import 'package:dartz/dartz.dart';
import 'package:ithelpdesk/core/config/flavor_config.dart';
import 'package:ithelpdesk/core/error/failures.dart';
import 'package:ithelpdesk/data/model/api_response_model.dart';
import 'package:ithelpdesk/data/model/request_data_models.dart';
import 'package:ithelpdesk/data/remote/api_urls.dart';
import 'package:ithelpdesk/domain/entities/api_entity.dart';
import 'package:ithelpdesk/domain/entities/request_form_entities.dart';
import 'package:ithelpdesk/domain/repository/apis_repository.dart';
import 'package:ithelpdesk/domain/usecase/base_usecase.dart';

class RequestsUseCase extends BaseUseCase {
  final ApisRepository apisRepository;
  RequestsUseCase({required this.apisRepository});

  @override
  ApisRepository getApisRepository() {
    return apisRepository;
  }

  Future<Either<Failure, ApiEntity<RequestsDataEntity>>> getRequestFormData(
      {required String serviceId,
      required Map<String, dynamic> requestParams}) async {
    var apiResponse =
        await apisRepository.getWithCustomBaseUrl<RequestDataModel>(
      baseUrl: FlavorConfig.instance.values.mdPortalBaseUrl,
      apiUrl: '$myRequestFormApiUrl$serviceId',
      requestParams: requestParams,
      responseModel: RequestDataModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<RequestsDataEntity>();
      return Right(apiResponseEntity);
    });
    // try {
    //   final apiResponse = await rootBundle.loadString(requestService);
    //   var apiResponseModel = ApiResponse<RequestDataModel>.fromJson(
    //       jsonDecode(apiResponse.isNotEmpty ? apiResponse : '{}'),
    //       RequestDataModel.fromJson);
    //   var apiResponseEntity = apiResponseModel.toEntity<RequestsDataEntity>();
    //   return Right(apiResponseEntity);
    // } catch (error) {
    //   return left(ServerFailure(error.toString()));
    // }
  }

  Future<Either<Failure, ApiEntity<DropdownDataEntity>>> getAccountTypes(
      {required String apiUrl,
      required Map<String, dynamic> requestParams}) async {
    var apiResponse =
        await apisRepository.getWithCustomBaseUrl<DropdownDataModel>(
      baseUrl: FlavorConfig.instance.values.mdPortalBaseUrl,
      apiUrl: '$baseServiceFormApiUrl$apiUrl',
      requestParams: requestParams,
      responseModel: DropdownDataModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<DropdownDataEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<UploadResponseEntity>>> uploadAttachment(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse =
        await apisRepository.postWithCustomBaseUrl<UploadResponseModel>(
      baseUrl: FlavorConfig.instance.values.mdPortalBaseUrl,
      apiUrl: uploadAttachmentUrl,
      requestParams: requestParams,
      responseModel: UploadResponseModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<UploadResponseEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<SubmitResponseEntity>>> submitRequest(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse =
        await apisRepository.postWithCustomBaseUrl<SubmitResponseModel>(
      baseUrl: FlavorConfig.instance.values.mdPortalBaseUrl,
      apiUrl: requestSubmitFormApiUrl,
      requestParams: requestParams,
      responseModel: SubmitResponseModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<SubmitResponseEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<HappinessMeterEntity>>>
      getHappinessMeterData(
          {required String url, Map<String, dynamic>? requestParams}) async {
    var apiResponse =
        await apisRepository.getWithCustomBaseUrl<HappinessMeterModel>(
      baseUrl: FlavorConfig.instance.values.mdPortalBaseUrl,
      apiUrl: '$happinessMeterApiUrl$url',
      requestParams: requestParams ?? {},
      responseModel: HappinessMeterModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<HappinessMeterEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<HappinessMeterEntity>>>
      submitHappinessMeterData(
          {required Map<String, dynamic> requestParams}) async {
    var apiResponse =
        await apisRepository.postWithCustomBaseUrl<HappinessMeterModel>(
      baseUrl: FlavorConfig.instance.values.mdPortalBaseUrl,
      apiUrl: submitHappinessMeterApiUrl,
      requestParams: requestParams,
      responseModel: HappinessMeterModel.fromJson,
      postAsArray: true,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<HappinessMeterEntity>();
      return Right(apiResponseEntity);
    });
  }
}
