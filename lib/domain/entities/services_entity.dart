// ignore_for_file: must_be_immutable

import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/domain/entities/base_entity.dart';

class ServiceCategoryListEntity extends BaseEntity {
  List<ServiceEntity> serviceCategories = [];
}

class ServiceListEntity extends BaseEntity {
  List<ServiceEntity> services = [];
}

class ServiceEntity extends BaseEntity {
  int? id;
  String? title;
  String? titleAr;
  String? icon;
  String? descriptionAr;
  String? descriptionEn;
  String? itemURL;
  String? fees;
  bool? isActive;
  bool? isFavorite;
  List<ServiceEntity> services = [];
  List<String> eligibleUsers = [];

  ServiceEntity();

  ServiceEntity.create(
      int this.id, String this.title, String this.titleAr, String this.icon);

  @override
  List<Object?> get props => [id];

  String get getTitle => isSelectedLocalEn ? title ?? '' : titleAr ?? '';

  String get getDescription =>
      isSelectedLocalEn ? descriptionEn ?? '' : descriptionAr ?? '';
}

class ServiceDetailsEntity extends BaseEntity {
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
  ServiceDetailsEntity();

  String get serviceDescription =>
      isSelectedLocalEn ? descriptionEn ?? '' : descriptionAr ?? '';

  String get title => isSelectedLocalEn ? titleEn ?? '' : titleAr ?? '';

  String get fee => isSelectedLocalEn ? feeDetailEn ?? '' : feeDetailAr ?? '';

  List<String> get requiredDocuments =>
      isSelectedLocalEn ? requiredDocumentsEnglish : requiredDocumentsArabic;

  List<String> get serviceSteps =>
      isSelectedLocalEn ? serviceStepsEnglish : serviceStepsArabic;
}

class MostUsedServicesEntity extends BaseEntity {
  List<int> mostUsedServices = [];
}

class ECCategoriesListEntity extends BaseEntity {
  List<ECCategoriesEntity> categories = [];
}

class ECCategoriesEntity extends BaseEntity {
  int? id;
  String? arabicTitle;
  String? englishTitle;
  ECCategoriesEntity();
  @override
  List<Object?> get props => [id];
  @override
  String toString() {
    return (isSelectedLocalEn ? englishTitle : arabicTitle) ?? '';
  }
}

class AgeRangeEntity extends BaseEntity {
  int? ageRangeId;
  String? ageRangeAr;
  String? ageRangeEn;
  AgeRangeEntity(this.ageRangeId, this.ageRangeAr, this.ageRangeEn);
  @override
  List<Object?> get props => [ageRangeId];
  @override
  String toString() {
    return (isSelectedLocalEn ? ageRangeEn : ageRangeAr) ?? '';
  }
}

class PoliceInformationTypeEntity extends BaseEntity {
  int? iformationId;
  String? descAr;
  String? descEn;
  PoliceInformationTypeEntity(this.iformationId, this.descAr, this.descEn);
  @override
  List<Object?> get props => [iformationId];
  @override
  String toString() {
    return (isSelectedLocalEn ? descEn : descAr) ?? '';
  }
}

class NationalityEntity extends BaseEntity {
  int? nationalityCode;
  String? nationalityAr;
  String? nationalityEn;
  String? isGCC;
  NationalityEntity(
      this.nationalityCode, this.nationalityAr, this.nationalityEn, this.isGCC);
  @override
  List<Object?> get props => [nationalityCode];
  @override
  String toString() {
    return (isSelectedLocalEn ? nationalityEn : nationalityAr) ?? '';
  }
}

class ReportCaseResponseEntity extends BaseEntity {
  int? tokenId;
  String? status;
}

class EmailSendResponseEntity extends BaseEntity {
  String? messageId;
}
