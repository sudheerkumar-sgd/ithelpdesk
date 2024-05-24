// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:ithelpdesk/data/model/base_model.dart';
import 'package:ithelpdesk/domain/entities/request_form_entities.dart';

class RequestDataModel extends BaseModel {
  int? id;
  List<RequestFieldEntity> fields = [];
  RequestDataModel();

  factory RequestDataModel.fromJson(Map<String, dynamic> json) {
    var requestDataModel = RequestDataModel();
    final response = json['response'];
    requestDataModel.id = response['id'];
    final formData = jsonDecode(response['template']);
    requestDataModel.fields = formData['fields'] != null
        ? (formData['fields'] as List).map((field) {
            return RequestFieldModel.fromJson(field).toEntity();
          }).toList()
        : [];

    return requestDataModel;
  }

  @override
  List<Object?> get props => [
        id,
      ];

  @override
  RequestsDataEntity toEntity() {
    fields.sort((a, b) => (a.priority ?? 0).compareTo(b.priority ?? 0));
    RequestsDataEntity requestsDataEntity = RequestsDataEntity();
    requestsDataEntity.id = id;
    requestsDataEntity.fields = fields;
    return requestsDataEntity;
  }
}

class RequestFieldModel extends BaseModel {
  String? name;
  String? groupName;
  String? type;
  String? url;
  String? labelEn;
  String? labelAr;
  String? placeholderEn;
  String? placeholderAr;
  bool? repeated;
  bool? multi;
  bool? isHidden;
  int? priority;
  int? cols;
  FormValidationEntity? validation;
  FormMessageEntity? messages;
  List<LKPchildrenEntity> lkpChildren = [];
  List<DropdownItemEntity> units = [];
  List<DropdownItemEntity> options = [];
  List<String> children = [];
  RequestFieldModel();

  factory RequestFieldModel.fromJson(Map<String, dynamic> json) {
    var requestFieldModel = RequestFieldModel();
    requestFieldModel.name = json['name'];
    requestFieldModel.groupName = json['groupName'];
    requestFieldModel.type = json['type'];
    requestFieldModel.priority = json['priority'];
    requestFieldModel.cols = json['cols'];
    requestFieldModel.url = json['url'];
    requestFieldModel.labelEn = json['labelEn'];
    requestFieldModel.labelAr = json['labelAr'];
    requestFieldModel.placeholderEn = json['placeholderEn'];
    requestFieldModel.placeholderAr = json['placeholderAr'];
    requestFieldModel.repeated = json['repeated'];
    requestFieldModel.multi = json['multi'];
    requestFieldModel.isHidden = json['isHidden'];
    requestFieldModel.lkpChildren = json['LKPchildren'] != null
        ? (json['LKPchildren'] as List).map((lkpChildren) {
            return LKPchildrenModel.fromJson(lkpChildren).toEntity();
          }).toList()
        : [];
    requestFieldModel.units = json['units'] != null
        ? (json['units'] as List).map((unit) {
            return DropdownItemModel.fromJson(unit).toEntity();
          }).toList()
        : [];
    requestFieldModel.options = json['options'] != null
        ? (json['options'] as List).map((unit) {
            return DropdownItemModel.fromJson(unit).toEntity();
          }).toList()
        : [];
    requestFieldModel.children = json['children'] != null
        ? (json['children'] as List).map((children) {
            return children.toString();
          }).toList()
        : [];
    requestFieldModel.validation = json['validation'] != null
        ? FormValidationModel.fromJson(json['validation']).toEntity()
        : null;
    requestFieldModel.messages = json['messages'] != null
        ? FormMessageModel.fromJson(json['messages']).toEntity()
        : null;
    return requestFieldModel;
  }

  @override
  List<Object?> get props => [
        name,
      ];

  @override
  RequestFieldEntity toEntity() {
    RequestFieldEntity requestFieldEntity = RequestFieldEntity();
    requestFieldEntity.name = name;
    requestFieldEntity.groupName = groupName;
    requestFieldEntity.type = type;
    requestFieldEntity.priority = priority;
    requestFieldEntity.cols = cols;
    requestFieldEntity.url = url;
    requestFieldEntity.labelEn = labelEn;
    requestFieldEntity.labelAr = labelAr;
    requestFieldEntity.placeholderEn = placeholderEn;
    requestFieldEntity.placeholderAr = placeholderAr;
    requestFieldEntity.repeated = repeated;
    requestFieldEntity.multi = multi;
    requestFieldEntity.isHidden = isHidden;
    requestFieldEntity.lkpChildren = lkpChildren;
    requestFieldEntity.children = children;
    requestFieldEntity.units = units;
    requestFieldEntity.options = options;
    requestFieldEntity.validation = validation;
    requestFieldEntity.messages = messages;
    return requestFieldEntity;
  }
}

class LKPchildrenModel extends BaseModel {
  int? childIndex;
  List<int> parentValue = [];
  LKPchildrenModel();

  factory LKPchildrenModel.fromJson(Map<String, dynamic> json) {
    var lkpChildrenModel = LKPchildrenModel();
    lkpChildrenModel.childIndex = json['childIndex'];
    lkpChildrenModel.parentValue = (json['parentValue'] as List)
        .map((e) => int.tryParse('$e') ?? 0)
        .toList();
    return lkpChildrenModel;
  }

  @override
  List<Object?> get props => [
        childIndex,
      ];

  @override
  LKPchildrenEntity toEntity() {
    LKPchildrenEntity lkpChildrenEntity = LKPchildrenEntity();
    lkpChildrenEntity.childIndex = childIndex;
    lkpChildrenEntity.parentValue = parentValue;
    return lkpChildrenEntity;
  }
}

class FormValidationModel extends BaseModel {
  bool? required;
  int? maxLength;
  int? maxSize;
  String? extensions;
  String? regex;
  FormValidationModel();

  factory FormValidationModel.fromJson(Map<String, dynamic>? json) {
    var formValidationModel = FormValidationModel();
    formValidationModel.required = json?['required'];
    formValidationModel.maxLength = json?['maxLength'];
    formValidationModel.maxSize = json?['maxSize'];
    formValidationModel.extensions = json?['extensions'];
    formValidationModel.regex = json?['regex'];
    return formValidationModel;
  }

  @override
  List<Object?> get props => [
        required,
      ];

  @override
  FormValidationEntity toEntity() {
    FormValidationEntity formValidationEntity = FormValidationEntity();
    formValidationEntity.required = required;
    formValidationEntity.maxLength = maxLength;
    formValidationEntity.maxSize = maxSize;
    formValidationEntity.extensions = extensions;
    formValidationEntity.regex = regex;
    return formValidationEntity;
  }
}

class FormMessageModel extends BaseModel {
  String? requiredEn;
  String? requiredAr;
  String? maxLengthEn;
  String? maxLengthAr;
  String? regexEn;
  String? regexAr;

  FormMessageModel();

  FormMessageModel.fromJson(Map<String, dynamic> json) {
    requiredEn = json['requiredEn'];
    requiredAr = json['requiredAr'];
    maxLengthEn = json['maxLengthEn'];
    maxLengthAr = json['maxLengthAr'];
    regexEn = json['regexEn'];
    regexAr = json['regexAr'];
  }
  @override
  List<Object?> get props => [
        requiredEn,
      ];

  @override
  FormMessageEntity toEntity() {
    FormMessageEntity formMessageEntity = FormMessageEntity();
    formMessageEntity.requiredEn = requiredEn;
    formMessageEntity.requiredAr = requiredAr;
    formMessageEntity.regexEn = regexEn;
    formMessageEntity.regexAr = regexAr;
    formMessageEntity.maxLengthAr = maxLengthAr;
    formMessageEntity.maxLengthEn = maxLengthEn;
    return formMessageEntity;
  }
}

class DropdownDataModel extends BaseModel {
  String? children;
  List<DropdownItemEntity> items = [];
  DropdownDataModel();

  factory DropdownDataModel.fromJson(Map<String, dynamic> json) {
    var applicationTypesModel = DropdownDataModel();
    final response = json['response'];
    //applicationTypesModel.children = response['children'];
    applicationTypesModel.items = response['items'] != null
        ? (response['items'] as List).map((field) {
            return DropdownItemModel.fromJson(field).toEntity();
          }).toList()
        : [];
    return applicationTypesModel;
  }

  @override
  List<Object?> get props => [
        children,
      ];

  @override
  DropdownDataEntity toEntity() {
    DropdownDataEntity accountTypesEntity = DropdownDataEntity();
    accountTypesEntity.children = children;
    accountTypesEntity.items = items;
    return accountTypesEntity;
  }
}

class DropdownItemModel extends BaseModel {
  int? id;
  String? textEn;
  String? textAr;
  String? displayTextEn;
  String? displayTextAr;
  String? url;
  String? value;
  String? nameAr;
  String? nameEn;
  List<String>? ext;
  int? maxSize;
  bool? isRequired;
  DropdownItemModel();

  factory DropdownItemModel.fromJson(Map<String, dynamic> json) {
    var dropdownItemModel = DropdownItemModel();
    dropdownItemModel.id = json['id'];
    dropdownItemModel.textEn = json['textEn'];
    dropdownItemModel.textAr = json['textAr'];
    dropdownItemModel.displayTextEn = json['displayTextEn'];
    dropdownItemModel.displayTextAr = json['displayTextAr'];
    dropdownItemModel.url = json['url'];
    dropdownItemModel.value = json['value'];
    dropdownItemModel.nameAr = json['nameAr'];
    dropdownItemModel.nameEn = json['nameEn'];
    dropdownItemModel.maxSize = json['maxSize'];
    dropdownItemModel.ext = json['ext'] != null
        ? (json['ext'] as List).map((e) => e.toString()).toList()
        : [];
    dropdownItemModel.isRequired = json['isRequired'];
    return dropdownItemModel;
  }

  @override
  List<Object?> get props => [
        id,
      ];

  @override
  DropdownItemEntity toEntity() {
    DropdownItemEntity dropdownItemEntity = DropdownItemEntity();
    dropdownItemEntity.id = id;
    dropdownItemEntity.textEn = textEn;
    dropdownItemEntity.textAr = textAr;
    dropdownItemEntity.displayTextAr = displayTextAr;
    dropdownItemEntity.displayTextEn = displayTextEn;
    dropdownItemEntity.url = url;
    dropdownItemEntity.value = value;
    dropdownItemEntity.nameAr = nameAr;
    dropdownItemEntity.nameEn = nameEn;
    dropdownItemEntity.ext = ext;
    dropdownItemEntity.maxSize = maxSize;
    dropdownItemEntity.isRequired = isRequired;
    return dropdownItemEntity;
  }
}

class UploadResponseModel extends BaseModel {
  int? documentDataId;
  int? documentTypeId;
  int? did;
  String? documentName;
  UploadResponseModel();

  factory UploadResponseModel.fromJson(Map<String, dynamic> json) {
    var uploadResponseModel = UploadResponseModel();
    uploadResponseModel.documentDataId = json['response']?['documentDataId'];
    uploadResponseModel.documentTypeId = json['response']?['documentTypeId'];
    uploadResponseModel.did = json['response']?['did'];
    uploadResponseModel.documentName = json['response']?['documentName'];
    return uploadResponseModel;
  }

  @override
  List<Object?> get props => [
        did,
      ];

  @override
  UploadResponseEntity toEntity() {
    final uploadResponseEntity = UploadResponseEntity();
    uploadResponseEntity.documentDataId = documentDataId;
    uploadResponseEntity.documentTypeId = documentTypeId;
    uploadResponseEntity.did = did;
    uploadResponseEntity.documentName = documentName;
    return uploadResponseEntity;
  }
}

class SubmitResponseModel extends BaseModel {
  int? serviceId;
  int? id;
  String? requestCode;
  bool? redirectToPayment;
  dynamic pdf;
  SubmitResponseModel();

  factory SubmitResponseModel.fromJson(Map<String, dynamic> json) {
    var submitResponseModel = SubmitResponseModel();
    submitResponseModel.id = json['response']?['request']?['id'];
    submitResponseModel.serviceId = json['response']?['request']?['serviceId'];
    submitResponseModel.requestCode =
        json['response']?['request']?['requestCode'];
    submitResponseModel.redirectToPayment =
        json['response']?['request']?['redirectToPayment'];
    submitResponseModel.pdf = json['response']?['pdf'];
    return submitResponseModel;
  }

  @override
  List<Object?> get props => [
        requestCode,
      ];

  @override
  SubmitResponseEntity toEntity() {
    final submitResponseEntity = SubmitResponseEntity();
    submitResponseEntity.id = id;
    submitResponseEntity.serviceId = serviceId;
    submitResponseEntity.requestCode = requestCode;
    submitResponseEntity.redirectToPayment = redirectToPayment;
    submitResponseEntity.pdf = pdf;
    return submitResponseEntity;
  }
}

class PaymentResponseModel extends BaseModel {
  String? checkoutURL;
  String? transactionReference;
  dynamic pdf;
  double? amount;
  double? edirhamFeeAmount;
  double? uaqsgFeeAmount;
  double? paidAmount;
  bool? paymentStatus;
  RequestStatusEntity? requestStatus;
  PaymentResponseModel();

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) {
    var paymentResponseModel = PaymentResponseModel();
    paymentResponseModel.checkoutURL =
        json['response']?['payment']?['checkoutURL'];
    paymentResponseModel.transactionReference =
        json['response']?['payment']?['transactionReference'];
    paymentResponseModel.amount = json['response']?['payment']?['amount'];
    paymentResponseModel.edirhamFeeAmount =
        json['response']?['payment']?['edirhamFeeAmount'];
    paymentResponseModel.uaqsgFeeAmount =
        json['response']?['payment']?['uaqsgFeeAmount'];
    paymentResponseModel.paidAmount =
        json['response']?['payment']?['paidAmount'];
    paymentResponseModel.paymentStatus =
        json['response']?['payment']?['paymentStatus'];
    paymentResponseModel.requestStatus = RequestStatusModel.fromJson(
            json['response']?['payment']?['requestStatus'])
        .toEntity();
    paymentResponseModel.pdf =
        json['response']?['payment']?['pdf'] ?? json['response']?['pdf'];
    return paymentResponseModel;
  }

  @override
  List<Object?> get props => [
        checkoutURL,
      ];

  @override
  PaymentResponseEntity toEntity() {
    final paymentResponseEntity = PaymentResponseEntity();
    paymentResponseEntity.checkoutURL = checkoutURL;
    paymentResponseEntity.transactionReference = transactionReference;
    paymentResponseEntity.amount = amount;
    paymentResponseEntity.edirhamFeeAmount = edirhamFeeAmount;
    paymentResponseEntity.uaqsgFeeAmount = uaqsgFeeAmount;
    paymentResponseEntity.paymentStatus = paymentStatus;
    paymentResponseEntity.requestStatus = requestStatus;
    paymentResponseEntity.paidAmount = paidAmount;
    paymentResponseEntity.pdf = pdf;
    return paymentResponseEntity;
  }
}

class RequestStatusModel extends BaseModel {
  int? id;
  String? statusName;
  String? statusNameEN;
  String? statusNameAR;
  String? statusCode;
  bool? isActive;
  bool? isPublished;
  bool? isSystemVal;
  bool? isDeleted;
  String? lastModificationDate;
  int? createdBy;
  int? modifiedBy;
  String? creationDate;

  RequestStatusModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    id = json['id'];
    statusName = json['statusName'];
    statusNameEN = json['statusNameEN'];
    statusNameAR = json['statusNameAR'];
    statusCode = json['statusCode'];
    isActive = json['isActive'];
    isPublished = json['isPublished'];
    isSystemVal = json['isSystemVal'];
    isDeleted = json['isDeleted'];
    lastModificationDate = json['lastModificationDate'];
    createdBy = json['createdBy'];
    modifiedBy = json['modifiedBy'];
    creationDate = json['creationDate'];
  }
  @override
  List<Object?> get props => [
        id,
      ];

  @override
  RequestStatusEntity toEntity() {
    final requestStatusEntity = RequestStatusEntity();
    requestStatusEntity.id = id;
    requestStatusEntity.statusName = statusName;
    requestStatusEntity.statusNameEN = statusNameEN;
    requestStatusEntity.statusNameAR = statusNameAR;
    requestStatusEntity.statusCode = statusCode;
    requestStatusEntity.isActive = isActive;
    requestStatusEntity.isPublished = isPublished;
    requestStatusEntity.isSystemVal = isSystemVal;
    requestStatusEntity.isDeleted = isDeleted;
    requestStatusEntity.lastModificationDate = lastModificationDate;
    requestStatusEntity.createdBy = createdBy;
    requestStatusEntity.modifiedBy = modifiedBy;
    requestStatusEntity.creationDate = creationDate;
    return requestStatusEntity;
  }
}

class HappinessMeterModel extends BaseModel {
  int? serviceId;
  int? happinessMeterId;
  int? channelId;
  String? happinessMeterQuestion;
  String? serviceName;
  String? departmentName;
  String? channelName;
  bool? isActive;

  HappinessMeterModel.fromJson(Map<String, dynamic> json) {
    json = json['response']?[0];
    serviceId = json['serviceId'];
    happinessMeterId = json['happinessMeterId'];
    channelId = json['channelId'];
    happinessMeterQuestion = json['happinessMeterQuestion'];
    serviceName = json['serviceName'];
    departmentName = json['departmentName'];
    channelName = json['channelName'];
    isActive = json['isActive'];
  }

  @override
  HappinessMeterEntity toEntity() {
    HappinessMeterEntity happinessMeterEntity = HappinessMeterEntity();
    happinessMeterEntity.serviceId = serviceId;
    happinessMeterEntity.happinessMeterId = happinessMeterId;
    happinessMeterEntity.happinessMeterQuestion = happinessMeterQuestion;
    happinessMeterEntity.serviceName = serviceName;
    happinessMeterEntity.channelName = channelName;
    happinessMeterEntity.departmentName = departmentName;
    happinessMeterEntity.isActive = isActive;
    return happinessMeterEntity;
  }
}
