// ignore_for_file: must_be_immutable

import 'package:ithelpdesk/core/common/log.dart';
import 'package:ithelpdesk/data/model/base_model.dart';
import 'package:ithelpdesk/domain/entities/services_entity.dart';

class ServiceCategoryListModel extends BaseModel {
  List<ServiceEntity> services = [];

  ServiceCategoryListModel();

  factory ServiceCategoryListModel.fromJson(Map<String, dynamic> json) {
    var serviceCategoriesModel = ServiceCategoryListModel();
    serviceCategoriesModel.services = json['Data'] != null
        ? (json['Data'] as List)
            .map((service) => ServiceCategoryModel.fromJson(service).toEntity())
            .toList()
        : [];
    return serviceCategoriesModel;
  }

  @override
  List<Object?> get props => [
        services,
      ];

  @override
  ServiceCategoryListEntity toEntity() {
    ServiceCategoryListEntity servicesEntity = ServiceCategoryListEntity();
    servicesEntity.serviceCategories = services;
    return servicesEntity;
  }
}

class ServiceCategoryModel extends BaseModel {
  int? id;
  String? title;
  String? titleAr;
  List<ServiceEntity> services = [];

  ServiceCategoryModel();

  factory ServiceCategoryModel.fromJson(Map<String, dynamic> json) {
    var serviceCategoryModel = ServiceCategoryModel();
    serviceCategoryModel.id = json['ID'];
    serviceCategoryModel.title = json['Title'];
    serviceCategoryModel.titleAr = json['TitleAr'];
    serviceCategoryModel.services =
        ServiceListModel.fromJson({'Data': json['Services']}).services;
    return serviceCategoryModel;
  }

  @override
  List<Object?> get props => [
        id,
        title,
      ];

  @override
  ServiceEntity toEntity() {
    ServiceEntity servicesEntity = ServiceEntity();
    servicesEntity.id = id;
    servicesEntity.title = title;
    servicesEntity.titleAr = titleAr;
    servicesEntity.services = services;
    return servicesEntity;
  }
}

class ServiceListModel extends BaseModel {
  List<ServiceEntity> services = [];

  ServiceListModel();

  factory ServiceListModel.fromJson(Map<String, dynamic> json) {
    var serviceListModel = ServiceListModel();
    final allservices = (json['Data'] as List)
        .map((service) => ServiceModel.fromJson(service).toEntity())
        .toList();
    serviceListModel.services =
        allservices.where((element) => element.isActive == true).toList();
    return serviceListModel;
  }

  @override
  List<Object?> get props => [
        services,
      ];

  @override
  List<ServiceEntity> toEntity() {
    return services;
  }
}

class ServiceModel extends BaseModel {
  int? id;
  String? title;
  String? titleAr;
  String? icon;
  String? descriptionEn;
  String? descriptionAr;
  String? itemURL;
  String? fees;
  bool? isActive;
  List<ServiceEntity> services = [];
  List<String> eligibleUsers = [];
  ServiceModel();

  factory ServiceModel.fromJson(Map<dynamic, dynamic> json) {
    var serviceModel = ServiceModel();
    serviceModel.id = json['ID'];
    serviceModel.title = json['Title'];
    serviceModel.titleAr = json['TitleAr'];
    serviceModel.icon = json['Icon'];
    serviceModel.descriptionEn = json['DescriptionEn'];
    serviceModel.descriptionAr = json['DescriptionAr'];
    serviceModel.itemURL = json['ItemURL'];
    serviceModel.fees = json['Fees'];
    serviceModel.isActive = json['isActive'];

    if (json['Services'] != null) {
      serviceModel.services =
          ServiceListModel.fromJson({'Data': json['Services']}).services;
    }
    if (json['EligibleUsers'] != null) {
      serviceModel.eligibleUsers = (json['EligibleUsers'] as List)
          .map((json) => json['Title'] as String)
          .toList();
    }
    if (json['EligibleUsersList'] != null) {
      serviceModel.eligibleUsers = (json['EligibleUsersList'] as List)
          .map((json) => json.toString())
          .toList();
    }
    return serviceModel;
  }
  factory ServiceModel.fromFavoriteJson(Map<dynamic, dynamic> json) {
    var serviceModel = ServiceModel();
    try {
      serviceModel.id = json['ID'];
      serviceModel.title = json['Title'];
      serviceModel.titleAr = json['TitleAr'];
      serviceModel.icon = json['Icon'];
      serviceModel.descriptionEn = json['DescriptionEn'];
      serviceModel.descriptionAr = json['DescriptionAr'];
      serviceModel.itemURL = json['ItemURL'];
      serviceModel.fees = json['Fees'] ?? '0';
      if (json['EligibleUsersList'] != null) {
        serviceModel.eligibleUsers = (json['EligibleUsersList'] as List)
            .map((json) => json.toString())
            .toList();
      }
    } catch (e) {
      printLog(e.toString());
    }
    return serviceModel;
  }
  @override
  List<Object?> get props => [
        id,
        title,
      ];

  @override
  ServiceEntity toEntity() {
    ServiceEntity servicesEntity = ServiceEntity();
    servicesEntity.id = id;
    servicesEntity.title = title;
    servicesEntity.titleAr = titleAr;
    servicesEntity.icon = icon;
    servicesEntity.descriptionEn = descriptionEn;
    servicesEntity.descriptionAr = descriptionAr;
    servicesEntity.itemURL = itemURL?.trim();
    servicesEntity.fees = fees;
    servicesEntity.isActive = isActive;
    servicesEntity.eligibleUsers = eligibleUsers;
    return servicesEntity;
  }
}

class ServiceDetailsModel extends BaseModel {
  int? id;
  String? titleEn;
  String? titleAr;
  String? descriptionEn;
  String? descriptionAr;
  String? feeDetailEn;
  String? feeDetailAr;
  bool? isEstablishment;
  bool? isIndividual;
  List<String> requiredDocumentsEnglish = [];
  List<String> requiredDocumentsArabic = [];
  List<String> serviceStepsEnglish = [];
  List<String> serviceStepsArabic = [];
  ServiceDetailsModel();

  factory ServiceDetailsModel.fromJson(Map<dynamic, dynamic> jsonResponse) {
    var serviceDetailsModel = ServiceDetailsModel();
    final json = jsonResponse['response'] is List
        ? jsonResponse['response'][0]
        : jsonResponse['response'];
    if (json != null) {
      serviceDetailsModel.id = json['ID'];
      serviceDetailsModel.titleEn = json['titleEnglish'];
      serviceDetailsModel.titleAr = json['titleArabic'];
      serviceDetailsModel.descriptionEn = json['descriptionEnglish'];
      serviceDetailsModel.descriptionAr = json['descriptionArabic'];
      serviceDetailsModel.feeDetailEn = json['feeDetailEn'];
      serviceDetailsModel.feeDetailAr = json['feeDetailAr'];
      serviceDetailsModel.isEstablishment = json['isEstablishment'];
      serviceDetailsModel.isIndividual = json['isIndividual'];

      if (json['requiredDocumentsEnglish'] != null) {
        serviceDetailsModel.requiredDocumentsEnglish =
            (json['requiredDocumentsEnglish'] as List)
                .map((json) => (json ?? '') as String)
                .toList();
      }
      if (json['requiredDocumentsArabic'] != null) {
        serviceDetailsModel.requiredDocumentsArabic =
            (json['requiredDocumentsArabic'] as List)
                .map((json) => (json ?? '').toString())
                .toList();
      }
      if (json['serviceStepsEnglish'] != null) {
        serviceDetailsModel.serviceStepsEnglish =
            (json['serviceStepsEnglish'] as List)
                .map((json) => (json ?? '').toString())
                .toList();
      }
      if (json['serviceStepsArabic'] != null) {
        serviceDetailsModel.serviceStepsArabic =
            (json['serviceStepsArabic'] as List)
                .map((json) => (json ?? '').toString())
                .toList();
      }
    }
    return serviceDetailsModel;
  }

  @override
  List<Object?> get props => [
        id,
        titleEn,
      ];

  @override
  ServiceDetailsEntity toEntity() {
    ServiceDetailsEntity serviceDetailsEntity = ServiceDetailsEntity();
    serviceDetailsEntity.id = id;
    serviceDetailsEntity.titleEn = titleEn;
    serviceDetailsEntity.titleAr = titleAr;
    serviceDetailsEntity.descriptionEn = descriptionEn;
    serviceDetailsEntity.descriptionAr = descriptionAr;
    serviceDetailsEntity.feeDetailAr = feeDetailAr;
    serviceDetailsEntity.feeDetailEn = feeDetailEn;
    serviceDetailsEntity.requiredDocumentsArabic = requiredDocumentsArabic;
    serviceDetailsEntity.requiredDocumentsEnglish = requiredDocumentsEnglish;
    serviceDetailsEntity.serviceStepsArabic = serviceStepsArabic;
    serviceDetailsEntity.serviceStepsEnglish = serviceStepsEnglish;
    return serviceDetailsEntity;
  }
}

class MostUsedServicesModel extends BaseModel {
  List<int> mostUsedServices = [];

  MostUsedServicesModel();

  factory MostUsedServicesModel.fromJson(Map<String, dynamic> json) {
    var mostUsedServicesModel = MostUsedServicesModel();
    if (json['response'] != null) {
      mostUsedServicesModel.mostUsedServices = (json['response'] as List)
          .map((data) => data['serviceId'] as int)
          .toList();
    }
    return mostUsedServicesModel;
  }

  @override
  List<Object?> get props => [
        mostUsedServices,
      ];

  @override
  MostUsedServicesEntity toEntity() {
    MostUsedServicesEntity mostUsedServicesEntity = MostUsedServicesEntity();
    mostUsedServicesEntity.mostUsedServices = mostUsedServices;
    return mostUsedServicesEntity;
  }
}

class ECCategoriesListModel extends BaseModel {
  List<ECCategoriesEntity> categories = [];

  ECCategoriesListModel();

  factory ECCategoriesListModel.fromJson(Map<String, dynamic> json) {
    var executiveCouncilListModel = ECCategoriesListModel();
    executiveCouncilListModel.categories = json['Data'] != null
        ? (json['Data'] as List)
            .map((service) => ECCategoriesModel.fromJson(service).toEntity())
            .toList()
        : [];
    return executiveCouncilListModel;
  }

  @override
  List<Object?> get props => [
        categories,
      ];

  @override
  ECCategoriesListEntity toEntity() {
    ECCategoriesListEntity executiveCouncilListEntity =
        ECCategoriesListEntity();
    executiveCouncilListEntity.categories = categories;
    return executiveCouncilListEntity;
  }
}

class ECCategoriesModel extends BaseModel {
  int? id;
  String? arabicTitle;
  String? englishTitle;
  ECCategoriesModel();

  factory ECCategoriesModel.fromJson(Map<String, dynamic> json) {
    var executiveCouncilModel = ECCategoriesModel();
    executiveCouncilModel.id = json['ID'];
    executiveCouncilModel.arabicTitle = json['ArabicTitle'];
    executiveCouncilModel.englishTitle = json['EnglishTitle'];
    return executiveCouncilModel;
  }

  @override
  List<Object?> get props => [
        id,
      ];

  @override
  ECCategoriesEntity toEntity() {
    ECCategoriesEntity executiveCouncilEntity = ECCategoriesEntity();
    executiveCouncilEntity.id = id;
    executiveCouncilEntity.arabicTitle = arabicTitle;
    executiveCouncilEntity.englishTitle = englishTitle;
    return executiveCouncilEntity;
  }
}

class ReportCaseResponseModel extends BaseModel {
  int? tokenId;
  String? status;
  String? description;
  ReportCaseResponseModel();

  factory ReportCaseResponseModel.fromJson(Map<String, dynamic> json) {
    var reportCaseResponseModel = ReportCaseResponseModel();
    reportCaseResponseModel.status = json['status'];
    reportCaseResponseModel.description = json['description'];
    if (json['token'] != null) {
      reportCaseResponseModel.tokenId = json['token']['tokenId'];
    }
    return reportCaseResponseModel;
  }

  @override
  List<Object?> get props => [
        tokenId,
      ];

  @override
  ReportCaseResponseEntity toEntity() {
    ReportCaseResponseEntity reportCaseResponseEntity =
        ReportCaseResponseEntity();
    reportCaseResponseEntity.tokenId = tokenId;
    reportCaseResponseEntity.status = status;
    reportCaseResponseEntity.description = description;
    return reportCaseResponseEntity;
  }
}

class EmailSendResponseModel extends BaseModel {
  String? messageId;
  EmailSendResponseModel();

  factory EmailSendResponseModel.fromJson(Map<String, dynamic> json) {
    var emailSendResponseModel = EmailSendResponseModel();
    emailSendResponseModel.messageId = json['fault']?['flowId'];
    return emailSendResponseModel;
  }

  @override
  List<Object?> get props => [
        messageId,
      ];

  @override
  EmailSendResponseEntity toEntity() {
    EmailSendResponseEntity emailSendResponseEntity = EmailSendResponseEntity();
    emailSendResponseEntity.messageId = messageId;
    return emailSendResponseEntity;
  }
}
