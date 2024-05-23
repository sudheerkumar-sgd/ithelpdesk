// ignore_for_file: must_be_immutable

import 'package:smartuaq/data/model/base_model.dart';
import 'package:smartuaq/domain/entities/single_data_entity.dart';

class SingleDataModel extends BaseModel {
  dynamic value;

  SingleDataModel();

  factory SingleDataModel.fromSessionIDJson(Map<String, dynamic> json) {
    var documentVerifyModel = SingleDataModel();
    documentVerifyModel.value = json['response']?['guid'];
    return documentVerifyModel;
  }

  factory SingleDataModel.fromSendOTP(Map<String, dynamic> json) {
    var documentVerifyModel = SingleDataModel();
    documentVerifyModel.value = json['response'];
    return documentVerifyModel;
  }

  @override
  SingleDataEntity toEntity() {
    return SingleDataEntity(value);
  }
}
