// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/domain/entities/base_entity.dart';

class ListEntity extends BaseEntity {
  List<BaseEntity> items = [];
}

class SubCategoryEntity extends BaseEntity {
  int? id;
  String? name;
  String? nameAr;
  int? categoryID;
  bool? isActive;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['nameAr'] = nameAr;
    data['categoryID'] = categoryID;
    data['isActive'] = isActive;
    return data;
  }

  @override
  String toString() {
    return (isSelectedLocalEn ? name ?? '' : nameAr ?? name) ?? '';
  }

  @override
  List<Object?> get props => [id, name, nameAr];
}

class ReasonsEntity extends BaseEntity {
  int? id;
  int? categoryID;
  int? subCategoryID;
  String? reason;
  String? reasonAr;
  bool? isActive;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['categoryID'] = categoryID;
    data['subCategoryID'] = subCategoryID;
    data['reason'] = reason;
    data['reasonAr'] = reasonAr;
    data['isActive'] = isActive;
    return data;
  }

  @override
  String toString() {
    return (isSelectedLocalEn ? reason ?? '' : reasonAr ?? reason) ?? '';
  }

  @override
  List<Object?> get props => [id, reason, reasonAr];
}

class EserviceEntity extends BaseEntity {
  int? id;
  int? servicEID;
  int? servicEDEPARTMENTID;
  String? servicENAMEEN;
  String? servicENAMEAR;
  bool? isActive;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['servicE_ID'] = servicEID;
    data['servicE_DEPARTMENT_ID'] = servicEDEPARTMENTID;
    data['servicE_NAME_EN'] = servicENAMEEN;
    data['servicE_NAME_AR'] = servicENAMEAR;
    data['isActive'] = isActive;
    return data;
  }

  @override
  String toString() {
    return (isSelectedLocalEn
            ? servicENAMEEN ?? ''
            : servicENAMEAR ?? servicENAMEEN) ??
        '';
  }

  @override
  List<Object?> get props => [id, servicENAMEEN, servicENAMEAR];
}

class ActionButtonEntity extends BaseEntity {
  int? id;
  String? iconPth;
  Color? color;
  String? nameEn;
  String? nameAr;
  ActionButtonEntity(
      {this.id, this.nameEn, this.nameAr, this.iconPth, this.color});
  @override
  String toString() {
    return (isSelectedLocalEn ? nameEn ?? '' : nameAr ?? nameEn) ?? '';
  }

  @override
  List<Object?> get props => [nameEn];
}

class DepartmentEntity extends BaseEntity {
  int? id;
  String? name;
  String? shortName;

  @override
  String toString() {
    return shortName ?? '';
  }

  @override
  List<Object?> get props => [id];
}

class UploadResponseEntity extends BaseEntity {
  int? documentDataId;
  int? documentTypeId;
  int? did;
  String? documentName;
  String? documentData;
  String? documentType;

  @override
  List<Object?> get props => [documentDataId];

  Map<String, dynamic> toJson() => {
        'fileId': documentDataId,
        'fileDid': did,
        'fileName': documentName,
      };
  @override
  String toString() {
    return documentName ?? '';
  }
}
