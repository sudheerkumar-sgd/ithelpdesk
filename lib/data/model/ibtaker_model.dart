import 'package:ithelpdesk/data/model/base_model.dart';
import 'package:ithelpdesk/domain/entities/ibtaker_entity.dart';

class IbtakerListDataModel extends BaseModel {
  int? pageNumber;
  int? pageSize;
  int? totalCount;
  int? totalPages;
  List<IbtakerIdeaEntity> ideas = [];

  IbtakerListDataModel.fromJson(Map<String, dynamic> response) {
    pageNumber = response['pageNumber'] as int?;
    pageSize = response['pageSize'] as int?;
    totalCount = response['totalCount'] as int?;
    totalPages = response['totalPages'] as int?;
    final dynamic rawIdeas = response['data'];
    if (rawIdeas is List) {
      ideas = <IbtakerIdeaEntity>[];
      for (final dynamic e in rawIdeas) {
        if (e is Map<String, dynamic>) {
          ideas.add(IbtakerIdeaModel.fromJson(e)
              .toEntity());
        }
      }
    }
  }

  @override
  IbtakerListDataEntity toEntity() {
    return IbtakerListDataEntity()
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..totalCount = totalCount
      ..totalPages = totalPages
      ..ideas = ideas;
  }
}

class IbtakerDepartmentModel extends BaseModel {
  int? id;
  String? name;
  String? shortName;

  IbtakerDepartmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    shortName = json['shortName'] as String?;
  }

  @override
  IbtakerDepartmentEntity toEntity() {
    return IbtakerDepartmentEntity()
      ..id = id
      ..name = name
      ..shortName = shortName;
  }
}

class IbtakerIdeaModel extends BaseModel {
  int? id;
  String? name;
  String? empID;
  String? username;
  String? proposalTitle;
  String? proposalType;
  String? currentIssue;
  String? improvementProposal;
  dynamic attachments;
  int? status;
  bool? isDeleted;
  String? createdOn;
  IbtakerDepartmentEntity? departmentData;
  List<IbtakerActionEntity> actions = [];

  IbtakerIdeaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    empID = json['empID']?.toString();
    username = json['username'] as String?;
    proposalTitle = json['proposalTitle'] as String?;
    proposalType = json['proposalType'] as String?;
    currentIssue = json['currentIssue'] as String?;
    improvementProposal = json['improvementProposal'] as String?;
    attachments = json['attachments'];
    status = json['status'] as int?;
    isDeleted = json['isDeleted'] as bool?;
    createdOn = json['createdOn'] as String?;
    final dynamic dept = json['departmentData'];
    if (dept is Map) {
      departmentData =
          IbtakerDepartmentModel.fromJson(Map<String, dynamic>.from(dept))
              .toEntity();
    }
    final dynamic actionItems = json['actions'];
    if (actionItems is List) {
      actions = <IbtakerActionEntity>[];
      for (final dynamic action in actionItems) {
        if (action is Map<String, dynamic>) {
          actions.add(IbtakerActionModel.fromJson(action).toEntity());
        }
      }
    }
  }

  @override
  IbtakerIdeaEntity toEntity() {
    return IbtakerIdeaEntity()
      ..id = id
      ..name = name
      ..empID = empID
      ..username = username
      ..proposalTitle = proposalTitle
      ..proposalType = proposalType
      ..currentIssue = currentIssue
      ..improvementProposal = improvementProposal
      ..attachments = attachments?.toString()
      ..status = status
      ..isDeleted = isDeleted
      ..createdOn = createdOn
      ..departmentData = departmentData
      ..actions = actions;
  }
}

class IbtakerActionModel extends BaseModel {
  int? id;
  int? ibtakerId;
  int? actionType;
  int? actionBy;
  int? actionTo;
  String? remarks;
  String? actionDate;

  IbtakerActionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    ibtakerId = json['ibtakerId'] as int?;
    actionType = json['actionType'] as int?;
    actionBy = json['actionBy'] as int?;
    actionTo = json['actionTo'] as int?;
    remarks = json['remarks'] as String?;
    actionDate = json['actionDate'] as String?;
  }

  @override
  IbtakerActionEntity toEntity() {
    return IbtakerActionEntity()
      ..id = id
      ..ibtakerId = ibtakerId
      ..actionType = actionType
      ..actionBy = actionBy
      ..actionTo = actionTo
      ..remarks = remarks
      ..actionDate = actionDate;
  }
}
