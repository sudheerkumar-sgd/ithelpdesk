import 'package:dartz/dartz.dart';
import 'package:ithelpdesk/core/error/failures.dart';
import 'package:ithelpdesk/data/model/api_response_model.dart';
import 'package:ithelpdesk/data/model/mywallet_model.dart';
import 'package:ithelpdesk/data/model/single_data_model.dart';
import 'package:ithelpdesk/data/remote/api_urls.dart';
import 'package:ithelpdesk/domain/entities/api_entity.dart';
import 'package:ithelpdesk/domain/entities/mywallet_entity.dart';
import 'package:ithelpdesk/domain/entities/single_data_entity.dart';
import 'package:ithelpdesk/domain/repository/apis_repository.dart';
import 'package:ithelpdesk/domain/usecase/base_usecase.dart';

class DocVerificationUseCase extends BaseUseCase {
  final ApisRepository apisRepository;
  DocVerificationUseCase({required this.apisRepository});

  @override
  ApisRepository getApisRepository() {
    return apisRepository;
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

  Future<Either<Failure, String>> getSessionId() async {
    var apiResponse = await apisRepository.get<SingleDataModel>(
      apiUrl: sessionIdApiUrl,
      requestParams: {},
      responseModel: SingleDataModel.fromSessionIDJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var sessionID = r.toEntity<SingleDataEntity>();
      return Right((sessionID.entity?.value ?? '').toString());
    });
  }

  Future<Either<Failure, String>> sendOTP(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.post<SingleDataModel>(
      apiUrl: sendOTPToMobileApiUrl,
      requestParams: requestParams,
      responseModel: SingleDataModel.fromSendOTP,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var response = r.toEntity<SingleDataEntity>();
      return Right((response.entity?.value ?? ''));
    });
  }

  Future<Either<Failure, String>> verifyOTP(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<SingleDataModel>(
      apiUrl: verifySMSOTP,
      requestParams: requestParams,
      responseModel: SingleDataModel.fromSendOTP,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var response = r.toEntity<SingleDataEntity>();
      return Right((response.entity?.value ?? false) ? 'Success' : 'Failure');
    });
  }
}
