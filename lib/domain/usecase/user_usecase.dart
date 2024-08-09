import 'package:dartz/dartz.dart';
import 'package:ithelpdesk/core/error/failures.dart';
import 'package:ithelpdesk/data/model/api_response_model.dart';
import 'package:ithelpdesk/data/model/login_model.dart';
import 'package:ithelpdesk/data/remote/api_urls.dart';
import 'package:ithelpdesk/domain/entities/api_entity.dart';
import 'package:ithelpdesk/domain/entities/user_credentials_entity.dart';
import 'package:ithelpdesk/domain/entities/user_entity.dart';
import 'package:ithelpdesk/domain/repository/apis_repository.dart';
import 'package:ithelpdesk/domain/usecase/base_usecase.dart';

class UserUseCase extends BaseUseCase {
  final ApisRepository apisRepository;
  UserUseCase({required this.apisRepository});

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
      if (apiResponseEntity.entity != null) {
        UserCredentialsEntity.create(apiResponseEntity.entity!);
      }
      return Right(apiResponseEntity);
    });
  }
}
