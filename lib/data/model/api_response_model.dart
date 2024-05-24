import 'package:equatable/equatable.dart';
import 'package:ithelpdesk/data/model/base_model.dart';
import 'package:ithelpdesk/domain/entities/api_entity.dart';
import 'package:ithelpdesk/domain/entities/base_entity.dart';

// ignore: must_be_immutable
class ApiResponse<T extends BaseModel> extends Equatable {
  bool? isSuccess;
  String? description;
  T? data;
  ApiResponse();

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>)? fromJson) {
    ApiResponse<T> apiResponse = ApiResponse<T>();
    apiResponse.isSuccess = json["IsSuccess"];
    apiResponse.description = json["Description"];
    apiResponse.data = fromJson != null ? fromJson(json) : null;
    return apiResponse;
  }

  @override
  List<Object?> get props => [isSuccess, description];
}

extension SourceModelExtension on ApiResponse {
  ApiEntity<T> toEntity<T extends BaseEntity>() {
    final apiEntity = ApiEntity<T>();
    apiEntity.isSuccess = isSuccess;
    apiEntity.description = description;
    apiEntity.entity = data?.toEntity();
    return apiEntity;
  }
}
