import 'package:ducanherp/data/models/nhanvien_model.dart';
import 'package:ducanherp/presentation/widgets/avatar/user_avatar.dart';
import 'package:flutter/material.dart';

class AvatarStack extends StatelessWidget {
  const AvatarStack({
    super.key,
    required this.nhanViens,
    this.maxVisible = 3,
    this.size = 36,
    this.overlap = 0.2,
  });

  final List<NhanVienModel> nhanViens;
  final int maxVisible;
  final double size;
  final double overlap;

  @override
  Widget build(BuildContext context) {
    final visibleCount =
        nhanViens.length > maxVisible ? maxVisible : nhanViens.length;

    final remaining =
        nhanViens.length > maxVisible ? nhanViens.length - maxVisible : 0;

    return SizedBox(
      height: size,
      width: size + (visibleCount - 1) * size * (1 - overlap),
      child: Stack(
        clipBehavior: Clip.none,
        children: List.generate(visibleCount, (index) {
          final nv = nhanViens[index];

          /// ⭐ LẤY 1 KÝ TỰ ĐẦU + HOA
          final initial = nv.tenNhanVien.trim().isNotEmpty
              ? nv.tenNhanVien.trim()[0].toUpperCase()
              : '?';

          return Positioned(
            left: index * size * (1 - overlap),
            child: UserAvatar(
              index: index,
              visibleCount: visibleCount,
              remaining: remaining,
              initial: initial,
              fullName: '${nv.tenNhanVien} (${nv.taiKhoan})',
              size: size,
            ),
          );
        }),
      ),
    );
  }
}
