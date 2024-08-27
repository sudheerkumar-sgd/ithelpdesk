// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/domain/entities/base_entity.dart';

import 'master_data_entities.dart';
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
}

class TicketsByMonthEntity extends BaseEntity {
  double? month;
  double? count;
}

class TicketsByCategoryEntity extends BaseEntity {
  int? category;
  int? count;
}

class TicketEntity extends BaseEntity {
  int? id;
  String? subject;
  int? subjectID;
  int? categoryID;
  String? categoryName;
  int? subCategoryID;
  String? date;
  int? departmentID;
  String? departmentName;
  String? priority;
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
  List<String>? attachments;
  int? teamCount;
  AssigneType? userType;
  bool? isMaxLevel;

  bool isMyTicket() {
    return (userID == UserCredentialsEntity.details().id);
  }

  List<ActionButtonEntity> getActionButtonsForMytickets(BuildContext context) {
    final actionButtons = List<ActionButtonEntity>.empty(growable: true);
    actionButtons.add(ActionButtonEntity(
        id: StatusType.closed.value,
        nameEn: context.resources.string.close,
        color: context.resources.color.viewBgColorLight));
    if (status == StatusType.returned &&
        assignedUserID == UserCredentialsEntity.details().id) {
      actionButtons.add(ActionButtonEntity(
          id: StatusType.resubmit.value,
          nameEn: 'Resubmit',
          color: context.resources.color.colorGreen26B757));
    }
    return actionButtons;
  }

  List<ActionButtonEntity> getActionButtonsForAssigned(BuildContext context) {
    final actionButtons = List<ActionButtonEntity>.empty(growable: true);
    if (status == StatusType.closed ||
        status == StatusType.reject ||
        userType == null) {
      return actionButtons;
    }
    if (assignedUserID != null &&
        assignedUserID != UserCredentialsEntity.details().id &&
        userType == AssigneType.approver) {
      actionButtons.add(ActionButtonEntity(
          id: StatusType.reAssign.value,
          nameEn: 'Re-Assign',
          color: context.resources.color.viewBgColorLight));
      return actionButtons;
    }
    if (status != StatusType.returned &&
        (assignedUserID == UserCredentialsEntity.details().id ||
            assignedUserID == null)) {
      actionButtons.add(ActionButtonEntity(
          id: StatusType.returned.value,
          nameEn: context.resources.string.returnText,
          color: context.resources.color.colorWhite));
    }
    if (status == StatusType.open &&
        (userType == AssigneType.approver ||
            (userType == AssigneType.implementer && (teamCount ?? 0) > 1))) {
      actionButtons.add(ActionButtonEntity(
          id: assigneType == AssigneType.implementer
              ? StatusType.forword.value
              : StatusType.approve.value,
          nameEn: assigneType == AssigneType.implementer
              ? context.resources.string.forwardTo
              : context.resources.string.approve,
          color: context.resources.color.colorGreen26B757));
    }
    actionButtons.add(ActionButtonEntity(
        id: StatusType.closed.value,
        nameEn: context.resources.string.close,
        color: context.resources.color.viewBgColorLight));
    if (status == StatusType.hold &&
        assignedUserID == UserCredentialsEntity.details().id) {
      actionButtons.add(ActionButtonEntity(
          id: StatusType.resubmit.value,
          nameEn: status == StatusType.hold
              ? 'Re-Open'
              : context.resources.string.open,
          color: context.resources.color.viewBgColor));
    }
    if (status == StatusType.returned &&
        assignedUserID == UserCredentialsEntity.details().id) {
      ActionButtonEntity(
          id: StatusType.resubmit.value,
          nameEn: context.resources.string.resubmit,
          color: context.resources.color.colorGreen26B757);
    }
    if (status != StatusType.hold &&
        assignedUserID == UserCredentialsEntity.details().id) {
      actionButtons.add(ActionButtonEntity(
          id: StatusType.hold.value,
          nameEn: context.resources.string.hold,
          color: context.resources.color.viewBgColor));
    }
    actionButtons.add(ActionButtonEntity(
        id: StatusType.reject.value,
        nameEn: context.resources.string.reject,
        color: context.resources.color.rejected));
    return actionButtons;
  }

  List<ActionButtonEntity> getActionButtons(BuildContext context) {
    return isMyTicket()
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

  Map<String, dynamic> toJson() => {
        "id": id ?? '',
        "employeeName": creator ?? '',
        "Category": categoryName ?? '',
        "subject": subject ?? '',
        "status": status?.name ?? '',
        "priority": priority ?? '',
        "assignee": assignedTo ?? '',
        "department": departmentName ?? '',
        "createDate": createdOn ?? '',
      };
  Map<String, dynamic> toMobileJson() => {
        "id": id ?? '',
        "Category": categoryName ?? '',
        "subject": subject ?? '',
        "status": status?.name ?? '',
        "priority": priority ?? '',
        "createDate": createdOn ?? '',
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
    data['priority'] = int.parse(priority ?? '4');
    data['mobileNumber'] = mobileNumber;
    data['requestType'] = 2;
    data['status'] = status?.value ?? 1;
    data['lastComments'] =
        (finalComments ?? '').isNotEmpty ? finalComments : null;
    data['serviceId'] = serviceId;
    data['serviceReqNo'] = serviceReqNo;
    return data;
  }
}

class TicketHistoryEntity extends BaseEntity {
  String? userName;
  String? subject;
  String? comment;
  String? date;
  List<String>? attachments;
}
