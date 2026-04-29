import 'package:ducanherp/core/helpers/user_storage_helper.dart';
import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/core/utils/snackbar_utils.dart';
import 'package:ducanherp/data/models/application_user.dart';
import 'package:ducanherp/data/models/nhanvien_model.dart';
import 'package:ducanherp/logic/bloc/nhanvien/nhanvien_bloc.dart';
import 'package:ducanherp/logic/bloc/nhanvien/nhanvien_event.dart';
import 'package:ducanherp/logic/bloc/nhanvien/nhanvien_state.dart';
import 'package:ducanherp/presentation/pages/quanlynhanvien/dialogs/qlnv_dialog.dart';
import 'package:ducanherp/presentation/pages/quanlynhanvien/widgets/qlnv_filter_chip.dart';
import 'package:ducanherp/presentation/pages/quanlynhanvien/widgets/qlnv_list_view.dart';
import 'package:ducanherp/presentation/pages/quanlynhanvien/widgets/qlnv_page_header.dart';
import 'package:ducanherp/presentation/pages/quanlynhanvien/widgets/qlnv_searchbar.dart';
import 'package:ducanherp/presentation/pages/quanlynhanvien/widgets/qlnv_stats_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuanLyNhanVienPage extends StatefulWidget {
  const QuanLyNhanVienPage({super.key});

  @override
  State<QuanLyNhanVienPage> createState() => _QuanLyNhanVienPageState();
}

class _QuanLyNhanVienPageState extends State<QuanLyNhanVienPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  ApplicationUser? user;
  late NhanVienModel searchVM;
  List<NhanVienModel> nhanVienList = [];
  List<NhanVienModel> filteredList = [];
  Map<String, List<String>> filters = {};
  String searchQuery = '';
  bool hasActiveFilters = false;

  @override
  void initState() {
    super.initState();
    _initSearchVM();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadUserData());
  }

  void _initSearchVM() {
    searchVM = NhanVienModel(
      id: '',
      tenNhanVien: '',
      taiKhoan: '',
      companyId: '',
      companyName: '',
      groupId: '',
      departmentId: '',
      departmentName: '',
      chucVuId: '',
      chucVu: '',
      chuyenMonId: '',
      chuyenMon: '',
      ordinarily: 1,
      createAt: DateTime.now(),
      createBy: '',
      isActive: 1,
      approvalUserId: '',
      dateApproval: DateTime.now(),
      approvalDept: '',
      departmentOrder: 2,
      approvalOrder: 1,
      approvalId: '',
      lastApprovalId: '',
      isStatus: '',
    );
  }

  Future<void> _loadUserData() async {
    final cachedUser = await UserStorageHelper.getCachedUserInfo();
    if (cachedUser == null || !mounted) return;

    setState(() {
      user = cachedUser;
      searchVM.groupId = cachedUser.groupId;
    });
    _reloadNhanVien();
  }

  void _reloadNhanVien() {
    context.read<NhanVienBloc>().add(GetNhanVienByVM(searchVM));
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value.trim();
    });
  }

  void _onClearSearch() {
    setState(() {
      searchQuery = '';
    });
  }

  void _onFilterApplied(
    Map<String, List<String>> appliedFilters,
    List<NhanVienModel> source,
  ) {
    setState(() {
      filters = appliedFilters;
      filteredList = source;
      hasActiveFilters = appliedFilters.values.any(
        (values) => values.isNotEmpty,
      );
    });
  }

  void _clearFilters() {
    setState(() {
      filters.clear();
      hasActiveFilters = false;
      filteredList = nhanVienList;
    });
  }

  void _removeSingleFilter(String key) {
    setState(() {
      // ❌ bỏ key hoàn toàn thay vì set []
      filters.remove(key);

      // cập nhật trạng thái filter
      hasActiveFilters = filters.isNotEmpty;

      // apply lại filter từ source gốc
      _rebuildFilteredList();
    });
  }

  void _rebuildFilteredList() {
    if (filters.isEmpty) {
      filteredList = nhanVienList;
      return;
    }

    filteredList =
        nhanVienList.where((nv) {
          bool match = true;

          filters.forEach((key, values) {
            if (values.isEmpty) return;

            switch (key) {
              case 'department':
                match &= values.contains(nv.departmentId);
                break;

              case 'position':
                match &= values.contains(nv.chucVuId);
                break;

              case 'status':
                match &= values.contains(nv.isActive.toString());
                break;

              case 'company':
                match &= values.contains(nv.companyId);
                break;

              default:
                break;
            }
          });

          return match;
        }).toList();
  }

  void _openDialog({NhanVienModel? nv}) {
    if (user == null) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => BlocProvider.value(
            value: context.read<NhanVienBloc>(),
            child: QLNVDialog(user: user!, searchVM: searchVM, nv: nv),
          ),
    );
  }

  Future<bool?> _showConfirmDialog({
    required String title,
    required String message,
    String confirmLabel = 'Dong y',
    bool destructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: context.surfaceHighest,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.xlRadius),
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: context.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: context.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Huy'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                style:
                    destructive
                        ? FilledButton.styleFrom(backgroundColor: context.error)
                        : null,
                child: Text(confirmLabel),
              ),
            ],
          ),
    );
  }

  Future<void> _onDeleteNhanVien(NhanVienModel nv) async {
    if (user == null) return;
    final confirm = await _showConfirmDialog(
      title: 'Xac nhan xoa',
      message: 'Ban co chac muon xoa nhan vien "${nv.tenNhanVien}" khong?',
      confirmLabel: 'Xoa',
      destructive: true,
    );
    if (confirm == true && mounted) {
      context.read<NhanVienBloc>().add(DeleteNhanVien(nv.id, user!.userName));
    }
  }

  Future<void> _duyetNhanVien(NhanVienModel nv) async {
    if (user == null) return;
    final confirm = await _showConfirmDialog(
      title: 'Xac nhan duyet',
      message: 'Ban co chac muon duyet nhan vien "${nv.taiKhoan}" khong?',
    );
    if (confirm == true && mounted) {
      context.read<NhanVienBloc>().add(DuyetNhanVien(nv.id, user!.userName));
    }
  }

  Future<void> _huyDuyetNhanVien(NhanVienModel nv) async {
    if (user == null) return;
    final confirm = await _showConfirmDialog(
      title: 'Xac nhan huy duyet',
      message: 'Ban co chac muon huy duyet nhan vien "${nv.taiKhoan}" khong?',
    );
    if (confirm == true && mounted) {
      context.read<NhanVienBloc>().add(HuyDuyetNhanVien(nv.id, user!.userName));
    }
  }

  List<NhanVienModel> get _displayList {
    final source = hasActiveFilters ? filteredList : nhanVienList;
    final keyword = searchQuery.trim().toLowerCase();

    return source.where((nv) {
      if (nv.taiKhoan == user?.userName) return false;
      if (keyword.isEmpty) return true;

      return nv.tenNhanVien.toLowerCase().contains(keyword) ||
          nv.taiKhoan.toLowerCase().contains(keyword) ||
          nv.chucVu.toLowerCase().contains(keyword) ||
          nv.companyName.toLowerCase().contains(keyword) ||
          nv.departmentName.toLowerCase().contains(keyword);
    }).toList();
  }

  int get _departmentCount =>
      _displayList
          .map((item) => item.departmentId)
          .where((id) => id.isNotEmpty)
          .toSet()
          .length;

  int get _approvedCount =>
      _displayList.where((item) => item.isActive == 3).length;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocConsumer<NhanVienBloc, NhanVienState>(
      listener: (context, state) {
        if (state is NhanVienByVMLoaded) {
          setState(() {
            nhanVienList = state.nhanViens;
            if (!hasActiveFilters) {
              filteredList = state.nhanViens;
            }
          });
        } else if (state is NhanVienSuccess) {
          showSnack(context, state.message);
          _reloadNhanVien();
        } else if (state is NhanVienError) {
          showSnack(context, state.message, isError: true);
        }
      },
      builder: (context, state) {
        final isLoading = state is NhanVienLoading && nhanVienList.isEmpty;

        return Scaffold(
          backgroundColor: context.background,
          floatingActionButton: FloatingActionButton(
            onPressed: () => _openDialog(),
            backgroundColor: context.primary,
            child: Icon(Icons.add, color: context.onPrimary, size: 28),
          ),
          body: SafeArea(
            child: RefreshIndicator(
              color: context.primary,
              backgroundColor: context.surfaceHighest,
              onRefresh: () async => _reloadNhanVien(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  88,
                ),
                children: [
                  QLNVPageHeader(
                    onBack: () => Navigator.pop(context),
                    onAdd: () => _openDialog(),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  QLNVStatsSection(
                    totalEmployees: _displayList.length,
                    totalDepartments: _departmentCount,
                    approvedEmployees: _approvedCount,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  QLNVSearchBar(
                    nhanVienList: nhanVienList,
                    onSearch: _onSearchChanged,
                    onClearSearch: _onClearSearch,
                    onFilterApplied: _onFilterApplied,
                    activeSearchQuery: searchQuery,
                    title: 'DANH SÁCH NHÂN VIÊN',
                  ),
                  if (hasActiveFilters || searchQuery.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    QLNVFilterChips(
                      filters: filters,
                      searchQuery: searchQuery,
                      onRemoveFilter: _removeSingleFilter,
                      onClearAll: _clearFilters,
                      onClearSearch: _onClearSearch,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  QLNVListView(
                    filteredList: _displayList,
                    isLoading: isLoading,
                    onEdit: (nv) => _openDialog(nv: nv),
                    onDelete: _onDeleteNhanVien,
                    onAction: (nv, action) {
                      if (action == 'approve') {
                        _duyetNhanVien(nv);
                      } else if (action == 'unapprove') {
                        _huyDuyetNhanVien(nv);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
