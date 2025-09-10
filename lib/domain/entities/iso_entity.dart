// ignore_for_file: must_be_immutable
import 'package:ithelpdesk/domain/entities/base_entity.dart';

class CRRequestEntity extends BaseEntity {
  int? requestId;
  int? workflowId;
  int? status;
  String? createdAt;
  String? completedAt;
  CRRequestDetailsEntity? details;

  CRRequestEntity();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requestId'] = requestId;
    data['firstName'] = details?.firstName;
    data['lastName'] = details?.lastName;
    data['fullName'] = details?.fullName;
    data['designation'] = details?.designation;
    data['department'] = details?.departmentName;
    data['emailID'] = details?.emailID;
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

  CRRequestDetailsEntity();
}
