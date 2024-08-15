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

enum UserType {
  visitor(1),
  uaeResident(2),
  uaeCitizen(3),
  gccResident(4),
  gccCitizen(5),
  walkIn(6),
  establishment(7),
  otp(8),
  anonymous(100);

  final int value;
  const UserType(this.value);
}

enum PriorityType {
  low(1),
  medium(2),
  high(3),
  critical(4);

  final int value;
  const PriorityType(this.value);
}

enum StatusType {
  open(1),
  closed(2),
  hold(3),
  reject(4),
  duplicate(5),
  returned(6),
  approve(7),
  forword(8),
  resubmit(9);

  final int value;
  const StatusType(this.value);

  factory StatusType.fromId(int value) {
    return values.firstWhere((e) => e.value == value);
  }

  factory StatusType.fromName(String value) {
    return values.firstWhere((e) => e.name.contains(value.toLowerCase()));
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
