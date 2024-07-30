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
  int? subCategoryID;
  String? date;
  int? departmentID;
  String? departmentName;
  int? priority;
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
  String? status;
  String? createdOn;
  String? reopenedOn;
  String? closedOn;
  String? updatedOn;
  int? requestType;
  String? computerName;

  Map<String, dynamic> toJson({bool showActionButtons = false}) => {
        "id": id ?? '',
        "employeeName": creator ?? '',
        "subject": subject ?? '',
        "status": status ?? '',
        "priority": priority ?? '',
        "assignee": assignedTo ?? '',
        "department": departmentName ?? '',
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
  Map<String, dynamic> toCreateJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this.userID;
    data['subject'] = this.subject;
    data['subjectID'] = this.subjectID;
    data['categoryID'] = this.categoryID;
    data['subCategoryID'] = this.subCategoryID;
    data['description'] = this.description;
    data['departmentID'] = this.departmentID;
    data['priority'] = this.priority;
    data['mobileNumber'] = this.mobileNumber;
    data['requestType'] = 2;
    return data;
  }
}
