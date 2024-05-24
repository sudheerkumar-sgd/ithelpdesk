import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ithelpdesk/app.dart';
import 'package:ithelpdesk/core/config/base_url_config.dart';
import 'package:ithelpdesk/core/config/flavor_config.dart';
import 'package:ithelpdesk/data/local/app_settings_db.dart';
import 'package:ithelpdesk/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(AppSettingsDB.name);
  FlavorConfig(
    flavor: Flavor.PRODUCTION,
    values: FlavorValues(
        portalBaseUrl: basePortalUrlProduction,
        mdSOABaseUrl: baseUrlMDSOAProd,
        mdPortalBaseUrl: baseMDUrlProduction,
        policeDomainBaseUrl: baseUrlPoliceDomain),
  );
  await di.init();
  runApp(const App());
}
