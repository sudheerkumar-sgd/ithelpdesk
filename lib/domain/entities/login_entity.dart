// ignore_for_file: must_be_immutable

import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/domain/entities/base_entity.dart';
import 'package:ithelpdesk/res/resources.dart';

class LoginEntity extends BaseEntity {
  String? fullnameAr;
  String? fullnameEn;
  String? email;
  int? userType;
  String? token;

  @override
  List<Object?> get props => [fullnameEn];

  String get getTitle =>
      isSelectedLocalEn ? fullnameEn ?? '' : fullnameAr ?? '';
}

class UserEntity extends BaseEntity {
  String? applicantId;
  String? fullNameEn;
  String? fullNameAr;
  String? phoneNumber;
  String? email;
  String? address;
  String? passportNo;
  String? firstPage;
  String? residencyPage;
  String? emiratesIdNo;
  String? emiratesIdFront;
  String? userName;
  String? citizenshipNameEn;
  String? citizenshipNameAr;
  String? residencyNamEn;
  String? residencyNameAr;
  String? mobileNumber2;
  String? landLinePhone;
  List<EstablishmentEntity> establishments = [];

  @override
  List<Object?> get props => [fullNameEn];

  String get getCitizenship =>
      (isSelectedLocalEn ? citizenshipNameEn : citizenshipNameAr) ?? '';
  String get getResidency =>
      (isSelectedLocalEn ? residencyNamEn : residencyNameAr) ?? '';
}

class EstablishmentEntity extends BaseEntity {
  int? id;
  int? postBox;
  String? tradeLicenseNo;
  int? tradeLicenseType;
  String? establishmentNameEn;
  String? establishmentNameAr;
  String? email;
  String? mobileNumber;
  int? licenseSourceType;
  int? establishmnetStatusType;
  String? tradeLicenseExpDate;
  int? licenseSourceId;
  bool? isInsideUAQ;

  @override
  List<Object?> get props => [tradeLicenseNo];

  String get establishmentName =>
      (isSelectedLocalEn ? establishmentNameEn : establishmentNameAr) ?? '';

  @override
  String toString() {
    return isSelectedLocalEn
        ? establishmentNameEn ?? ''
        : establishmentNameAr ?? '';
  }
}

class UpdateFirbaseTokenEntity extends BaseEntity {
  bool? isUpdated;

  @override
  List<Object?> get props => [isUpdated];
}
