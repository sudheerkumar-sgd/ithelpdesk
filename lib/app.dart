import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/config/app_routes.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ithelpdesk/data/local/user_data_db.dart';
import 'dart:html';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    getParams();
    final Locale locale = Locale(context.resources.getLocal());
    isSelectedLocalEn = (locale.languageCode == LocalEnum.en.name);
    var theme = context.resources.theme;
    theme.fontFamily(
        locale.languageCode == LocalEnum.ar.name ? fontFamilyAR : fontFamilyEN);
    userToken = context.userDataDB.get(UserDataDB.userToken, defaultValue: '');
    return MaterialApp(
      locale: locale,
      debugShowCheckedModeBanner: false,
      title: 'itHelpDesk',
      theme: theme.theme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (BuildContext context) =>
          context.resources.string.appTitle,
      initialRoute:
          userToken.isNotEmpty ? AppRoutes.userMainRoute : AppRoutes.startRoute,
      routes: AppRoutes.getRoutes(),
    );
  }

  void getParams() {
    var uri = Uri.dataFromString(window.location.href);
    Map<String, String> params = uri.queryParameters;
    var origin = params['origin'];
    var destiny = params['destiny'];
    print(origin);
    print(destiny);
  }
}
