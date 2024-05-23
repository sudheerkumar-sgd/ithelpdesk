import 'package:dartz/dartz.dart';
import 'package:smartuaq/core/error/failures.dart';
import 'package:smartuaq/data/model/api_response_model.dart';
import 'package:smartuaq/data/model/login_model.dart';
import 'package:smartuaq/data/remote/api_urls.dart';
import 'package:smartuaq/domain/entities/api_entity.dart';
import 'package:smartuaq/domain/entities/login_entity.dart';
import 'package:smartuaq/domain/repository/apis_repository.dart';
import 'package:smartuaq/domain/usecase/base_usecase.dart';

class LoginUseCase extends BaseUseCase {
  final ApisRepository apisRepository;
  LoginUseCase({required this.apisRepository});
  
  @override
  ApisRepository getApisRepository() {
    return apisRepository;
  }

  Future<Either<Failure, ApiEntity<LoginEntity>>> doLogin(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.post<LoginModel>(
      apiUrl: uaePassLoginApiUrl,
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

  Future<Either<Failure, ApiEntity<LoginEntity>>> doLoginWithCredentials(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.post<LoginModel>(
      apiUrl: credentialsLoginApiUrl,
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

  Future<Either<Failure, ApiEntity<UpdateFirbaseTokenEntity>>>
      updateFirbaseToken({required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.post<UpdateFirbaseTokenModel>(
      apiUrl: updateFireBaseTokenApiUrl,
      requestParams: requestParams,
      responseModel: UpdateFirbaseTokenModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<UpdateFirbaseTokenEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<UserEntity>>> getUserData(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<UserModel>(
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
}
