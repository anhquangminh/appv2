import 'package:ducanherp/common/fa_icons.dart';
import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/data/models/application_user.dart';
import 'package:ducanherp/data/models/congviec_model.dart';
import 'package:ducanherp/data/models/group_report_model.dart';
import 'package:ducanherp/presentation/pages/qlcv/danhsachcongviec_page.dart';
import 'package:ducanherp/presentation/widgets/common/app_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TeamSection extends StatefulWidget {
  final List<GroupReportModel> groupList;
  final ApplicationUser? user;

  const TeamSection({super.key, required this.groupList, required this.user});

  @override
  State<TeamSection> createState() => _TeamSectionState();
}

class _TeamSectionState extends State<TeamSection> {
  bool showAll = false;

  /// ✅ Sử dụng bảng màu phối hợp theo tinh thần Atelier
  List<Color> get palette => [
    context.primary,
    context.chartBlue,
    context.chartGreen,
    context.chartOrange,
    context.chartRed,
  ];

  Color _getColor(String key) {
    final index = key.hashCode.abs() % palette.length;
    return palette[index];
  }

  @override
  Widget build(BuildContext context) {
    final listToShow = showAll ? widget.groupList : widget.groupList.take(8).toList();

    return _SectionCard(
      title: 'TRẠNG THÁI NHÓM',
      onViewAll: () => setState(() => showAll = !showAll),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: listToShow.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.lg, // Tăng nhẹ để text không bị dính vào icon tầng dưới
          childAspectRatio: 0.9, 
        ),
        itemBuilder: (_, i) {
          final g = listToShow[i];
          final color = _getColor(g.tenNhom);

          return _TeamItem(
            icon: _getGroupIcon(g.iconName),
            name: g.tenNhom,
            badge: g.soLuong > 99 ? '99+' : g.soLuong.toString(),
            accentColor: color,
            onTap: () {
              var model = _buildDefaultModel(widget.user!);
              model.tenNhom = g.tenNhom;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DanhSachCongViecPage(congViecModel: model),
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _getGroupIcon(String? iconName) {
    if (iconName == null || iconName.isEmpty) return FontAwesomeIcons.users;
    return faIcons[iconName] ?? FontAwesomeIcons.users;
  }

  CongViecModel _buildDefaultModel(ApplicationUser user) {
    return CongViecModel(
      id: '',
      idNguoiGiaoViec: user.userName,
      nguoiThucHien: '',
      nhomCongViec: '',
      tenNhom: '',
      ngayBatDau: DateTime.now(),
      ngayKetThuc: DateTime.now(),
      mucDoUuTien: '',
      tuDanhGia: '',
      duocDanhGia: 0,
      tienDo: 0,
      lapLai: '',
      tenCongViec: '',
      noiDungCongViec: '',
      fileDinhKem: '',
      groupId: user.groupId,
      companyId: user.companyId,
      companyName: '',
      createAt: DateTime.now(),
      createBy: '',
      isActive: 1,
      pageNumber: 1,
      pageSize: 10,
    );
  }
}

class _TeamItem extends StatelessWidget {
  final IconData icon;
  final String name;
  final String badge;
  final Color accentColor;
  final VoidCallback onTap;

  const _TeamItem({
    required this.icon,
    required this.name,
    required this.badge,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.xlRadius,
      highlightColor: context.opacity(accentColor, 0.05),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              /// ✅ Circle Icon với Tonal Layering
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: context.surfaceLow, // Dùng surface thấp hơn để tạo chiều sâu
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(icon, color: accentColor, size: 20),
                ),
              ),

              /// ✅ Badge - Organic & Soft Shadow
              if (badge != '0' && badge != '00')
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: AppRadius.pillRadius,
                      // Botanical Shadow cho badge để tạo hiệu ứng "nổi" nhẹ
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(color: context.surfaceHighest, width: 2),
                    ),
                    child: Text(
                      badge,
                      style: context.theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          /// ✅ Text chuẩn Editorial
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.theme.textTheme.labelSmall?.copyWith(
              color: context.textPrimary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onViewAll;

  const _SectionCard({
    required this.title,
    required this.child,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      // Tonal Nesting: Card màu surfaceHighest nổi trên nền background
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: context.theme.textTheme.labelMedium?.copyWith(
                  color: context.textSecondary,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: onViewAll,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Tất cả',
                  style: context.theme.textTheme.labelMedium?.copyWith(
                    color: context.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          child,
        ],
      ),
    );
  }
}