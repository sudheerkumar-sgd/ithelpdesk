import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:ithelpdesk/core/constants/constants.dart';

void printLog(Object log) {
  if (kDebugMode) {
    print(log);
  }
}

void logFirbaseScreenView({
  required String screenName,
}) {
  FirebaseAnalytics.instance.logScreenView(
    screenName: screenName.replaceAll(' ', '_'),
    parameters: {'version': appVersion},
  );
}

void logFirbaseEvent(
    {required String eventname, Map<String, dynamic>? params}) {
  FirebaseAnalytics.instance.logEvent(name: eventname, parameters: params);
}

void logFirbaseEventClick(
    {required String eventname, Map<String, dynamic>? params}) {
  FirebaseAnalytics.instance.logEvent(
      name: '$eventname clicked'.replaceAll(' ', '_'), parameters: params);
}
