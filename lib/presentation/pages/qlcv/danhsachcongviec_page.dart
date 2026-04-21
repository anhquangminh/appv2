import 'package:ducanherp/core/navigation/route_observer.dart';
import 'package:ducanherp/core/themes/app_shadows.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_text_styles.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/presentation/pages/qlcv/calender_page.dart';
import 'package:ducanherp/presentation/widgets/shimmer/list_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ducanherp/core/helpers/user_storage_helper.dart';
import 'package:ducanherp/data/models/application_user.dart';
import 'package:ducanherp/data/models/congviec_model.dart';
import 'package:ducanherp/logic/bloc/congviec/congviec_bloc.dart';
import 'package:ducanherp/logic/bloc/congviec/congviec_event.dart';
import 'package:ducanherp/logic/bloc/congviec/congviec_state.dart';
import 'package:ducanherp/presentation/pages/qlcv/widgets/job/job_item.dart';

class DanhSachCongViecPage extends StatefulWidget {
  final CongViecModel? congViecModel;

  const DanhSachCongViecPage({super.key, this.congViecModel});

  @override
  State<DanhSachCongViecPage> createState() => _DanhSachCongViecPageState();
}

class _DanhSachCongViecPageState extends State<DanhSachCongViecPage>
    with RouteAware {
  ApplicationUser? user;
  final Map<String, List<CongViecModel>> _cachedJobsByKey = {};
  String? _selectedTenNhom;
  String? _selectedMucDoUuTien;
  String? _selectedLapLai;

  String? _sortField;
  bool _sortAsc = true;

  final TextEditingController _searchController = TextEditingController();
  String get _searchText => _searchController.text.trim().toLowerCase();

  String _cacheKey(ApplicationUser user) => '${user.userName}_${user.groupId}';

  List<CongViecModel> get _currentCachedJobs {
    if (user == null) return [];
    return _cachedJobsByKey[_cacheKey(user!)] ?? [];
  }

  List<String> _getUniqueTenNhom(List<CongViecModel> jobs) =>
      jobs.map((e) => e.tenNhom).toSet().toList();

  List<String> _getUniqueMucDoUuTien(List<CongViecModel> jobs) =>
      jobs.map((e) => e.mucDoUuTien).toSet().toList();

  List<String> _getUniqueLapLai(List<CongViecModel> jobs) =>
      jobs.map((e) => e.lapLai).toSet().toList();

  @override
  void initState() {
    super.initState();
    _loadUser();
    if (widget.congViecModel != null) {
      final model = widget.congViecModel!;

      if (model.tenNhom.isNotEmpty) _selectedTenNhom = model.tenNhom;
      if (model.mucDoUuTien.isNotEmpty) {
        _selectedMucDoUuTien = model.mucDoUuTien;
      }
      if (model.lapLai.isNotEmpty) _selectedLapLai = model.lapLai;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _reloadCongViec();
    super.didPopNext();
  }

  void _reloadCongViec() {
    if (user == null) return;

    context.read<CongViecBloc>().add(
      EventGetCongViecByVM(widget.congViecModel ?? _buildDefaultModel(user!)),
    );
  }

  Future<void> _loadUser() async {
    final cachedUser = await UserStorageHelper.getCachedUserInfo();
    if (!mounted || cachedUser == null) return;

    setState(() => user = cachedUser);

    context.read<CongViecBloc>().add(
      EventGetCongViecByVM(
        widget.congViecModel ?? _buildDefaultModel(cachedUser),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    _reloadCongViec();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surface,
      body: Column(
        children: [
          _buildSearchBar(context),
          _buildActiveFilters(),
          Expanded(
            child: BlocBuilder<CongViecBloc, CongViecState>(
              builder: (context, state) {
                if (state is StateCongViecLoading) {
                  return ListShimmer(key: ValueKey('loading'));
                }

                if (state is StateCongViecByVMLoaded) {
                  if (user != null) {
                    _cachedJobsByKey[_cacheKey(user!)] = List.from(
                      state.congViecs,
                    );
                  }
                  final filteredJobs = _getFilteredJobs(state.congViecs);
                  if (filteredJobs.isNotEmpty) {
                    return RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        itemCount: filteredJobs.length,
                        itemBuilder:
                            (_, i) => JobItem(congViecModel: filteredJobs[i]),
                      ),
                    );
                  } else {
                    return const Center(child: Text('No data'));
                  }
                }

                if (state is StateCongViecError) {
                  return Center(child: Text(state.message));
                }

                return const Center(child: Text('No data'));
              },
            ),
          ),
        ],
      ),
    );
  }

  List<CongViecModel> _getFilteredJobs(List<CongViecModel> jobs) {
    final searchText = _searchText;
    var filtered =
        jobs.where((job) {
          final matchTenNhom =
              _selectedTenNhom == null ||
              _selectedTenNhom!.isEmpty ||
              job.tenNhom == _selectedTenNhom;
          final matchMucDoUuTien =
              _selectedMucDoUuTien == null ||
              _selectedMucDoUuTien!.isEmpty ||
              job.mucDoUuTien == _selectedMucDoUuTien;
          final matchLapLai =
              _selectedLapLai == null ||
              _selectedLapLai!.isEmpty ||
              job.lapLai == _selectedLapLai;
          final matchSearch =
              searchText.isEmpty ||
              job.tenCongViec.toLowerCase().contains(searchText) ||
              job.noiDungCongViec.toLowerCase().contains(searchText);
          return matchTenNhom && matchMucDoUuTien && matchLapLai && matchSearch;
        }).toList();

    // Sắp xếp
    if (_sortField != null) {
      switch (_sortField) {
        case "createAt":
          filtered.sort(
            (a, b) =>
                _sortAsc
                    ? a.createAt.compareTo(b.createAt)
                    : b.createAt.compareTo(a.createAt),
          );
          break;
        case "ngayBatDau":
          filtered.sort(
            (a, b) =>
                _sortAsc
                    ? a.ngayBatDau.compareTo(b.ngayBatDau)
                    : b.ngayBatDau.compareTo(a.ngayBatDau),
          );
          break;
        case "ngayKetThuc":
          filtered.sort(
            (a, b) =>
                _sortAsc
                    ? a.ngayKetThuc.compareTo(b.ngayKetThuc)
                    : b.ngayKetThuc.compareTo(a.ngayKetThuc),
          );
          break;
      }
    }
    return filtered;
  }

  Widget _buildSearchBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 6, 6, 6),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
              color: context.textPrimary,
            ),
            Expanded(
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: context.surface,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: AppShadows.soft,
                  border: Border.all(color: context.border),
                ),
                child: TextField(
                  controller: _searchController,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: "Tìm kiếm...",
                    hintStyle: TextStyle(
                      color: context.textSecondary,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    suffixIcon:
                        _searchController.text.isEmpty
                            ? Icon(Icons.search, color: context.textSecondary)
                            : IconButton(
                              icon: Icon(
                                Icons.close,
                                color: context.textSecondary,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            ),
                  ),
                  style: TextStyle(color: context.textPrimary, fontSize: 14),
                  onChanged: (text) {
                    setState(() {});
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: () {
                final jobs =
                    context.read<CongViecBloc>().state
                            is StateCongViecByVMLoaded
                        ? (context.read<CongViecBloc>().state
                                as StateCongViecByVMLoaded)
                            .congViecs
                        : <CongViecModel>[];
                _showFilterSheet(jobs);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: context.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.border),
                ),
                child: Icon(Icons.filter_list, color: context.textPrimary),
              ),
            ),
            const SizedBox(width: 5),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (_) => CalendarPage(congViecModels: _currentCachedJobs),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: context.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.border),
                ),
                child: Icon(Icons.calendar_month, color: context.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet(List<CongViecModel> jobs) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Header với tiêu đề & nút đóng
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Lọc dữ liệu',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E5)),
              // Sắp xếp theo trường nào
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _sortField ?? "",
                      items: [
                        DropdownMenuItem(
                          value: "",
                          child: Text("Không sắp xếp"),
                        ),
                        DropdownMenuItem(
                          value: "createAt",
                          child: Text("Ngày tạo"),
                        ),
                        DropdownMenuItem(
                          value: "ngayBatDau",
                          child: Text("Ngày bắt đầu"),
                        ),
                        DropdownMenuItem(
                          value: "ngayKetThuc",
                          child: Text("Ngày kết thúc"),
                        ),
                      ],
                      onChanged:
                          (val) => setState(
                            () => _sortField = val!.isEmpty ? null : val,
                          ),
                      decoration: InputDecoration(labelText: "Sắp xếp theo"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: Icon(
                      _sortAsc ? Icons.arrow_downward : Icons.arrow_upward,
                    ),
                    tooltip: _sortAsc ? "Tăng dần" : "Giảm dần",
                    onPressed: () {
                      setState(() {
                        _sortAsc = !_sortAsc;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedTenNhom,
                items: [
                  DropdownMenuItem(value: '', child: Text('Tất cả nhóm')),
                  ..._getUniqueTenNhom(jobs).map(
                    (nhom) => DropdownMenuItem(value: nhom, child: Text(nhom)),
                  ),
                ],
                onChanged: (val) => setState(() => _selectedTenNhom = val),
                decoration: InputDecoration(labelText: 'Nhóm công việc'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedMucDoUuTien,
                items: [
                  DropdownMenuItem(value: '', child: Text('Tất cả ưu tiên')),
                  ..._getUniqueMucDoUuTien(
                    jobs,
                  ).map((e) => DropdownMenuItem(value: e, child: Text(e))),
                ],
                onChanged: (val) => setState(() => _selectedMucDoUuTien = val),
                decoration: InputDecoration(labelText: 'Mức độ ưu tiên'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedLapLai,
                items: [
                  DropdownMenuItem(value: '', child: Text('Tất cả lặp lại')),
                  ..._getUniqueLapLai(
                    jobs,
                  ).map((e) => DropdownMenuItem(value: e, child: Text(e))),
                ],
                onChanged: (val) => setState(() => _selectedLapLai = val),
                decoration: InputDecoration(labelText: 'Kiểu lặp lại'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedTenNhom = '';
                          _selectedMucDoUuTien = '';
                          _selectedLapLai = '';
                          _sortField = null;
                          _sortAsc = true;
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black,
                      ),
                      child: Text('Xoá lọc'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Áp dụng lọc'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActiveFilters() {
    List<Widget> chips = [];

    if (_selectedTenNhom != null && _selectedTenNhom!.isNotEmpty) {
      chips.add(
        _buildFilterChip(
          label: _selectedTenNhom!,
          onClear: () => setState(() => _selectedTenNhom = ''),
        ),
      );
    }

    if (_selectedMucDoUuTien != null && _selectedMucDoUuTien!.isNotEmpty) {
      chips.add(
        _buildFilterChip(
          label: _selectedMucDoUuTien!,
          onClear: () => setState(() => _selectedMucDoUuTien = ''),
        ),
      );
    }

    if (_selectedLapLai != null && _selectedLapLai!.isNotEmpty) {
      chips.add(
        _buildFilterChip(
          label: _selectedLapLai!,
          onClear: () => setState(() => _selectedLapLai = ''),
        ),
      );
    }

    if (_sortField != null && _sortField!.isNotEmpty) {
      String sortLabel = '';
      switch (_sortField) {
        case 'createAt':
          sortLabel = 'Ngày tạo';
          break;
        case 'ngayBatDau':
          sortLabel = 'Ngày bắt đầu';
          break;
        case 'ngayKetThuc':
          sortLabel = 'Ngày kết thúc';
          break;
        default:
          sortLabel = _sortField!;
      }

      chips.add(
        _buildFilterChip(
          label: 'Sắp xếp: $sortLabel${_sortAsc ? ' ↑' : ' ↓'}',
          onClear: () => setState(() => _sortField = ''),
        ),
      );
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: SizedBox(
        width: double.infinity, // ⭐ ÉP FULL WIDTH
        child: Align(
          alignment: Alignment.centerLeft, // ⭐ ÉP CĂN TRÁI
          child: Wrap(spacing: 8, runSpacing: 8, children: chips),
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required VoidCallback onClear,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: context.surfaceLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.body(
              context,
            ).copyWith(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: AppSpacing.xs),
          GestureDetector(
            onTap: onClear,
            child: Icon(Icons.close, size: 18, color: context.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// ==================== PRIVATE ====================

CongViecModel _buildDefaultModel(ApplicationUser user) {
  return CongViecModel(
    id: '',
    idNguoiGiaoViec: user.userName,
    nguoiThucHien: '',
    nhomCongViec: '',
    tenNhom: '',
    ngayBatDau: DateTime.now(),
    ngayKetThuc: DateTime.now(),
    mucDoUuTien: '',
    tuDanhGia: '',
    duocDanhGia: 0,
    tienDo: 0,
    lapLai: '',
    tenCongViec: '',
    noiDungCongViec: '',
    fileDinhKem: '',
    groupId: user.groupId,
    companyId: user.companyId,
    companyName: '',
    createAt: DateTime.now(),
    createBy: '',
    isActive: 1,
    pageNumber: 1,
    pageSize: 10,
  );
}
