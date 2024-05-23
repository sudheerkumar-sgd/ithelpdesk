import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:smartuaq/core/constants/constants.dart';
import 'package:smartuaq/core/extensions/build_context_extension.dart';
import 'package:smartuaq/presentation/home/user_main_screen.dart';
import 'package:smartuaq/res/resources.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appVersion = "${packageInfo.version} (${packageInfo.buildNumber})";
    });
    Resources resources = context.resources;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: resources.color.colorWhite,
        statusBarIconBrightness: Brightness.dark));
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const UserMainScreen()),
          (_) => false);
    });
    return const Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SizedBox(),
    );
  }
}
