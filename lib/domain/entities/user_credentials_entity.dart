import 'dart:convert';

import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/data/local/user_data_db.dart';

class UserCredentialsEntity {
  static UserCredentialsEntity? userData;
  int? id;
  String? name;
  String? username;
  int? departmentID;
  UserType? userType;
  UserCredentialsEntity();
  factory UserCredentialsEntity.details() {
    if (userData == null && userToken.isNotEmpty) {
      userData = UserCredentialsEntity();
      String normalizedSource = base64Url.normalize(userToken.split(".")[1]);
      final data = jsonDecode(utf8.decode(base64Url.decode(normalizedSource)));
      userData?.id = int.tryParse(data['ID']);
      userData?.departmentID = int.tryParse(data['DepartmentID']);
      userData?.username = data['UserName'];
      userData?.name = data['Name'];
      userData?.userType = UserType.fromId(int.tryParse(data['Role']) ?? 7);
    }
    return userData ?? UserCredentialsEntity();
  }

  factory UserCredentialsEntity.create(String userToken) {
    final userDetails = UserDataDB();
    userDetails.put(UserDataDB.userToken, userToken);
    return UserCredentialsEntity.details();
  }
}
