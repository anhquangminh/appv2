import 'package:ducanherp/core/utils/snackbar_utils.dart';
import 'package:ducanherp/logic/bloc/quanlynhanvien/quanlynhanvien_bloc.dart';
import 'package:ducanherp/core/helpers/user_storage_helper.dart';
import 'package:ducanherp/data/models/application_user.dart';
import 'package:ducanherp/data/models/quanlynhanvien_model.dart';
import 'package:ducanherp/presentation/pages/quanlythanhviennhom/dialogs/qltv_add_dialog.dart';
import 'package:ducanherp/presentation/pages/quanlythanhviennhom/widgets/qltv_filter_chips.dart';
import 'package:ducanherp/presentation/pages/quanlythanhviennhom/widgets/qltv_list_view.dart';
import 'package:ducanherp/presentation/pages/quanlythanhviennhom/widgets/qltv_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuanLyThanhVienNhomPage extends StatefulWidget {
  const QuanLyThanhVienNhomPage({super.key});

  @override
  State<QuanLyThanhVienNhomPage> createState() =>
      _QuanLyThanhVienNhomPageState();
}

class _QuanLyThanhVienNhomPageState extends State<QuanLyThanhVienNhomPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  ApplicationUser? user;
  final TextEditingController searchController = TextEditingController();
  late QuanLyNhanVienModel searchVM;
  List<QuanLyNhanVienModel> qlnvVienList = [];

  List<QuanLyNhanVienModel> filteredList = [];

  /// filter dạng CHIP
  Map<String, List<String>> filters = {};

  @override
  void initState() {
    super.initState();
    searchVM = QuanLyNhanVienModel(
      id: '',
      idNhomNhanVien: '',
      tenNhanVien: '',
      tenNhom: '',
      taiKhoan: '',
      groupId: '',
      companyId: '',
      companyName: '',
      createAt: DateTime.now(),
      createBy: '',
      isActive: -1,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadUserData());
  }

  Future<void> _loadUserData() async {
    final cachedUser = await UserStorageHelper.getCachedUserInfo();
    if (cachedUser != null && mounted) {
      setState(() {
        user = cachedUser;
        searchVM.groupId = user!.groupId;
      });
      context.read<QuanLyNhanVienBloc>().add(GetQuanLyNhanVienByVM(searchVM));
    }
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
          qlnvVienList.where((nv) {
            final taiKhoan = nv.taiKhoan.toLowerCase();
            final tenNhanVien = nv.tenNhanVien.toLowerCase();
            final tenNhom = nv.tenNhom.toLowerCase();

            return taiKhoan.contains(keyword) ||
                tenNhanVien.contains(keyword) ||
                tenNhom.contains(keyword);
          }).toList();
    });
  }

  void _onClearSearch() {
    searchController.clear();
    _onSearchChanged('');
  }

  void _onFilterApplied(
    Map<String, List<String>> appliedFilters,
    List<QuanLyNhanVienModel> source,
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
            value: context.read<QuanLyNhanVienBloc>(),
            child: QLTVDialog(user: user!, searchVM: searchVM),
          ),
    );
  }

  void _openEditDialog(QuanLyNhanVienModel qlnv) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => BlocProvider.value(
            value: context.read<QuanLyNhanVienBloc>(),
            child: QLTVDialog(user: user!, searchVM: searchVM, qlnv: qlnv),
          ),
    );
  }

  void _onDeleteNhanVien(QuanLyNhanVienModel nhanVien) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: Text(
              'Bạn có chắc muốn xóa nhân viên "${nhanVien.tenNhanVien}" khỏi nhóm không?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  context.read<QuanLyNhanVienBloc>().add(
                    DeleteQuanLyNhanVien(nhanVien.id, user!.userName),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Xóa', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  void _duyetNhom(QuanLyNhanVienModel qltv) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Xác nhận duyệt'),
            content: Text(
              'Bạn có chắc muốn duyệt nhóm "${qltv.tenNhanVien}" khỏi nhóm không?',
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
      context.read<QuanLyNhanVienBloc>().add(
        DuyetQuanLyNhanVien(qltv.id, user!.userName),
      );
    }
  }

  void _huyDuyetNhom(QuanLyNhanVienModel qltv) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Xác nhận hủy duyệt'),
            content: Text(
              'Bạn có chắc muốn hủy duyệt "${qltv.tenNhanVien}" khỏi nhóm không?',
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
      context.read<QuanLyNhanVienBloc>().add(
        HuyDuyetQuanLyNhanVien(qltv.id, user!.userName),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
   
      appBar: AppBar(
        centerTitle: true,
        elevation: 4,

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,),
          onPressed: () => Navigator.pop(context, true),
        ),
        title: Text(
          'Quản lý thành viên nhóm',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
       
          ),
        ),
      ),
      body: Column(
        children: [
          QLTVSearchBar(
            searchController: searchController,
            qlnvList: qlnvVienList,
            onSearch: _onSearchChanged,
            onClearSearch: _onClearSearch,
            onFilterApplied: _onFilterApplied,
            onAdd: _openAddDialog,
          ),

          /// CHIP HIỂN THỊ FILTER
          QLTVFilterChips(
            filters: filters,
            onClear: () {
              setState(() {
                filters.clear();
                filteredList = qlnvVienList;
              });
            },
          ),

          /// LIST
          Expanded(
            child: BlocListener<QuanLyNhanVienBloc, QuanLyNhanVienState>(
              listener: (context, state) {
                if (state is QuanLyNhanVienVMLoaded) {
                  setState(() {
                    qlnvVienList = state.quanLyNhanViens;
                    filteredList = qlnvVienList;
                  });
                }
                if (state is QuanLyNhanVienError) {
                  context.read<QuanLyNhanVienBloc>().add(
                    GetQuanLyNhanVienByVM(searchVM),
                  );
                  showSnack(context, state.message, isError: true);
                }
                if (state is QuanLyNhanVienSuccess) {
                  context.read<QuanLyNhanVienBloc>().add(
                    GetQuanLyNhanVienByVM(searchVM),
                  );
                  showSnack(context, state.message);
                }
              },
              child: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: QLTVListView(
                  filteredList: filteredList,
                  searchVM: searchVM,
                  onOpen: _openEditDialog,
                  onDelete: _onDeleteNhanVien,
                  onAction: (ltv, action) {
                    switch (action) {
                      // ignore: constant_pattern_never_matches_value_type
                      case 'approve':
                        _duyetNhom(ltv);
                        break;
                      // ignore: constant_pattern_never_matches_value_type
                      case 'unapprove':
                        _huyDuyetNhom(ltv);
                        break;
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
