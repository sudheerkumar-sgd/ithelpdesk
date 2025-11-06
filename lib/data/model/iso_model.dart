// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/data/model/base_model.dart';
import 'package:ithelpdesk/data/model/form_model.dart';
import 'package:ithelpdesk/domain/entities/form_entities.dart';
import 'package:ithelpdesk/domain/entities/iso_entity.dart';

class CRRequestDataModel extends BaseModel {
  int? totalPage;
  List<CRRequestEntity> requests = [];

  CRRequestDataModel.fromJson(Map<String, dynamic> response) {
    final json = response['data'] ?? response;
    totalPage = json['totalPage'];
    if (json['requests'] is List) {
      requests = <CRRequestEntity>[];
      for (var json in (json['requests'] as List)) {
        requests.add(CRRequestModel.fromJson(json).toEntity());
      }
    }
  }
  @override
  CRRequestDataEntity toEntity() {
    return CRRequestDataEntity()
      ..totalPage = totalPage
      ..requests = requests;
  }
}

class CRRequestModel extends BaseModel {
  int? requestId;
  String? requestCode;
  String? requestType;
  int? workflowId;
  int? currentStep;
  int? requestStaus;
  String? createdAt;
  String? updatedAt;
  String? attachmentUrlPrefix;
  String? currentStepName;
  String? assginedEmployee;
  int? requestPriority;
  Map? requestDetail;

  CRRequestDetailsEntity? details;
  WorkflowFieldEntity? workflowFieldEntity;
  List<CRRequestStepEntity> steps = [];
  List<CRRequestHistoryEntity> requestHistory = [];
  List<CRAttachmentEntity> attachements = [];

  CRRequestModel();

  CRRequestModel.fromJson(Map<String, dynamic> response) {
    final json = response['data'] ?? response;
    requestId = json['requestId'];
    requestCode = json['requestCode'];
    requestType = json['requestType'];
    workflowId = json['workflowId'];
    currentStep = json['currentStep'];
    requestStaus = json['requestStaus'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    attachmentUrlPrefix = json['attachmentUrlPrefix'];
    currentStepName = json['currentStepName'];
    assginedEmployee = json['assginedEmployee'];
    requestPriority = json['requestPriority'];
    if (json['requestDetail'] != null) {
      requestDetail = jsonDecode(json['requestDetail']);
    }
    if (json['workflowField'] != null) {
      workflowFieldEntity =
          WorkflowFieldModel.fromJson(json['workflowField']).toEntity();
    }
    if (json['steps'] != null) {
      steps = <CRRequestStepEntity>[];
      json['steps'].forEach((v) {
        steps.add(CRRequestStepModel.fromJson(v).toEntity());
      });
    }
    if (json['requestHistory'] != null) {
      requestHistory = <CRRequestHistoryEntity>[];
      json['requestHistory'].forEach((v) {
        requestHistory.add(CRRequestHistoryModel.fromJson(v).toEntity());
      });
    }
    if (json['requestHistory'] != null) {
      requestHistory = <CRRequestHistoryEntity>[];
      json['requestHistory'].forEach((v) {
        requestHistory.add(CRRequestHistoryModel.fromJson(v).toEntity());
      });
    }

    if (json['attachements'] != null) {
      attachements = <CRAttachmentEntity>[];
      json['attachements'].forEach((v) {
        attachements.add(CRAttachmentModel.fromJson(v).toEntity());
      });
    }
  }

  @override
  CRRequestEntity toEntity() {
    return CRRequestEntity()
      ..requestId = requestId
      ..requestCode = requestCode
      ..requestType = requestType
      ..workflowId = workflowId
      ..currentStep = currentStep
      ..requestStaus = RequestStatus.fromId(requestStaus ?? 1)
      ..createdAt = createdAt
      ..updatedAt = updatedAt
      ..attachmentUrlPrefix = attachmentUrlPrefix
      ..currentStepName = currentStepName
      ..assginedEmployee = assginedEmployee
      ..requestPriority = PriorityType.fromId(requestPriority ?? 1)
      ..requestDetail = requestDetail
      ..workflowFieldEntity = workflowFieldEntity
      ..steps = steps
      ..attachments = attachements
      ..requestHistory = requestHistory;
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
  String? exstingDepartment;
  String? emailID;
  String? employeeID;
  String? loginID;
  String? accessDetails;
  int? reportingManagerID;
  String? reportingManager;
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
    exstingDepartment = json['exstingDepartment'];
    emailID = json['emailID'];
    employeeID = json['employeeID'];
    loginID = json['loginID'];
    accessDetails = json['accessDetails'];
    reportingManagerID = json['reportingManagerID'];
    reportingManager = json['reportingManager'];
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
      ..exstingDepartment = exstingDepartment
      ..emailID = emailID
      ..employeeID = employeeID
      ..loginID = loginID
      ..accessDetails = accessDetails
      ..reportingManagerID = reportingManagerID
      ..reportingManager = reportingManager
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
  int? stepOrder;
  List<FormEntity> inputFields = [];
  int? assignedTo;
  String? assigneDisplayName;
  String? updatedAt;
  int? status;
  Map? stepFormData;
  List<CRRequestStepAssigneeEntity> assignees = [];

  CRRequestStepModel();

  CRRequestStepModel.fromJson(Map<String, dynamic> json) {
    requestStepId = json['requestStepId'];
    stepName = json['stepName'];
    stepOrder = json['stepOrder'];
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
    if (json['inputFields'] != null) {
      inputFields = List<Map<String, dynamic>>.from(
        jsonDecode(json['inputFields'] ?? '[]'),
      ).map((e) => FormModel.fromJson(e).toEntity()).toList();
    }
    if (json['stepFormData'] != null) {
      stepFormData = jsonDecode(json['stepFormData']);
    }
  }

  @override
  CRRequestStepEntity toEntity() {
    return CRRequestStepEntity()
      ..requestStepId = requestStepId
      ..stepName = stepName
      ..stepOrder = stepOrder
      ..inputFields = inputFields
      ..stepFormData = stepFormData
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

class CRRequestHistoryModel extends BaseModel {
  int? id;
  String? name;
  String? createdOn;
  String? requestID;
  int? employeeID;
  int? stepID;
  RequestStepStatus? status;
  List<CRCommentEntity> comments = [];
  List<CRAttachmentEntity> attachments = [];

  CRRequestHistoryModel();
  CRRequestHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdOn = json['createdOn'];
    requestID = json['requestID'];
    employeeID = json['employeeID'];
    stepID = json['stepID'];
    status = RequestStepStatus.fromId(json['status'] ?? 1);
    if (json['comments'] != null) {
      comments = <CRCommentEntity>[];
      json['comments'].forEach((v) {
        comments.add(CRCommentModel.fromJson(v).toEntity());
      });
    }
    if (json['attachments'] != null) {
      attachments = <CRAttachmentEntity>[];
      json['attachments'].forEach((v) {
        attachments.add(CRAttachmentModel.fromJson(v).toEntity());
      });
    }
  }
  @override
  CRRequestHistoryEntity toEntity() {
    return CRRequestHistoryEntity()
      ..id = id
      ..name = name
      ..createdOn = createdOn
      ..requestID = requestID
      ..employeeID = employeeID
      ..stepID = stepID
      ..status = status
      ..comments = comments
      ..attachments = attachments;
  }
}

class CRCommentModel extends BaseModel {
  int? id;
  String? comment;
  String? createdOn;
  String? requestID;
  int? employeeID;

  CRCommentModel();
  CRCommentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    createdOn = json['createdOn'];
    requestID = json['requestID'];
    employeeID = json['employeeID'];
  }
  @override
  CRCommentEntity toEntity() {
    return CRCommentEntity()
      ..id = id
      ..comment = comment
      ..createdOn = createdOn
      ..requestID = requestID
      ..employeeID = employeeID;
  }
}

class WorkflowFieldModel extends BaseModel {
  int? id;
  List<Map<String, dynamic>> formFields = [];
  List<Map<String, dynamic>> reportFields = [];
  List<Map<String, dynamic>> detailsFields = [];
  WorkflowFieldModel();

  WorkflowFieldModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['formFields'] != null) {
      formFields = List<Map<String, dynamic>>.from(
        jsonDecode(json['formFields'] ?? '[]'),
      );
    }
    if (json['reportFields'] != null) {
      reportFields = List<Map<String, dynamic>>.from(
        jsonDecode(json['reportFields'] ?? '[]'),
      );
    }
    if (json['detailsFields'] != null) {
      detailsFields = List<Map<String, dynamic>>.from(
        jsonDecode(json['detailsFields'] ?? '[]'),
      );
    }
  }
  @override
  WorkflowFieldEntity toEntity() {
    return WorkflowFieldEntity()
      ..id = id
      ..formFields = formFields
      ..reportFields = reportFields
      ..detailsFields = detailsFields;
  }
}
