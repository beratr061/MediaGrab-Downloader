import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      // Android 13+ uses different permissions
      if (await _isAndroid13OrHigher()) {
        final status = await Permission.photos.request();
        return status.isGranted;
      } else {
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    } else if (Platform.isIOS) {
      final status = await Permission.photos.request();
      return status.isGranted;
    }
    // Desktop platforms don't need storage permission
    return true;
  }
  
  Future<bool> checkStoragePermission() async {
    if (Platform.isAndroid) {
      if (await _isAndroid13OrHigher()) {
        return await Permission.photos.isGranted;
      } else {
        return await Permission.storage.isGranted;
      }
    } else if (Platform.isIOS) {
      return await Permission.photos.isGranted;
    }
    return true;
  }
  
  Future<bool> _isAndroid13OrHigher() async {
    if (Platform.isAndroid) {
      // Check Android version
      // This is a simplified check, you might want to use device_info_plus
      return true; // Assume modern Android for now
    }
    return false;
  }
}
