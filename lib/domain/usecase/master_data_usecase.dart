import 'package:dartz/dartz.dart';
import 'package:ithelpdesk/core/error/failures.dart';
import 'package:ithelpdesk/data/model/api_response_model.dart';
import 'package:ithelpdesk/data/model/master_data_models.dart';
import 'package:ithelpdesk/data/remote/api_urls.dart';
import 'package:ithelpdesk/domain/entities/api_entity.dart';
import 'package:ithelpdesk/domain/entities/master_data_entities.dart';
import 'package:ithelpdesk/domain/repository/apis_repository.dart';
import 'package:ithelpdesk/domain/usecase/base_usecase.dart';

class MasterDataUseCase extends BaseUseCase {
  final ApisRepository apisRepository;
  MasterDataUseCase({required this.apisRepository});

  @override
  ApisRepository getApisRepository() {
    return apisRepository;
  }

  Future<Either<Failure, ApiEntity<ListEntity>>> getSubCategories(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<ListModel>(
      apiUrl: subcategoriesApiUrl,
      requestParams: requestParams,
      responseModel: ListModel.fromSubCategoryJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<ListEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<ListEntity>>> getReasons(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<ListModel>(
      apiUrl: reasonsApiUrl,
      requestParams: requestParams,
      responseModel: ListModel.fromReasonsJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<ListEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<ListEntity>>> getEservices(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<ListModel>(
      apiUrl: eservicesApiUrl,
      requestParams: requestParams,
      responseModel: ListModel.fromEserviceJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<ListEntity>();
      return Right(apiResponseEntity);
    });
  }
}
