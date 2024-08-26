// ignore_for_file: must_be_immutable

import 'package:ithelpdesk/data/model/base_model.dart';

import '../../domain/entities/user_entity.dart';

class LoginModel extends BaseModel {
  String? fullnameAr;
  String? fullnameEn;
  String? email;
  int? userType;
  String? token;
  LoginModel();

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    var loginModel = LoginModel();
    loginModel.fullnameAr = json['data']?['fullnameAr'];
    loginModel.fullnameEn = json['data']?['fullnameEn'];
    loginModel.email = json['data']?['email'];
    loginModel.userType = json['data']?['userType'];
    loginModel.token = json['data']?['token'];
    return loginModel;
  }

  @override
  List<Object?> get props => [
        fullnameAr,
        fullnameEn,
      ];

  @override
  LoginEntity toEntity() {
    LoginEntity lgoinEntity = LoginEntity();
    lgoinEntity.fullnameEn = fullnameEn;
    lgoinEntity.fullnameAr = fullnameAr;
    lgoinEntity.email = email;
    lgoinEntity.userType = userType;
    lgoinEntity.token = token;
    return lgoinEntity;
  }
}

class UserModel extends BaseModel {
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

  UserModel();

  UserModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['data'] ?? json;
    id = userJson['id'];
    name = userJson['name'];
    email = userJson['email'];
    username = userJson['username'];
    employeeID = userJson['employeeID'];
    roleID = userJson['roleID'];
    departmentID = userJson['departmentID'];
    createdOn = userJson['createdOn'];
    isStaff = userJson['isStaff'];
    status = userJson['status'];
    statusChangedOn = userJson['statusChangedOn'];
    designation = userJson['designation'];
    manager = userJson['manager'];
    department = userJson['department'];
    mobile = userJson['mobile'];
  }

  @override
  List<Object?> get props => [
        id,
      ];

  @override
  UserEntity toEntity() {
    UserEntity userEntity = UserEntity();
    userEntity.id = id;
    userEntity.name = name;
    userEntity.email = email;
    userEntity.username = username;
    userEntity.employeeID = employeeID;
    userEntity.roleID = roleID;
    userEntity.departmentID = departmentID;
    userEntity.createdOn = createdOn;
    userEntity.status = status;
    userEntity.designation = designation;
    userEntity.manager = manager;
    userEntity.department = department;
    userEntity.mobile = mobile;
    return userEntity;
  }
}

class EstablishmentModel extends BaseModel {
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

  EstablishmentModel();

  factory EstablishmentModel.fromJson(Map<String, dynamic> json) {
    var establishment = EstablishmentModel();
    establishment.id = json['id'];
    establishment.postBox = json['postBox'];
    establishment.email = json['email'];
    establishment.tradeLicenseNo = json['tradeLicenseNo'];
    establishment.tradeLicenseType = json['tradeLicenseType'];
    establishment.establishmentNameEn = json['establishmentNameEn'];
    establishment.establishmentNameAr = json['establishmentNameAr'];
    establishment.licenseSourceType = json['licenseSourceType'];
    establishment.mobileNumber = json['mobileNumber'];
    establishment.establishmnetStatusType = json['establishmnetStatusType'];
    establishment.tradeLicenseExpDate = json['tradeLicenseExpDate'];
    establishment.licenseSourceId = json['licenseSourceId'];
    establishment.isInsideUAQ = json['isInideUAQ'];
    return establishment;
  }

  @override
  List<Object?> get props => [
        tradeLicenseNo,
      ];

  @override
  EstablishmentEntity toEntity() {
    EstablishmentEntity establishmentEntity = EstablishmentEntity();
    establishmentEntity.id = id;
    establishmentEntity.postBox = postBox;
    establishmentEntity.email = email;
    establishmentEntity.mobileNumber = mobileNumber;
    establishmentEntity.tradeLicenseNo = tradeLicenseNo;
    establishmentEntity.tradeLicenseType = tradeLicenseType;
    establishmentEntity.establishmentNameEn = establishmentNameEn;
    establishmentEntity.establishmentNameAr = establishmentNameAr;
    establishmentEntity.licenseSourceType = licenseSourceType;
    establishmentEntity.establishmnetStatusType = establishmnetStatusType;
    establishmentEntity.tradeLicenseExpDate = tradeLicenseExpDate;
    establishmentEntity.licenseSourceId = licenseSourceId;
    establishmentEntity.isInsideUAQ = isInsideUAQ;
    return establishmentEntity;
  }
}

class UpdateFirbaseTokenModel extends BaseModel {
  bool? isUpdated;
  UpdateFirbaseTokenModel();

  factory UpdateFirbaseTokenModel.fromJson(Map<String, dynamic> json) {
    var updateFirbaseTokenModel = UpdateFirbaseTokenModel();
    updateFirbaseTokenModel.isUpdated = json['response'];
    return updateFirbaseTokenModel;
  }

  @override
  List<Object?> get props => [
        isUpdated,
      ];

  @override
  UpdateFirbaseTokenEntity toEntity() {
    UpdateFirbaseTokenEntity updateFirbaseTokenEntity =
        UpdateFirbaseTokenEntity();
    updateFirbaseTokenEntity.isUpdated = isUpdated;
    return updateFirbaseTokenEntity;
  }
}
