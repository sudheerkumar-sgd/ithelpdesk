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

enum ServiceType {
  visitor('Visitor'),
  uaeResident('UAE Resident'),
  uaeCitizen('UAE Citizen'),
  gccResident('GCCResident'),
  gccCitizen('GCC Citizen'),
  establishment('Establishment');

  final String value;
  const ServiceType(this.value);

  static ServiceType getElgibleServiceName(int userType) {
    switch (userType) {
      case 1:
        return visitor;
      case 2:
        return uaeResident;
      case 3:
        return uaeCitizen;
      case 4:
        return gccResident;
      case 5:
        return uaeResident;
      case 7:
        return establishment;
    }
    return visitor;
  }
}
