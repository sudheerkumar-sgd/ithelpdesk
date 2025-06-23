import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:ithelpdesk/core/common/log.dart';
import 'package:ithelpdesk/core/config/flavor_config.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/data/local/user_data_db.dart';
import 'package:ithelpdesk/presentation/common_widgets/alert_dialog_widget.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';
import 'package:ithelpdesk/presentation/utils/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mime/mime.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:html' as html;

Future<void> openMapsSheet(
    BuildContext context, String title, double lat, double lang) async {
  try {
    final availableMaps = await MapLauncher.installedMaps;
    if (availableMaps.length > 1) {
      if (context.mounted) {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      Container(
                        padding: const EdgeInsets.only(top: 15),
                        child: ListTile(
                          onTap: () => map.showMarker(
                            coords: Coords(lat, lang),
                            title: title,
                          ),
                          title: Text(map.mapName),
                          leading: SvgPicture.asset(
                            map.icon,
                            height: 30.0,
                            width: 30.0,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      }
    } else {
      await availableMaps.first.showMarker(
        coords: Coords(lat, lang),
        title: title,
      );
    }
  } catch (e) {
    printLog(e.toString());
  }
}

Future<void> launchMapUrl(
    BuildContext context, String title, double lat, double long) async {
  final availableMaps = await MapLauncher.installedMaps;
  await availableMaps.first.showMarker(
    coords: Coords(lat, long),
    title: title,
  );
}

callNumber(BuildContext context, String number) async {
  final result = await FlutterPhoneDirectCaller.callNumber(number);
  if (result == false && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Center(child: Text('could_not_launch_this_app')),
    ));
  }
}

sendEmail(BuildContext context, String email) async {
  final result =
      await launchUrl(Uri.parse("mailto:${Uri.encodeComponent(email)}"));
  if (result == false && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Center(child: Text('could_not_launch_this_app')),
    ));
  }
}

launchAppUrl() {
  if (Platform.isAndroid || Platform.isIOS) {
    final url = Uri.parse(
      Platform.isAndroid
          ? "market://details?id=uaq.gov.ithelpdesk"
          : "https://apps.apple.com/app/id1063110068",
    );
    launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }
}

launchWebUrl(String url) {
  if (Platform.isAndroid || Platform.isIOS) {
    final uri = Uri.parse(
      url,
    );
    launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }
}

String getAppUrl() {
  return Platform.isAndroid
      ? 'https://play.google.com/store/apps/details?id=uaq.gov.ithelpdesk'
      : 'https://apps.apple.com/ae/app/ithelpdesk/id1063110068';
}

double distance(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371;
  final dLat = deg2rad(lat2 - lat1);
  final dLon = deg2rad(lon2 - lon1);
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  final d = R * c;
  return d;
}

double deg2rad(deg) {
  return deg * (pi / 180);
}

String getCurrentDateByformat(String format) {
  return DateFormat(format).format(DateTime.now());
}

String getDateByformat(String format, DateTime dateTime) {
  try {
    return dateTime.year == 0 ? '' : DateFormat(format).format(dateTime);
  } catch (error) {
    return '';
  }
}

DateTime getDateTimeByString(String format, String date) {
  try {
    return DateFormat(format).parse(date);
  } catch (error) {
    return DateTime(0);
  }
}

startTimer({required Duration duration, required Function callback}) {
  Timer.periodic(duration, (Timer t) => callback());
}

int daysBetween(DateTime from, DateTime to) {
  return (to.difference(from).inSeconds);
}

int getDays(DateTime from, DateTime to) {
  return getHours(from, to) ~/ 24;
}

int getHours(DateTime from, DateTime to) {
  return daysBetween(from, to) ~/ (60 * 60);
}

int getMinutes(DateTime from, DateTime to) {
  return daysBetween(from, to) ~/ (60);
}

String getHoursMinutesFormat(DateTime from, DateTime to) {
  var minutes = getMinutes(from, to);
  return '${minutes ~/ 60}.${minutes % 60} hrs';
}

String getRemainingHoursMinutesFormat(DateTime from, DateTime to) {
  var minutes = 480 - getMinutes(from, to);
  if (minutes < 1) {
    return '0';
  }
  return '${(minutes ~/ 60)}.${minutes % 60} hrs';
}

logout(BuildContext context) {
  Iterable keys = [
    UserDataDB.loginDisplayName + UserDataDB.enLocalSufix,
    UserDataDB.loginDisplayName + UserDataDB.arLocalSufix,
    UserDataDB.userEmail,
    UserDataDB.userType,
    UserDataDB.userToken,
  ];
  context.userDataDB.deleteAll(keys);
  userToken = '';
  Phoenix.rebirth(context);
}

mixin userFullNameUsKey {}

bool isImage(String path) {
  final mimeType = lookupMimeType(path);

  return mimeType?.startsWith('image/') ?? false;
}

bool isPdf(String path) {
  final mimeType = lookupMimeType(path);

  return mimeType?.startsWith('application/pdf') ?? false;
}

double getTopSafeAreaHeight(BuildContext context) {
  printLog('${MediaQuery.of(context).padding.top}');
  return MediaQuery.of(context).padding.top;
}

double getBottomSafeAreaHeight(BuildContext context) {
  printLog('${MediaQuery.of(context).padding.bottom}');
  return MediaQuery.of(context).padding.bottom;
}

Size getScrrenSize(BuildContext context) {
  printLog('${MediaQuery.of(context).size}');
  return MediaQuery.of(context).size;
}

bool isDesktop(BuildContext context, {Size? size}) {
  size ??= screenSize;
  return size.width > 600;
}

Map<String, dynamic> getFCMMessageData(
    {required String to,
    required String title,
    required String body,
    String type = '',
    String imageUrl = '',
    String audioUrl = '',
    String notificationId = ''}) {
  return {
    "to": '/topics/$to',
    "notification": {
      "id": notificationId,
      "title": title,
      "body": body,
      "image_url": imageUrl,
      "audio_url": audioUrl,
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "sound": "default",
    },
    "data": {
      "id": notificationId,
      "title": title,
      "body": body,
      "image_url": imageUrl,
      "audio_url": audioUrl,
      "type": type,
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      "notification_id": notificationId
    },
    "priority": "high"
  };
}

String getLeavesApproverFCMBodyText(
    String prefix, String leaveName, String fromDate, String toDate) {
  return '$prefix has applied for $leaveName Request from $fromDate to $toDate';
}

// String getWeatherIcon(int weatherCode) {
//   switch (weatherCode) {
//     case 2 || 3:
//       return DrawableAssets.icCloudy; //Cloudy
//     //case 45&&48: return DrawableAssets.bgWeather;//Foggy
//     case 61 || 63 || 65 || 66 || 67:
//       return DrawableAssets.icRain; //Rain
//     case 95 || 96 || 99:
//       return DrawableAssets.icStorm; //Thunderstorm
//     default:
//       return DrawableAssets.icSun;
//   }
// }

bool isStringArabic(String text) {
  final RegExp arabic = RegExp(r'[\u0621-\u064A]+');
  if (arabic.hasMatch(text.trim())) return true;
  return false;
}

String getFontNameByString(String text) {
  return isStringArabic(text) ? fontFamilyAR : fontFamilyEN;
}

Future<String> doUaePassLogin() async {
  // final uaePassPlugin = UaePass();
  // // await uaePassPlugin.setUpSandbox();
  // await uaePassPlugin.setUpEnvironment(uaePassMobClientId,
  //     uaePassMobClientSecret, uaePassAppUrlScheme, uaePassState,
  //     isProduction: true, redirectUri: uaePassRedirectUri);
  return "";
}

String getGoogleStaticMapUrl(double lat, double long) {
  return 'https://maps.googleapis.com/maps/api/staticmap?zoom=15&size=600x400&maptype=roadmap&markers=color:red|label:S|$lat,$long&key=AIzaSyB_aALVvfyHAL9WGro-3EJ6L3JZ86bWgIQ';
}

Future<Position?> getLocationDetails(BuildContext context) async {
  var isLocationOn = await Location.checkGps();
  if (isLocationOn) {
    return Location.getLocation();
  } else {
    if (context.mounted) {
      Dialogs.showInfoDialog(
        context,
        PopupType.fail,
        'please Enable Location to submit',
      );
    }
    return null;
  }
}

String getUploadFileRequestString(Map<String, dynamic> fileData) {
  String name = getCurrentDateByformat("yyMMddHHmmss") + fileData['fileType'];
  String data =
      "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:upl='http://xmlns.oracle.com/UAQBusinessProcess/UAQ_DocumentUpload_Download_Ser/Upload_DownloadBpel'>\n<soapenv:Header>\n<wsse:Security xmlns:wsse='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd'>\n<wsse:UsernameToken xmlns:wsu='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd'>\n<wsse:Username>uaqdev</wsse:Username>\n<wsse:Password Type='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText'>welcome1</wsse:Password>\n</wsse:UsernameToken>\n</wsse:Security>\n</soapenv:Header>\n<soapenv:Body>\n<upl:UploadInput>\n<upl:DocName>$name</upl:DocName>\n<upl:DocTitle>${fileData['fileName']}</upl:DocTitle>\n<upl:DocType>Document</upl:DocType>\n<upl:DocSecurityGroup>Public</upl:DocSecurityGroup>\n<upl:AuthorName>uaqdev</upl:AuthorName>\n<upl:FileList>\n<upl:FileRecord>\n<upl:Filename>$name</upl:Filename>\n<upl:FileContent>${fileData['fileNamebase64data']}</upl:FileContent>\n</upl:FileRecord>\n</upl:FileList>\n</upl:UploadInput>\n</soapenv:Body>\n</soapenv:Envelope>";
  return data;
}

TransformationController getZoomViewTransformationController() {
  final viewTransformationController = TransformationController();
  viewTransformationController.value.setEntry(0, 0, 2);
  viewTransformationController.value.setEntry(1, 1, 2);
  viewTransformationController.value.setEntry(2, 2, 2);
  viewTransformationController.value.setEntry(0, 3, -160);
  viewTransformationController.value.setEntry(1, 3, -80);
  return viewTransformationController;
}

Future<String> getDeviceId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor ?? ''; // unique ID on iOS
  } else if (Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.id; // unique ID on Android
  }
  return '';
}

Future<void> printData(
    {String? title, String? headerData, String? bodyData, int? count}) async {
  String base64ImageLeft =
      await imageAssetToBase64('assets/images/ic_logo.png');
  String base64ImageRight =
      await imageAssetToBase64('assets/images/ic_sgd_logo.png');
  final htmlString = '''
  <!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Report</title>
  <style>
    @page {
      margin: 1.5cm;
    }

    body {
      font-family: Arial, sans-serif;
      margin: 0;
    }

    .logo {
      height: 60px;
    }

    .title {
      font-size: 24px;
      font-weight: bold;
      color: #2B2C34;
      text-align: center;
      margin-top: 10px;
      margin-bottom: 20px;
    }

    .header-logos {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .header-logos img {
      height: 60px;
    }

    .title-section {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-top: 15px;
      padding-bottom: 10px;
    }

    .title-section .title {
      flex: 1;
      text-align: center;
      font-size: 24px;
      font-weight: bold;
      color: #2B2C34;
    }

    .title-section .total-tickets {
      text-align: right;
      color: red;
      font-size: 16px;
      font-weight: bold;
      white-space: nowrap;
    }

    .data-table {
      width: 100%;
      border-collapse: collapse;
      page-break-inside: auto;
    }

    .data-table th {
      background-color: #2B2C34;
      color: white;
      font-weight: bold;
      padding: 8px;
      border: 1px solid #ccc;
      font-size: 13px;
    }

    .data-table td {
      padding: 8px;
      border: 1px solid #ccc;
      font-size: 13px;
    }

    .data-table tr:nth-child(even) {
      background-color: #f9fbfc;
    }

    .data-table tr:nth-child(odd) {
      background-color: #ffffff;
    }

    .data-table td.no-border {
      padding: 8px;
      border: 0px solid #ccc !important;
      font-size: 13px;
      border: none;
    }
  </style>
</head>
<body onload="window.print(); window.onafterprint = () => window.close();">

  

  <!-- Data Table -->
  <table class="data-table">
    <thead>
    <!-- Logos Row -->
    <tr>
    <td colspan="12" class="no-border">
  <div class="header-logos">
    <img src="data:image/png;base64,$base64ImageLeft"  alt="Left Logo">
    <img src="data:image/png;base64,$base64ImageRight"  alt="Right Logo">
  </div>

  <!-- Title and Ticket Count -->
  <div class="title-section">
    <div></div> <!-- Spacer -->
    <div class="title">$title</div>
    <div class="total-tickets">Total Tickets: $count</div>
  </div>
  </td>
  </tr>
      $headerData
    </thead>
    <tbody>
      $bodyData
    </tbody>
  </table>
</body>
</html>

  ''';

  final blob = html.Blob([htmlString], 'text/html');

  final url = html.Url.createObjectUrlFromBlob(blob);
  html.window.open(url, '_blank');

  html.Url.revokeObjectUrl(url);
}

reloadPage() {
  html.window.location.reload();
}

String get getImageBaseUrl =>
    '${FlavorConfig.instance.values.portalBaseUrl}Attachments/';

List<StatusType> getStatusTypes() {
  return [
    StatusType.notAssigned,
    StatusType.open,
    StatusType.hold,
    StatusType.reject,
    StatusType.closed,
    StatusType.returned,
    StatusType.acquired,
  ];
}

List<IssueType> getIssueTypes() {
  return [
    IssueType.customer,
    IssueType.employee,
    IssueType.system,
    IssueType.other,
  ];
}

List<PriorityType> getPriorityTypes() {
  return [
    PriorityType.low,
    PriorityType.medium,
    PriorityType.high,
    PriorityType.critical,
  ];
}

Future<String> imageAssetToBase64(String path) async {
  final ByteData bytes = await rootBundle.load(path);
  final Uint8List list = bytes.buffer.asUint8List();
  return base64Encode(list);
}

String monthName(int month, {String locale = 'en'}) {
  return DateFormat.MMM(locale).format(DateTime(0, month));
}
