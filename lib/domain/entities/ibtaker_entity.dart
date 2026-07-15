// ignore_for_file: must_be_immutable
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/domain/entities/base_entity.dart';
import 'package:ithelpdesk/domain/entities/master_data_entities.dart';

class IbtakerListDataEntity extends BaseEntity {
  int? pageNumber;
  int? pageSize;
  int? totalCount;
  int? totalPages;
  List<IbtakerIdeaEntity> ideas = [];
  List<IbtakerStatusCountEntity> countByStatus = [];
}

class IbtakerProposalTypeEntity extends BaseEntity {
  int? id;
  String? name;
  String? nameAr;

  bool get isOther {
    final en = (name ?? '').trim().toLowerCase();
    final ar = (nameAr ?? '').trim();
    return en == 'other' || ar == 'أخرى' || ar == 'اخرى';
  }

  String displayName({required bool isLocalEn}) {
    if (isLocalEn) {
      return name ?? '';
    }
    return (nameAr?.isNotEmpty ?? false) ? nameAr! : (name ?? '');
  }
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
  String? eid;
  String? email;
  String? mobileNumber;
  IbtakerType? ibtakerType;
  IbtakerStatus? status;
  bool? isDeleted;
  String? createdOn;
  DepartmentEntity? departmentData;
  IbtakerProposalTypeEntity? proposalTypeData;
  DepartmentEntity? proposalToData;
  List<IbtakerActionEntity> actions = [];
  List<IbtakerAttachmentEntity> ibtakerAttachments = [];

  String get displayProposalType {
    return displayProposalTypeLocalized(isLocalEn: isSelectedLocalEn);
  }

  String displayProposalTypeLocalized({required bool isLocalEn}) {
    if (proposalTypeData != null) {
      if (proposalTypeData!.isOther) {
        return (proposalType?.isNotEmpty ?? false)
            ? proposalType!
            : proposalTypeData!.displayName(isLocalEn: isLocalEn);
      }
      return proposalTypeData!.displayName(isLocalEn: isLocalEn);
    }
    return proposalType ?? '';
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      if (ibtakerType == IbtakerType.internal)
        'department': departmentData?.shortName ?? '',
      'proposalTitle': proposalTitle,
      'proposalType': displayProposalType,
      'proposalTo': proposalToData?.shortName ?? proposalToData?.name ?? '',
      'currentIssue': currentIssue,
      'improvementProposal': improvementProposal,
      'status': status?.toString(),
      'createdOn':
          getDateByformat('dd-MM-yyyy', DateTime.parse(createdOn ?? '')),
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
  String? actionToName;
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
