import 'package:ducanherp/core/helpers/user_storage_helper.dart';
import 'package:ducanherp/data/models/application_user.dart';
import 'package:ducanherp/presentation/pages/quanlynhanvien/dialogs/qlnv_dialog.dart';
import 'package:ducanherp/presentation/pages/quanlynhanvien/widgets/qlnv_filter_chip.dart';
import 'package:ducanherp/presentation/pages/quanlynhanvien/widgets/qlnv_list_view.dart';
import 'package:ducanherp/presentation/pages/quanlynhanvien/widgets/qlnv_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/bloc/nhanvien/nhanvien_bloc.dart';
import '../../../logic/bloc/nhanvien/nhanvien_event.dart';
import '../../../logic/bloc/nhanvien/nhanvien_state.dart';
import '../../../data/models/nhanvien_model.dart';

class QuanLyNhanVienPage extends StatefulWidget {
  const QuanLyNhanVienPage({super.key});

  @override
  State<QuanLyNhanVienPage> createState() => _QuanLyNhanVienPageState();
}

class _QuanLyNhanVienPageState extends State<QuanLyNhanVienPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final TextEditingController _tenController = TextEditingController();
  ApplicationUser? user;
  late NhanVienModel searchVM;
  bool loadChiNhanh = false;

  final TextEditingController searchController = TextEditingController();

  List<NhanVienModel> nhomNhanVienList = [];
  List<NhanVienModel> filteredList = [];

  /// filter dạng CHIP
  Map<String, List<String>> filters = {};
  Map<String, List<String>> currentFilters = {};

  @override
  void initState() {
    super.initState();
    searchVM = NhanVienModel(
      id: '',
      tenNhanVien: '',
      taiKhoan: '',
      companyId: '',
      companyName: '',
      groupId: user?.groupId ?? '',
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
    WidgetsBinding.instance.addPostFrameCallback((_) => loadUserData());
  }

  Future<void> loadUserData() async {
    final cachedUser = await UserStorageHelper.getCachedUserInfo();
    if (cachedUser != null && mounted) {
      setState(() {
        user = cachedUser;
        searchVM.groupId = user!.groupId;
      });
      // ignore: use_build_context_synchronously
      context.read<NhanVienBloc>().add(GetNhanVienByVM(searchVM));
    }
  }

  @override
  void dispose() {
    _tenController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    final keyword = value.trim().toLowerCase();

    if (keyword.isEmpty) {
      setState(() {
        filteredList = [];
      });
      return;
    }

    setState(() {
      filteredList =
          nhomNhanVienList.where((nv) {
            final taiKhoan = nv.taiKhoan.toLowerCase();
            final tenNhanVien = nv.tenNhanVien.toLowerCase();

            return taiKhoan.contains(keyword) || tenNhanVien.contains(keyword);
          }).toList();
    });
  }

  void _onClearSearch() {
    searchController.clear();
    _onSearchChanged('');
  }

  void _onFilterApplied(
    Map<String, List<String>> appliedFilters,
    List<NhanVienModel> source,
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
            value: context.read<NhanVienBloc>(),
            child: QLNVDialog(user: user!, searchVM: searchVM),
          ),
    );
  }

  void _openEditDialog(NhanVienModel nv) {
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

  void _onDeleteNhanVien(NhanVienModel nv) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Xác nhận xóa'),
            content: Text(
              'Bạn có chắc muốn xóa nhân viên "${nv.tenNhanVien}" không?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // Đóng dialog
                child: Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  context.read<NhanVienBloc>().add(
                    DeleteNhanVien(nv.id, user!.userName),
                  );
                  Navigator.pop(context); // Đóng dialog sau khi xóa
                },
                child: Text('Xóa', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  void _duyet(NhanVienModel nv) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Xác nhận duyệt'),
            content: Text(
              'Bạn có chắc muốn duyệt nhóm "${nv.taiKhoan}" không?',
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
      context.read<NhanVienBloc>().add(DuyetNhanVien(nv.id, user!.userName));
      // ignore: use_build_context_synchronously
      context.read<NhanVienBloc>().add(GetNhanVienByVM(searchVM));
    }
  }

  void _huyDuyet(NhanVienModel nv) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Xác nhận hủy duyệt'),
            content: Text(
              'Bạn có chắc muốn hủy duyệt nhóm "${nv.taiKhoan}" không?',
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
      context.read<NhanVienBloc>().add(HuyDuyetNhanVien(nv.id, user!.userName));
      // ignore: use_build_context_synchronously
      context.read<NhanVienBloc>().add(GetNhanVienByVM(searchVM));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final nhanVienList =
        (context.watch<NhanVienBloc>().state is NhanVienByVMLoaded)
            ? (context.watch<NhanVienBloc>().state as NhanVienByVMLoaded)
                .nhanViens
            : <NhanVienModel>[];
    nhomNhanVienList = nhanVienList;

    return BlocListener<NhanVienBloc, NhanVienState>(
      listener: (context, state) {
        if (state is NhanVienSuccess) {
          final msg = state.message;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(msg)));
          // Reload list after successful operation
          context.read<NhanVienBloc>().add(GetNhanVienByVM(searchVM));
        } else if (state is NhanVienError) {
          final err = state.message;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Lỗi: $err')));
        }
      },
      child: Column(
        children: [
          /// SEARCH + FILTER + ADD
          QLNVSearchBar(
            searchController: searchController,
            nhanVienList: nhanVienList,
            onSearch: _onSearchChanged,
            onClearSearch: _onClearSearch,
            onFilterApplied: _onFilterApplied,
            onAdd: _openAddDialog,
          ),

          /// CHIP HIỂN THỊ FILTER
          QLNVFilterChips(
            filters: filters,
            onClear: () {
              setState(() {
                filters.clear();
                filteredList = nhomNhanVienList;
              });
            },
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: QLNVListView(
                filteredList: filteredList,
                currentUser: user?.userName,
                onRefresh: () {
                  context.read<NhanVienBloc>().add(GetNhanVienByVM(searchVM));
                },
                onEdit: _openEditDialog,
                onDelete: _onDeleteNhanVien,
                onAction: (nv, action) {
                  if (action == 'approve') {
                    _duyet(nv);
                  } else if (action == 'unapprove') {
                    _huyDuyet(nv);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
