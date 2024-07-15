// ignore_for_file: must_be_immutable

import 'package:ithelpdesk/domain/entities/base_entity.dart';

class DashboardEntity extends BaseEntity {
  int? id;
  int? notAssignedRequests;
  int? openRequests;
  int? closedRequests;
  int? totalRequests;
  List<TicketsByMonthEntity>? ticketsByMonth;
  List<TicketsByCategoryEntity>? ticketsByCategory;
  List<TicketEntity>? latestTickets;
}

class TicketsByMonthEntity extends BaseEntity {
  int? month;
  int? count;
}

class TicketsByCategoryEntity extends BaseEntity {
  int? category;
  int? count;
}

class TicketEntity extends BaseEntity {
  int? id;
  String? subject;
  int? categoryID;
  int? subCategoryID;
  String? date;
  int? departmentID;
  int? priority;
  String? mobileNumber;
  int? userID;
  int? level;
  int? assignedTo;
  int? previousAssignee;
  int? transferBy;
  String? assignedDate;
  String? forwardedDate;
  bool? isChargeable;
  bool? isDeleted;
  String? dueDate;
  String? finalComments;
  int? status;
  String? createdOn;
  String? reopenedOn;
  String? closedOn;
  String? updatedOn;
  int? requestType;
  String? computerName;

  Map<String, dynamic> toJson({bool showActionButtons = false}) => {
        "id": id ?? '',
        "employeeName": userID ?? '',
        "subject": subject ?? '',
        "status": status ?? '',
        "priority": priority ?? '',
        "assignee": assignedTo ?? '',
        "department": departmentID ?? '',
        "createDate": createdOn ?? '',
        "showActionButtons": showActionButtons,
      };
  Map<String, dynamic> toMobileJson({bool showActionButtons = false}) => {
        "id": id ?? '',
        "subject": subject ?? '',
        "status": status ?? '',
        "priority": priority ?? '',
        "createDate": createdOn ?? '',
        "showActionButtons": showActionButtons,
      };
}
