import 'dart:ui';

import 'package:flutter/material.dart';
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
  reopen(10),
  acquired(11),
  transfer(12),
  reAssign(13);

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
      case acquired:
        return isSelectedLocalEn ? 'Acquire' : 'يكتسب';
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
      case acquired:
        return const Color.fromARGB(255, 237, 105, 11);
      default:
        return const Color.fromARGB(255, 156, 103, 242);
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
  dedAdmin(12),
  mdServices(13),
  dedServices(14),
  itAdmin(15);

  final int value;
  const UserType(this.value);

  factory UserType.fromId(int value) {
    return values.firstWhere((e) => e.value == value);
  }

  factory UserType.fromName(String value) {
    return values.firstWhere((e) => e.name.contains(value.toLowerCase()));
  }

  bool isAdmin() {
    switch (this) {
      case superAdmin:
      case sgdAdmin:
      case mdAdmin:
      case dedAdmin:
      case itAdmin:
        return true;
      default:
        return false;
    }
  }
}

enum IssueType {
  customer(1),
  employee(2),
  bug(5),
  system(3),
  datamigration(6),
  reports(7),
  other(4);

  final int value;
  const IssueType(this.value);

  factory IssueType.fromId(int value) {
    return values.firstWhere((e) => e.value == value);
  }

  factory IssueType.fromName(String value) {
    return values.firstWhere((e) => e.name.contains(value.toLowerCase()));
  }

  @override
  String toString() {
    switch (this) {
      case customer:
        return isSelectedLocalEn ? 'Customer' : 'عميل';
      case employee:
        return isSelectedLocalEn ? 'Employee' : 'موظف';
      case system:
        return isSelectedLocalEn ? 'System' : 'نظام';
      case bug:
        return isSelectedLocalEn ? 'Bug' : 'خلل برمجي';
      case datamigration:
        return isSelectedLocalEn ? 'Data Migration' : 'ترحيل البيانات';
      case reports:
        return isSelectedLocalEn ? 'Reports' : "التقارير";
      case other:
        return isSelectedLocalEn ? 'Other' : 'نظام';
    }
  }
}

enum FormFieldType {
  collection,
  text,
  number,
  phone,
  textarea,
  email,
  file,
  multifile,
  image,
  date,
  dateFrom,
  dateTo,
  radiovertical,
  radio,
  checkbox,
  pdfviewer,
  termsconditions,
  button,
  label,
  labelheader;

  factory FormFieldType.fromName(String value) {
    return values.firstWhere((e) => e.name.contains(value.toLowerCase()));
  }
}

enum RequestStatus {
  pending(1),
  completed(2),
  inprogress(3),
  rejected(4),
  hold(5);

  final int value;
  const RequestStatus(this.value);

  factory RequestStatus.fromId(int value) {
    return values.firstWhere((e) => e.value == value);
  }

  factory RequestStatus.fromName(String value) {
    return values.firstWhere((e) => e.name.contains(value.toLowerCase()));
  }

  Color getColor() {
    switch (this) {
      case completed:
        return const Color(0xFF3ECA6E);
      case rejected:
        return const Color(0xFFFF0000);
      case inprogress:
        return const Color.fromARGB(255, 237, 105, 11);
      case pending:
        return const Color.fromARGB(255, 237, 105, 11);
      case hold:
        return const Color.fromARGB(255, 237, 105, 11);
    }
  }

  @override
  String toString() {
    switch (this) {
      case completed:
        return isSelectedLocalEn ? 'Completed' : 'مكتمل';
      case rejected:
        return isSelectedLocalEn ? 'Rejected' : 'مرفوض';
      case inprogress:
        return isSelectedLocalEn ? 'In Progress' : 'قيد التنفيذ';
      case pending:
        return isSelectedLocalEn ? 'Pending' : 'قيد الانتظار';
      case hold:
        return isSelectedLocalEn ? 'On Hold' : 'معلق';
    }
  }
}

enum RequestStepStatus {
  submited(1),
  returned(2),
  approved(3),
  close(4),
  aquire(5),
  transfer(6),
  reject(7),
  hold(8),
  reSubmit(9),
  inProgress(10),
  open(11),
  pending(12);

  final int value;
  const RequestStepStatus(this.value);

  factory RequestStepStatus.fromId(int value) {
    return values.firstWhere((e) => e.value == value,
        orElse: () =>
            throw ArgumentError('Invalid RequestStepStatus id: $value'));
  }

  factory RequestStepStatus.fromName(String value) {
    return values.firstWhere((e) => e.name.toLowerCase() == value.toLowerCase(),
        orElse: () =>
            throw ArgumentError('Invalid RequestStepStatus name: $value'));
  }

  @override
  String toString() {
    switch (this) {
      case close:
        return isSelectedLocalEn ? 'Close' : 'اغلاق';
      case reject:
        return isSelectedLocalEn ? 'Reject' : 'رفض';
      case hold:
        return isSelectedLocalEn ? 'Hold' : 'تعليق';
      case returned:
        return isSelectedLocalEn ? 'Return' : 'إرجاع';
      case inProgress:
        return isSelectedLocalEn ? 'In Progress' : 'قيد التنفيذ';
      case transfer:
        return isSelectedLocalEn ? 'Transfer' : 'تم التحويل';
      case approved:
        return isSelectedLocalEn ? 'Approve' : 'موافق عليه';
      case submited:
        return isSelectedLocalEn ? 'Submit' : 'تم الإرسال';
      case reSubmit:
        return isSelectedLocalEn ? 'Resubmit' : 'إعادة الإرسال';
      case RequestStepStatus.aquire:
        return isSelectedLocalEn ? 'Acquire' : 'يكتسب';
      case open:
        return isSelectedLocalEn ? 'Open' : 'مفتوح';
      case pending:
        return isSelectedLocalEn ? 'Pending' : 'قيد الانتظار';
    }
  }

  String toStatusString() {
    switch (this) {
      case close:
        return isSelectedLocalEn ? 'Completed' : 'مكتمل';
      case reject:
        return isSelectedLocalEn ? 'Rejected' : 'مرفوض';
      case hold:
        return isSelectedLocalEn ? 'Hold' : 'تعليق';
      case returned:
        return isSelectedLocalEn ? 'Returned' : 'إرجاع';
      case inProgress:
        return isSelectedLocalEn ? 'In Progress' : 'قيد التنفيذ';
      case transfer:
        return isSelectedLocalEn ? 'Transfered' : 'تم التحويل';
      case approved:
        return isSelectedLocalEn ? 'Approved' : 'موافق عليه';
      case submited:
        return isSelectedLocalEn ? 'Submited' : 'تم الإرسال';
      case reSubmit:
        return isSelectedLocalEn ? 'Resubmited' : 'إعادة الإرسال';
      case RequestStepStatus.aquire:
        return isSelectedLocalEn ? 'Acquire' : 'يكتسب';
      case open:
        return isSelectedLocalEn ? 'Open' : 'مفتوح';
      case pending:
        return isSelectedLocalEn ? 'Pending' : 'قيد الانتظار';
    }
  }

  Color getColor() {
    switch (this) {
      case close:
        return const Color(0xFF3ECA6E);
      case reject:
        return const Color(0xFFFF0000);
      case hold:
        return const Color.fromARGB(255, 243, 219, 3);
      case returned:
        return const Color.fromARGB(255, 6, 101, 202);
      case inProgress:
        return const Color.fromARGB(255, 237, 105, 11);
      case transfer:
        return const Color.fromARGB(255, 237, 105, 11);
      case aquire:
        return const Color.fromARGB(255, 237, 105, 11);
      case approved:
        return const Color(0xFF3ECA6E);
      default:
        return const Color.fromARGB(255, 156, 103, 242);
    }
  }
}

enum RequestStepActions {
  submited(1),
  returned(2),
  approved(3),
  rejected(4),
  transfered(5),
  closed(6),
  hold(7);

  final int value;
  const RequestStepActions(this.value);

  factory RequestStepActions.fromId(int value) {
    return values.firstWhere((e) => e.value == value,
        orElse: () =>
            throw ArgumentError('Invalid RequestStepActions id: $value'));
  }

  factory RequestStepActions.fromName(String value) {
    return values.firstWhere((e) => e.name.toLowerCase() == value.toLowerCase(),
        orElse: () =>
            throw ArgumentError('Invalid RequestStepActions name: $value'));
  }
}

enum CategoryEnum {
  itsupport(1),
  isocr(2),
  eservice(3),
  application(4);

  final int value;
  const CategoryEnum(this.value);

  factory CategoryEnum.fromId(int value) {
    return values.firstWhere((e) => e.value == value,
        orElse: () => throw ArgumentError('Invalid Category id: $value'));
  }

  factory CategoryEnum.fromName(String value) {
    return values.firstWhere((e) => e.name.toLowerCase() == value.toLowerCase(),
        orElse: () => throw ArgumentError('Invalid Category name: $value'));
  }

  @override
  String toString() {
    switch (this) {
      case itsupport:
        return isSelectedLocalEn ? 'IT Support' : "الدعم الفني";
      case isocr:
        return isSelectedLocalEn ? 'ISO CR' : "نماذج طلبات التغيير";
      case eservice:
        return isSelectedLocalEn ? 'Eservices' : "الخدمات";
      case application:
        return isSelectedLocalEn ? 'Application' : "الانظمة";
    }
  }
}

enum DashboardFilterEnum {
  current(1),
  month(2),
  year(3),
  custom(4);

  final int value;
  const DashboardFilterEnum(this.value);

  factory DashboardFilterEnum.fromId(int value) {
    return values.firstWhere((e) => e.value == value,
        orElse: () => throw ArgumentError('Invalid Category id: $value'));
  }

  factory DashboardFilterEnum.fromName(String value) {
    return values.firstWhere((e) => e.name.toLowerCase() == value.toLowerCase(),
        orElse: () => throw ArgumentError('Invalid Category name: $value'));
  }

  @override
  String toString() {
    switch (this) {
      case current:
        return isSelectedLocalEn ? 'Current Month' : "الشهر الحالي";
      case month:
        return isSelectedLocalEn ? 'Last Month' : "الشهر السابق";
      case year:
        return isSelectedLocalEn ? 'Year' : "السنة";
      case custom:
        return isSelectedLocalEn ? 'Custom' : "مخصص";
    }
  }
}

enum DepartmentEnum {
  external(0, "EXT"),
  sgd(1, "DGD"),
  ded(2, "DED"),
  ec(3, "EC"),
  upd(4, "UPD"),
  md(5, "MD"),
  tad(6, "TAD"),
  tar(7, "TAR"),
  fd(8, "FD"),
  bcd(10, "BCD"),
  fad(12, "FAD"),
  dewan(17, "Dewan"),
  rec(18, "REC");

  final int id;
  final String name;

  const DepartmentEnum(this.id, this.name);

  factory DepartmentEnum.fromId(int value) {
    return values.firstWhere((e) => e.id == value,
        orElse: () => throw ArgumentError('Invalid Category id: $value'));
  }

  @override
  String toString() {
    return name;
  }
}

enum IbtakerStatus {
  all(-1),
  pending(0),
  submitted(1),
  approved(2),
  rejected(3),
  transfered(4),
  hold(5),
  closed(6);

  final int value;
  const IbtakerStatus(this.value);

  factory IbtakerStatus.fromId(int? value) {
    return values.firstWhere((e) => e.value == (value ?? 0));
  }

  @override
  String toString() {
    switch (this) {
      case pending:
        return isSelectedLocalEn ? 'Pending' : 'في الانتظار';
      case approved:
        return isSelectedLocalEn ? 'Approved' : 'معتمد';
      case rejected:
        return isSelectedLocalEn ? 'Rejected' : 'مرفوض';
      case transfered:
        return isSelectedLocalEn ? 'Transfered' : 'تحويل';
      case submitted:
        return isSelectedLocalEn ? 'Submitted' : 'تم الارسال';
      case hold:
        return isSelectedLocalEn ? 'Hold' : 'تعليق';
      case closed:
        return isSelectedLocalEn ? 'Closed' : 'اغلاق';
      case all:
        return isSelectedLocalEn ? 'All' : 'جميع';
    }
  }

  Color color() {
    switch (this) {
      case IbtakerStatus.pending:
        return Colors.orange;
      case IbtakerStatus.submitted:
        return Colors.blue;
      case IbtakerStatus.approved:
        return Colors.green;
      case IbtakerStatus.rejected:
        return Colors.red;
      case IbtakerStatus.transfered:
        return Colors.purple;
      case IbtakerStatus.hold:
        return Colors.orange;
      case IbtakerStatus.closed:
        return Colors.green;
      case all:
        return Colors.grey;
    }
  }
}
