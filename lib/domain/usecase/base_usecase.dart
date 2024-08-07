import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ithelpdesk/core/error/failures.dart';
import 'package:ithelpdesk/data/model/api_response_model.dart';
import 'package:ithelpdesk/data/model/login_model.dart';
import 'package:ithelpdesk/data/remote/api_urls.dart';
import 'package:ithelpdesk/domain/entities/api_entity.dart';
import 'package:ithelpdesk/domain/repository/apis_repository.dart';

import '../entities/user_entity.dart';

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

  ApisRepository getApisRepository();
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
