import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'permission_type.dart';
import '../../data/models/permission_model.dart';

class PermissionHelper {
  static const _key = 'permissions';

  /// Lấy danh sách permission đã cache
  static Future<List<PermissionModel>> getPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];

    return list
        .map((e) => PermissionModel.fromJson(jsonDecode(e)))
        .toList();
  }

  /// Kiểm tra có quyền cụ thể không
  static bool hasPermission({
    required List<PermissionModel> permissions,
    required String parentMajorId,
    required String majorName,
    required PermissionType type,
  }) {
    return permissions.any(
      (p) =>
          p.parentMajorId == parentMajorId &&
          p.majorName == majorName &&
          p.permissionType == type.index,
    );
  }
}
