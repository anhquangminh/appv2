import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/data/models/nhanvien_model.dart';
import 'package:ducanherp/presentation/widgets/dialog/filter_sheet.dart';
import 'package:flutter/material.dart';

class QLNVSearchBar extends StatefulWidget {
  final List<NhanVienModel> nhanVienList;
  final ValueChanged<String> onSearch;
  final VoidCallback onClearSearch;
  final Function(
    Map<String, List<String>> filters,
    List<NhanVienModel> filteredList,
  ) onFilterApplied;
  final String activeSearchQuery;
  final String title;

  const QLNVSearchBar({
    super.key,
    required this.nhanVienList,
    required this.onSearch,
    required this.onClearSearch,
    required this.onFilterApplied,
    required this.activeSearchQuery,
    this.title = 'DANH SÁCH NHÂN VIÊN',
  });

  @override
  State<QLNVSearchBar> createState() => _QLNVSearchBarState();
}

class _QLNVSearchBarState extends State<QLNVSearchBar> {
  bool _isSearching = false;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.activeSearchQuery);
    _isSearching = widget.activeSearchQuery.isNotEmpty;
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
                          hintText: 'Tìm nhân viên...',
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
                          widget.title.toUpperCase(),
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
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
          ],
        ),
      ],
    );
  }

  void _openFilterSheet(BuildContext context) {
    FilterSheet.show(
      context: context,
      data: widget.nhanVienList,
      filterFields: const [
        {'label': 'Công ty', 'field': 'companyName'},
        {'label': 'Bộ phận', 'field': 'departmentName'},
        {'label': 'Tài khoản', 'field': 'taiKhoan'},
        {'label': 'Tên nhân viên', 'field': 'tenNhanVien'},
      ],
      getFieldValue: (item, field) {
        switch (field) {
          case 'companyName': return item.companyName;
          case 'departmentName': return item.departmentName;
          case 'taiKhoan': return item.taiKhoan;
          case 'tenNhanVien': return item.tenNhanVien;
          default: return '';
        }
      },
      onApplyFilter: (filters) {
        final filtered = widget.nhanVienList.where((nv) {
          return filters.entries.every((e) {
            final value = switch (e.key) {
              'companyName' => nv.companyName,
              'departmentName' => nv.departmentName,
              'taiKhoan' => nv.taiKhoan,
              'tenNhanVien' => nv.tenNhanVien,
              _ => '',
            };
            return e.value.isEmpty || e.value.contains(value);
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