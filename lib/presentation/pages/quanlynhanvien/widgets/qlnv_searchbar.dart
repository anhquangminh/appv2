import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/data/models/nhanvien_model.dart';
import 'package:flutter/material.dart';
import 'package:ducanherp/presentation/widgets/dialog/filter_sheet.dart';

class QLNVSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final List<NhanVienModel> nhanVienList;

  /// CALLBACKS
  final ValueChanged<String> onSearch;
  final VoidCallback onClearSearch;
  final VoidCallback onAdd;
  final Function(
    Map<String, List<String>> filters,
    List<NhanVienModel> filteredList,
  )
  onFilterApplied;

  const QLNVSearchBar({
    super.key,
    required this.searchController,
    required this.nhanVienList,
    required this.onSearch,
    required this.onClearSearch,
    required this.onFilterApplied,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      child: Row(
        children: [
          /// SEARCH
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: context.surface,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: context.opacity(Colors.black, 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: context.border),
              ),
              child: TextField(
                controller: searchController,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: "Tìm kiếm...",
                  hintStyle: TextStyle(color: context.textSecondary),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  prefixIcon: Icon(
                    Icons.search,
                    color: context.textSecondary,
                  ),
                  suffixIcon: searchController.text.isEmpty
                      ? null
                      : IconButton(
                          icon: Icon(
                            Icons.close,
                            color: context.textSecondary,
                          ),
                          onPressed: onClearSearch,
                        ),
                ),
                onChanged: onSearch,
                style: TextStyle(
                  color: context.textPrimary,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          const SizedBox(width: 6),

          /// FILTER
          InkWell(
            onTap: () {
              FilterSheet.show(
                context: context,
                data: nhanVienList,
                filterFields: const [
                  {'label': 'Công ty', 'field': 'companyName'},
                  {'label': 'Bộ phận', 'field': 'departmentName'},
                  {'label': 'Tài khoản', 'field': 'taiKhoan'},
                  {'label': 'Tên nhân viên', 'field': 'tenNhanVien'},
                ],
                getFieldValue: (item, field) {
                  switch (field) {
                    case 'companyName':
                      return item.companyName ?? '';
                    case 'departmentName':
                      return item.departmentName ?? '';
                    case 'taiKhoan':
                      return item.taiKhoan;
                    case 'tenNhanVien':
                      return item.tenNhanVien;
                    default:
                      return '';
                  }
                },
                onApplyFilter: (filters) {
                  final filtered = nhanVienList.where((nv) {
                    return filters.entries.every((e) {
                      final value = switch (e.key) {
                            'companyName' => nv.companyName,
                            'departmentName' => nv.departmentName,
                            'tenNhanVien' => nv.tenNhanVien,
                            'taiKhoan' => nv.taiKhoan,
                            _ => null,
                          } ??
                          '';
                      return e.value.isEmpty || e.value.contains(value);
                    });
                  }).toList();

                  onFilterApplied(filters, filtered);
                  Navigator.pop(context);
                },
              );
            },
            child: CircleAvatar(
              backgroundColor: context.surface,
              radius: 20,
              child: Icon(
                Icons.filter_list,
                color: context.textPrimary,
              ),
            ),
          ),

          const SizedBox(width: 6),

          /// ADD
          InkWell(
            onTap: onAdd,
            child: CircleAvatar(
              backgroundColor: context.primary,
              radius: 20,
              child: Icon(
                Icons.group_add_outlined,
                color: context.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}