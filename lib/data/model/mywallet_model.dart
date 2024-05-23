// ignore_for_file: must_be_immutable

import 'package:smartuaq/data/model/base_model.dart';
import 'package:smartuaq/domain/entities/mywallet_entity.dart';

class FinesResponseModel extends BaseModel {
  int? totalPermits;
  int? totalLicenses;
  int? totalRequests;
  double? totalFines;
  FinesDptEntity? allDepartmentFines;
  List<FinesEntity> fineList = [];
  FinesResponseModel();

  factory FinesResponseModel.fromJson(Map<String, dynamic> json) {
    var finesResponseModel = FinesResponseModel();
    finesResponseModel.totalLicenses = json['response']['totalLicenses'];
    finesResponseModel.totalPermits = json['response']['totalPermits'];
    finesResponseModel.totalRequests = json['response']['totalRequests'];

    if (json['response']['departmentFineList'] != null &&
        json['response']['departmentFineList'] is List) {
      finesResponseModel.allDepartmentFines = FinesDptModel.fromJson(
              (json['response']['departmentFineList'] as List).first)
          .toEntity();
    }
    return finesResponseModel;
  }

  factory FinesResponseModel.fromMDJson(Map<String, dynamic> json) {
    var finesResponseModel = FinesResponseModel();
    finesResponseModel.fineList = json['response'] != null
        ? (json['response'] as List).map((service) {
            final entity = FinesModel.fromJson(service).toEntity();
            finesResponseModel.totalFines =
                ((finesResponseModel.totalFines ?? 0) + (entity.amount ?? 0));
            return entity;
          }).toList()
        : [];
    return finesResponseModel;
  }

  @override
  List<Object?> get props => [
        allDepartmentFines,
      ];

  @override
  FinesListEntity toEntity() {
    FinesListEntity finesListEntity = FinesListEntity();
    finesListEntity.totalLicenses = totalLicenses;
    finesListEntity.totalPermits = totalPermits;
    finesListEntity.totalRequests = totalRequests;
    finesListEntity.totalFines = totalFines;
    finesListEntity.allDepartmentFines = allDepartmentFines;
    finesListEntity.fineList = fineList;
    return finesListEntity;
  }
}

class FinesDptModel extends BaseModel {
  var totalFines;
  List<FinesEntity> fineList = [];
  FinesDptModel();

  factory FinesDptModel.fromJson(Map<String, dynamic> json) {
    var finesDptModel = FinesDptModel();
    finesDptModel.totalFines = json['totalFines'];
    finesDptModel.fineList = json['fineList'] != null
        ? (json['fineList'] as List)
            .map((service) => FinesModel.fromJson(service).toEntity())
            .toList()
        : [];
    return finesDptModel;
  }

  @override
  List<Object?> get props => [
        totalFines,
      ];

  @override
  FinesDptEntity toEntity() {
    FinesDptEntity finesDptEntity = FinesDptEntity();
    finesDptEntity.totalFines = totalFines;
    finesDptEntity.fineList = fineList;
    return finesDptEntity;
  }
}

class FinesModel extends BaseModel {
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
  String? inspectionTitleEn;
  String? inspectionTitleAr;
  var amount;
  bool? isIndividual;
  String? paymentURL;
  String? establishmentId;
  FinesModel();

  factory FinesModel.fromJson(Map<String, dynamic> json) {
    var finesModel = FinesModel();
    finesModel.fineId = '${json['id']}';
    finesModel.issueDate = json['issueDate'] ?? json['creationDate'];
    finesModel.fineNameAr = json['fineNameAr'] ?? json['fineTitleAr'];
    finesModel.fineNameEn = json['fineNameEn'] ?? json['fineTitleEn'];
    finesModel.categoryNameAr = json['categoryNameAr'];
    finesModel.categoryNameEn = json['categoryNameEn'];
    finesModel.fineSourceAr = json['fineSourceAr'];
    finesModel.fineSourceEn = json['fineSourceEn'];
    finesModel.departmentAr = json['departmentAr'];
    finesModel.departmentEn = json['departmentEn'];
    finesModel.licenseNumber = json['licenseNumber'];
    finesModel.tradeNameAr = json['tradeNameAr'];
    finesModel.inspectionTitleEn = json['inspectionTitleEn'];
    finesModel.tradeNameEn = json['tradeNameEn'];
    finesModel.inspectionTitleAr = json['inspectionTitleAr'];
    finesModel.amount = double.parse('${json['amount'] ?? 0.0}');
    finesModel.isIndividual = json['isIndividual'];
    finesModel.establishmentId = '${json['establishmentId']}';
    finesModel.paymentURL = json['paymentURL'] ??
        'https://mdservices.uaq.ae/e-services/request-service/33';
    return finesModel;
  }

  @override
  List<Object?> get props => [
        issueDate,
      ];

  @override
  FinesEntity toEntity() {
    FinesEntity finesEntity = FinesEntity();
    finesEntity.fineId = fineId;
    finesEntity.issueDate = issueDate;
    finesEntity.fineNameAr = fineNameAr;
    finesEntity.fineNameEn = fineNameEn;
    finesEntity.categoryNameAr = categoryNameAr;
    finesEntity.categoryNameEn = categoryNameEn;
    finesEntity.fineSourceAr = fineSourceAr;
    finesEntity.fineSourceEn = fineSourceEn;
    finesEntity.departmentAr = departmentAr;
    finesEntity.departmentEn = departmentEn;
    finesEntity.licenseNumber = licenseNumber;
    finesEntity.tradeNameAr = tradeNameAr;
    finesEntity.tradeNameEn = tradeNameEn;
    finesEntity.amount = amount;
    finesEntity.isIndividual = isIndividual;
    finesEntity.paymentURL = paymentURL;
    finesEntity.inspectionTitleAr = inspectionTitleAr;
    finesEntity.inspectionTitleEn = inspectionTitleEn;
    finesEntity.establishmentId = establishmentId;
    return finesEntity;
  }
}

class DocumentVerifyModel extends BaseModel {
  String? did;
  bool? verfiyStatus;
  String? referenceNumber;
  String? documentData;
  DocumentVerifyModel();

  factory DocumentVerifyModel.fromJson(Map<String, dynamic> json) {
    var documentVerifyModel = DocumentVerifyModel();
    documentVerifyModel.did = json['response']?['did'];
    documentVerifyModel.verfiyStatus = json['response']?['verfiyStatus'];
    documentVerifyModel.referenceNumber = json['response']?['referenceNumber'];
    return documentVerifyModel;
  }

  factory DocumentVerifyModel.fromGetDocumentJson(Map<String, dynamic> json) {
    var documentVerifyModel = DocumentVerifyModel();
    documentVerifyModel.documentData = json['response'];
    return documentVerifyModel;
  }

  @override
  List<Object?> get props => [
        did,
      ];

  @override
  DocumentVerifyEntity toEntity() {
    DocumentVerifyEntity documentVerifyEntity = DocumentVerifyEntity();
    documentVerifyEntity.did = did;
    documentVerifyEntity.verfiyStatus = verfiyStatus;
    documentVerifyEntity.referenceNumber = referenceNumber;
    documentVerifyEntity.documentData = documentData;
    return documentVerifyEntity;
  }
}

class PaymentModel extends BaseModel {
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

  PaymentModel();
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    var paymentModel = PaymentModel();
    paymentModel.paymentId = json['paymentId'];
    paymentModel.paymentDate = json['paymentDate'];
    paymentModel.amount = json['amount'];
    paymentModel.serviceNameEn = json['serviceNameEn'];
    paymentModel.serviceNameAr = json['serviceNameAr'];
    paymentModel.status = json['status'];
    paymentModel.paymentCode = json['paymentCode'];
    paymentModel.paymentType = json['paymentType'];
    paymentModel.paymentChannel = json['paymentChannel'];
    paymentModel.edirhamReference = json['edirhamReference'];
    paymentModel.paymentCategory = json['paymentTpaymentCategoryype'];
    paymentModel.viewURL = json['request']?['viewURL'];
    paymentModel.requestCode = json['request']?['requestCode'];
    paymentModel.requestId = json['request']?['externalId'];
    return paymentModel;
  }

  @override
  List<Object?> get props => [
        paymentId,
      ];

  @override
  PaymentEntity toEntity() {
    PaymentEntity paymentEntity = PaymentEntity();
    paymentEntity.paymentId = paymentId;
    paymentEntity.requestId = requestId;
    paymentEntity.paymentDate = paymentDate;
    paymentEntity.amount = amount;
    paymentEntity.serviceNameEn = serviceNameEn;
    paymentEntity.serviceNameAr = serviceNameAr;
    paymentEntity.status = status;
    paymentEntity.paymentCode = paymentCode;
    paymentEntity.paymentType = paymentType;
    paymentEntity.paymentChannel = paymentChannel;
    paymentEntity.edirhamReference = edirhamReference;
    paymentEntity.paymentCategory = paymentCategory;
    paymentEntity.viewURL = viewURL;
    paymentEntity.requestCode = requestCode;
    return paymentEntity;
  }
}

class PaymentsListModel extends BaseModel {
  List<PaymentEntity> payments = [];

  PaymentsListModel();

  factory PaymentsListModel.fromJson(Map<String, dynamic> json) {
    var paymentsListModel = PaymentsListModel();
    paymentsListModel.payments = json['response']?['list'] != null
        ? (json['response']?['list'] as List)
            .map((payment) => PaymentModel.fromJson(payment).toEntity())
            .toList()
        : [];
    return paymentsListModel;
  }

  @override
  List<Object?> get props => [
        payments,
      ];

  @override
  PaymentsListEntity toEntity() {
    PaymentsListEntity paymentsListEntity = PaymentsListEntity();
    paymentsListEntity.payments = payments;
    return paymentsListEntity;
  }
}

class MyDocumentsListModel extends BaseModel {
  List<MyDocumentEntity> documents = [];

  MyDocumentsListModel();

  factory MyDocumentsListModel.fromJson(Map<String, dynamic> json) {
    var myDocumentsListModel = MyDocumentsListModel();
    myDocumentsListModel.documents = json['response'] != null
        ? (json['response'] as List)
            .map((document) => MyDocumentModel.fromJson(document).toEntity())
            .toList()
        : [];
    return myDocumentsListModel;
  }

  factory MyDocumentsListModel.fromLicenseJson(Map<String, dynamic> json) {
    var myDocumentsListModel = MyDocumentsListModel();
    myDocumentsListModel.documents =
        json['response']['activeLicenses']?['licenses'] != null
            ? (json['response']['activeLicenses']?['licenses'] as List)
                .map((document) =>
                    MyDocumentModel.fromLicenseJson(document).toEntity())
                .toList()
            : [];
    return myDocumentsListModel;
  }

  factory MyDocumentsListModel.fromPermitJson(Map<String, dynamic> json) {
    var myDocumentsListModel = MyDocumentsListModel();
    myDocumentsListModel.documents = json['response'] != null
        ? (json['response'] as List)
            .map((document) =>
                MyDocumentModel.fromPermitJson(document).toEntity())
            .toList()
        : [];
    return myDocumentsListModel;
  }

  @override
  List<Object?> get props => [
        documents,
      ];

  @override
  MyDocumentsListEntity toEntity() {
    final myDocumentList = MyDocumentsListEntity();
    myDocumentList.documents = documents;
    return myDocumentList;
  }
}

class MyDocumentModel extends BaseModel {
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
  MyDocumentModel();

  factory MyDocumentModel.fromJson(Map<String, dynamic> json) {
    var myDocumentModel = MyDocumentModel();
    myDocumentModel.did = '${json['did']}';
    myDocumentModel.requestId = '${json['requestId'] ?? ''}';
    myDocumentModel.documentName = json['documentName'];
    myDocumentModel.requestCode = (myDocumentModel.documentName ?? '')
        .substring(
            0,
            (myDocumentModel.documentName ?? '')
                    .lastIndexOf((myDocumentModel.requestId ?? '')) +
                (myDocumentModel.requestId ?? '').length);
    myDocumentModel.requestDocumentSubTypeId = json['requestDocumentSubTypeId'];
    myDocumentModel.requestDocumentSubTypeNameEN =
        json['requestDocumentSubTypeNameEN'];
    myDocumentModel.requestDocumentSubTypeNameAR =
        json['requestDocumentSubTypeNameAR'];
    myDocumentModel.creationDate = json['creationDate'];
    myDocumentModel.lastModificationDate = json['lastModificationDate'];
    return myDocumentModel;
  }

  factory MyDocumentModel.fromLicenseJson(Map<String, dynamic> json) {
    var myDocumentModel = MyDocumentModel();
    myDocumentModel.did = '${json['did'] ?? json['DID']}';
    myDocumentModel.requestId = '${json['requestId'] ?? ''}';
    myDocumentModel.requestCode = json['requestCode'];
    myDocumentModel.documentName = json['documentName'];
    myDocumentModel.licenseNumber = json['licenseNumber'];
    myDocumentModel.expiryDate = json['expiryDate'];
    myDocumentModel.requestDocumentSubTypeId = json['requestDocumentSubTypeId'];
    myDocumentModel.licenseTradeNameEn = json['licenseTradeName']?['nameEn'];
    myDocumentModel.licenseTradeNameAr = json['licenseTradeName']?['nameAr'];
    myDocumentModel.licenseTypeEn = json['licenseType']?['nameEn'];
    myDocumentModel.licenseTypeAr = json['licenseType']?['nameAr'];
    myDocumentModel.creationDate = json['creationDate'];
    myDocumentModel.lastModificationDate = json['lastModificationDate'];
    return myDocumentModel;
  }

  factory MyDocumentModel.fromPermitJson(Map<String, dynamic> json) {
    var myDocumentModel = MyDocumentModel();
    myDocumentModel.did = '${json['did']}';
    myDocumentModel.requestId = '${json['requestId'] ?? ''}';
    myDocumentModel.requestCode = json['requestCode'];
    myDocumentModel.requestCode = json['requestCode'];
    myDocumentModel.requestCode = json['requestCode'];
    myDocumentModel.documentName = json['documentName'];
    myDocumentModel.permitId = json['permit']?['id'];
    myDocumentModel.permitNameEn = json['permit']?['nameEn'];
    myDocumentModel.permitNameAr = json['permit']?['nameAr'];
    myDocumentModel.creationDate = json['issueDate'];
    myDocumentModel.lastModificationDate = json['lastModificationDate'];
    return myDocumentModel;
  }

  @override
  List<Object?> get props => [
        did,
      ];

  @override
  MyDocumentEntity toEntity() {
    MyDocumentEntity myDocumentEntity = MyDocumentEntity();
    myDocumentEntity.did = did;
    myDocumentEntity.requestId = requestId;
    myDocumentEntity.requestCode = requestCode;
    myDocumentEntity.documentName = documentName;
    myDocumentEntity.requestDocumentSubTypeId = requestDocumentSubTypeId;
    myDocumentEntity.requestDocumentSubTypeNameEN =
        requestDocumentSubTypeNameEN;
    myDocumentEntity.requestDocumentSubTypeNameAR =
        requestDocumentSubTypeNameAR;
    myDocumentEntity.licenseTradeNameAr = licenseTradeNameAr;
    myDocumentEntity.licenseTradeNameEn = licenseTradeNameEn;
    myDocumentEntity.licenseTypeAr = licenseTypeAr;
    myDocumentEntity.licenseTypeEn = licenseTypeEn;
    myDocumentEntity.licenseNumber = licenseNumber;
    myDocumentEntity.expiryDate = expiryDate;
    myDocumentEntity.permitId = permitId;
    myDocumentEntity.permitNameAr = permitNameAr;
    myDocumentEntity.permitNameEn = permitNameEn;
    myDocumentEntity.creationDate = creationDate;
    myDocumentEntity.lastModificationDate = lastModificationDate;
    return myDocumentEntity;
  }
}
