import 'package:dartz/dartz.dart';
import 'package:ithelpdesk/core/config/base_url_config.dart';
import 'package:ithelpdesk/core/config/flavor_config.dart';
import 'package:ithelpdesk/core/error/failures.dart';
import 'package:ithelpdesk/data/local/user_data_db.dart';
import 'package:ithelpdesk/data/model/api_response_model.dart';
import 'package:ithelpdesk/data/model/base_model.dart';
import 'package:ithelpdesk/data/model/login_model.dart';
import 'package:ithelpdesk/data/model/requests_model.dart';
import 'package:ithelpdesk/data/model/services_model.dart';
import 'package:ithelpdesk/data/remote/api_urls.dart';
import 'package:ithelpdesk/domain/entities/api_entity.dart';
import 'package:ithelpdesk/domain/entities/base_entity.dart';
import 'package:ithelpdesk/domain/entities/login_entity.dart';
import 'package:ithelpdesk/domain/entities/requests_entity.dart';
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

  Future<Either<Failure, ApiEntity<ServiceCategoryListEntity>>> getAllServices(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<ServiceCategoryListModel>(
        apiUrl: allServicesApiUrl,
        requestParams: requestParams,
        responseModel: ServiceCategoryListModel.fromJson,
        cachePath: 'services.json');
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<ServiceCategoryListEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<ServiceCategoryListEntity>>>
      getServicesDataFromLocal(
          {required Map<String, dynamic> requestParams}) async {
    var apiResponse =
        await apisRepository.getFromCache<ServiceCategoryListModel>(
      filePath: 'services.json',
      responseModel: ServiceCategoryListModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<ServiceCategoryListEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<MostUsedServicesEntity>>>
      getMostUsedServices({required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<MostUsedServicesModel>(
        apiUrl: mostServicesApiUrl,
        requestParams: requestParams,
        responseModel: MostUsedServicesModel.fromJson,
        cachePath: 'mostUsedServices.json');
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<MostUsedServicesEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<MostUsedServicesEntity>>>
      getMostUsedServicesFromLocal(
          {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.getFromCache<MostUsedServicesModel>(
      filePath: 'mostUsedServices.json',
      responseModel: MostUsedServicesModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<MostUsedServicesEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<NotificationListEntity>>> getNotifications(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<NotificationListModel>(
      apiUrl: myNotificationsApiUrl,
      requestParams: requestParams,
      responseModel: NotificationListModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<NotificationListEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<NotificationListEntity>>> clearNotifications(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.post<NotificationListModel>(
      apiUrl: clearNotificationsApiUrl,
      requestParams: requestParams,
      responseModel: NotificationListModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<NotificationListEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, List<ServiceEntity>>> saveFavoritesData(
      {required UserDataDB userDB,
      required List<ServiceEntity> toBeAddfavorites}) async {
    try {
      var favoriteData =
          userDB.get(UserDataDB.userFavorites, defaultValue: []) as List;
      var favorites = [];
      favorites.addAll(favoriteData);
      var index = favorites.indexWhere((element) => element['ID'] == 0);
      for (int i = 0; i < toBeAddfavorites.length; i++) {
        final favoriteEntity = toBeAddfavorites[i];
        favorites.insert(i + index, {
          'ID': favoriteEntity.id ?? 0,
          'Title': '${favoriteEntity.title}',
          'TitleAr': '${favoriteEntity.titleAr}',
          'Icon': '${favoriteEntity.icon}',
          'ItemURL': '${favoriteEntity.itemURL}',
          'Fees': '${favoriteEntity.fees}',
          'DescriptionAr': '${favoriteEntity.descriptionAr}',
          'DescriptionEn': '${favoriteEntity.descriptionEn}',
          'EligibleUsersList': favoriteEntity.eligibleUsers,
        });
      }
      userDB.put(UserDataDB.userFavorites, favorites);
      favoriteData =
          userDB.get(UserDataDB.userFavorites, defaultValue: []) as List;
      final result = favoriteData
          .map((eventJson) =>
              ServiceModel.fromFavoriteJson(eventJson).toEntity())
          .toList();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<ServiceEntity>>> removeFavoritesData(
      {required UserDataDB userDB,
      required ServiceEntity favoriteEntity}) async {
    try {
      var favoriteData =
          userDB.get(UserDataDB.userFavorites, defaultValue: []) as List;
      var favorites = favoriteData;
      var index =
          favorites.indexWhere((element) => element['ID'] == favoriteEntity.id);
      favorites.removeAt(index);
      userDB.put(UserDataDB.userFavorites, favorites);
      favoriteData =
          userDB.get(UserDataDB.userFavorites, defaultValue: []) as List;
      final result = favoriteData
          .map((eventJson) => ServiceModel.fromJson(eventJson).toEntity())
          .toList();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, ApiEntity<ECCategoriesListEntity>>> getECCategories(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<ECCategoriesListModel>(
      apiUrl: myCityProblemCategoriesApiUrl,
      requestParams: requestParams,
      responseModel: ECCategoriesListModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<ECCategoriesListEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<BaseEntity>>> submitECProblem(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.post<BaseModel>(
      apiUrl: myCityProblemSubmitApiUrl,
      requestParams: requestParams,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<BaseEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<ReportCaseResponseEntity>>> submitReportCase(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse =
        await apisRepository.postWithCustomBaseUrl<ReportCaseResponseModel>(
      baseUrl: FlavorConfig.instance.values.policeDomainBaseUrl,
      apiUrl: reportACase,
      requestParams: requestParams,
      responseModel: ReportCaseResponseModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<ReportCaseResponseEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<ReportCaseResponseEntity>>>
      submitOTPReportCase({required Map<String, dynamic> requestParams}) async {
    var apiResponse =
        await apisRepository.postWithCustomBaseUrl<ReportCaseResponseModel>(
      baseUrl: FlavorConfig.instance.values.policeDomainBaseUrl,
      apiUrl: reportCaseOTPValidation,
      requestParams: requestParams,
      responseModel: ReportCaseResponseModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<ReportCaseResponseEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, ApiEntity<ReportCaseResponseEntity>>>
      resendOTPReportCase({required Map<String, dynamic> requestParams}) async {
    var apiResponse =
        await apisRepository.postWithCustomBaseUrl<ReportCaseResponseModel>(
      baseUrl: FlavorConfig.instance.values.policeDomainBaseUrl,
      apiUrl: reportCaseResendOTP,
      requestParams: requestParams,
      responseModel: ReportCaseResponseModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      var apiResponseEntity = r.toEntity<ReportCaseResponseEntity>();
      return Right(apiResponseEntity);
    });
  }

  Future<Either<Failure, String>> uploadPoliceAttachment(
      {required String content}) async {
    var apiResponse = await apisRepository.postWithStringContent(
        baseUrl: baseUrlPoliceAttachment,
        apiUrl: '',
        content: content,
        contentTypeHeader: 'text/xml;charset=utf-8');
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      return Right(r);
    });
  }

  Future<Either<Failure, List<EstablishmentEntity>>> getEstablishmets(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await apisRepository.get<UserModel>(
      apiUrl: getEstablishmentsApiUrl,
      requestParams: requestParams,
      responseModel: UserModel.fromEstablishmentsJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      return Right(r.toEntity<UserEntity>().entity?.establishments ?? []);
    });
  }

  Future<Either<Failure, ApiEntity<ServiceDetailsEntity>>> getServiceDetails(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse =
        await apisRepository.getWithCustomBaseUrl<ServiceDetailsModel>(
      baseUrl: FlavorConfig.instance.values.mdSOABaseUrl,
      apiUrl: serviceDetailsApiUrl,
      requestParams: requestParams,
      responseModel: ServiceDetailsModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      return Right(r.toEntity<ServiceDetailsEntity>());
    });
  }

  Future<Either<Failure, ApiEntity<EmailSendResponseEntity>>> sendEmailSupport(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse =
        await apisRepository.postWithCustomBaseUrl<EmailSendResponseModel>(
      baseUrl: FlavorConfig.instance.values.mdSOABaseUrl,
      apiUrl: sendEmailSupportApiUrl,
      requestParams: requestParams,
      responseModel: EmailSendResponseModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      return Right(r.toEntity<EmailSendResponseEntity>());
    });
  }
}
