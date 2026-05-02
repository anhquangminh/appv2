import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/data/models/nhomnhanvien_model.dart';
import 'package:ducanherp/presentation/widgets/shimmer/list_shimmer.dart';
import 'package:flutter/material.dart';

import 'nhom_list_item.dart';

class NhomListView extends StatelessWidget {
  final List<NhomNhanVienModel> filteredList;
  final NhomNhanVienModel searchVM;
  final bool isLoading;
  final Function(NhomNhanVienModel) onEdit;
  final Function(NhomNhanVienModel) onDelete;
  final Function(NhomNhanVienModel) onManageMembers;
  final Function(NhomNhanVienModel) onOpen;
  final Function(NhomNhanVienModel, String action) onAction;
  final int Function(NhomNhanVienModel) getMemberCount;

  const NhomListView({
    super.key,
    required this.filteredList,
    required this.searchVM,
    required this.isLoading,
    required this.onEdit,
    required this.onDelete,
    required this.onManageMembers,
    required this.onOpen,
    required this.onAction,
    required this.getMemberCount,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const ListShimmer(key: ValueKey('loadingNhomNhanViens'));
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
              Icons.groups_2_outlined,
              size: 52,
              color: context.textSecondary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Chưa có nhóm phù hợp',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: context.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Hãy thử đổi bộ lọc hoặc thêm nhóm mới để bắt đầu.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.textSecondary,
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      key: const ValueKey('loadedNhomNhanViens'),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredList.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final nnv = filteredList[index];

        return NhomListItem(
          nhom: nnv,
          index: index,
          onTap: () => onOpen(nnv),
          onEdit: () => onEdit(nnv),
          onDelete: () => onDelete(nnv),
          onManageMembers: () => onManageMembers(nnv),
          onActionSelected: (action) => onAction(nnv, action),
          memberCount: getMemberCount(nnv),
        );
      },
    );
  }
}
