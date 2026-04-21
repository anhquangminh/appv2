import 'package:ducanherp/core/navigation/route_observer.dart';
import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_shadows.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_text_styles.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/presentation/pages/qlcv/calender_page.dart';
import 'package:ducanherp/presentation/widgets/bages/quahan_bage.dart';
import 'package:ducanherp/presentation/pages/qlcv/widgets/myjob/myjob_item.dart';
import 'package:ducanherp/presentation/widgets/shimmer/list_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ducanherp/core/helpers/user_storage_helper.dart';
import 'package:ducanherp/data/models/application_user.dart';
import 'package:ducanherp/data/models/congviec_model.dart';
import 'package:ducanherp/logic/bloc/congviec/congviec_bloc.dart';
import 'package:ducanherp/logic/bloc/congviec/congviec_event.dart';
import 'package:ducanherp/logic/bloc/congviec/congviec_state.dart';

class DSCVDuocGiaoPage extends StatefulWidget {
  final CongViecModel? congViecModel;

  const DSCVDuocGiaoPage({super.key, this.congViecModel});

  @override
  State<DSCVDuocGiaoPage> createState() => _DanhSachCongViecPageState();
}

class _DanhSachCongViecPageState extends State<DSCVDuocGiaoPage>
    with RouteAware {
  ApplicationUser? user;
  final Map<String, List<CongViecModel>> _cachedJobsByKey = {};
  String? _selectedTenNhom;
  String? _selectedMucDoUuTien;
  String? _selectedLapLai;
  String? _selectedTrangThai;

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

  bool isQuaHan(CongViecModel job) {
    final now = DateTime.now();
    return job.tienDo < 10 && job.ngayKetThuc.isBefore(now);
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
      backgroundColor: context.background,
      body: Column(
        children: [
          _buildSearchBar(context),
          _buildActiveFilters(),
          Expanded(
            child: BlocBuilder<CongViecBloc, CongViecState>(
              buildWhen:
                  (prev, curr) =>
                      curr is StateCongViecByVMLoaded ||
                      curr is StateCongViecLoading,
              builder: (context, state) {
                if (state is StateCongViecLoading && _cachedJobsByKey.isEmpty) {
                  return const ListShimmer();
                }

                if (state is StateCongViecByVMLoaded) {
                  if (user != null) {
                    _cachedJobsByKey[_cacheKey(user!)] = List.from(
                      state.congViecs,
                    );
                  }
                }

                final jobsToShow = _getFilteredJobs(_currentCachedJobs);

                if (jobsToShow.isEmpty) {
                  return const Center(child: Text('No data'));
                }

                return RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    itemCount: jobsToShow.length,
                    itemBuilder: (_, i) {
                      final job = jobsToShow[i];
                      final quaHan = isQuaHan(job);

                      return Stack(
                        children: [
                          MyJobItem(
                            congViecModel: job,
                            onRefresh: _handleRefresh,
                          ),

                          if (quaHan)
                            const Positioned(
                              top: 10,
                              right: 10,
                              child: QuaHanBadge(),
                            ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  List<CongViecModel> _getFilteredJobs(List<CongViecModel> jobs) {
    final now = DateTime.now();
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

          bool matchTrangThai = true;
          if (_selectedTrangThai != null && _selectedTrangThai!.isNotEmpty) {
            switch (_selectedTrangThai) {
              case 'DangThucHien':
                matchTrangThai =
                    job.tienDo > 0 &&
                    job.tienDo < 10 &&
                    (job.ngayKetThuc.isAfter(now));
                break;
              case 'HoanThanh':
                matchTrangThai = job.tienDo >= 10;
                break;
              case 'Cho':
                matchTrangThai = job.tienDo == 0 && job.ngayBatDau.isAfter(now);
                break;
              case 'ChuaLam':
                matchTrangThai =
                    job.tienDo == 0 && !job.ngayBatDau.isAfter(now);
                break;
              case 'QuaHan':
                matchTrangThai =
                    job.tienDo < 10 && job.ngayKetThuc.isBefore(now);
                break;
              default:
                matchTrangThai = true;
            }
          }

          return matchTenNhom &&
              matchMucDoUuTien &&
              matchLapLai &&
              matchTrangThai &&
              matchSearch;
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
                  borderRadius: AppRadius.mdRadius,
                  boxShadow: AppShadows.soft,
                  border: Border.all(color: context.border),
                ),
                child: TextField(
                  controller: _searchController,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: "Tìm kiếm...",
                    hintStyle: TextStyle(color: context.textSecondary),
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
                  style: AppTextStyles.body(context),
                  onChanged: (text) {
                    setState(() {});
                  },
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.sm),

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
              borderRadius: BorderRadius.circular(100),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: context.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.border),
                  boxShadow: AppShadows.soft,
                ),
                child: Icon(Icons.filter_list, color: context.textPrimary),
              ),
            ),

            const SizedBox(width: AppSpacing.xs),

            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (_) => CalendarPage(congViecModels: _currentCachedJobs),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(100),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: context.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.border),
                  boxShadow: AppShadows.soft,
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
      isScrollControlled: true,
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Lọc dữ liệu',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFE5E5E5),
                    ),
                    const SizedBox(height: 10),
                    // ---------------- Sắp xếp ----------------
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _sortField ?? '',
                            items: const [
                              DropdownMenuItem(
                                value: '',
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
                            decoration: const InputDecoration(
                              labelText: "Sắp xếp theo",
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: Icon(
                            _sortAsc
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                          ),
                          tooltip: _sortAsc ? "Tăng dần" : "Giảm dần",
                          onPressed: () => setState(() => _sortAsc = !_sortAsc),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ---------------- Nhóm ----------------
                    DropdownButtonFormField<String>(
                      value: _selectedTenNhom,
                      items: [
                        const DropdownMenuItem(
                          value: '',
                          child: Text('Tất cả nhóm'),
                        ),
                        ..._getUniqueTenNhom(jobs).map(
                          (nhom) =>
                              DropdownMenuItem(value: nhom, child: Text(nhom)),
                        ),
                      ],
                      onChanged:
                          (val) => setState(() => _selectedTenNhom = val),
                      decoration: const InputDecoration(
                        labelText: 'Nhóm công việc',
                      ),
                    ),
                    const SizedBox(height: 10),
                    // ---------------- Mức độ ưu tiên ----------------
                    DropdownButtonFormField<String>(
                      value: _selectedMucDoUuTien,
                      items: [
                        const DropdownMenuItem(
                          value: '',
                          child: Text('Tất cả ưu tiên'),
                        ),
                        ..._getUniqueMucDoUuTien(jobs).map(
                          (e) => DropdownMenuItem(value: e, child: Text(e)),
                        ),
                      ],
                      onChanged:
                          (val) => setState(() => _selectedMucDoUuTien = val),
                      decoration: const InputDecoration(
                        labelText: 'Mức độ ưu tiên',
                      ),
                    ),
                    const SizedBox(height: 10),
                    // ---------------- Lặp lại ----------------
                    DropdownButtonFormField<String>(
                      value: _selectedLapLai,
                      items: [
                        const DropdownMenuItem(
                          value: '',
                          child: Text('Tất cả lặp lại'),
                        ),
                        ..._getUniqueLapLai(jobs).map(
                          (e) => DropdownMenuItem(value: e, child: Text(e)),
                        ),
                      ],
                      onChanged: (val) => setState(() => _selectedLapLai = val),
                      decoration: const InputDecoration(
                        labelText: 'Kiểu lặp lại',
                      ),
                    ),
                    const SizedBox(height: 10),
                    // ---------------- Trạng thái ----------------
                    DropdownButtonFormField<String>(
                      value: _selectedTrangThai,
                      items: const [
                        DropdownMenuItem(
                          value: '',
                          child: Text('Tất cả trạng thái'),
                        ),
                        DropdownMenuItem(
                          value: 'DangThucHien',
                          child: Text('Đang thực hiện'),
                        ),
                        DropdownMenuItem(
                          value: 'HoanThanh',
                          child: Text('Hoàn thành'),
                        ),
                        DropdownMenuItem(value: 'Cho', child: Text('Chờ')),
                        DropdownMenuItem(
                          value: 'ChuaLam',
                          child: Text('Chưa làm'),
                        ),
                        DropdownMenuItem(
                          value: 'QuaHan',
                          child: Text('Quá hạn'),
                        ),
                      ],
                      onChanged:
                          (val) => setState(() => _selectedTrangThai = val),
                      decoration: const InputDecoration(
                        labelText: 'Trạng thái',
                      ),
                    ),
                    const SizedBox(height: 20),
                    // ---------------- Nút ----------------
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedTenNhom = '';
                                _selectedMucDoUuTien = '';
                                _selectedLapLai = '';
                                _selectedTrangThai = '';
                                _sortField = null;
                                _sortAsc = true;
                              });
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade300,
                              foregroundColor: Colors.black,
                            ),
                            child: const Text('Xoá lọc'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Áp dụng lọc'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
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
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: context.border),
        boxShadow: AppShadows.soft,
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
          const SizedBox(width: AppSpacing.sm),
          GestureDetector(
            onTap: onClear,
            child: Icon(Icons.close, size: 18, color: context.textSecondary),
          ),
        ],
      ),
    );
  }

  /// ==================== PRIVATE ====================

  CongViecModel _buildDefaultModel(ApplicationUser user) {
    return CongViecModel(
      id: '',
      idNguoiGiaoViec: '',
      nguoiThucHien: user.userName,
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
}
