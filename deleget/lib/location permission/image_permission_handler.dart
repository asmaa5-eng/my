import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePermissionHandler {
  Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      status = await Permission.camera.request();
      return status.isGranted;
    } else if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
      status = await Permission.camera.status;
      return status.isGranted;
    }
    return false;
  }

  Future<bool> requestGalleryPermission() async {
    var status = await Permission.photos.status;
    if (status.isDenied) {
      status = await Permission.photos.request();
      return status.isGranted;
    } else if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
      status = await Permission.photos.status;
      return status.isGranted;
    }
    return false;
  }
}

Future<File?> pickImage({bool fromCamera = false}) async {
  bool hasPermission;
  if (fromCamera) {
    hasPermission = await ImagePermissionHandler().requestCameraPermission();
  } else {
    hasPermission = await ImagePermissionHandler().requestGalleryPermission();
  }

  if (!hasPermission) {
    print('Image permission not granted.');
    return null;
  }

  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(
    source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    imageQuality: 80, // تقلل حجم الصورة
  );

  if (pickedFile != null) {
    return File(pickedFile.path);
  } else {
    print('No image selected.');
    return null;
  }
}
