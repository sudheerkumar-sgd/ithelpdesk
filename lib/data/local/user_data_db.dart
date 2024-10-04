import 'package:hive_flutter/hive_flutter.dart';
import 'package:ithelpdesk/core/constants/constants.dart';

class UserDataDB {
  static const String name = 'db_app_settings';
  static const String enLocalSufix = 'en';
  static const String arLocalSufix = 'ar';
  static const String loginDisplayName = 'login_display_name_';
  static const String servicesSortOption = 'services_sort';
  static const String userServiceDisplayType = 'service_display_type';
  static const String userId = 'user_id';
  static const String userName = 'user_name';
  static const String userEmail = 'user_email';
  static const String userDptId = 'user_dpt_id';
  static const String userType = 'user_type';
  static const String userToken = 'user_token';
  static const String userFavorites = 'user_favorites';
  static const String userOnvaction = 'user_on_vaction';
  static const String userMobileNumber = 'user_mobilenumber';
  static const String homeTourDone = 'home_tour_done';

  Box settingDB = Hive.box(name);
  UserDataDB();

  put(String name, dynamic value) {
    settingDB.put(name, value);
  }

  dynamic get(String name, {dynamic defaultValue}) {
    return settingDB.get(name, defaultValue: defaultValue);
  }

  dynamic delete(String name) {
    return settingDB.delete(name);
  }

  dynamic deleteAll(Iterable keys) {
    return settingDB.deleteAll(keys);
  }

  dynamic getTextByLocal(String name, {dynamic defaultValue}) {
    return settingDB.get(
        '$name${isSelectedLocalEn ? enLocalSufix : arLocalSufix}',
        defaultValue: defaultValue);
  }

  dynamic putTextByLocal(String name,
      {required String enValue, required String arValue}) {
    settingDB.put('$name$enLocalSufix', enValue);
    settingDB.put('$name$arLocalSufix', arValue);
  }
}
