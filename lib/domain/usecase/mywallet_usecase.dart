import 'package:dartz/dartz.dart';
import 'package:smartuaq/core/config/flavor_config.dart';
import 'package:smartuaq/core/error/failures.dart';
import 'package:smartuaq/data/model/api_response_model.dart';
import 'package:smartuaq/data/model/mywallet_model.dart';
import 'package:smartuaq/data/model/requests_model.dart';
import 'package:smartuaq/data/remote/api_urls.dart';
import 'package:smartuaq/domain/entities/api_entity.dart';
import 'package:smartuaq/domain/entities/mywallet_entity.dart';
import 'package:smartuaq/domain/entities/requests_entity.dart';
import 'package:smartuaq/domain/repository/apis_repository.dart';
import 'package:smartuaq/domain/usecase/base_usecase.dart';

class MyWalletUseCase extends BaseUseCase {
  final ApisRepository apisRepository;
  MyWalletUseCase({required this.apisRepository});

  @override
  ApisRepository getApisRepository() {
    return apisRepository;
  }

  Future<Either<Failure, ApiEntity<RequestsListEntity>>> getRequests(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<RequestsListModel>(
      apiUrl: getMyRequestsApiUrl,
      requestParams: requestParams,
      responseModel: RequestsListModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<RequestsListEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<RequestsListEntity>>> getMyDEDRequests(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<RequestsListModel>(
      //baseUrl: FlavorConfig.instance.values.mdPortalBaseUrl,
      apiUrl: myRequestsPortalApiUrl,
      requestParams: requestParams,
      responseModel: RequestsListModel.fromMyRequestsJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<RequestsListEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<RequestsListEntity>>> getMyRequests(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse =
        await apisRepository.getWithCustomBaseUrl<RequestsListModel>(
      baseUrl: FlavorConfig.instance.values.mdSOABaseUrl,
      apiUrl: getMyRequestsApiUrl,
      requestParams: requestParams,
      responseModel: RequestsListModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<RequestsListEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<RequestsEntity>>> getRequestDetails(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.getWithCustomBaseUrl<RequestsModel>(
      baseUrl: FlavorConfig.instance.values.mdSOABaseUrl,
      apiUrl: getRequestsDetails,
      requestParams: requestParams,
      responseModel: RequestsModel.fromDetailsJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<RequestsEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<FinesListEntity>>> getMyFines(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<FinesResponseModel>(
      //baseUrl: FlavorConfig.instance.values.mdPortalBaseUrl,
      apiUrl: getMyFinesApiUrl,
      requestParams: requestParams,
      responseModel: FinesResponseModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<FinesListEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<FinesListEntity>>> getMyTotalFine(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse =
        await apisRepository.getWithCustomBaseUrl<FinesResponseModel>(
      baseUrl: FlavorConfig.instance.values.mdSOABaseUrl,
      apiUrl: getMyFinesMDApiUrl,
      requestParams: requestParams,
      responseModel: FinesResponseModel.fromMDJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<FinesListEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<FinesListEntity>>> getMyEstFinesList(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.postWithCustomBaseUrl(
      baseUrl: FlavorConfig.instance.values.mdSOABaseUrl,
      apiUrl: getMyEstFinesMDApiUrl,
      requestParams: requestParams,
      responseModel: FinesResponseModel.fromMDJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<FinesListEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<DocumentVerifyEntity>>> verifyDocument(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<DocumentVerifyModel>(
      apiUrl: verfiyDocumentMoblieApiUrl,
      requestParams: requestParams,
      responseModel: DocumentVerifyModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<DocumentVerifyEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<DocumentVerifyEntity>>> getDocument(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<DocumentVerifyModel>(
      apiUrl: getDocumentApiUrl,
      requestParams: requestParams,
      responseModel: DocumentVerifyModel.fromGetDocumentJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<DocumentVerifyEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<DocumentVerifyEntity>>> getUserDocument(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<DocumentVerifyModel>(
      apiUrl: getDocumentApiUrl,
      requestParams: requestParams,
      responseModel: DocumentVerifyModel.fromGetDocumentJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<DocumentVerifyEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<PaymentsListEntity>>> getPaymentsList(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<PaymentsListModel>(
      apiUrl: getMyPaymentApiUrl,
      requestParams: requestParams,
      responseModel: PaymentsListModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<PaymentsListEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<MyDocumentsListEntity>>> getMyDocuments(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse =
        await apisRepository.getWithCustomBaseUrl<MyDocumentsListModel>(
      baseUrl: FlavorConfig.instance.values.mdSOABaseUrl,
      apiUrl: myDocumentsApiUrl,
      requestParams: requestParams,
      responseModel: MyDocumentsListModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<MyDocumentsListEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<MyDocumentsListEntity>>> getMyLicenses(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<MyDocumentsListModel>(
      apiUrl: myLicenseApiUrl,
      requestParams: requestParams,
      responseModel: MyDocumentsListModel.fromLicenseJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<MyDocumentsListEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<MyDocumentsListEntity>>> getMyPermits(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<MyDocumentsListModel>(
      apiUrl: myPermitsApiUrl,
      requestParams: requestParams,
      responseModel: MyDocumentsListModel.fromPermitJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<MyDocumentsListEntity>();
      return Right(apiResponseEntity);
    });
  }
}
