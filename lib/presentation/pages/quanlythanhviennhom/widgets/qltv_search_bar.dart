import 'package:ducanherp/data/models/quanlynhanvien_model.dart';
import 'package:flutter/material.dart';
import 'package:ducanherp/presentation/widgets/dialog/filter_sheet.dart';

class QLTVSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final List<QuanLyNhanVienModel> qlnvList;

  /// CALLBACKS
  final ValueChanged<String> onSearch;
  final VoidCallback onClearSearch;
  final VoidCallback onAdd;
  final Function(
    Map<String, List<String>> filters,
    List<QuanLyNhanVienModel> filteredList,
  )
  onFilterApplied;

  const QLTVSearchBar({
    super.key,
    required this.searchController,
    required this.qlnvList,
    required this.onSearch,
    required this.onClearSearch,
    required this.onFilterApplied,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 12, 12, 0),

      child: Row(
        children: [
          /// SEARCH
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: "Tìm kiếm...",
                  border: InputBorder.none,
                  isDense: true, // ⭐ giảm padding mặc định
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon:
                      searchController.text.isEmpty
                          ? null
                          : IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: onClearSearch,
                          ),
                ),
                onChanged: onSearch,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),

          const SizedBox(width: 5),

          /// FILTER
          InkWell(
            onTap: () {
              FilterSheet.show(
                context: context,
                data: qlnvList,
                filterFields: [
                  {'label': 'Công ty', 'field': 'companyName'},
                  {'label': 'Tên nhóm', 'field': 'tenNhom'},
                  {'label': 'Tên nhân viên', 'field': 'tenNhanVien'},
                  {'label': 'Tài khoản', 'field': 'taiKhoan'},
                ],
                getFieldValue: (item, field) {
                  switch (field) {
                    case 'companyName':
                      return item.companyName ?? '';
                    case 'tenNhom':
                      return item.tenNhom ?? '';
                    case 'tenNhanVien':
                      return item.tenNhanVien ?? '';
                    case 'taiKhoan':
                      return item.taiKhoan ?? '';
                    default:
                      return '';
                  }
                },
                onApplyFilter: (filters) {
                  final filtered =
                      qlnvList.where((nv) {
                        return filters.entries.every((e) {
                          final value =
                              switch (e.key) {
                                'companyName' => nv.companyName,
                                'tenNhom' => nv.tenNhom,
                                'taiKhoan' => nv.taiKhoan,
                                'tenNhanVien' => nv.tenNhanVien,
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

              radius: 20,
              child: Icon(
                Icons.filter_list,

              ),
            ),
          ),

          const SizedBox(width: 5),

          /// ADD
          InkWell(
            onTap: onAdd,
            child: CircleAvatar(

              radius: 20,
              child: Icon(
                Icons.group_add_outlined,

              ),
            ),
          ),
        ],
      ),
    );
  }
}
