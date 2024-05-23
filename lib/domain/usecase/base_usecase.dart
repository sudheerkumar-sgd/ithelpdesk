import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:smartuaq/core/config/flavor_config.dart';
import 'package:smartuaq/core/error/failures.dart';
import 'package:smartuaq/data/model/api_response_model.dart';
import 'package:smartuaq/data/model/login_model.dart';
import 'package:smartuaq/data/model/request_data_models.dart';
import 'package:smartuaq/data/remote/api_urls.dart';
import 'package:smartuaq/domain/entities/api_entity.dart';
import 'package:smartuaq/domain/entities/login_entity.dart';
import 'package:smartuaq/domain/entities/request_form_entities.dart';
import 'package:smartuaq/domain/repository/apis_repository.dart';

abstract class BaseUseCase {
  Future<Either<Failure, ApiEntity<UserEntity>>> getUserData(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await getApisRepository.call().get<UserModel>(
          apiUrl: getUserDataApiUrl,
          requestParams: requestParams,
          responseModel: UserModel.fromJson,
        );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<UserEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<PaymentResponseEntity>>> requestPaymnetView(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await getApisRepository
        .call()
        .postWithCustomBaseUrl<PaymentResponseModel>(
          baseUrl: FlavorConfig.instance.values.mdPortalBaseUrl,
          apiUrl: requestPaymentFormApiUrl,
          requestParams: requestParams,
          responseModel: PaymentResponseModel.fromJson,
        );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<PaymentResponseEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<PaymentResponseEntity>>> updateRequestStatus(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await getApisRepository
        .call()
        .postWithCustomBaseUrl<PaymentResponseModel>(
          baseUrl: FlavorConfig.instance.values.mdPortalBaseUrl,
          apiUrl: requestStatusApiUrl,
          requestParams: requestParams,
          responseModel: PaymentResponseModel.fromJson,
        );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<PaymentResponseEntity>();
      return Right(apiResponseEntity);
    });
  }

  ApisRepository getApisRepository();
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
