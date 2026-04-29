import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/data/models/nhanvien_model.dart';
import 'package:ducanherp/presentation/widgets/shimmer/app_shimmer.dart';
import 'package:flutter/material.dart';

import 'qlnv_list_item.dart';

class QLNVListView extends StatelessWidget {
  final List<NhanVienModel> filteredList;
  final bool isLoading;
  final Function(NhanVienModel) onEdit;
  final Function(NhanVienModel) onDelete;
  final Function(NhanVienModel, String action) onAction;

  const QLNVListView({
    super.key,
    required this.filteredList,
    required this.isLoading,
    required this.onEdit,
    required this.onDelete,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _NhanVienListShimmer(key: ValueKey('loadingNhanViens'));
    }

    if (filteredList.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: context.surfaceHighest,
          borderRadius: AppRadius.xlRadius,
          border: Border.all(color: context.borderStrong),
        ),
        child: Column(
          children: [
            Icon(
              Icons.people_outline_rounded,
              size: 48,
              color: context.textSecondary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Khong co nhan vien phu hop',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: context.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Thu doi tu khoa tim kiem hoac bo loc de xem lai danh sach.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: context.textSecondary),
            ),
          ],
        ),
      );
    }

    return Column(
      key: const ValueKey('loadedNhanViens'),
      children: [
        for (var index = 0; index < filteredList.length; index++) ...[
          if (index > 0) const SizedBox(height: AppSpacing.md),
          QLNVListItem(
            nhanVien: filteredList[index],
            onTap: () => onEdit(filteredList[index]),
            onEdit: () => onEdit(filteredList[index]),
            onDelete: () => onDelete(filteredList[index]),
            onActionSelected: (action) => onAction(filteredList[index], action),
          ),
        ],
      ],
    );
  }
}

class _NhanVienListShimmer extends StatelessWidget {
  const _NhanVienListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(4, (index) {
        return Padding(
          padding: EdgeInsets.only(bottom: index == 3 ? 0 : AppSpacing.md),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.surfaceHighest,
              borderRadius: AppRadius.xlRadius,
              border: Border.all(color: context.borderStrong),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ShimmerBox(height: 48, width: 48, radius: AppRadius.md),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerBox(height: 18, width: 150, radius: 8),
                          SizedBox(height: AppSpacing.xs),
                          ShimmerBox(height: 12, width: 180, radius: 8),
                          SizedBox(height: AppSpacing.xxs),
                          ShimmerBox(height: 12, width: 200, radius: 8),
                          SizedBox(height: AppSpacing.xxs),
                          ShimmerBox(height: 12, width: 170, radius: 8),
                        ],
                      ),
                    ),
                    SizedBox(width: AppSpacing.xs),
                    ShimmerBox(height: 24, width: 24, radius: 12),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                const ShimmerBox(height: 56, radius: AppRadius.md),
              ],
            ),
          ),
        );
      }),
    );
  }
}
