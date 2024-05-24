// ignore_for_file: must_be_immutable

import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/domain/entities/base_entity.dart';

class FinesListEntity extends BaseEntity {
  int? totalPermits;
  int? totalLicenses;
  int? totalRequests;
  double? totalFines;
  FinesDptEntity? allDepartmentFines;
  List<FinesEntity>? fineList;
}

class FinesDptEntity extends BaseEntity {
  var totalFines;
  List<FinesEntity> fineList = [];

  @override
  List<Object?> get props => [totalFines];
}

class FinesEntity extends BaseEntity {
  String? fineId;
  String? issueDate;
  String? fineNameAr;
  String? fineNameEn;
  String? categoryNameAr;
  String? categoryNameEn;
  String? fineSourceAr;
  String? fineSourceEn;
  String? departmentAr;
  String? departmentEn;
  String? licenseNumber;
  String? tradeNameAr;
  String? tradeNameEn;
  var amount;
  bool? isIndividual;
  String? paymentURL;

  String? inspectionTitleEn;
  String? inspectionTitleAr;
  String? establishmentId;

  @override
  List<Object?> get props => [issueDate];

  String get fineName =>
      isSelectedLocalEn ? fineNameEn ?? '' : fineNameAr ?? '';
  String get inspectionTitle =>
      isSelectedLocalEn ? inspectionTitleEn ?? '' : inspectionTitleAr ?? '';
}

class DocumentVerifyEntity extends BaseEntity {
  String? did;
  bool? verfiyStatus;
  String? referenceNumber;
  String? requestNumber;
  String? documentData;
}

class PaymentsListEntity extends BaseEntity {
  List<PaymentEntity> payments = [];
}

class PaymentEntity extends BaseEntity {
  int? paymentId;
  int? requestId;
  String? paymentDate;
  var amount;
  String? serviceNameEn;
  String? serviceNameAr;
  bool? status;
  String? paymentCode;
  String? paymentType;
  String? paymentChannel;
  String? edirhamReference;
  String? paymentCategory;
  String? viewURL;
  String? requestCode;
  String get serviceName =>
      isSelectedLocalEn ? serviceNameEn ?? '' : serviceNameAr ?? '';
}

class MyDocumentsListEntity extends BaseEntity {
  List<MyDocumentEntity> documents = [];
}

class MyDocumentEntity extends BaseEntity {
  String? did;
  String? requestId;
  String? requestCode;
  String? documentName;
  int? requestDocumentSubTypeId;
  String? requestDocumentSubTypeNameEN;
  String? requestDocumentSubTypeNameAR;
  String? licenseTradeNameAr;
  String? licenseTradeNameEn;
  String? licenseTypeAr;
  String? licenseTypeEn;
  String? licenseNumber;
  String? expiryDate;
  String? permitId;
  String? permitNameAr;
  String? permitNameEn;
  String? creationDate;
  String? lastModificationDate;
  String? documentData;

  String get certificateName => isSelectedLocalEn
      ? requestDocumentSubTypeNameEN ?? ''
      : requestDocumentSubTypeNameAR ?? '';

  String get licenseTradeName =>
      isSelectedLocalEn ? licenseTradeNameEn ?? '' : licenseTradeNameAr ?? '';

  String get permitName =>
      isSelectedLocalEn ? permitNameEn ?? '' : permitNameAr ?? '';
}
