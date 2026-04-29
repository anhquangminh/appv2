import 'package:ducanherp/core/helpers/user_storage_helper.dart';
import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/core/utils/snackbar_utils.dart';
import 'package:ducanherp/data/models/application_user.dart';
import 'package:ducanherp/data/models/nhomnhanvien_model.dart';
import 'package:ducanherp/logic/bloc/nhomnhanvien/nhomnhanvien_bloc.dart';
import 'package:ducanherp/presentation/pages/quanlynhanvien/quanlynhanvien_page.dart';
import 'package:ducanherp/presentation/pages/quanlynhom/dialogs/nhom_nhan_vien_dialog.dart';
import 'package:ducanherp/presentation/pages/quanlynhom/widgets/nhom_filter_chips.dart';
import 'package:ducanherp/presentation/pages/quanlynhom/widgets/nhom_list_view.dart';
import 'package:ducanherp/presentation/pages/quanlynhom/widgets/nhom_search_bar.dart';
import 'package:ducanherp/presentation/widgets/common/app_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum _NhomSortMode { none, name, members, pending }

class QuanLyNhomPage extends StatefulWidget {
  final ValueListenable<int>? actionNotifier;

  const QuanLyNhomPage({super.key, this.actionNotifier});

  @override
  State<QuanLyNhomPage> createState() => _QuanLyNhomPageState();
}

class _QuanLyNhomPageState extends State<QuanLyNhomPage> {
  ApplicationUser? user;

  List<NhomNhanVienModel> nhomNhanVienList = [];
  List<NhomNhanVienModel> filteredList = [];
  Map<String, List<String>> filters = {};
  bool hasActiveFilters = false;
  String searchQuery = '';
  _NhomSortMode sortMode = _NhomSortMode.none;

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
    widget.actionNotifier?.addListener(_handleActionNotifier);
    WidgetsBinding.instance.addPostFrameCallback((_) => loadUserData());
  }

  @override
  void didUpdateWidget(covariant QuanLyNhomPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.actionNotifier != widget.actionNotifier) {
      oldWidget.actionNotifier?.removeListener(_handleActionNotifier);
      widget.actionNotifier?.addListener(_handleActionNotifier);
    }
  }

  @override
  void dispose() {
    widget.actionNotifier?.removeListener(_handleActionNotifier);
    super.dispose();
  }

  void _handleActionNotifier() {
    if (!mounted) return;
    _openAddDialog();
  }

  Future<void> loadUserData() async {
    final cachedUser = await UserStorageHelper.getCachedUserInfo();
    if (cachedUser != null && mounted) {
      setState(() {
        user = cachedUser;
        searchVM.groupId = user!.groupId;
      });
      _reloadGroups();
    }
  }

  void _reloadGroups() {
    context.read<NhomNhanVienBloc>().add(GetNhomNhanVienByVM(searchVM));
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
  final hasFilter = filters.values.any((e) => e.isNotEmpty);

  setState(() {
    hasActiveFilters = hasFilter;

    if (!hasFilter) {
      filteredList = nhomNhanVienList;
      return;
    }

    filteredList = nhomNhanVienList.where((nv) {
      // department
      if (filters['companyName']?.isNotEmpty == true &&
          !filters['companyName']!.contains(nv.companyName)) {
        return false;
      }

      // position
      if (filters['tenNhom']?.isNotEmpty == true &&
          !filters['tenNhom']!.contains(nv.tenNhom)) {
        return false;
      }

      // status
      if (filters['taiKhoan']?.isNotEmpty == true &&
          !filters['taiKhoan']!.contains(nv.taiKhoan.toString())) {
        return false;
      }
      return true;
    }).toList();
  });
}

  void _onFilterApplied(
    Map<String, List<String>> appliedFilters,
    List<NhomNhanVienModel> source,
  ) {
    setState(() {
      filters = appliedFilters;
      filteredList = source;
      hasActiveFilters = appliedFilters.values.any(
        (values) => values.isNotEmpty,
      );
    });
  }

  void _onSortChanged(String mode) {
    setState(() {
      sortMode = switch (mode) {
        'name' => _NhomSortMode.name,
        'members' => _NhomSortMode.members,
        'pending' => _NhomSortMode.pending,
        _ => _NhomSortMode.none,
      };
    });
  }

  void _openAddDialog() {
    if (user == null) return;
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
    if (user == null) return;
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
    if (user == null) return;
    context.read<NhomNhanVienBloc>().add(
      DeleteNhomNhanVien(nhom.id, user!.userName),
    );
  }

  Future<void> _duyetNhom(NhomNhanVienModel nhom) async {
    final confirm = await _showConfirmDialog(
      title: 'Xác nhận duyệt',
      message: 'Bạn có chắc muốn duyệt nhóm "${nhom.tenNhom}" không?',
    );

    if (confirm == true && mounted && user != null) {
      context.read<NhomNhanVienBloc>().add(
        DuyetNhomNhanVien(nhom.id, user!.userName),
      );
    }
  }

  Future<void> _huyDuyetNhom(NhomNhanVienModel nhom) async {
    final confirm = await _showConfirmDialog(
      title: 'Xác nhận hủy duyệt',
      message: 'Bạn có chắc muốn hủy duyệt nhóm "${nhom.tenNhom}" không?',
    );

    if (confirm == true && mounted && user != null) {
      context.read<NhomNhanVienBloc>().add(
        HuyDuyetNhomNhanVien(nhom.id, user!.userName),
      );
    }
  }

  Future<bool?> _showConfirmDialog({
    required String title,
    required String message,
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
                child: const Text('Hủy'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Đồng ý'),
              ),
            ],
          ),
    );
  }

  List<NhomNhanVienModel> get _displayList {
    final source = hasActiveFilters ? filteredList : nhomNhanVienList;
    final query = searchQuery.trim().toLowerCase();

    final list =
        source.where((item) {
          if (query.isEmpty) return true;
          return item.tenNhom.toLowerCase().contains(query) ||
              item.tenNhanVien.toLowerCase().contains(query) ||
              item.companyName.toLowerCase().contains(query) ||
              item.taiKhoan.toLowerCase().contains(query);
        }).toList();

    switch (sortMode) {
      case _NhomSortMode.name:
        list.sort(
          (a, b) => a.tenNhom.toLowerCase().compareTo(b.tenNhom.toLowerCase()),
        );
        break;
      case _NhomSortMode.members:
        list.sort((a, b) => b.total.compareTo(a.total));
        break;
      case _NhomSortMode.pending:
        list.sort((a, b) {
          final aPending = a.isActive == 3 ? 1 : 0;
          final bPending = b.isActive == 3 ? 1 : 0;
          return aPending.compareTo(bPending);
        });
        break;
      case _NhomSortMode.none:
        break;
    }

    return list;
  }

  int get _totalMembers =>
      _displayList.fold<int>(0, (sum, item) => sum + item.total);
  int get _groupCount => _displayList.length;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NhomNhanVienBloc, NhomNhanVienState>(
      listener: (context, state) {
        if (state is NhomNhanVienVMLoaded) {
          setState(() {
            nhomNhanVienList = state.nhomNhanViens;
            if (!hasActiveFilters) {
              filteredList = state.nhomNhanViens;
            }
          });
        }
        if (state is NhomNhanVienError) {
          showSnack(context, state.message, isError: true);
          _reloadGroups();
        }
        if (state is NhomNhanVienSuccess) {
          showSnack(context, state.message);
          _reloadGroups();
        }
      },
      builder: (context, state) {
        final isLoading =
            state is NhomNhanVienLoading && nhomNhanVienList.isEmpty;

        return LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 768;
            final horizontalPadding = isTablet ? AppSpacing.lg : AppSpacing.md;

            return RefreshIndicator(
              color: context.primary,
              backgroundColor: context.surfaceHighest,
              onRefresh: () async => _reloadGroups(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  AppSpacing.md,
                  horizontalPadding,
                  AppSpacing.xl,
                ),
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isTablet ? 760 : 560,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildOverviewCard(),
                          SizedBox(
                            height: isTablet ? AppSpacing.lg : AppSpacing.md,
                          ),
                          NhomSearchBar(
                            nhomNhanVienList: nhomNhanVienList,
                            onSearch: _onSearchChanged,
                            onClearSearch: _onClearSearch,
                            onFilterApplied: _onFilterApplied,
                            onSortChanged: _onSortChanged,
                            currentSortMode: sortMode.name,
                            activeSearchQuery: searchQuery,
                            compact: !isTablet,
                          ),
                          if (filters.values.any(
                                (values) => values.isNotEmpty,
                              ) ||
                              searchQuery.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.sm),
                            NhomFilterChips(
                              filters: filters,
                              searchQuery: searchQuery,
                              onRemoveFilter: _removeSingleFilter,
                              onClearSearch: _onClearSearch,
                              onClear: () {
                                setState(() {
                                  filters.clear();
                                  filteredList = nhomNhanVienList;
                                  hasActiveFilters = false;
                                });
                              },
                            ),
                          ],
                          const SizedBox(height: AppSpacing.md),
                          NhomListView(
                            filteredList: _displayList,
                            searchVM: searchVM,
                            isLoading: isLoading,
                            onOpen: _openEditDialog,
                            onEdit: _openEditDialog,
                            onDelete: _deleteNhom,
                            onAction: (nhom, action) {
                              switch (action) {
                                case 'approve':
                                  _duyetNhom(nhom);
                                  break;
                                case 'unapprove':
                                  _huyDuyetNhom(nhom);
                                  break;
                              }
                            },
                          ),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOverviewCard() {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TỔNG NHÂN SỰ',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: context.textPrimary,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.sm,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '$_totalMembers',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(
                        color: context.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: context.secondaryContainer,
                        borderRadius: AppRadius.pillRadius,
                      ),
                      child: Text(
                        '+$_groupCount tháng này',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: context.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: context.background,
              borderRadius: AppRadius.mdRadius,
            ),
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
               
                Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const QuanLyNhanVienPage(),
                        ),
                      );
              },
              child: Icon(
                Icons.badge_outlined,
                size: 20,
                color: context.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
