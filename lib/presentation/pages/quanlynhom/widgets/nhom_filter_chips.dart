import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:flutter/material.dart';

class NhomFilterChips extends StatelessWidget {
  final Map<String, List<String>> filters;
  final String searchQuery;
  final VoidCallback onClear;
  final Function(String key) onRemoveFilter; 
  final VoidCallback onClearSearch;

  const NhomFilterChips({
    super.key,
    required this.filters,
    required this.searchQuery,
    required this.onRemoveFilter,
    required this.onClear,
    required this.onClearSearch,
    
  });

  @override
  Widget build(BuildContext context) {
    final activeFilters =
        filters.entries.where((entry) => entry.value.isNotEmpty).toList();

    if (activeFilters.isEmpty && searchQuery.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 36, // Cố định chiều cao để tạo thanh cuộn ngang gọn gàng
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        // Padding để các item không bị dính vào mép màn hình khi cuộn
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm), 
        children: [
          if (searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: _FilterChip(label: 'Tìm: $searchQuery', onRemove: onClearSearch),
            ),
          
          ...activeFilters.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: _FilterChip(
                label: entry.value.join(', '), 
                onRemove: () => onRemoveFilter(entry.key), // Truyền Key vào đây
              ),
            ),
          ),

          // Nút Xóa lọc nằm cuối dòng
          TextButton.icon(
            onPressed: () {
              onClear();
              onClearSearch();
            },
            icon: Icon(
              Icons.restart_alt_rounded,
              size: 14,
              color: context.primary,
            ),
            label: Text(
              'Xóa lọc',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: context.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: context.surfaceHighest,
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.pillRadius,
                side: BorderSide(color: context.border, width: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _FilterChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 200), // Giới hạn độ dài chip
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: context.secondaryContainer.withValues(alpha: 0.82),
        borderRadius: AppRadius.pillRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: context.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close_rounded, 
              size: 14, 
              color: context.primary.withValues(alpha: 0.6)
            ),
          ),
        ],
      ),
    );
  }
}