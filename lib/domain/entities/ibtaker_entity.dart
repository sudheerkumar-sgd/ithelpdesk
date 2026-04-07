// ignore_for_file: must_be_immutable
import 'package:ithelpdesk/domain/entities/base_entity.dart';

class IbtakerListDataEntity extends BaseEntity {
  int? pageNumber;
  int? pageSize;
  int? totalCount;
  int? totalPages;
  List<IbtakerIdeaEntity> ideas = [];
}

class IbtakerDepartmentEntity extends BaseEntity {
  int? id;
  String? name;
  String? shortName;
}

class IbtakerIdeaEntity extends BaseEntity {
  int? id;
  String? name;
  String? empID;
  String? username;
  String? proposalTitle;
  String? proposalType;
  String? currentIssue;
  String? improvementProposal;
  String? attachments;
  int? status;
  bool? isDeleted;
  String? createdOn;
  IbtakerDepartmentEntity? departmentData;
  List<IbtakerActionEntity> actions = [];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'empID': empID,
      'username': username,
      'proposalTitle': proposalTitle,
      'proposalType': proposalType,
      'currentIssue': currentIssue,
      'improvementProposal': improvementProposal,
      'status': status,
      'createdOn': createdOn,
      'department': departmentData?.name ?? '',
    };
  }
}

class IbtakerActionEntity extends BaseEntity {
  int? id;
  int? ibtakerId;
  int? actionType;
  int? actionBy;
  int? actionTo;
  String? remarks;
  String? actionDate;

  String get actionName {
    switch (actionType) {
      case 1:
        return 'Created';
      case 2:
        return 'Transferred';
      case 3:
        return 'Approved';
      case 4:
        return 'Hold';
      case 5:
        return 'Rejected';
      default:
        return 'Updated';
    }
  }
}
