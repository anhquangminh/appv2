import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestStoragePermission(BuildContext context) async {
  if (!Platform.isAndroid) {
    // iOS không cần xin quyền storage
    return true;
  }

  // Thử xin MANAGE_EXTERNAL_STORAGE (Android 11+). Trên Android <11, request() sẽ trả về false.
  var status = await Permission.manageExternalStorage.request();
  if (status.isGranted) return true;

  // Nếu chưa grant, thử xin storage (Android <11).
  status = await Permission.storage.request();
  if (status.isGranted) return true;

  // Nếu user vẫn từ chối => show dialog dẫn vào Settings
  await showDialog(
    // ignore: use_build_context_synchronously
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text("Cần quyền truy cập bộ nhớ"),
      content: const Text(
        "Ứng dụng cần quyền truy cập bộ nhớ để tải file.\n"
        "Vui lòng cấp quyền trong Cài đặt.",
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Huỷ")),
        TextButton(
          onPressed: () {
            openAppSettings();
            Navigator.pop(ctx);
          },
          child: const Text("Mở Cài đặt"),
        ),
      ],
    ),
  );

  // Kiểm lại sau khi user quay về Settings
  status = await Permission.manageExternalStorage.status;
  if (status.isGranted) return true;
  status = await Permission.storage.status;
  return status.isGranted;
}
