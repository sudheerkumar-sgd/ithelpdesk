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
