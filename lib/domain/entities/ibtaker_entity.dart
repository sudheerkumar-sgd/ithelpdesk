// ignore_for_file: must_be_immutable
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/domain/entities/base_entity.dart';

class IbtakerListDataEntity extends BaseEntity {
  int? pageNumber;
  int? pageSize;
  int? totalCount;
  int? totalPages;
  List<IbtakerIdeaEntity> ideas = [];
  List<IbtakerStatusCountEntity> countByStatus = [];
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
  IbtakerStatus? status;
  bool? isDeleted;
  String? createdOn;
  IbtakerDepartmentEntity? departmentData;
  List<IbtakerActionEntity> actions = [];
  List<IbtakerAttachmentEntity> ibtakerAttachments = [];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'proposalTitle': proposalTitle,
      'proposalType': proposalType,
      'currentIssue': currentIssue,
      'improvementProposal': improvementProposal,
      'status': status?.toString(),
      'createdOn':
          getDateByformat('dd-MM-yyyy', DateTime.parse(createdOn ?? '')),
      'department': departmentData?.shortName ?? '',
    };
  }

  Map<String, dynamic> toExcel() {
    final m = toJson();
    return m.map((k, v) => MapEntry(k, v ?? ''));
  }
}

class IbtakerActionEntity extends BaseEntity {
  int? id;
  int? ibtakerId;
  int? actionType;
  IbtakerStatus? action;
  int? actionBy;
  String? actionByName;
  int? actionTo;
  String? remarks;
  String? actionDate;
}

class IbtakerStatusCountEntity extends BaseEntity {
  String? status;
  int? statusValue;
  int? count;
}

class IbtakerAttachmentEntity extends BaseEntity {
  int? id;
  int? ibtakerId;
  String? filePath;
  String? uploadedOn;
}
