import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/data/local/user_data_db.dart';

import 'user_entity.dart';

class UserCredentialsEntity {
  static UserCredentialsEntity? userData;
  int? id;
  String? name;
  String? username;
  int? departmentID;
  UserCredentialsEntity();
  factory UserCredentialsEntity.details() {
    if (userData == null) {
      userData = UserCredentialsEntity();
      final userDetails = UserDataDB();
      userData?.id = userDetails.get(UserDataDB.userId);
      userData?.name = userDetails.get(UserDataDB.name);
      userData?.username = userDetails.get(UserDataDB.userName);
      userData?.departmentID = userDetails.get(UserDataDB.userDptId);
    }
    return userData ?? UserCredentialsEntity();
  }

  factory UserCredentialsEntity.create(UserEntity userEntity) {
    final userDetails = UserDataDB();
    userDetails.put(UserDataDB.userId, userEntity.id);
    userDetails.put(UserDataDB.name, userEntity.name);
    userDetails.put(UserDataDB.userName, userEntity.username);
    userDetails.put(UserDataDB.userDptId, userEntity.departmentID);
    return UserCredentialsEntity.details();
  }
}
