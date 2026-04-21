import 'package:ducanherp/core/helpers/user_storage_helper.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/core/utils/snackbar_utils.dart';
import 'package:ducanherp/presentation/pages/quanlynhom/dialogs/nhom_nhan_vien_dialog.dart';
import 'package:ducanherp/presentation/widgets/dialog/filter_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ducanherp/data/models/application_user.dart';
import 'package:ducanherp/data/models/nhomnhanvien_model.dart';
import 'package:ducanherp/logic/bloc/nhomnhanvien/nhomnhanvien_bloc.dart';

import 'widgets/nhom_search_bar.dart';
import 'widgets/nhom_filter_chips.dart';
import 'widgets/nhom_list_view.dart';

class QuanLyNhomPage extends StatefulWidget {
  const QuanLyNhomPage({super.key});

  @override
  State<QuanLyNhomPage> createState() => _QuanLyNhomPageState();
}

class _QuanLyNhomPageState extends State<QuanLyNhomPage> {
  ApplicationUser? user;
  final TextEditingController searchController = TextEditingController();

  List<NhomNhanVienModel> nhomNhanVienList = [];
  List<NhomNhanVienModel> filteredList = [];

  /// filter dạng CHIP
  Map<String, List<String>> filters = {};

  late NhomNhanVienModel searchVM;

  @override
  void initState() {
    super.initState();
    searchVM = NhomNhanVienModel(
      id: '',
      idQuanLy: '',
      tenNhanVien: '',
      tenNhom: '',
      iconName: '',
      taiKhoan: '',
      total: 0,
      groupId: '',
      companyId: '',
      companyName: '',
      createAt: DateTime.now(),
      createBy: '',
      isActive: 1,
      pageNumber: 1,
      pageSize: 20,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => loadUserData());
  }

  Future<void> loadUserData() async {
    final cachedUser = await UserStorageHelper.getCachedUserInfo();
    if (cachedUser != null && mounted) {
      setState(() {
        user = cachedUser;
        searchVM.groupId = user!.groupId;
      });
      context.read<NhomNhanVienBloc>().add(GetNhomNhanVienByVM(searchVM));
    }
  }

  void _onSearchChanged(String value) {
    searchVM = NhomNhanVienModel(
      id: '',
      idQuanLy: '',
      tenNhanVien: '',
      tenNhom: value,
      iconName: '',
      taiKhoan: '',
      total: 0,
      groupId: user!.groupId,
      companyId: '',
      companyName: '',
      createAt: DateTime.now(),
      createBy: '',
      isActive: 1,
      pageNumber: 1,
      pageSize: 20,
    );

    context.read<NhomNhanVienBloc>().add(GetNhomNhanVienByVM(searchVM));
  }

  void _onClearSearch() {
    searchController.clear();
    _onSearchChanged('');
  }

  void _onFilterApplied(
    Map<String, List<String>> appliedFilters,
    List<NhomNhanVienModel> source,
  ) {
    setState(() {
      filters = appliedFilters;
      filteredList = source;
    });
  }

  void _openAddDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => BlocProvider.value(
            value: context.read<NhomNhanVienBloc>(),
            child: NhomNhanVienDialog(user: user!, searchVM: searchVM),
          ),
    );
  }

  void _openEditDialog(NhomNhanVienModel nhom) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => BlocProvider.value(
            value: context.read<NhomNhanVienBloc>(),
            child: NhomNhanVienDialog(
              user: user!,
              searchVM: searchVM,
              nnv: nhom,
            ),
          ),
    );
  }

  void _deleteNhom(NhomNhanVienModel nhom) {
    context.read<NhomNhanVienBloc>().add(
      DeleteNhomNhanVien(nhom.id, user!.userName),
    );
  }

  void _duyetNhom(NhomNhanVienModel nhom) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Xác nhận duyệt'),
            content: Text(
              'Bạn có chắc muốn duyệt nhóm "${nhom.tenNhom}" không?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Đồng ý'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      // ignore: use_build_context_synchronously
      context.read<NhomNhanVienBloc>().add(
        DuyetNhomNhanVien(nhom.id, user!.userName),
      );
    }
  }

  void _huyDuyetNhom(NhomNhanVienModel nhom) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Xác nhận hủy duyệt'),
            content: Text(
              'Bạn có chắc muốn hủy duyệt nhóm "${nhom.tenNhom}" không?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Đồng ý'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      // ignore: use_build_context_synchronously
      context.read<NhomNhanVienBloc>().add(
        HuyDuyetNhomNhanVien(nhom.id, user!.userName),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: context.border.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tổng nhân sự",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: context.textSecondary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: context.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.badge, color: context.success),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // TOTAL
                    Row(
                      children: [
                        Text(
                          "124",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: context.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: context.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "+4 tháng này",
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: context.success,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // 🔥 SUB STATS (NHÓM + QUẢN LÝ NHÂN VIÊN)
                    Row(
                      children: [
                        Expanded(
                          child: _miniStat(
                            context,
                            icon: Icons.groups,
                            title: "Nhóm",
                            value: "12",
                            color: context.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _miniStat(
                            context,
                            icon: Icons.manage_accounts,
                            title: "QL Nhân viên",
                            value: "08",
                            color: context.info,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // SEARCH + FILTER + ADD
              NhomSearchBar(
                nhomNhanVienList: nhomNhanVienList,
                onSearch: _onSearchChanged,
                onClearSearch: _onClearSearch,
                onFilterApplied: _onFilterApplied,
                onAdd: _openAddDialog,
              ),
              // Icon(Icons.filter_alt_outlined, color: context.textSecondary),
              // CHIP HIỂN THỊ FILTER
              NhomFilterChips(
                filters: filters,
                onClear: () {
                  setState(() {
                    filters.clear();
                    filteredList = nhomNhanVienList;
                  });
                },
              ),

              const SizedBox(height: 10),
              Expanded(
                child: BlocListener<NhomNhanVienBloc, NhomNhanVienState>(
                  listener: (context, state) {
                    if (state is NhomNhanVienVMLoaded) {
                      setState(() {
                        nhomNhanVienList = state.nhomNhanViens;
                        filteredList = state.nhomNhanViens;
                      });
                    }
                    if (state is NhomNhanVienError) {
                      showSnack(context, state.message, isError: true);

                      // ignore: use_build_context_synchronously
                      context.read<NhomNhanVienBloc>().add(
                        GetNhomNhanVienByVM(searchVM),
                      );
                    }
                    if (state is NhomNhanVienSuccess) {
                      showSnack(context, state.message);

                      // ignore: use_build_context_synchronously
                      context.read<NhomNhanVienBloc>().add(
                        GetNhomNhanVienByVM(searchVM),
                      );
                    }
                  },
                  child: NhomListView(
                    filteredList: filteredList,
                    searchVM: searchVM,
                    onOpen: _openEditDialog,
                    onEdit: _openEditDialog,
                    onDelete: _deleteNhom,
                    onAction: (nhom, action) {
                      switch (action) {
                        // ignore: constant_pattern_never_matches_value_type
                        case 'approve':
                          _duyetNhom(nhom);
                          break;
                        // ignore: constant_pattern_never_matches_value_type
                        case 'unapprove':
                          _huyDuyetNhom(nhom);
                          break;
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniStat(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: context.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.border.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: context.textSecondary,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
