import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:ithelpdesk/core/common/log.dart';

class Location {
  static Future<bool> checkGps() async {
    var servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      bool haspermission = false;
      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          printLog('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          printLog("Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }
      return haspermission;
    } else {
      printLog("GPS Service is not enabled, turn on GPS location");
      return false;
    }
  }

  static Future<Position> getLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    return position;
  }
}
