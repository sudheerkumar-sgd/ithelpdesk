// ignore_for_file: must_be_immutable

import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/domain/entities/base_entity.dart';

class RequestsDataEntity extends BaseEntity {
  int? id;
  List<RequestFieldEntity> fields = [];

  @override
  List<Object?> get props => [id];
}

class RequestFieldEntity extends BaseEntity {
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
  List<LKPchildrenEntity> lkpChildren = [];
  List<String> children = [];
  List<DropdownItemEntity> units = [];
  List<DropdownItemEntity> options = [];
  FormValidationEntity? validation;
  FormMessageEntity? messages;
  List<RequestFieldEntity> repeatedFields = [];

  @override
  List<Object?> get props => [name, groupName, url, labelEn, labelAr];

  String get getLabel => (isSelectedLocalEn ? labelEn : labelAr) ?? '';
  String get placeholder =>
      (isSelectedLocalEn ? placeholderEn : placeholderAr) ?? '';
}

class LKPchildrenEntity extends BaseEntity {
  int? childIndex;
  List<int> parentValue = [];

  @override
  List<Object?> get props => [childIndex, parentValue];
}

class FormValidationEntity extends BaseEntity {
  bool? required;
  int? maxLength;
  int? maxSize;
  String? extensions;
  String? regex;

  @override
  List<Object?> get props => [required, maxLength];
}

class FormMessageEntity extends BaseEntity {
  String? requiredEn;
  String? requiredAr;
  String? maxLengthEn;
  String? maxLengthAr;
  String? regexEn;
  String? regexAr;

  @override
  List<Object?> get props => [requiredEn, maxLengthEn];

  String? get requiredMessage => isSelectedLocalEn ? requiredEn : requiredAr;
  String? get maxLengthMessage => isSelectedLocalEn ? maxLengthEn : maxLengthAr;
  String? get regexMessage => isSelectedLocalEn ? regexEn : regexAr;
}

class DropdownDataEntity extends BaseEntity {
  String? children;
  List<DropdownItemEntity> items = [];

  @override
  List<Object?> get props => [children];
}

class DropdownItemEntity extends BaseEntity {
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

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return (isSelectedLocalEn ? textEn ?? nameEn : textAr ?? nameAr) ?? '';
  }

  String get name => (isSelectedLocalEn ? nameEn : nameAr) ?? '';

  Map<String, dynamic> toJson() => {
        "id": id ?? '',
        "valueEn": textEn ?? '',
        "valueAr": textAr ?? '',
        "url": url ?? '',
      };
}

class UploadResponseEntity extends BaseEntity {
  int? documentDataId;
  int? documentTypeId;
  int? did;
  String? documentName;
  String? documentData;
  String? documentType;

  @override
  List<Object?> get props => [documentDataId];

  Map<String, dynamic> toJson() => {
        'fileId': documentDataId,
        'fileDid': did,
        'fileName': documentName,
      };
}

class SubmitResponseEntity extends BaseEntity {
  int? id;
  int? serviceId;
  String? requestCode;
  int? totalAmount;
  bool? redirectToPayment;
  dynamic pdf;

  @override
  List<Object?> get props => [requestCode];
}

class PaymentResponseEntity extends BaseEntity {
  String? checkoutURL;
  String? transactionReference;
  dynamic pdf;
  double? amount;
  double? edirhamFeeAmount;
  double? uaqsgFeeAmount;
  double? paidAmount;
  bool? paymentStatus;
  RequestStatusEntity? requestStatus;
  String? requestCode;

  @override
  List<Object?> get props => [checkoutURL];
}

class RequestStatusEntity extends BaseEntity {
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

  @override
  List<Object?> get props => [id];

  String get getStatus =>
      (isSelectedLocalEn ? statusNameEN : statusNameAR) ?? '';
}

class SupportDocumentEntity {
  String? note;
  String? name;
  List<UploadResponseEntity>? value;
  UploadResponseEntity? file;
  SupportDocumentEntity({this.note, this.value, this.name, this.file});
  Map<String, dynamic> toJson() => {
        'note': note,
        'name': name,
        'value': value,
        'file': file,
      };
}

class HappinessMeterEntity extends BaseEntity {
  int? serviceId;
  int? happinessMeterId;
  int? channelId;
  String? happinessMeterQuestion;
  String? serviceName;
  String? departmentName;
  String? channelName;
  bool? isActive;
  @override
  List<Object?> get props => [serviceId];
}
