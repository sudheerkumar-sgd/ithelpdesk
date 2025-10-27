// ignore_for_file: must_be_immutable

import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/data/model/base_model.dart';
import 'package:ithelpdesk/domain/entities/form_entities.dart';

class FormModel extends BaseModel {
  String? name;
  String? lableEn;
  String? lableAr;
  String? type;
  FormValidationEntity? validation;
  FormMessageEntity? validationMessage;

  FormModel({name, lableEn, lableAr, type, validation, validationMessage});

  FormModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    lableEn = json['lableEn'];
    lableAr = json['lableAr'];
    type = json['type'];
    validation = json['validation'] != null
        ? FormValidationModel.fromJson(json['validation']).toEntity()
        : null;
    validationMessage = json['validationMessage'] != null
        ? FormMessageModel.fromJson(json['validationMessage']).toEntity()
        : null;
  }

  @override
  FormEntity toEntity() {
    return FormEntity()
      ..type = FormFieldType.fromName(type ?? 'text')
      ..name = name
      ..labelEn = lableEn
      ..labelAr = lableAr
      ..validation = validation
      ..messages = validationMessage;
  }
}

class FormValidationModel extends BaseModel {
  bool? isrequired;
  int? maxLength;
  int? maxSize;
  String? extensions;
  String? regex;
  String? relatedTo;
  String? relatedMin;
  dynamic min;
  dynamic max;
  FormValidationModel();

  factory FormValidationModel.fromJson(Map<String, dynamic>? json) {
    var formValidationModel = FormValidationModel();
    formValidationModel.isrequired = json?['isrequired'];
    formValidationModel.maxLength = json?['maxLength'];
    formValidationModel.maxSize = json?['maxSize'];
    formValidationModel.extensions = json?['extensions'];
    formValidationModel.regex = json?['regex'];
    formValidationModel.relatedMin = json?['relatedMin'];
    formValidationModel.relatedTo = json?['relatedTo'];
    formValidationModel.min = json?['min'];
    formValidationModel.max = json?['max'];
    return formValidationModel;
  }

  @override
  List<Object?> get props => [
        isrequired,
      ];

  @override
  FormValidationEntity toEntity() {
    FormValidationEntity formValidationEntity = FormValidationEntity();
    formValidationEntity.isrequired = isrequired;
    formValidationEntity.maxLength = maxLength;
    formValidationEntity.maxSize = maxSize;
    formValidationEntity.extensions = extensions;
    formValidationEntity.regex = regex;
    formValidationEntity.relatedTo = relatedTo;
    formValidationEntity.relatedMin = relatedMin;
    formValidationEntity.min = min;
    formValidationEntity.max = max;
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
  String? maxEn;
  String? maxAr;
  String? minEn;
  String? minAr;

  FormMessageModel();

  FormMessageModel.fromJson(Map<String, dynamic> json) {
    requiredEn = json['requiredEn'];
    requiredAr = json['requiredAr'];
    maxLengthEn = json['maxLengthEn'];
    maxLengthAr = json['maxLengthAr'];
    regexEn = json['regexEn'];
    regexAr = json['regexAr'];
    maxEn = json['maxEn'];
    maxAr = json['maxAr'];
    minEn = json['minEn'];
    minAr = json['minAr'];
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
    formMessageEntity.maxEn = maxEn;
    formMessageEntity.maxAr = maxAr;
    formMessageEntity.minEn = minEn;
    formMessageEntity.minAr = minAr;
    return formMessageEntity;
  }
}
