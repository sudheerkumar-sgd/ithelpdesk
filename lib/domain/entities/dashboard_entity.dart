// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/core/extensions/string_extension.dart';
import 'package:ithelpdesk/domain/entities/base_entity.dart';

import 'user_credentials_entity.dart';

class DashboardEntity extends BaseEntity {
  int? id;
  int? notAssignedRequests;
  int? openRequests;
  int? closedRequests;
  int? totalRequests;
  List<TicketsByMonthEntity>? ticketsByMonth;
  List<TicketsByCategoryEntity>? ticketsByCategory;
  List<TicketEntity> assignedTickets = [];
  List<TicketEntity> myTickets = [];
  List<TicketEntity> teamTickets = [];
  List<TicketEntity> historyTickets = [];
}

class TicketsByMonthEntity extends BaseEntity {
  double? month;
  double? count;
}

class TicketsByCategoryEntity extends BaseEntity {
  int? category;
  int? count;
}

class TicketPageEntity extends BaseEntity {
  List<TicketEntity> ticketsList = [];
  int? totalCount;
  int? pageCount;
}

class TicketEntity extends BaseEntity {
  int? id;
  String? subject;
  String? subjectAr;
  int? subjectID;
  int? categoryID;
  String? categoryName;
  String? categoryNameAr;
  int? subCategoryID;
  String? date;
  int? departmentID;
  String? departmentName;
  PriorityType? priority;
  String? mobileNumber;
  int? userID;
  String? creator;
  int? level;
  int? assignedUserID;
  String? assignedTo;
  AssigneType? assigneType;
  int? previousAssignedID;
  String? transferBy;
  String? assignedDate;
  String? forwardedDate;
  bool? isChargeable;
  bool? isDeleted;
  String? dueDate;
  String? finalComments;
  StatusType? status;
  String? createdOn;
  String? reopenedOn;
  String? closedOn;
  String? updatedOn;
  int? requestType;
  int? serviceId;
  String? computerName;
  String? serviceReqNo;
  String? serviceName;
  List<String>? attachments;
  int? teamCount;
  AssigneType? userType;
  bool? isMaxLevel;
  IssueType? issueType;
  String? tradeLicenseName;
  int? tradeLicenseNumber;
  int? raisedBy;
  String? raisedByName;
  String? email;
  String? customerMobileNumber;

  @override
  String toString() {
    return '$id - $subject';
  }

  bool isMyTicket() {
    return (userID == UserCredentialsEntity.details().id &&
        assignedUserID != userID);
  }

  @override
  List<Object?> get props => [
        id,
      ];

  List<StatusType> getActionButtonsForMytickets(BuildContext context) {
    final actionButtons = List<StatusType>.empty(growable: true);
    if (status != StatusType.reject && status != StatusType.closed) {
      actionButtons.add(StatusType.closed);
    }
    if (status == StatusType.returned &&
        assignedUserID == UserCredentialsEntity.details().id) {
      actionButtons.add(StatusType.resubmit);
    }
    if (status == StatusType.closed &&
        getDays(getDateTimeByString('dd-MMM-yyyy HH:mm', closedOn ?? ''),
                DateTime.now()) <
            5) {
      actionButtons.add(StatusType.reopen);
    }
    return actionButtons;
  }

  List<StatusType> getActionButtonsForAssigned(BuildContext context) {
    final actionButtons = List<StatusType>.empty(growable: true);

    if (status == StatusType.open &&
        assignedUserID != null &&
        userType == AssigneType.implementer &&
        assignedUserID != UserCredentialsEntity.details().id) {
      actionButtons.add(StatusType.acquired);
      return actionButtons;
    }
    if (status == StatusType.closed && userType == AssigneType.approver) {
      actionButtons.add(StatusType.reopen);
      return actionButtons;
    }
    if (status == StatusType.closed || status == StatusType.reject) {
      return actionButtons;
    }
    if (assignedUserID != null &&
        assignedUserID != UserCredentialsEntity.details().id &&
        userType == AssigneType.approver) {
      actionButtons.add(StatusType.reAssign);
      return actionButtons;
    }
    if ((assignedUserID == UserCredentialsEntity.details().id ||
        assignedUserID == null)) {
      actionButtons.add(StatusType.returned);
    }
    if ((status == StatusType.open ||
            status == StatusType.acquired ||
            status == StatusType.returned) &&
        (userType == AssigneType.approver ||
            (userType == AssigneType.implementer ||
                assignedUserID == UserCredentialsEntity.details().id))) {
      if (userType == AssigneType.implementer ||
          assignedUserID == UserCredentialsEntity.details().id) {
        actionButtons.add(StatusType.forward);
      } else {
        actionButtons.add(
            assignedUserID == null ? StatusType.approve : StatusType.reAssign);
      }
    }
    if ((status == StatusType.open || status == StatusType.returned) &&
        assignedUserID == UserCredentialsEntity.details().id &&
        userType == AssigneType.implementer) {
      actionButtons.add(StatusType.acquired);
    }
    actionButtons.add(StatusType.closed);
    if (status == StatusType.hold &&
        assignedUserID == UserCredentialsEntity.details().id) {
      actionButtons.add(StatusType.open);
    }
    if (status == StatusType.returned &&
        assignedUserID == UserCredentialsEntity.details().id) {
      StatusType.resubmit;
    }
    if (status != StatusType.hold &&
        assignedUserID == UserCredentialsEntity.details().id) {
      actionButtons.add(StatusType.hold);
    }
    actionButtons.add(StatusType.reject);
    return actionButtons;
  }

  List<StatusType> getActionButtons(BuildContext context,
      {bool showMyTicketActions = false}) {
    return (showMyTicketActions || isMyTicket())
        ? getActionButtonsForMytickets(context)
        : getActionButtonsForAssigned(context);
  }

  bool isTicketChargeable() {
    return categoryID == 1 &&
        UserCredentialsEntity.details().userType == UserType.sgdIT;
  }

  bool canEnable() {
    return userType == AssigneType.approver &&
        status != StatusType.closed &&
        status != StatusType.reject;
  }

  bool get isCommentRequired =>
      status == StatusType.hold ||
      status == StatusType.reject ||
      status == StatusType.closed;

  bool get showIssueType => (status == StatusType.closed && categoryID == 3);

  Map<String, dynamic> toJson() => {
        "id": id ?? '',
        "employeeName": creator ?? '',
        "Category": isSelectedLocalEn
            ? categoryName ?? ''
            : categoryNameAr ?? (categoryName ?? ''),
        "subject":
            isSelectedLocalEn ? subject ?? '' : subjectAr ?? (subject ?? ''),
        "status": status,
        "issueType": issueType?.toString() ?? '',
        "priority": priority,
        "assignee": assignedTo ?? '',
        "department": departmentName ?? '',
        "createDate": createdOn ?? '',
        "updateDate": updatedOn ?? '',
      };
  Map<String, dynamic> toMobileJson() => {
        "id": id ?? '',
        "subject":
            isSelectedLocalEn ? subject ?? '' : subjectAr ?? (subject ?? ''),
        "status": status,
        "priority": priority,
        "updatedDate": updatedOn ?? createdOn ?? '',
      };
  Map<String, dynamic> toITCategotyPrintJson() => {
        "TicketNo": id ?? '',
        "Department": departmentName ?? '',
        "CreatedDate": createdOn ?? '',
        closedOn != null ? 'ClosedDate' : 'UpdatedDate':
            closedOn != null ? closedOn ?? '' : updatedOn ?? createdOn ?? '',
        "AssignedTo": assignedTo ?? '',
        "ClosedBy": status == StatusType.closed ? assignedTo ?? '' : '',
        "status": status,
        "priority": priority,
        "TransferredBy": transferBy ?? '',
        "Charges": isChargeable ?? false ? '50' : '',
      };
  Map<String, dynamic> toCreateJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) {
      data["id"] = id;
    }
    data['userID'] = userID;
    data['subject'] = subject;
    data['subjectID'] = subjectID;
    data['categoryID'] = categoryID;
    data['subCategoryID'] = subCategoryID;
    data['description'] = description;
    data['departmentID'] = departmentID;
    data['assignedTo'] = assignedUserID;
    data['priority'] = priority?.value;
    data['mobileNumber'] = mobileNumber;
    data['requestType'] = 2;
    data['status'] = status?.value ?? 1;
    data['lastComments'] =
        (finalComments ?? '').isNotEmpty ? finalComments : null;
    data['serviceId'] = serviceId;
    data['serviceReqNo'] = serviceReqNo;
    data['serviceName'] = serviceName;
    data['tradeLicenseName'] = tradeLicenseName;
    data['tradeLicenseNumber'] = tradeLicenseNumber;
    data['isChargeable'] = isChargeable;
    data['issueType'] = issueType?.value;
    data['raisedBy'] = raisedBy;
    data['email'] = email;
    data['customerMobileNumber'] = customerMobileNumber;
    return data;
  }

  Map<String, dynamic> toExcel() => {
        "id": id ?? '',
        "employeeName": creator ?? '',
        "category": categoryName ?? '',
        "subject": subject ?? '',
        'description': description,
        "status": status,
        "priority": priority,
        "assignee": assignedTo ?? '',
        "department": departmentName ?? '',
        'mobileNumber': mobileNumber ?? '',
        'serviceId': serviceId ?? '',
        'serviceReqNo': serviceReqNo ?? '',
        'serviceName': serviceName ?? '',
        'tradeLicenseName': tradeLicenseName ?? '',
        'tradeLicenseNumber': tradeLicenseNumber ?? '',
        'Issue Type': (issueType?.toString() ?? '').capitalize(),
        'Reason For Issue': finalComments ?? '',
        'requestType': 2,
        'raisedBy': raisedByName ?? '',
        'isChargeable': isChargeable ?? false ? 'Yes' : 'No',
        "createDate": createdOn ?? '',
        "closedDate": closedOn ?? '',
      };
}

class TicketHistoryEntity extends BaseEntity {
  String? userDisplayName;
  String? userName;
  String? subject;
  String? comment;
  String? date;
  List<String>? attachments;
}
