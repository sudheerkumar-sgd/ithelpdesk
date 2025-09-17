// ignore_for_file: must_be_immutable

import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/data/model/base_model.dart';
import 'package:ithelpdesk/domain/entities/iso_entity.dart';

class CRRequestModel extends BaseModel {
  int? requestId;
  String? requestType;
  int? workflowId;
  int? currentStep;
  int? status;
  String? createdAt;
  String? completedAt;
  String? attachmentUrlPrefix;
  CRRequestDetailsEntity? details;
  List<CRRequestStepEntity> steps = [];

  CRRequestModel();

  CRRequestModel.fromJson(Map<String, dynamic> response) {
    final json = response['data'] ?? response;
    requestId = json['requestId'];
    requestType = json['requestType'];
    workflowId = json['workflowId'];
    currentStep = json['currentStep'];
    status = json['status'];
    createdAt = json['createdAt'];
    completedAt = json['completedAt'];
    attachmentUrlPrefix = json['attachmentUrlPrefix'];
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
      ..requestType = requestType
      ..workflowId = workflowId
      ..currentStep = currentStep
      ..status = RequestStatus.fromId(status ?? 1)
      ..createdAt = createdAt
      ..completedAt = completedAt
      ..attachmentUrlPrefix = attachmentUrlPrefix
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
  String? employeeID;
  String? loginID;
  String? accessTypeID;
  int? reportingManagerID;
  String? dateOfJoining;
  String? requestPriority;
  String? reasonOfAccess;
  String? comments;
  List<CRAttachmentEntity> attachements = [];

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
    employeeID = json['employeeID'];
    loginID = json['loginID'];
    accessTypeID = json['accessTypeID'];
    reportingManagerID = json['reportingManagerID'];
    dateOfJoining = json['dateOfJoining'];
    requestPriority = json['requestPriority'];
    reasonOfAccess = json['reasonOfAccess'];
    comments = json['comments'];
    if (json['attachements'] != null) {
      attachements = <CRAttachmentEntity>[];
      json['attachements'].forEach((v) {
        attachements.add(CRAttachmentModel.fromJson(v).toEntity());
      });
    }
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
      ..emailID = emailID
      ..employeeID = employeeID
      ..loginID = loginID
      ..accessTypeID = accessTypeID
      ..reportingManagerID = reportingManagerID
      ..dateOfJoining = dateOfJoining
      ..requestPriority = requestPriority
      ..reasonOfAccess = reasonOfAccess
      ..comments = comments
      ..attachments = attachements;
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
      ..actionId = RequestStepStatus.fromId(actionId ?? 1)
      ..actionName = actionName;
  }
}

class CRAttachmentModel extends BaseModel {
  int? id;
  String? name;
  String? createdOn;
  String? requestID;
  int? workflowID;
  int? commentID;

  CRAttachmentModel();
  CRAttachmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdOn = json['createdOn'];
    requestID = json['requestID'];
    workflowID = json['workflowID'];
    commentID = json['commentID'];
  }

  @override
  CRAttachmentEntity toEntity() {
    return CRAttachmentEntity()
      ..id = id
      ..name = name
      ..createdOn = createdOn
      ..requestID = requestID
      ..workflowID = workflowID
      ..commentID = commentID;
  }
}
