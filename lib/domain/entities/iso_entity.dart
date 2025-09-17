// ignore_for_file: must_be_immutable
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/domain/entities/base_entity.dart';

class CRRequestEntity extends BaseEntity {
  int? requestId;
  String? requestType;
  int? workflowId;
  int? currentStep;
  RequestStatus? status;
  String? createdAt;
  String? completedAt;
  String? attachmentUrlPrefix;
  CRRequestDetailsEntity? details;
  List<CRRequestStepEntity> steps = [];

  CRRequestEntity();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requestId'] = requestId;
    data['requestType'] = requestType;
    data['firstName'] = details?.firstName;
    data['lastName'] = details?.lastName;
    data['fullName'] = details?.fullName;
    data['designation'] = details?.designation;
    data['department'] = details?.departmentName;
    data['emailID'] = details?.emailID;
    data['employeeID'] = details?.employeeID;
    data['loginID'] = details?.loginID;
    data['accessTypeID'] = details?.accessTypeID;
    data['reportingManagerID'] = details?.reportingManagerID;
    data['dateOfJoining'] = details?.dateOfJoining;
    data['requestPriority'] = details?.requestPriority;
    data['reasonOfAccess'] = details?.reasonOfAccess;
    data['comments'] = details?.comments;
    data['createdAt'] = createdAt;
    return data;
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
  String? emailID;
  String? employeeID;
  String? loginID;
  String? accessTypeID;
  int? reportingManagerID;
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
}
