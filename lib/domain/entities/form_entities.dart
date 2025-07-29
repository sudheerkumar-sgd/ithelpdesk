// ignore_for_file: must_be_immutable

import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/domain/entities/base_entity.dart';

class FormEntity extends BaseEntity {
  String? name;
  String? groupName;
  FormFieldType? type;
  String? url;
  Map<String, dynamic>? urlInputData;
  dynamic Function(Map<String, dynamic>)? requestModel;
  String? parameterName;
  String? label;
  String? labelAr;
  String? labelEn;
  String? placeholder;
  String? placeholderEn;
  String? placeholderTe;
  String? suffixIcon;
  bool? repeated;
  bool? multi;
  bool? isHidden;
  bool? isEnabled;
  bool? timeOnly;
  bool? hasTime;
  int? priority;
  int? cols;
  double? verticalSpace;
  double? horizontalSpace;
  dynamic fieldValue;
  dynamic inputFieldData;
  Function(dynamic)? onDatachnage;
  List<String> responseFields = [];
  List<LKPchildrenEntity> lkpChildren = [];
  List<String> children = [];
  FormValidationEntity? validation;
  FormMessageEntity? messages;
  FieldParentEntity? parent;

  @override
  List<Object?> get props => [name, groupName, url, labelEn, labelAr];

  String get getLabel => (isSelectedLocalEn ? labelEn : labelAr) ?? label ?? '';
  String get getPlaceholder =>
      (isSelectedLocalEn ? placeholderEn : placeholderTe) ?? placeholder ?? '';
}

class LKPchildrenEntity extends BaseEntity {
  int? childIndex;
  String? childname;
  List<int> parentValue = [];

  @override
  List<Object?> get props => [childIndex, parentValue];
}

class FormValidationEntity extends BaseEntity {
  bool? required;
  int? maxLength;
  int? maxSize;
  String? extensions;
  String? regex;
  String? relatedTo;
  String? relatedMin;
  dynamic min;
  dynamic max;

  @override
  List<Object?> get props => [required, maxLength];
}

class FormMessageEntity extends BaseEntity {
  String? requiredText;
  String? requiredEn;
  String? requiredAr;
  String? maxLength;
  String? maxLengthEn;
  String? maxLengthAr;
  String? regex;
  String? regexEn;
  String? regexAr;
  String? max;
  String? maxEn;
  String? maxAr;
  String? min;
  String? minEn;
  String? minAr;
  String? validate;
  String? validateEn;
  String? validateAr;

  @override
  List<Object?> get props => [requiredEn, maxLengthEn];

  String? get requiredMessage =>
      (isSelectedLocalEn ? requiredEn : requiredAr) ?? requiredText;
  String? get maxLengthMessage =>
      (isSelectedLocalEn ? maxLengthEn : maxLengthAr) ?? maxLength;
  String? get regexMessage => (isSelectedLocalEn ? regexEn : regexAr) ?? regex;
  String? get maxMessage => (isSelectedLocalEn ? maxEn : maxAr) ?? max;
  String? get minMessage => (isSelectedLocalEn ? minEn : minAr) ?? min;
  String? get validateMessage =>
      (isSelectedLocalEn ? validateEn : validateAr) ?? validate;
}

class FieldParentEntity extends BaseEntity {
  dynamic parentValue;
  String? parentName;
  String? parentType;
  String? parentAction;

  @override
  List<Object?> get props => [parentValue, parentName];
}

class DropdownDataEntity extends BaseEntity {
  String? children;
  List<DropdownItemEntity> items = [];

  @override
  List<Object?> get props => [children];
}

class DropdownItemEntity extends BaseEntity {
  int? id;
  String? textEn;
  String? textAr;
  String? displayTextEn;
  String? displayTextAr;
  String? url;
  String? value;
  String? nameAr;
  String? nameEn;
  String? email;
  List<String>? ext;
  int? maxSize;
  bool? isRequired;
  bool? isActive;
  bool? isPublished;

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return (isSelectedLocalEn ? textEn ?? nameEn : textAr ?? nameAr) ?? '';
  }

  String get name => (isSelectedLocalEn ? nameEn : nameAr) ?? '';

  Map<String, dynamic> toJson() => {
        "id": id ?? '',
        "valueEn": textEn ?? '',
        "valueAr": textAr ?? '',
        "url": url ?? '',
      };
}
