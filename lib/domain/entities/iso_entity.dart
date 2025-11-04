// ignore_for_file: must_be_immutable
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/domain/entities/base_entity.dart';
import 'package:ithelpdesk/domain/entities/form_entities.dart';

class CRRequestEntity extends BaseEntity {
  int? requestId;
  String? requestType;
  int? workflowId;
  int? currentStep;
  RequestStatus? requestStaus;
  String? createdAt;
  String? updatedAt;
  String? attachmentUrlPrefix;
  String? currentStepName;
  String? assginedEmployee;
  PriorityType? requestPriority;
  Map? requestDetail;

  //CRRequestDetailsEntity? details;
  WorkflowFieldEntity? workflowFieldEntity;
  List<CRRequestStepEntity> steps = [];
  List<CRRequestHistoryEntity> requestHistory = [];
  List<CRAttachmentEntity>? attachments;

  CRRequestEntity();

  Map<String, dynamic> toFullJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requestId'] = requestId;
    data['requestType'] = requestType;
    data['currentStepName'] = currentStepName;
    data['requestStaus'] = requestStaus;
    data['assginedEmployee'] = assginedEmployee;
    data['requestPriority'] = requestPriority?.toString();
    data['requestPriority'] = requestPriority.toString();
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
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

  Map<String, dynamic> toDetailsJson(Map step1Details) {
    final Map<String, dynamic> reportData = <String, dynamic>{};
    for (var field in workflowFieldEntity?.detailsFields ?? []) {
      if (step1Details[field['key'].toString().toLowerCase()] is List) {
        for (var e
            in (step1Details[field['key'].toString().toLowerCase()] as List)) {
          reportData[field['Name']] = (reportData[field['Name']] ?? '') +
              '${(e is Map) ? e['name'] : e}, ';
        }
      } else if (step1Details[field['key'].toString().toLowerCase()] is Map) {
        reportData[field['Name']] =
            step1Details[field['key'].toString().toLowerCase()]?['name'];
      } else {
        reportData[field['Name']] =
            step1Details[field['key'].toString().toLowerCase()];
      }
    }
    // for (var field in workflowFieldEntity?.detailsFields ?? []) {
    //   if (fields?[field['key'].toString().toLowerCase()] is Map) {
    //     reportData[field['Name']] =
    //         fields?[field['key'].toString().toLowerCase()]?['name'];
    //   } else {
    //     reportData[field['Name']] =
    //         fields?[field['key'].toString().toLowerCase()];
    //   }
    // }
    if (reportData['Updated On'] == null) {
      reportData.remove('Updated On');
    }
    return reportData;
  }

  Map<String, dynamic> toSubmittedJson(Map step1Details) {
    final Map<String, dynamic> reportData = <String, dynamic>{};
    for (var field in workflowFieldEntity?.detailsFields ?? []) {
      if (step1Details[field['key'].toString().toLowerCase()] == null ||
          step1Details[field['key'].toString().toLowerCase()] == "") {
        continue;
      }
      if (step1Details[field['key'].toString().toLowerCase()] is Map) {
        reportData[field['Name']] =
            step1Details[field['key'].toString().toLowerCase()]?['name'];
      } else {
        reportData[field['Name']] =
            step1Details[field['key'].toString().toLowerCase()];
      }
    }
    // for (var field in workflowFieldEntity?.detailsFields ?? []) {
    //   if (fields?[field['key'].toString().toLowerCase()] is Map) {
    //     reportData[field['Name']] =
    //         fields?[field['key'].toString().toLowerCase()]?['name'];
    //   } else {
    //     reportData[field['Name']] =
    //         fields?[field['key'].toString().toLowerCase()];
    //   }
    // }
    if (reportData['Updated On'] == null) {
      reportData.remove('Updated On');
    }
    return reportData;
  }

  Map<String, dynamic> toUiJson(List<FormEntity> fromFelds, Map details) {
    final Map<String, dynamic> reportData = <String, dynamic>{};
    for (var field in details.entries) {
      if (details[field.key] is Map) {
        reportData[field.key] = field.value['name'];
      } else {
        reportData[field.key] = field.value;
      }
    }
    // for (var field in workflowFieldEntity?.detailsFields ?? []) {
    //   if (fields?[field['key'].toString().toLowerCase()] is Map) {
    //     reportData[field['Name']] =
    //         fields?[field['key'].toString().toLowerCase()]?['name'];
    //   } else {
    //     reportData[field['Name']] =
    //         fields?[field['key'].toString().toLowerCase()];
    //   }
    // }
    // if (reportData['Updated On'] == null) {
    //   reportData['Updated On'] = updatedAt;
    // }
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
  int? stepOrder;
  List<FormEntity> inputFields = [];
  int? assignedTo;
  String? assigneDisplayName;
  String? updatedAt;
  RequestStepStatus? status;
  Map? stepFormData;
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
