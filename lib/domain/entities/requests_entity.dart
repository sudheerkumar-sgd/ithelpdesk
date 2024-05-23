// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:smartuaq/core/constants/constants.dart';
import 'package:smartuaq/core/constants/data_constants.dart';
import 'package:smartuaq/domain/entities/base_entity.dart';
import 'package:smartuaq/res/resources.dart';

class RequestsListEntity extends BaseEntity {
  List<RequestsEntity> requests = [];
}

class RequestsEntity extends BaseEntity {
  String? requestId;
  String? serviceId;
  String? establishmentId;
  String? requestCode;
  int? status;
  String? submitDate;
  String? creationDate;
  String? serviceNameEn;
  String? serviceNameAr;
  String? statusName;
  String? statusNameEn;
  String? statusNameAR;
  String? redirectUrl;
  String? viewUrl;
  String? comment;
  List<RequestTimeLineEntity> requestTimeLine = [];
  RequestsEntity();
  RequestsEntity.create(
      this.requestCode, this.serviceNameEn, this.statusNameAR, this.statusName);

  @override
  List<Object?> get props => [requestId];

  String get getServiceName =>
      isSelectedLocalEn ? serviceNameEn ?? '' : serviceNameAr ?? '';
  String get getStatus =>
      isSelectedLocalEn ? statusNameEn ?? '' : statusNameAR ?? '';

  Color getColorByStatus(Resources resources) {
    if ((statusName ?? '').toLowerCase().contains('complete')) {
      return resources.color.completed;
    } else if ((statusName ?? '').toLowerCase().contains('rejected')) {
      return resources.color.rejected;
    } else {
      return resources.color.pending;
    }
  }

  bool get isPending =>
      (!(statusName ?? '').toLowerCase().contains('complete') &&
          !(statusName ?? '').toLowerCase().contains('rejected'));

  bool get isPendingForAction =>
      pendingActionTypes.contains((statusName ?? '').toLowerCase()) ||
      pendingActionTypes.contains((statusNameEn ?? '').toLowerCase()) ||
      (statusName ?? '').toLowerCase().contains('payment');

  bool get isCompleted => (statusName ?? '').toLowerCase().contains('complete');

  bool get isRejected => (statusName ?? '').toLowerCase().contains('rejected');
}

class RequestTimeLineEntity extends BaseEntity {
  String? actionId;
  String? nameEN;
  String? nameAR;
  String? creationDate;
  String? status;
  String? did;
  String? requestHistoryId;

  @override
  List<Object?> get props => [status, requestHistoryId];

  String get getStepName => isSelectedLocalEn ? nameEN ?? '' : nameAR ?? '';

  Color getColorByStatus(Resources resources) {
    return (actionId ?? '0') == '0'
        ? resources.color.pending
        : (actionId ?? '0') == '2'
            ? resources.color.rejected
            : resources.color.completed;
  }
}

class NotificationListEntity extends BaseEntity {
  List<NotificationEntity> notofications = [];
}

class NotificationEntity extends BaseEntity {
  String? title;
  String? body;
  String? date;

  @override
  List<Object?> get props => [title, date];
}
