// ignore_for_file: must_be_immutable
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/domain/entities/base_entity.dart';

class CRRequestEntity extends BaseEntity {
  int? requestId;
  String? requestType;
  int? workflowId;
  int? currentStep;
  RequestStatus? requestStaus;
  String? createdAt;
  String? completedAt;
  String? attachmentUrlPrefix;
  String? currentStepName;
  String? assginedEmployee;
  PriorityType? requestPriority;

  CRRequestDetailsEntity? details;
  WorkflowFieldEntity? workflowFieldEntity;
  List<CRRequestStepEntity> steps = [];
  List<CRRequestHistoryEntity> requestHistory = [];

  CRRequestEntity();

  Map<String, dynamic> toFullJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requestId'] = requestId;
    data['requestType'] = requestType;
    data['currentStepName'] = currentStepName;
    data['requestStaus'] = requestStaus;
    data['assginedEmployee'] = assginedEmployee;
    data['requestPriority'] = requestPriority?.toString();
    data['firstName'] = details?.firstName;
    data['lastName'] = details?.lastName;
    data['fullName'] = details?.fullName;
    data['designation'] = details?.designation;
    data['departmentName'] = details?.departmentName;
    data['exstingDepartmentName'] = details?.exstingDepartment;
    data['emailID'] = details?.emailID;
    data['employeeID'] = details?.employeeID;
    data['loginID'] = details?.loginID;
    data['accessDetails'] = details?.accessDetails;
    data['reportingManagerID'] = details?.reportingManagerID;
    data['reportingManager'] = details?.reportingManager;
    data['dateOfJoining'] = details?.dateOfJoining;
    data['requestPriority'] = requestPriority.toString();
    data['reasonOfAccess'] = details?.reasonOfAccess;
    data['comments'] = details?.comments;
    data['createdAt'] = createdAt;
    return data;
  }

  Map<String, dynamic> toJson() {
    final data = toFullJson();
    final Map<String, dynamic> reportData = <String, dynamic>{};
    for (var field in workflowFieldEntity?.reportFields ?? []) {
      reportData[field['Name']] = data[field['key']];
    }
    return reportData;
  }

  Map<String, dynamic> toDetailsJson() {
    final data = toFullJson();
    final Map<String, dynamic> reportData = <String, dynamic>{};
    for (var field in workflowFieldEntity?.detailsFields ?? []) {
      reportData[field['Name']] = data[field['key']];
    }
    return reportData;
  }
}

class CRRequestDetailsEntity extends BaseEntity {
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
  List<CRAttachmentEntity>? attachments;

  CRRequestDetailsEntity();
}

class CRRequestStepEntity extends BaseEntity {
  int? requestStepId;
  String? stepName;
  int? assignedTo;
  String? assigneDisplayName;
  String? updatedAt;
  RequestStepStatus? status;
  List<CRRequestStepAssigneeEntity> assignees = [];

  CRRequestStepEntity();
}

class CRRequestStepAssigneeEntity extends BaseEntity {
  int? employeeId;
  int? roleId;
  List<CRRequestStepActionEntity> actions = [];

  CRRequestStepAssigneeEntity();
}

class CRRequestStepActionEntity extends BaseEntity {
  RequestStepStatus? actionId;
  String? actionName;

  CRRequestStepActionEntity();
}

class CRAttachmentEntity extends BaseEntity {
  int? id;
  String? name;
  String? createdOn;
  String? requestID;
  int? workflowID;
  int? commentID;

  @override
  String toString() {
    return name ?? '';
  }
}

class CRRequestHistoryEntity extends BaseEntity {
  int? id;
  String? name;
  String? createdOn;
  String? requestID;
  int? employeeID;
  int? stepID;
  RequestStepStatus? status;
  List<CRCommentEntity> comments = [];
  List<CRAttachmentEntity> attachments = [];
}

class CRCommentEntity extends BaseEntity {
  int? id;
  String? comment;
  String? createdOn;
  String? requestID;
  int? employeeID;
}

class WorkflowFieldEntity extends BaseEntity {
  int? id;
  List<Map<String, dynamic>> formFields = [];
  List<Map<String, dynamic>> reportFields = [];
  List<Map<String, dynamic>> detailsFields = [];
}
