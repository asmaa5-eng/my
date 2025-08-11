import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lol/model/user.dart';

class PermissionHandler {
  Future<bool> requestLocationPermission() async {
    // Check if the permission is already granted
    var status = await Permission.location.status;
    if (status.isDenied) {
      status = await Permission.location.request();
      if (status.isGranted) {
        return true;
      } else {
        return false;
      }
    } else if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      // The user permanently denied the permission, you can open app settings
      await openAppSettings();
      status = await Permission.location.status;
      if (status.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}

Future<void> getLocation(User user) async {
  bool hasPermission = await PermissionHandler().requestLocationPermission();

  if (hasPermission) {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    user.latitude = position.latitude;
    user.longitude = position.longitude;
  } else {
    print('Location permission not granted.');
  }
}
