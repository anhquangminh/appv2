import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:flutter/material.dart';

class QLNVFilterChips extends StatelessWidget {
  final Map<String, List<String>> filters;
  final String searchQuery;
  // Thay đổi: Hàm này nhận vào key để biết cần xóa mục nào
  final Function(String key) onRemoveFilter; 
  final VoidCallback onClearAll; // Xóa tất cả lọc (trừ search)
  final VoidCallback onClearSearch;

  const QLNVFilterChips({
    super.key,
    required this.filters,
    required this.searchQuery,
    required this.onRemoveFilter,
    required this.onClearAll,
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
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        children: [
          // 1. Chip tìm kiếm
          if (searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: _FilterChip(
                label: 'Tìm: $searchQuery', 
                onRemove: onClearSearch
              ),
            ),

          // 2. Các Chip lọc dữ liệu (Chỉ xóa từng cái dựa trên Key)
          ...activeFilters.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: _FilterChip(
                label: entry.value.join(', '), 
                onRemove: () => onRemoveFilter(entry.key), // Truyền Key vào đây
              ),
            ),
          ),

          // 3. Nút Xóa tất cả (Reset)
          TextButton.icon(
            onPressed: () {
              onClearAll();
              onClearSearch();
            },
            icon: Icon(Icons.restart_alt_rounded, size: 14, color: context.primary),
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
      constraints: const BoxConstraints(maxWidth: 200),
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
              color: context.primary.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}