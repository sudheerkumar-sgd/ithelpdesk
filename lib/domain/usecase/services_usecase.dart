import 'package:dartz/dartz.dart';
import 'package:ithelpdesk/core/error/failures.dart';
import 'package:ithelpdesk/data/model/api_response_model.dart';
import 'package:ithelpdesk/data/model/services_model.dart';
import 'package:ithelpdesk/data/remote/api_urls.dart';
import 'package:ithelpdesk/domain/entities/api_entity.dart';
import 'package:ithelpdesk/domain/entities/services_entity.dart';
import 'package:ithelpdesk/domain/repository/apis_repository.dart';
import 'package:ithelpdesk/domain/usecase/base_usecase.dart';

class ServicesUseCase extends BaseUseCase {
  final ApisRepository apisRepository;
  ServicesUseCase({required this.apisRepository});

  @override
  ApisRepository getApisRepository() {
    return apisRepository;
  }

  Future<Either<Failure, ApiEntity<ServiceCategoryListEntity>>>
      getDashboardData({required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<ServiceCategoryListModel>(
      apiUrl: dashboardApiUrl,
      requestParams: requestParams,
      responseModel: ServiceCategoryListModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<ServiceCategoryListEntity>();
      return Right(apiResponseEntity);
    });
  }
}
