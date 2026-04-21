
import 'permission_type.dart';

extension PermissionTypeExt on int {
  PermissionType toPermissionType() {
    switch (this) {
      case 0:
        return PermissionType.access;
      case 1:
        return PermissionType.view;
      case 2:
        return PermissionType.export;
      case 3:
        return PermissionType.create;
      case 4:
        return PermissionType.update;
      case 5:
        return PermissionType.delete;
      default:
        throw Exception('PermissionType không hợp lệ: $this');
    }
  }
}

extension PermissionTypeName on PermissionType {
  String get label {
    switch (this) {
      case PermissionType.access:
        return 'Truy cập';
      case PermissionType.view:
        return 'Xem';
      case PermissionType.export:
        return 'Xuất';
      case PermissionType.create:
        return 'Tạo';
      case PermissionType.update:
        return 'Sửa';
      case PermissionType.delete:
        return 'Xóa';
    }
  }
}
