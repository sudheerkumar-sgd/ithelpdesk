// ignore_for_file: must_be_immutable

import 'package:ithelpdesk/data/model/base_model.dart';
import 'package:ithelpdesk/domain/entities/single_data_entity.dart';

class SingleDataModel extends BaseModel {
  dynamic value;

  SingleDataModel();

  factory SingleDataModel.fromCreateRequest(Map<String, dynamic> json) {
    var createRequestModel = SingleDataModel();
    createRequestModel.value = json['data']?['ticketId'] ?? json['message'];
    return createRequestModel;
  }

  @override
  SingleDataEntity toEntity() {
    return SingleDataEntity(value);
  }
}

class NameIDModel extends BaseModel {
  int? id;
  String? name;
  String? nameAr;

  NameIDModel();

  factory NameIDModel.fromJson(Map<String, dynamic> json) {
    var nameIDModel = NameIDModel();
    nameIDModel.id = json['id'];
    nameIDModel.name = json['name'];
    nameIDModel.nameAr = json['nameAr'];
    return nameIDModel;
  }

  @override
  NameIDEntity toEntity() {
    return NameIDEntity(id, name, nameAr: nameAr);
  }
}
