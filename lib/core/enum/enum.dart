import 'dart:ui';

import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/extensions/string_extension.dart';

enum ThemeEnum {
  red('red'),
  blue('blue'),
  peach('peach');

  final String name;
  const ThemeEnum(this.name);
}

enum LocalEnum {
  en('en'),
  ar('ar');

  final String name;
  const LocalEnum(this.name);
}

enum FontSizeEnum {
  smallSize(1),
  defaultSize(2),
  bigSize(3);

  final int size;
  const FontSizeEnum(this.size);

  factory FontSizeEnum.fromSize(int size) {
    switch (size) {
      case 1:
        return FontSizeEnum.smallSize;
      case 3:
        return FontSizeEnum.bigSize;
      default:
        return FontSizeEnum.defaultSize;
    }
  }
}

enum RequestStatusEnum {
  completed(1),
  rejected(2),
  pending(3);

  final int value;
  const RequestStatusEnum(this.value);
}

enum PriorityType {
  low(1),
  medium(2),
  high(3),
  critical(4);

  final int value;
  const PriorityType(this.value);

  factory PriorityType.fromId(int value) {
    return values.firstWhere((e) => e.value == value);
  }

  factory PriorityType.fromName(String value) {
    return values.firstWhere((e) => e.name.contains(value.toLowerCase()));
  }

  @override
  String toString() {
    switch (this) {
      case low:
        return isSelectedLocalEn ? name.capitalize() : 'منخفض';
      case medium:
        return isSelectedLocalEn ? name.capitalize() : 'متوسط';
      case high:
        return isSelectedLocalEn ? name.capitalize() : 'عالي';
      case critical:
        return isSelectedLocalEn ? name.capitalize() : 'حرج';
      default:
        return name.toString();
    }
  }
}

enum StatusType {
  all(-1),
  notAssigned(0),
  open(1),
  closed(2),
  hold(3),
  reject(4),
  duplicate(5),
  returned(6),
  approve(7),
  forward(8),
  resubmit(9),
  transfer(10),
  reAssign(11),
  reopen(9);

  final int value;
  const StatusType(this.value);

  factory StatusType.fromId(int value) {
    return values.firstWhere((e) => e.value == value);
  }

  factory StatusType.fromName(String value) {
    return values.firstWhere((e) => e.name.contains(value.toLowerCase()));
  }

  @override
  String toString() {
    switch (this) {
      case closed:
        return isSelectedLocalEn ? 'Close' : 'اغلاق';
      case reject:
        return isSelectedLocalEn ? 'Reject' : 'رفض';
      case hold:
        return isSelectedLocalEn ? 'Hold' : 'تعليق';
      case returned:
        return isSelectedLocalEn ? 'Return' : 'إرجاع';
      case open:
        return isSelectedLocalEn ? 'Open' : 'مفتوح';
      case forward:
        return isSelectedLocalEn ? 'Forward' : 'إلى الأمام';
      case reAssign:
        return isSelectedLocalEn ? 'Re-Assign' : 'إلى الأمام';
      case resubmit:
        return isSelectedLocalEn ? 'Resubmit' : 'إعادة الإرسال';
      case reopen:
        return isSelectedLocalEn ? 'Re-Open' : 'إعادة الفتح';
      default:
        return name.capitalize();
    }
  }

  Color getColor() {
    switch (this) {
      case closed:
        return const Color(0xFF3ECA6E);
      case reject:
        return const Color(0xFFFF0000);
      case hold:
        return const Color.fromARGB(255, 243, 219, 3);
      case returned:
        return const Color.fromARGB(255, 6, 101, 202);
      case open:
        return const Color.fromARGB(255, 237, 105, 11);
      default:
        return const Color(0xffC9CCC4);
    }
  }
}

enum AssigneType {
  approver(1),
  implementer(2);

  final int value;
  const AssigneType(this.value);

  factory AssigneType.fromId(int value) {
    return values.firstWhere((e) => e.value == value);
  }
}

enum AppBarItem {
  vacation(1),
  language(2),
  user(2);

  final int value;
  const AppBarItem(this.value);

  factory AppBarItem.fromId(int value) {
    return values.firstWhere((e) => e.value == value);
  }
}

enum UserType {
  superAdmin(1),
  sgdAdmin(2),
  sgdIT(3),
  sgdDC(4),
  sgdEservice(5),
  localIT(6),
  user(7),
  tarasol(8),
  erp(9),
  applications(10),
  mdAdmin(11),
  dedAdmin(12);

  final int value;
  const UserType(this.value);

  factory UserType.fromId(int value) {
    return values.firstWhere((e) => e.value == value);
  }

  factory UserType.fromName(String value) {
    return values.firstWhere((e) => e.name.contains(value.toLowerCase()));
  }
}
