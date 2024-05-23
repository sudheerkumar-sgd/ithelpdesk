import 'dart:convert';

import 'package:smartuaq/core/constants/constants.dart';

class UserCredentialsEntity {
  static UserCredentialsEntity? userCredentialsEntity;
  String? userId;
  String? userNameEN;
  String? userNameAR;
  String? integrationId;
  String? mobileNumber;
  bool? hasEstablishment;
  UserCredentialsEntity();
  factory UserCredentialsEntity.details() {
    if (userCredentialsEntity == null && userToken.isNotEmpty) {
      userCredentialsEntity = UserCredentialsEntity();
      String normalizedSource = base64Url.normalize(userToken.split(".")[1]);
      final data = jsonDecode(utf8.decode(base64Url.decode(normalizedSource)));
      userCredentialsEntity?.userId = '${data['UserId']}';
      userCredentialsEntity?.userNameAR = '${data['UserNameAR']}';
      userCredentialsEntity?.userNameEN = '${data['UserNameEN']}';
      userCredentialsEntity?.integrationId = '${data['IntegrationId']}';
      userCredentialsEntity?.mobileNumber = '${data['Mobile']}';
      userCredentialsEntity?.hasEstablishment =
          data['HaveEstablishment'] == 'True';
    }
    return userCredentialsEntity ?? UserCredentialsEntity();
  }

  String getUserQueryString() {
    final queryParameters = {
      'applicantId': userId,
      'lang': isSelectedLocalEn ? 'en' : 'ar',
      'sessionId': integrationId,
      'channelId': '3',
    };
    final queryString = Uri(queryParameters: queryParameters).query;
    return queryString;
  }

  String get userDisplayName =>
      isSelectedLocalEn ? userNameEN ?? '' : userNameAR ?? '';
}
