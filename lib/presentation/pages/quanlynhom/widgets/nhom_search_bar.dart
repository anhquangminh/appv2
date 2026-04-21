import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:ducanherp/data/models/nhomnhanvien_model.dart';
import 'package:ducanherp/presentation/widgets/dialog/filter_sheet.dart';

class NhomSearchBar extends StatelessWidget {
  final List<NhomNhanVienModel> nhomNhanVienList;

  final ValueChanged<String> onSearch;
  final VoidCallback onClearSearch;
  final VoidCallback onAdd;
  final Function(
    Map<String, List<String>> filters,
    List<NhomNhanVienModel> filteredList,
  )
  onFilterApplied;

  const NhomSearchBar({
    super.key,
    required this.nhomNhanVienList,
    required this.onSearch,
    required this.onClearSearch,
    required this.onFilterApplied,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// LEFT: TITLE
        Text(
          "Danh sách",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: context.textSecondary,
          ),
        ),

        /// PUSH RIGHT
        const Spacer(),

        /// RIGHT: ACTIONS
        Row(
          children: [
            /// FILTER
            InkWell(
              onTap: () {
                FilterSheet.show(
                  context: context,
                  data: nhomNhanVienList,
                  filterFields: const [
                    {'label': 'Công ty', 'field': 'companyName'},
                    {'label': 'Tên nhóm', 'field': 'tenNhom'},
                    {'label': 'Tài khoản', 'field': 'taiKhoan'},
                  ],
                  getFieldValue: (item, field) {
                    switch (field) {
                      case 'companyName':
                        return item.companyName ?? '';
                      case 'tenNhom':
                        return item.tenNhom;
                      case 'taiKhoan':
                        return item.taiKhoan;
                      default:
                        return '';
                    }
                  },
                  onApplyFilter: (filters) {
                    final filtered =
                        nhomNhanVienList.where((nv) {
                          return filters.entries.every((e) {
                            final value =
                                switch (e.key) {
                                  'companyName' => nv.companyName,
                                  'tenNhom' => nv.tenNhom,
                                  'taiKhoan' => nv.taiKhoan,
                                  _ => null,
                                } ??
                                '';
                            return e.value.isEmpty ||
                                e.value.contains(value);
                          });
                        }).toList();

                    onFilterApplied(filters, filtered);
                    Navigator.pop(context);
                  },
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.filter_alt_outlined,
                  size: 18, // 👉 nhỏ lại
                  color: context.textSecondary,
                ),
              ),
            ),

            const SizedBox(width: 8),

            /// ADD
            InkWell(
              onTap: onAdd,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.group_add_outlined,
                  size: 18, // 👉 nhỏ lại
                  color: context.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}