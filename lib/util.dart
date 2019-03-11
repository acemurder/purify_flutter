import 'package:flutter/services.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

const String SAVE_PATH = "Purify/";
const String SUFFIX = ".mp4";
const String CHANNEL_NAME = "purify_flutter/notify_media";

const _platform = const MethodChannel(CHANNEL_NAME);


Future<Null> notifyScanMedia(String path) async {
  try {
    await _platform.invokeMethod("mediaScan", {"path": path});
  } on PlatformException catch (e) {

  }
}

Future<String> getSavePath() async {
  Directory root = await getExternalStorageDirectory();

  String dirPath = "${root.path}/$SAVE_PATH";

  Directory dir = Directory(dirPath);
  bool exist = await dir.exists();
  if (!exist) {
    await dir.create();
  }
  String fileName = "${DateTime.now().millisecondsSinceEpoch.toString()}.mp4";
  String path = "$dirPath$fileName";
  print(path);
  return path;
}

Future<bool> checkStoragePermission() {
  return PermissionUtil.checkPermission(Permission.WriteExternalStorage);
}

Future<bool> requestStoragePermission() async {
  PermissionStatus status =
      await PermissionUtil.requestPermission(Permission.WriteExternalStorage);
  if (status == PermissionStatus.authorized) {
    return true;
  } else {
    return false;
  }
}

class PermissionUtil {
  static Future<PermissionStatus> requestPermission(
      Permission permission) async {
    return SimplePermissions.requestPermission(permission);
  }

  static Future<bool> checkPermission(Permission permission) {
    return SimplePermissions.checkPermission(permission);
  }

  static getPermissionStatus(Permission permission) async {
    final res = await SimplePermissions.getPermissionStatus(permission);
    print("permission status is " + res.toString());
  }
}
