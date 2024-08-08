// ignore_for_file: must_be_immutable

import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/data/model/base_model.dart';
import 'package:ithelpdesk/domain/entities/dashboard_entity.dart';

class DashboardModel extends BaseModel {
  int? id;
  int? notAssignedRequests;
  int? openRequests;
  int? closedRequests;
  int? totalRequests;
  List<TicketsByMonthEntity>? ticketsByMonth;
  List<TicketsByCategoryEntity>? ticketsByCategory;
  List<TicketEntity> assignedTickets = [];
  List<TicketEntity> myTickets = [];

  DashboardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    notAssignedRequests = json['notAssignedRequests'];
    openRequests = json['openRequests'];
    closedRequests = json['closedRequests'];
    totalRequests = json['totalRequests'];
    if (json['ticketsByMonth'] != null) {
      ticketsByMonth = <TicketsByMonthEntity>[];
      json['ticketsByMonth'].forEach((v) {
        ticketsByMonth!.add(TicketsByMonthModel.fromJson(v).toEntity());
      });
    }
    if (json['ticketsByCategory'] != null) {
      ticketsByCategory = <TicketsByCategoryEntity>[];
      json['ticketsByCategory'].forEach((v) {
        ticketsByCategory!.add(TicketsByCategoryModel.fromJson(v).toEntity());
      });
    }
    if (json['assignedTickets'] != null) {
      assignedTickets = <TicketEntity>[];
      json['assignedTickets'].forEach((v) {
        assignedTickets.add(TicketsModel.fromJson(v).toEntity());
      });
    }
    if (json['myTickets'] != null) {
      myTickets = <TicketEntity>[];
      json['myTickets'].forEach((v) {
        myTickets.add(TicketsModel.fromJson(v).toEntity());
      });
    }
  }

  @override
  DashboardEntity toEntity() {
    var dashboardEntity = DashboardEntity();
    dashboardEntity.notAssignedRequests = notAssignedRequests;
    dashboardEntity.openRequests = openRequests;
    dashboardEntity.closedRequests = closedRequests;
    dashboardEntity.totalRequests = totalRequests;
    dashboardEntity.ticketsByMonth = ticketsByMonth;
    dashboardEntity.ticketsByCategory = ticketsByCategory;
    dashboardEntity.assignedTickets = assignedTickets;
    dashboardEntity.myTickets = myTickets;
    return dashboardEntity;
  }
}

class TicketsByMonthModel extends BaseModel {
  double? month;
  double? count;

  TicketsByMonthModel.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['month'] = month;
    data['count'] = count;
    return data;
  }

  @override
  TicketsByMonthEntity toEntity() {
    var ticketsByMonthEntity = TicketsByMonthEntity();
    ticketsByMonthEntity.month = month;
    ticketsByMonthEntity.count = count;
    return ticketsByMonthEntity;
  }
}

class TicketsByCategoryModel extends BaseModel {
  int? category;
  int? count;

  TicketsByCategoryModel.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['category'] = category;
    data['count'] = count;
    return data;
  }

  @override
  TicketsByCategoryEntity toEntity() {
    var ticketsByCategoryEntity = TicketsByCategoryEntity();
    ticketsByCategoryEntity.category = category;
    ticketsByCategoryEntity.count = count;
    return ticketsByCategoryEntity;
  }
}

class TicketsModel extends BaseModel {
  int? id;
  String? subject;
  int? categoryID;
  String? categoryName;
  int? subCategoryID;
  int? subjectID;
  String? date;
  String? description;
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
  String? status;
  String? createdOn;
  String? reopenedOn;
  String? closedOn;
  String? updatedOn;
  int? requestType;
  String? computerName;
  String? duplicateRequestID;
  bool? isCustomAssign;

  TicketsModel.fromJson(Map<String, dynamic> ticketsJson) {
    final json = ticketsJson['data'] ?? ticketsJson;
    id = json['id'];
    subject = json['subject'];
    subjectID = json['subjectID'];
    categoryID = json['categoryID'];
    categoryName = json['category'];
    subCategoryID = json['subCategoryID'];
    date = json['date'];
    description = json['description'];
    departmentID = json['departmentID'];
    departmentName = json['departmentName'];
    priority = json['priority'];
    mobileNumber = json['mobileNumber'];
    userID = json['userID'];
    creator = json['creator'];
    level = json['level'];
    assignedTo = json['assignedTo'];
    previousAssignee = json['previousAssignee'];
    transferBy = json['transferBy'];
    assignedDate = json['assignedDate'];
    forwardedDate = json['forwardedDate'];
    isChargeable = json['isChargeable'];
    isDeleted = json['isDeleted'];
    dueDate = json['dueDate'];
    finalComments = json['finalComments'];
    status = json['status'];
    createdOn = json['createdOn'];
    reopenedOn = json['reopenedOn'];
    closedOn = json['closedOn'];
    updatedOn = json['updatedOn'];
    requestType = json['requestType'];
    computerName = json['computerName'];
    duplicateRequestID = json['duplicateRequestID'];
    isCustomAssign = json['isCustomAssign'];
  }

  @override
  TicketEntity toEntity() {
    var ticketsEntity = TicketEntity();
    ticketsEntity.id = id;
    ticketsEntity.subject = subject;
    ticketsEntity.subjectID = subjectID;
    ticketsEntity.categoryID = categoryID;
    ticketsEntity.categoryName = categoryName;
    ticketsEntity.subCategoryID = subCategoryID;
    ticketsEntity.date = date;
    ticketsEntity.description = description;
    ticketsEntity.departmentID = departmentID;
    ticketsEntity.departmentName = departmentName;
    ticketsEntity.priority = priority;
    ticketsEntity.mobileNumber = mobileNumber;
    ticketsEntity.userID = userID;
    ticketsEntity.creator = creator;
    ticketsEntity.level = level;
    ticketsEntity.assignedTo = assignedTo;
    ticketsEntity.previousAssignee = previousAssignee;
    ticketsEntity.transferBy = transferBy;
    ticketsEntity.assignedDate = assignedDate;
    ticketsEntity.forwardedDate = forwardedDate;
    ticketsEntity.isChargeable = isChargeable;
    ticketsEntity.isDeleted = isDeleted;
    ticketsEntity.dueDate = dueDate;
    ticketsEntity.finalComments = finalComments;
    ticketsEntity.status = StatusType.fromName(status ?? StatusType.open.name);
    ticketsEntity.createdOn = createdOn;
    ticketsEntity.reopenedOn = reopenedOn;
    ticketsEntity.closedOn = closedOn;
    ticketsEntity.updatedOn = updatedOn;
    ticketsEntity.requestType = requestType;
    ticketsEntity.computerName = computerName;
    return ticketsEntity;
  }
}

class TicketHistoryModel extends BaseModel {
  String? userName;
  String? subject;
  String? date;

  TicketHistoryModel.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    subject = json['subject'];
    date = json['date'];
  }

  @override
  TicketHistoryEntity toEntity() {
    var ticketHistoryEntity = TicketHistoryEntity();
    ticketHistoryEntity.userName = userName;
    ticketHistoryEntity.subject = subject;
    ticketHistoryEntity.date = date;
    return ticketHistoryEntity;
  }
}
