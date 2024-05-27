import 'package:flutter/material.dart';
import 'package:ithelpdesk/data/local/app_settings_db.dart';
import 'package:ithelpdesk/data/local/user_data_db.dart';
import '../../../res/resources.dart';

extension LocalizedBuildContext on BuildContext {
  Resources get resources => Resources.of(this);
  AppSettingsDB get appSettingsDB => AppSettingsDB();
  UserDataDB get userDataDB => UserDataDB();
}