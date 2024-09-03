// ignore_for_file: must_be_immutable

import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/domain/entities/base_entity.dart';

class SingleDataEntity extends BaseEntity {
  final dynamic value;

  SingleDataEntity(this.value);
}

class NameIDEntity extends BaseEntity {
  int? id;
  String? name;
  String? nameAr;

  NameIDEntity(this.id, this.name, {this.nameAr});
  @override
  String toString() {
    return (isSelectedLocalEn ? name : nameAr ?? name) ?? '';
  }
}
