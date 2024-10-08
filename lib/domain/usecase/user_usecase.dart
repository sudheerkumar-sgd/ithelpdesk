import 'package:dartz/dartz.dart';
import 'package:ithelpdesk/core/error/failures.dart';
import 'package:ithelpdesk/data/model/api_response_model.dart';
import 'package:ithelpdesk/data/model/login_model.dart';
import 'package:ithelpdesk/data/remote/api_urls.dart';
import 'package:ithelpdesk/domain/entities/api_entity.dart';
import 'package:ithelpdesk/domain/entities/user_entity.dart';
import 'package:ithelpdesk/domain/repository/apis_repository.dart';
import 'package:ithelpdesk/domain/usecase/base_usecase.dart';

import '../../data/model/master_data_models.dart';
import '../../data/model/single_data_model.dart';
import '../entities/master_data_entities.dart';
import '../entities/single_data_entity.dart';

class UserUseCase extends BaseUseCase {
  final ApisRepository apisRepository;
  UserUseCase({required this.apisRepository});

  @override
  ApisRepository getApisRepository() {
    return apisRepository;
  }

  Future<Either<Failure, ApiEntity<LoginEntity>>> validateUser(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.post<LoginModel>(
      apiUrl: validateUserApiUrl,
      requestParams: requestParams,
      responseModel: LoginModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<LoginEntity>();
      return Right(apiResponseEntity);
    });
  }

  @override
  Future<Either<Failure, ApiEntity<UserEntity>>> getUserData(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<UserModel>(
      apiUrl: userDetailsApiUrl,
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

  Future<Either<Failure, ApiEntity<ListEntity>>> getDirectoryEmployees({
    required Map<String, dynamic> requestParams,
  }) async {
    var apiResponse = await apisRepository.get<ListModel>(
      apiUrl: directoryEmployeesApiUrl,
      requestParams: requestParams,
      responseModel: ListModel.fromDirectoryEmployeesJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<ListEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<SingleDataEntity>>> updateVactionStatus(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse =
        await apisRepository.postWithMultipartData<SingleDataModel>(
      apiUrl: updateVactionStatusUrl,
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
