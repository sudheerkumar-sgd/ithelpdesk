// ignore_for_file: must_be_immutable

import 'package:smartuaq/core/common/common_utils.dart';
import 'package:smartuaq/data/model/base_model.dart';
import 'package:smartuaq/domain/entities/requests_entity.dart';

class RequestsListModel extends BaseModel {
  List<RequestsEntity> requests = [];

  RequestsListModel();

  factory RequestsListModel.fromJson(Map<String, dynamic> json) {
    var serviceCategoriesModel = RequestsListModel();
    serviceCategoriesModel.requests = json['RequestList'] != null
        ? (json['RequestList'] as List)
            .map((service) => RequestsModel.fromJson(service).toEntity())
            .toList()
        : [];
    return serviceCategoriesModel;
  }

  factory RequestsListModel.fromMyRequestsJson(Map<String, dynamic> json) {
    var serviceCategoriesModel = RequestsListModel();
    if (json['response']['department'] != null) {
      for (var department in (json['response']['department'] as List)) {
        if (department['department']['code'] == 'DED') {
          serviceCategoriesModel.requests.addAll(
              (department['requestDetailes'] as List)
                  .map((request) => RequestsModel.fromJson(request).toEntity())
                  .toList());
        }
      }
    }
    return serviceCategoriesModel;
  }

  @override
  List<Object?> get props => [
        requests,
      ];

  @override
  RequestsListEntity toEntity() {
    RequestsListEntity requestsListEntity = RequestsListEntity();
    requestsListEntity.requests = requests;
    return requestsListEntity;
  }
}

class RequestsModel extends BaseModel {
  String? requestId;
  String? serviceId;
  String? establishmentId;
  String? requestCode;
  int? status;
  String? statusName;
  String? submitDate;
  String? creationDate;
  String? serviceNameEn;
  String? serviceNameAr;
  String? statusNameEn;
  String? statusNameAR;
  String? redirectUrl;
  String? viewUrl;
  String? comment;
  List<RequestTimeLineEntity> requestTimeLine = [];
  RequestsModel();

  factory RequestsModel.fromJson(Map<String, dynamic> json) {
    var requestsModel = RequestsModel();
    requestsModel.requestId = '${json['id'] ?? ''}';
    requestsModel.serviceId = '${json['serviceId'] ?? ''}';
    requestsModel.establishmentId = '${json['establishmentId'] ?? ''}';
    requestsModel.requestCode = json['requestCode'];
    requestsModel.status = json['status'];
    requestsModel.submitDate = json['submitDate'];
    requestsModel.creationDate = json['creationDate'];
    requestsModel.serviceNameEn = json['serviceNameEN'];
    requestsModel.serviceNameAr = json['serviceNameAR'];
    if (json['serviceNameEN'] == null) {
      requestsModel.serviceNameEn = json['service']?['nameEn'];
      requestsModel.serviceNameAr = json['service']?['nameAr'];
    }
    if (json['statusNameEn'] == null) {
      requestsModel.statusName = json['requestCurrentStatus']?['statusName'];
      requestsModel.statusNameEn =
          json['requestCurrentStatus']?['statusNameEN'];
      requestsModel.statusNameAR =
          json['requestCurrentStatus']?['statusNameAR'];
    }
    requestsModel.redirectUrl = json['redirectUrl'];
    requestsModel.viewUrl = json['url'];
    if (requestsModel.requestCode?.startsWith('DED_') == false) {
      requestsModel.redirectUrl =
          (requestsModel.statusName ?? '').toLowerCase().contains('payment')
              ? '$getPaymentRedirectUrl${requestsModel.requestId}'
              : '$getRequestRedirectUrl${requestsModel.serviceId}';
      requestsModel.viewUrl = '$getRequestViewUrl${requestsModel.requestId}';
    } else {
      requestsModel.statusName = ((requestsModel.status ?? 0) == 1)
          ? 'complete'.toUpperCase()
          : ((requestsModel.status ?? 0) == 2)
              ? 'rejected'.toUpperCase()
              : 'pending'.toUpperCase();
    }
    if (json['requestTimeLine'] != null) {
      requestsModel.requestTimeLine = (json['requestTimeLine'] as List)
          .map((request) => RequestTimeLineModel.fromJson(request).toEntity())
          .toList();
    }
    return requestsModel;
  }

  factory RequestsModel.fromDetailsJson(Map<String, dynamic> json) {
    if (json['response'] is List) {
      return RequestsModel.fromJson(json['response'][0]);
    }
    final model = RequestsModel.fromJson(json['response']?['request']);
    model.comment = json['response']?['comment'];
    return model;
  }

  @override
  List<Object?> get props => [
        requestId,
        requestCode,
      ];

  @override
  RequestsEntity toEntity() {
    RequestsEntity requestsEntity = RequestsEntity();
    requestsEntity.requestId = requestId;
    requestsEntity.serviceId = serviceId;
    requestsEntity.establishmentId = establishmentId;
    requestsEntity.requestCode = requestCode;
    requestsEntity.status = status;
    requestsEntity.submitDate = submitDate;
    requestsEntity.creationDate = creationDate;
    requestsEntity.serviceNameEn = serviceNameEn;
    requestsEntity.serviceNameAr = serviceNameAr;
    requestsEntity.statusName = statusName;
    requestsEntity.statusNameEn = statusNameEn;
    requestsEntity.statusNameAR = statusNameAR;
    requestsEntity.requestTimeLine = requestTimeLine;
    requestsEntity.redirectUrl = redirectUrl;
    requestsEntity.viewUrl = viewUrl;
    requestsEntity.comment = comment;
    return requestsEntity;
  }
}

class RequestTimeLineModel extends BaseModel {
  String? actionId;
  String? nameEN;
  String? nameAR;
  String? creationDate;
  String? status;
  String? did;
  String? requestHistoryId;
  RequestTimeLineModel();

  factory RequestTimeLineModel.fromJson(Map<String, dynamic> json) {
    var requestTimeLineModel = RequestTimeLineModel();
    requestTimeLineModel.actionId = '${json['actionId'] ?? 0}';
    requestTimeLineModel.nameEN = json['nameEN'];
    requestTimeLineModel.nameAR = json['nameAR'];
    requestTimeLineModel.creationDate = json['creationDate'];
    requestTimeLineModel.status = '${json['status'] ?? ''}';
    requestTimeLineModel.did = '${json['did'] ?? ''}';
    requestTimeLineModel.requestHistoryId = '${json['requestHistoryId'] ?? ''}';
    return requestTimeLineModel;
  }

  @override
  List<Object?> get props => [
        status,
        requestHistoryId,
      ];

  @override
  RequestTimeLineEntity toEntity() {
    RequestTimeLineEntity requestsEntity = RequestTimeLineEntity();
    requestsEntity.actionId = actionId;
    requestsEntity.nameEN = nameEN;
    requestsEntity.nameAR = nameAR;
    requestsEntity.creationDate = creationDate;
    requestsEntity.status = status;
    requestsEntity.did = did;
    requestsEntity.requestHistoryId = requestHistoryId;
    return requestsEntity;
  }
}

class NotificationListModel extends BaseModel {
  List<NotificationEntity> notofications = [];

  NotificationListModel();

  factory NotificationListModel.fromJson(Map<String, dynamic> json) {
    var notificationListModel = NotificationListModel();
    notificationListModel.notofications = json['response'] != null
        ? (json['response'] as List)
            .map((service) => NotificationModel.fromJson(service).toEntity())
            .toList()
        : [];
    return notificationListModel;
  }

  @override
  List<Object?> get props => [
        notofications,
      ];

  @override
  NotificationListEntity toEntity() {
    NotificationListEntity notificationListEntity = NotificationListEntity();
    notificationListEntity.notofications = notofications;
    return notificationListEntity;
  }
}

class NotificationModel extends BaseModel {
  String? title;
  String? body;
  String? date;
  NotificationModel();

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    var notificationModel = NotificationModel();
    notificationModel.title = json['title'];
    notificationModel.body = json['body'];
    notificationModel.date = json['date'];
    return notificationModel;
  }

  @override
  List<Object?> get props => [
        title,
        date,
      ];

  @override
  NotificationEntity toEntity() {
    NotificationEntity notificationEntity = NotificationEntity();
    notificationEntity.title = title;
    notificationEntity.body = body;
    notificationEntity.date = date;
    return notificationEntity;
  }
}
