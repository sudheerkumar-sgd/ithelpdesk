// ignore_for_file: must_be_immutable

import 'package:ithelpdesk/domain/entities/base_entity.dart';

class TicketEntity extends BaseEntity {
  int? id;
  String? employeeName;
  String? subject;
  String? status;
  String? priority;
  String? assignee;
  String? department;
  String? createDate;
  TicketEntity(this.id, this.employeeName, this.subject, this.status,
      this.priority, this.assignee, this.department, this.createDate);
  @override
  List<Object?> get props => [id];

  Map<String, dynamic> toJson() => {
        "id": id ?? '',
        "employeeName": employeeName ?? '',
        "subject": subject ?? '',
        "status": status ?? '',
        "priority": priority ?? '',
        "assignee": assignee ?? '',
        "department": department ?? '',
        "createDate": createDate ?? '',
      };
}
