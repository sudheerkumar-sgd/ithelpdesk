// ignore_for_file: must_be_immutable

import 'package:ithelpdesk/data/model/base_model.dart';
import 'package:ithelpdesk/data/model/dashboard_model.dart';
import 'package:ithelpdesk/data/model/login_model.dart';
import 'package:ithelpdesk/domain/entities/directory_entity.dart';
import 'package:ithelpdesk/domain/entities/master_data_entities.dart';

class ListModel extends BaseModel {
  List<dynamic> items = [];
  ListModel.fromSubCategoryJson(Map<String, dynamic> json) {
    if (json['data'] is List) {
      for (var json in (json['data'] as List)) {
        items.add(SubCategoryModel.fromJson(json).toEntity());
      }
    }
  }

  ListModel.fromReasonsJson(Map<String, dynamic> json) {
    if (json['data'] is List) {
      for (var json in (json['data'] as List)) {
        items.add(ReasonsModel.fromJson(json).toEntity());
      }
    }
  }

  ListModel.fromEserviceJson(Map<String, dynamic> json) {
    if (json['data'] is List) {
      for (var json in (json['data'] as List)) {
        items.add(EserviceModel.fromJson(json).toEntity());
      }
    }
  }

  ListModel.fromTicketHistoryJson(Map<String, dynamic> json) {
    if (json['data'] is List) {
      for (var json in (json['data'] as List)) {
        items.add(TicketHistoryModel.fromJson(json).toEntity());
      }
    }
  }

  ListModel.fromTicketCommnetsJson(Map<String, dynamic> json) {
    if (json['data'] is List) {
      for (var json in (json['data'] as List)) {
        items.add(TicketHistoryModel.fromJson(json).toEntity());
      }
    }
  }

  ListModel.fromTicketsJson(Map<String, dynamic> json) {
    if (json['data'] is List) {
      for (var json in (json['data'] as List)) {
        items.add(TicketsModel.fromJson(json).toEntity());
      }
    }
  }

  ListModel.fromDepartmentsJson(Map<String, dynamic> json) {
    if (json['data'] is List) {
      for (var json in (json['data'] as List)) {
        items.add(DepartmentModel.fromJson(json).toEntity());
      }
    }
  }

  ListModel.fromEmployeesJson(Map<String, dynamic> json) {
    if (json['data'] is List) {
      for (var json in (json['data'] as List)) {
        items.add(UserModel.fromJson(json).toEntity());
      }
    }
  }

  ListModel.fromDirectoryEmployeesJson(Map<String, dynamic> json) {
    if (json['data'] is List) {
      for (var json in (json['data'] as List)) {
        items.add(DirectoryModel.fromJson(json).toEntity());
      }
    }
  }

  @override
  ListEntity toEntity() {
    final listEntity = ListEntity();
    listEntity.items = items;
    return listEntity;
  }
}

class SubCategoryModel extends BaseModel {
  int? id;
  String? name;
  String? nameAr;
  int? categoryID;
  bool? isActive;

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameAr = json['nameAr'];
    categoryID = json['categoryID'];
    isActive = json['isActive'];
  }

  @override
  SubCategoryEntity toEntity() {
    final subCategoryEntity = SubCategoryEntity();
    subCategoryEntity.id = id;
    subCategoryEntity.categoryID = categoryID;
    subCategoryEntity.name = name;
    subCategoryEntity.nameAr = nameAr;
    return subCategoryEntity;
  }
}

class ReasonsModel extends BaseModel {
  int? id;
  int? categoryID;
  int? subCategoryID;
  String? reason;
  String? reasonAr;
  bool? isActive;

  ReasonsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryID = json['categoryID'];
    subCategoryID = json['subCategoryID'];
    reason = json['reason'];
    reasonAr = json['reasonAr'];
    isActive = json['isActive'];
  }

  @override
  ReasonsEntity toEntity() {
    final reasonsEntity = ReasonsEntity();
    reasonsEntity.id = id;
    reasonsEntity.categoryID = categoryID;
    reasonsEntity.subCategoryID = subCategoryID;
    reasonsEntity.reason = reason;
    reasonsEntity.reasonAr = reasonAr;
    return reasonsEntity;
  }
}

class EserviceModel extends BaseModel {
  int? id;
  int? servicEID;
  int? servicEDEPARTMENTID;
  String? servicENAMEEN;
  String? servicENAMEAR;
  bool? isActive;

  EserviceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    servicEID = json['servicE_ID'];
    servicEDEPARTMENTID = json['servicE_DEPARTMENT_ID'];
    servicENAMEEN = json['servicE_NAME_EN'];
    servicENAMEAR = json['servicE_NAME_AR'];
    isActive = json['isActive'];
  }

  @override
  EserviceEntity toEntity() {
    final eserviceEntity = EserviceEntity();
    eserviceEntity.id = id;
    eserviceEntity.servicEID = servicEID;
    eserviceEntity.servicENAMEEN = servicENAMEEN;
    eserviceEntity.servicENAMEAR = servicENAMEAR;
    eserviceEntity.servicEDEPARTMENTID = servicEDEPARTMENTID;
    return eserviceEntity;
  }
}

class DepartmentModel extends BaseModel {
  int? id;
  String? name;
  String? shortName;
  String? servicENAMEAR;

  DepartmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortName = json['shortName'];
  }

  @override
  DepartmentEntity toEntity() {
    final departmentEntity = DepartmentEntity();
    departmentEntity.id = id;
    departmentEntity.name = name;
    departmentEntity.shortName = shortName;
    return departmentEntity;
  }
}

class DirectoryModel extends BaseModel {
  int? id;
  String? employeeName;
  String? designation;
  String? department;
  String? emailId;

  DirectoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeName = json['name'];
    department = json['department'];
    designation = json['designation'];
    emailId = json['email'];
  }

  @override
  DirectoryEntity toEntity() {
    final directoryEntity = DirectoryEntity();
    directoryEntity.id = id;
    directoryEntity.employeeName = employeeName;
    directoryEntity.designation = designation;
    directoryEntity.department = department;
    directoryEntity.emailId = emailId;
    return directoryEntity;
  }
}
