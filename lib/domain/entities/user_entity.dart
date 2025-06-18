// ignore_for_file: must_be_immutable

import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/domain/entities/base_entity.dart';

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
  int? id;
  String? name;
  String? email;
  String? username;
  String? employeeID;
  int? roleID;
  int? departmentID;
  String? createdOn;
  bool? isStaff;
  bool? status;
  String? statusChangedOn;
  String? designation;
  String? manager;
  String? department;
  String? mobile;
  String? contactNumber;

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return name ?? '';
  }
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
