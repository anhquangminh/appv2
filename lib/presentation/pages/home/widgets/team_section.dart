import 'dart:math';

import 'package:ducanherp/core/themes/app_colors.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/data/models/application_user.dart';
import 'package:ducanherp/data/models/congviec_model.dart';
import 'package:ducanherp/data/models/group_report_model.dart';
import 'package:ducanherp/presentation/pages/qlcv/danhsachcongviec_page.dart';
import 'package:flutter/material.dart';

class TeamSection extends StatefulWidget {
  final List<GroupReportModel> groupList;
  final ApplicationUser? user;

  const TeamSection({super.key, required this.groupList, required this.user});

  @override
  State<TeamSection> createState() => _TeamSectionState();
}

class _TeamSectionState extends State<TeamSection> {
  bool showAll = false;

  final List<Color> iconColors = [
    AppColors.accentBlue,
    AppColors.accentGreen,
    AppColors.accentOrange,
    AppColors.accentRed,
    AppColors.accentPurple,
    AppColors.accentBlue,
  ];

  @override
  Widget build(BuildContext context) {
    final listToShow = showAll
        ? widget.groupList
        : widget.groupList.take(8).toList(); // tối đa 8 item

    return _SectionCard(
      title: 'TRẠNG THÁI NHÓM',
      onViewAll: () {
        setState(() {
          showAll = !showAll;
        });
      },
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        mainAxisSpacing: 0,
        crossAxisSpacing: 8,
        childAspectRatio: 0.9,
        children: listToShow
            .map(
              (g) => _item(
                context,
                _getIconData(g.iconName),
                g.tenNhom,
                g.soLuong > 99 ? '99+' : g.soLuong.toString().padLeft(2, '0'),
                iconColors[Random().nextInt(iconColors.length)],
                () {
                  var buildDefaultModel = _buildDefaultModel(widget.user!);
                  buildDefaultModel.tenNhom = g.tenNhom;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DanhSachCongViecPage(
                        congViecModel: buildDefaultModel,
                      ),
                    ),
                  );
                },
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _item(
    BuildContext context,
    IconData icon,
    String name,
    String badge,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: context.opacity(color, 0.1),
                child: Icon(icon, color: color, size: 20),
              ),
              if (badge.isNotEmpty)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: context.surface, width: 1.5),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      badge,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: context.onPrimary,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: context.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'local_shipping':
        return Icons.local_shipping;
      case 'calculate':
        return Icons.calculate;
      case 'code':
        return Icons.code;
      case 'build':
        return Icons.build;
      case 'gavel':
        return Icons.gavel;
      case 'inventory_2':
        return Icons.inventory_2;
      case 'payments':
        return Icons.payments;
      case 'groups':
        return Icons.groups;
      default:
        return Icons.group;
    }
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: context.textSecondary,
                ),
              ),
              GestureDetector(
                onTap: onViewAll,
                child: Text(
                  'Tất cả',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: context.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // CONTENT
          child,
        ],
      ),
    );
  }
}