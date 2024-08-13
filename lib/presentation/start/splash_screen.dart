import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ithelpdesk/data/local/user_data_db.dart';
import 'package:ithelpdesk/injection_container.dart';
import 'package:ithelpdesk/presentation/bloc/user/user_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/presentation/home/user_main_screen.dart';
import 'package:ithelpdesk/res/resources.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final UserBloc _userBloc = sl<UserBloc>();

  @override
  Widget build(BuildContext context) {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appVersion = "${packageInfo.version} (${packageInfo.buildNumber})";
    });
    Resources resources = context.resources;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: resources.color.colorWhite,
        statusBarIconBrightness: Brightness.dark));
    Future.delayed(const Duration(seconds: 0), () async {
      final user = await _userBloc.validateUser({"username": username});
      if (context.mounted) {
        userToken = user.token ?? '';
        context.userDataDB.put(UserDataDB.userToken, userToken);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const UserMainScreen()),
            (_) => false);
      }
    });
    return BlocProvider(
      create: (context) => _userBloc,
      child: const Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: SizedBox(),
      ),
    );
  }
}
