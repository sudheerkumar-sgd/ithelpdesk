// ignore_for_file: must_be_immutable

import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/domain/entities/base_entity.dart';

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
  String? level;
  String? assignedTo;
  int? previousAssignee;
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
  String? computerName;

  Map<String, dynamic> toJson({bool showActionButtons = false}) => {
        "id": id ?? '',
        "employeeName": creator ?? '',
        "Category": categoryName ?? '',
        "subject": subject ?? '',
        "status": status?.name ?? '',
        "priority": priority ?? '',
        "assignee": assignedTo ?? '',
        "department": departmentName ?? '',
        "createDate": createdOn ?? '',
        "showActionButtons": showActionButtons,
      };
  Map<String, dynamic> toMobileJson({bool showActionButtons = false}) => {
        "id": id ?? '',
        "Category": categoryName ?? '',
        "subject": subject ?? '',
        "status": status?.name ?? '',
        "priority": priority ?? '',
        "createDate": createdOn ?? '',
        "showActionButtons": showActionButtons,
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
    data['priority'] = int.parse(priority ?? '4');
    data['mobileNumber'] = mobileNumber;
    data['requestType'] = 2;
    data['status'] = status?.value ?? 1;
    data['finalComments'] = finalComments ?? '';
    return data;
  }
}

class TicketHistoryEntity extends BaseEntity {
  String? userName;
  String? subject;
  String? date;
}
