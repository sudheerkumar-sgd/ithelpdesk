// ignore_for_file: must_be_immutable

import 'package:ithelpdesk/data/model/base_model.dart';
import 'package:ithelpdesk/domain/entities/iso_entity.dart';

class CRRequestModel extends BaseModel {
  int? requestId;
  int? workflowId;
  int? status;
  String? createdAt;
  String? completedAt;
  CRRequestDetailsEntity? details;

  CRRequestModel();

  CRRequestModel.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    workflowId = json['workflowId'];
    status = json['status'];
    createdAt = json['createdAt'];
    completedAt = json['completedAt'];
    if (json['details'] != null) {
      details = CRRequestDetailsModel.fromJson(json['details']).toEntity();
    }
  }

  @override
  CRRequestEntity toEntity() {
    return CRRequestEntity()
      ..requestId = requestId
      ..workflowId = workflowId
      ..status = status
      ..createdAt = createdAt
      ..completedAt = completedAt
      ..details = details;
  }
}

class CRRequestDetailsModel extends BaseModel {
  int? detailId;
  String? firstName;
  String? lastName;
  String? fullName;
  String? designation;
  int? departmentID;
  String? departmentName;
  String? emailID;

  CRRequestDetailsModel();

  CRRequestDetailsModel.fromJson(Map<String, dynamic> json) {
    detailId = json['detailId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    fullName = json['fullName'];
    designation = json['designation'];
    departmentID = json['departmentID'];
    departmentName = json['departmentName'];
    emailID = json['emailID'];
  }

  @override
  CRRequestDetailsEntity toEntity() {
    return CRRequestDetailsEntity()
      ..detailId = detailId
      ..firstName = firstName
      ..lastName = lastName
      ..fullName = fullName
      ..designation = designation
      ..departmentID = departmentID
      ..departmentName = departmentName
      ..emailID = emailID;
  }
}
