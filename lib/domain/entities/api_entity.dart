// ignore_for_file: must_be_immutable

import 'package:smartuaq/domain/entities/base_entity.dart';

class ApiEntity<T extends BaseEntity> extends BaseEntity {
  T? entity;

  ApiEntity({this.entity});

  @override
  List<Object?> get props => [isSuccess, description];
}
