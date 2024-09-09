import 'package:hive_flutter/hive_flutter.dart';

class AppSettingsDB {
  static const String name = 'db_app_settings';
  static const String appColorKey = 'key_app_color';
  static const String appThemeKey = 'key_app_theme';
  static const String appLocalKey = "app_local_key";
  static const String appFontSizeKey = "app_font_size_key";
  static const String isSplashDoneKey = "is_splash_done";
  static const String welcomeTourDone = 'welcome_tour_done';
  static const String selectedSideBarIndex = 'selected_idebar_index';

  Box settingDB = Hive.box(name);

  AppSettingsDB();

  Future<void> put(String name, dynamic value) async {
    await settingDB.put(name, value);
  }

  dynamic get(String name, {dynamic defaultValue}) {
    return settingDB.get(name, defaultValue: defaultValue);
  }
}
