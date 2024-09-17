import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:ithelpdesk/app.dart';
import 'package:ithelpdesk/core/config/base_url_config.dart';
import 'package:ithelpdesk/core/config/flavor_config.dart';
import 'package:ithelpdesk/data/local/app_settings_db.dart';
import 'package:ithelpdesk/injection_container.dart' as di;
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(AppSettingsDB.name);
  FlavorConfig(
    flavor: Flavor.DEVELOPMENT,
    values: FlavorValues(
      portalBaseUrl: baseUrlDevelopment,
      mdSOABaseUrl: baseUrlSOAProd,
    ),
  );
  await di.init();
  usePathUrlStrategy();
  runApp(Phoenix(child: const App()));
}
