// ignore_for_file: must_be_immutable

import 'package:smartuaq/data/model/base_model.dart';
import 'package:smartuaq/domain/entities/login_entity.dart';

class LoginModel extends BaseModel {
  String? fullnameAr;
  String? fullnameEn;
  String? email;
  int? userType;
  String? token;
  LoginModel();

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    var loginModel = LoginModel();
    loginModel.fullnameAr = json['response']['fullnameAr'];
    loginModel.fullnameEn = json['response']['fullnameEn'];
    loginModel.email = json['response']['email'];
    loginModel.userType = json['response']['userType'];
    loginModel.token = json['response']['token'];
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

  UserModel();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    var userModel = UserModel();
    userModel.fullNameEn = json['response']['fullNameEn'];
    userModel.fullNameAr = json['response']['fullNameAr'];
    userModel.email = json['response']['email'];
    userModel.phoneNumber = json['response']['phoneNumber'];
    userModel.passportNo = json['response']['passportNo'];
    userModel.firstPage = json['response']['FirstPage'];
    userModel.residencyPage = json['response']['ResidencyPage'];
    userModel.emiratesIdNo = json['response']['emiratesIDNo'];
    userModel.residencyNamEn = json['response']['residencyNamEn'];
    userModel.residencyNameAr = json['response']['residencyNameAr'];
    userModel.citizenshipNameEn = json['response']['citizenshipNameEn'];
    userModel.citizenshipNameAr = json['response']['citizenshipNameAr'];
    if (json['response']['establishmentUser'] != null) {
      userModel.establishments = (json['response']['establishmentUser'] as List)
          .map((json) =>
              EstablishmentModel.fromJson(json['reg_EstablishmentInfo'])
                  .toEntity())
          .toList();
    }
    return userModel;
  }

  factory UserModel.fromEstablishmentsJson(Map<String, dynamic> json) {
    var userModel = UserModel();
    if (json['response'] != null) {
      userModel.establishments = (json['response'] as List)
          .map((json) => EstablishmentModel.fromJson(json).toEntity())
          .toList();
    }
    return userModel;
  }

  @override
  List<Object?> get props => [
        fullNameAr,
        fullNameEn,
      ];

  @override
  UserEntity toEntity() {
    UserEntity userEntity = UserEntity();
    userEntity.fullNameEn = fullNameEn;
    userEntity.fullNameAr = fullNameAr;
    userEntity.email = email;
    userEntity.emiratesIdNo = emiratesIdNo;
    userEntity.citizenshipNameEn = citizenshipNameEn;
    userEntity.citizenshipNameAr = citizenshipNameAr;
    userEntity.phoneNumber = phoneNumber;
    userEntity.residencyNamEn = residencyNamEn;
    userEntity.residencyNameAr = residencyNameAr;
    userEntity.establishments = establishments;
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
