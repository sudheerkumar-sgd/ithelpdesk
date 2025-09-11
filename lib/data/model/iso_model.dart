// ignore_for_file: must_be_immutable

import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/data/model/base_model.dart';
import 'package:ithelpdesk/domain/entities/iso_entity.dart';

class CRRequestModel extends BaseModel {
  int? requestId;
  int? workflowId;
  int? currentStep;
  int? status;
  String? createdAt;
  String? completedAt;
  CRRequestDetailsEntity? details;
  List<CRRequestStepEntity> steps = [];

  CRRequestModel();

  CRRequestModel.fromJson(Map<String, dynamic> response) {
    final json = response['data'] ?? response;
    requestId = json['requestId'];
    workflowId = json['workflowId'];
    currentStep = json['currentStep'];
    status = json['status'];
    createdAt = json['createdAt'];
    completedAt = json['completedAt'];
    if (json['details'] != null) {
      details = CRRequestDetailsModel.fromJson(json['details']).toEntity();
    }
    if (json['steps'] != null) {
      steps = <CRRequestStepEntity>[];
      json['steps'].forEach((v) {
        steps.add(CRRequestStepModel.fromJson(v).toEntity());
      });
    }
  }

  @override
  CRRequestEntity toEntity() {
    return CRRequestEntity()
      ..requestId = requestId
      ..workflowId = workflowId
      ..currentStep = currentStep
      ..status = RequestStatus.fromId(status ?? 1)
      ..createdAt = createdAt
      ..completedAt = completedAt
      ..details = details
      ..steps = steps;
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

class CRRequestStepModel extends BaseModel {
  int? requestStepId;
  String? stepName;
  int? assignedTo;
  String? assigneDisplayName;
  String? updatedAt;
  int? status;
  List<CRRequestStepAssigneeEntity> assignees = [];

  CRRequestStepModel();

  CRRequestStepModel.fromJson(Map<String, dynamic> json) {
    requestStepId = json['requestStepId'];
    stepName = json['stepName'];
    assignedTo = json['assignedTo'];
    assigneDisplayName = json['assigneDisplayName'];
    updatedAt = json['updatedAt'];
    status = json['status'];
    if (json['assignees'] != null) {
      assignees = <CRRequestStepAssigneeEntity>[];
      json['assignees'].forEach((v) {
        assignees.add(CRRequestStepAssigneeModel.fromJson(v).toEntity());
      });
    }
  }

  @override
  CRRequestStepEntity toEntity() {
    return CRRequestStepEntity()
      ..requestStepId = requestStepId
      ..stepName = stepName
      ..assignedTo = assignedTo
      ..assigneDisplayName = assigneDisplayName
      ..updatedAt = updatedAt
      ..status = RequestStepStatus.fromId(status ?? 8)
      ..assignees = assignees;
  }
}

class CRRequestStepAssigneeModel extends BaseModel {
  int? employeeId;
  int? roleId;
  List<CRRequestStepActionEntity> actions = [];

  CRRequestStepAssigneeModel();

  CRRequestStepAssigneeModel.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    roleId = json['roleId'];
    if (json['actions'] != null) {
      actions = <CRRequestStepActionEntity>[];
      json['actions'].forEach((v) {
        actions.add(CRRequestStepActionModel.fromJson(v).toEntity());
      });
    }
  }

  @override
  CRRequestStepAssigneeEntity toEntity() {
    return CRRequestStepAssigneeEntity()
      ..employeeId = employeeId
      ..roleId = roleId
      ..actions = actions;
  }
}

class CRRequestStepActionModel extends BaseModel {
  int? actionId;
  String? actionName;

  CRRequestStepActionModel();
  CRRequestStepActionModel.fromJson(Map<String, dynamic> json) {
    actionId = json['actionId'];
    actionName = json['actionName'];
  }

  @override
  CRRequestStepActionEntity toEntity() {
    return CRRequestStepActionEntity()
      ..actionId = StatusType.fromId(actionId ?? 1)
      ..actionName = actionName;
  }
}
