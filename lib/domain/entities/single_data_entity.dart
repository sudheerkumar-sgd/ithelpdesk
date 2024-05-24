// ignore_for_file: must_be_immutable

import 'package:ithelpdesk/domain/entities/base_entity.dart';

class SingleDataEntity extends BaseEntity {
  final dynamic value;

  SingleDataEntity(this.value);
}
