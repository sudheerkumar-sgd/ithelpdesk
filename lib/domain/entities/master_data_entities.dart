// ignore_for_file: must_be_immutable

import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/domain/entities/base_entity.dart';

class ListEntity extends BaseEntity {
  List<dynamic> items = [];
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
    return isSelectedLocalEn ? name ?? '' : nameAr ?? '';
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
    return isSelectedLocalEn ? reason ?? '' : reasonAr ?? '';
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
    return isSelectedLocalEn ? servicENAMEEN ?? '' : servicENAMEAR ?? '';
  }

  @override
  List<Object?> get props => [id, servicENAMEEN, servicENAMEAR];
}