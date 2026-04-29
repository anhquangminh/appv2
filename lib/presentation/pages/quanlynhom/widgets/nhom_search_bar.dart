import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart'; 
import 'package:ducanherp/data/models/nhomnhanvien_model.dart';
import 'package:ducanherp/presentation/widgets/dialog/filter_sheet.dart';
import 'package:flutter/material.dart';

class NhomSearchBar extends StatefulWidget {
  final List<NhomNhanVienModel> nhomNhanVienList;
  final ValueChanged<String> onSearch;
  final VoidCallback onClearSearch;
  final Function(
    Map<String, List<String>> filters,
    List<NhomNhanVienModel> filteredList,
  ) onFilterApplied;
  final ValueChanged<String> onSortChanged;
  final String currentSortMode;
  final String activeSearchQuery;
  final bool compact;

  const NhomSearchBar({
    super.key,
    required this.nhomNhanVienList,
    required this.onSearch,
    required this.onClearSearch,
    required this.onFilterApplied,
    required this.onSortChanged,
    required this.currentSortMode,
    required this.activeSearchQuery,
    required this.compact,
  });

  @override
  State<NhomSearchBar> createState() => _NhomSearchBarState();
}

class _NhomSearchBarState extends State<NhomSearchBar> {
  bool _isSearching = false;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.activeSearchQuery);
    _isSearching = widget.activeSearchQuery.isNotEmpty;
  }

  // Luôn cập nhật controller nếu searchQuery thay đổi từ bên ngoài (ví dụ khi xóa chip search)
  @override
  void didUpdateWidget(covariant NhomSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activeSearchQuery != oldWidget.activeSearchQuery) {
      _searchController.text = widget.activeSearchQuery;
      if (widget.activeSearchQuery.isEmpty) _isSearching = false;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        widget.onClearSearch();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: _isSearching
                    ? TextField(
                        key: const ValueKey('searchTextField'),
                        controller: _searchController,
                        autofocus: true,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: context.textPrimary,
                            ),
                        onChanged: widget.onSearch,
                        decoration: InputDecoration(
                          hintText: 'Tìm nhóm...',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md, vertical: 8),
                          fillColor: context.surfaceHigh,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: AppRadius.pillRadius,
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(Icons.search_rounded,
                              size: 18, color: context.primary),
                        ),
                      )
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'DANH SÁCH NHÓM QUẢN LÝ',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: context.textPrimary,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.6,
                              ),
                        ),
                      ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            _HeaderAction(
              tooltip: _isSearching ? 'Đóng' : 'Tìm kiếm',
              icon: _isSearching ? Icons.close_rounded : Icons.search_rounded,
              onTap: _toggleSearch,
            ),
            const SizedBox(width: AppSpacing.xxs),
            _HeaderAction(
              tooltip: 'Lọc',
              icon: Icons.tune_rounded,
              onTap: () => _openFilterSheet(context),
            ),
            const SizedBox(width: AppSpacing.xxs),
            PopupMenuButton<String>(
              tooltip: 'Sắp xếp',
              color: context.surfaceHighest,
              elevation: 4,
              shadowColor: context.shadow,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
              onSelected: widget.onSortChanged,
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'none', child: Text('Mặc định')),
                PopupMenuItem(value: 'name', child: Text('Tên A-Z')),
                PopupMenuItem(value: 'members', child: Text('Nhiều nhân sự')),
                PopupMenuItem(value: 'pending', child: Text('Ưu tiên chờ duyệt')),
              ],
              child: _HeaderAction(
                tooltip: 'Sắp xếp',
                icon: widget.currentSortMode == 'none' 
                    ? Icons.sort_by_alpha_rounded 
                    : Icons.filter_list_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _openFilterSheet(BuildContext context) {
    FilterSheet.show(
      context: context,
      data: widget.nhomNhanVienList,
      filterFields: const [
        {'label': 'Công ty', 'field': 'companyName'},
        {'label': 'Tên nhóm', 'field': 'tenNhom'},
        {'label': 'Tài khoản', 'field': 'taiKhoan'},
      ],
      getFieldValue: (item, field) {
        switch (field) {
          case 'companyName': return item.companyName;
          case 'tenNhom': return item.tenNhom;
          case 'taiKhoan': return item.taiKhoan;
          default: return '';
        }
      },
      onApplyFilter: (filters) {
        // Logic lọc này đảm bảo chỉ những Key có data mới tham gia lọc
        final filtered = widget.nhomNhanVienList.where((nv) {
          return filters.entries.every((e) {
            if (e.value.isEmpty) return true; // Quan trọng: Nếu list rỗng thì bỏ qua tiêu chí này
            final value = switch (e.key) {
              'companyName' => nv.companyName,
              'tenNhom' => nv.tenNhom,
              'taiKhoan' => nv.taiKhoan,
              _ => '',
            };
            return e.value.contains(value);
          });
        }).toList();

        widget.onFilterApplied(filters, filtered);
        Navigator.pop(context);
      },
    );
  }
}

class _HeaderAction extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback? onTap;

  const _HeaderAction({required this.tooltip, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.pillRadius,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Icon(icon, color: context.primary, size: 22),
        ),
      ),
    );
  }
}