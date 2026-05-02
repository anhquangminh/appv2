import 'package:ducanherp/core/themes/app_text_styles.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/presentation/pages/duyet/widgets/duyet_task_item.dart';
import 'package:ducanherp/presentation/widgets/common/compact_action_button.dart';
import 'package:ducanherp/presentation/widgets/toasts/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ducanherp/core/helpers/user_storage_helper.dart';
import 'package:ducanherp/data/models/application_user.dart';

import 'package:ducanherp/logic/bloc/duyet/duyet_bloc.dart';
import 'package:ducanherp/logic/bloc/duyet/duyet_event.dart';
import 'package:ducanherp/logic/bloc/duyet/duyet_state.dart';

enum DuyetTabType { choDuyet, daDuyet }

class DuyetScreen extends StatefulWidget {
  const DuyetScreen({super.key});

  @override
  State<DuyetScreen> createState() => _DuyetScreenState();
}

class _DuyetScreenState extends State<DuyetScreen> {
  ApplicationUser? user;

  int currentPage = 0;
  final int pageSize = 20;
  int totalItems = 0;
  bool isLoading = false;

  final ScrollController _scrollController = ScrollController();

  List<dynamic> tasksLoaded = [];
  final Map<DuyetTabType, List<dynamic>> _tasksCache = {};
  final Map<DuyetTabType, int> _totalCache = {};
  final Map<DuyetTabType, int> _pageCache = {};
  final Set<DuyetTabType> _loadedTabs = {};

  final Set<String> selectedItems = {};
  bool isSelectionMode = false;
  final Set<String> expandedItems = {};

  DuyetTabType currentTab = DuyetTabType.choDuyet;

  /// FILTER
  bool showFilter = false;
  String keyword = "";
  String selectedStatus = "all";
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> get _filteredTasks {
    return tasksLoaded.where((e) {
      final matchKeyword =
          keyword.isEmpty ||
          (e.title ?? '').toString().toLowerCase().contains(
            keyword.toLowerCase(),
          );

      final matchStatus =
          selectedStatus == "all"
              ? true
              : selectedStatus == "pending"
              ? e.isActive != 3
              : e.isActive == 3;

      return matchKeyword && matchStatus;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _init();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _init() async {
    user = await UserStorageHelper.getCachedUserInfo();
    if (user != null) _loadTasks();
  }

  void _loadTasks() {
    if (currentTab == DuyetTabType.choDuyet) {
      context.read<DuyetBloc>().add(
        EventGetAwaitingApprovalTasks(
          groupId: user!.groupId,
          userId: user!.id,
          currentPage: currentPage,
          pageSize: pageSize,
        ),
      );
    } else {
      context.read<DuyetBloc>().add(
        EventGetApprovalByUserIdTasks(
          groupId: user!.groupId,
          userId: user!.id,
          currentPage: currentPage,
          pageSize: pageSize,
        ),
      );
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !isLoading) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (isLoading) return;
    if (tasksLoaded.length >= totalItems && totalItems > 0) return;

    setState(() {
      isLoading = true;
      currentPage++;
    });

    _loadTasks();
  }

  Future<void> _refresh() async {
    setState(() {
      currentPage = 0;
      isLoading = true;
      totalItems = 0;
      tasksLoaded.clear();
      _tasksCache.remove(currentTab);
      _totalCache.remove(currentTab);
      _pageCache.remove(currentTab);
      _loadedTabs.remove(currentTab);
      selectedItems.clear();
      isSelectionMode = false;
    });

    _loadTasks();
  }

  void _switchTab(DuyetTabType type) {
    if (currentTab == type) return;

    _saveCurrentTabCache();
    final cachedTasks = _tasksCache[type];
    final hasCache = _loadedTabs.contains(type) && cachedTasks != null;

    setState(() {
      currentTab = type;
      currentPage = hasCache ? (_pageCache[type] ?? 0) : 0;
      totalItems = hasCache ? (_totalCache[type] ?? cachedTasks.length) : 0;
      tasksLoaded = hasCache ? List<dynamic>.from(cachedTasks) : [];
      selectedItems.clear();
      isSelectionMode = false;
      expandedItems.clear();
      isLoading = !hasCache;
    });

    if (!hasCache) {
      _loadTasks();
    }
  }

  void _saveCurrentTabCache() {
    _tasksCache[currentTab] = List<dynamic>.from(tasksLoaded);
    _totalCache[currentTab] = totalItems;
    _pageCache[currentTab] = currentPage;
    if (tasksLoaded.isNotEmpty || totalItems > 0) {
      _loadedTabs.add(currentTab);
    }
  }

  void _cacheLoadedTabData() {
    _tasksCache[currentTab] = List<dynamic>.from(tasksLoaded);
    _totalCache[currentTab] = totalItems;
    _pageCache[currentTab] = currentPage;
    _loadedTabs.add(currentTab);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DuyetBloc, StateDuyet>(
      listener: (context, state) {
        if (state is StateDuyetSuccess) {
          showAppToast(
            context,
            message: state.message,
            icon: Icons.check_circle,
            backgroundColor: context.success,
            textColor: context.onPrimary,
          );

          setState(() {
            /// 👉 remove item khỏi list "chờ duyệt"
            if (currentTab == DuyetTabType.choDuyet) {
              tasksLoaded.removeWhere((e) => e.id == state.id);
            }

            /// 👉 nếu đang ở tab "đã duyệt" thì update trạng thái
            if (currentTab == DuyetTabType.daDuyet) {
              final index = tasksLoaded.indexWhere((e) => e.id == state.id);
              if (index != -1) {
                tasksLoaded[index].isActive = state.isApprove ? 3 : 0;
              }
            }

            selectedItems.remove(state.id);
            _cacheLoadedTabData();
          });
        }
        if (state is StateAwaitingApprovalTasksLoaded &&
            currentTab == DuyetTabType.choDuyet) {
          setState(() {
            isLoading = false;
            totalItems = state.totalCount;

            if (currentPage == 0) {
              tasksLoaded = state.tasks;
            } else {
              final existingIds = tasksLoaded.map((e) => e.id).toSet();
              tasksLoaded.addAll(
                state.tasks.where((e) => !existingIds.contains(e.id)),
              );
            }
            _cacheLoadedTabData();
          });
        }

        if (state is StateApprovalByUserIdTasksLoaded &&
            currentTab == DuyetTabType.daDuyet) {
          setState(() {
            isLoading = false;
            totalItems = state.totalCount;

            if (currentPage == 0) {
              tasksLoaded = state.tasks;
            } else {
              final existingIds = tasksLoaded.map((e) => e.id).toSet();
              tasksLoaded.addAll(
                state.tasks.where((e) => !existingIds.contains(e.id)),
              );
            }
            _cacheLoadedTabData();
          });
        }
      },
      builder: (context, state) {
        final c = context;

        if (state is StateDuyetLoading &&
            currentPage == 0 &&
            tasksLoaded.isEmpty &&
            !_loadedTabs.contains(currentTab)) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          backgroundColor: c.background,
          floatingActionButton:
              currentTab == DuyetTabType.choDuyet &&
                      isSelectionMode &&
                      selectedItems.isNotEmpty
                  ? _buildMultiActionFAB()
                  : null,
          body: RefreshIndicator(
            onRefresh: _refresh,
            child: SafeArea(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _buildHeader(context),
                    ),
                  ),

                  /// TITLE + FILTER ICON
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildTitleRow(context),
                    ),
                  ),

                  /// FILTER (TOGGLE)
                  if (showFilter)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildSearchFilter(),
                      ),
                    ),

                  const SliverToBoxAdapter(child: SizedBox(height: 8)),

                  if (currentTab == DuyetTabType.choDuyet && isSelectionMode)
                    SliverToBoxAdapter(child: _buildSelectionInfo()),

                  /// LIST
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final item = _filteredTasks[index];

                        return DuyetTaskItem(
                          item: item,
                          isSelectionMode:
                              currentTab == DuyetTabType.choDuyet &&
                              isSelectionMode,
                          isSelected: selectedItems.contains(item.id),
                          isExpanded: expandedItems.contains(item.id),
                          onTap: () {
                            if (!isSelectionMode) return;
                            setState(() {
                              selectedItems.contains(item.id)
                                  ? selectedItems.remove(item.id)
                                  : selectedItems.add(item.id);
                            });
                          },
                          onLongPress: () {
                            if (currentTab == DuyetTabType.daDuyet) return;
                            setState(() {
                              isSelectionMode = true;
                              selectedItems.add(item.id);
                            });
                          },
                          onToggleExpand: () {
                            setState(() {
                              expandedItems.contains(item.id)
                                  ? expandedItems.remove(item.id)
                                  : expandedItems.add(item.id);
                            });
                          },
                          onMenuAction:
                              currentTab == DuyetTabType.choDuyet
                                  ? (isApprove) async {
                                    setState(() {
                                      tasksLoaded.removeWhere(
                                        (e) => e.id == item.id,
                                      );
                                    });

                                    context.read<DuyetBloc>().add(
                                      isApprove
                                          ? EventDuyetRequest(
                                            id: item.id,
                                            userName: user?.userName ?? '',
                                          )
                                          : EventHuyDuyetRequest(
                                            id: item.id,
                                            userName: user?.userName ?? '',
                                          ),
                                    );
                                  }
                                  : null,
                          onCheckboxChanged:
                              currentTab == DuyetTabType.choDuyet
                                  ? (value) {
                                    setState(() {
                                      value == true
                                          ? selectedItems.add(item.id)
                                          : selectedItems.remove(item.id);
                                    });
                                  }
                                  : null,
                        );
                      }, childCount: _filteredTasks.length),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child:
                        isLoading
                            ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: c.primary,
                                ),
                              ),
                            )
                            : const SizedBox.shrink(),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final total = totalItems;
    final loaded = tasksLoaded.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.grey700,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentTab == DuyetTabType.choDuyet ? "ĐANG CHỜ DUYỆT" : "ĐÃ DUYỆT",
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            "$total",
            style: const TextStyle(fontSize: 40, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text("Đã tải $loaded", style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    final c = context;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Danh sách", style: AppTextStyles.title(context)),
        Row(
          children: [
            PopupMenuButton<DuyetTabType>(
              onSelected: _switchTab,
              itemBuilder:
                  (_) => const [
                    PopupMenuItem(
                      value: DuyetTabType.choDuyet,
                      child: Text("Chờ duyệt"),
                    ),
                    PopupMenuItem(
                      value: DuyetTabType.daDuyet,
                      child: Text("Đã duyệt"),
                    ),
                  ],
              child: Row(
                children: [
                  Text(
                    currentTab == DuyetTabType.choDuyet
                        ? "Chờ duyệt"
                        : "Đã duyệt",
                    style: TextStyle(fontSize: 11, color: c.textSecondary),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.expand_more, size: 16, color: c.textSecondary),
                ],
              ),
            ),
            const SizedBox(width: 8),

            /// 👉 FILTER ICON
            GestureDetector(
              onTap: () {
                setState(() {
                  showFilter = !showFilter;
                });
              },
              child: Icon(
                Icons.filter_alt,
                size: 18,
                color: showFilter ? c.primary : c.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchFilter() {
    final c = context;

    return Column(
      children: [
        Container(
          height: 42,
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: c.border.withValues(alpha: 0.2)),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => keyword = v),
            decoration: InputDecoration(
              hintText: "Tìm kiếm...",
              prefixIcon: Icon(Icons.search, size: 18, color: c.textSecondary),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _filterChip("Tất cả", "all"),
            const SizedBox(width: 6),
            _filterChip("Chờ duyệt", "pending"),
            const SizedBox(width: 6),
            _filterChip("Đã duyệt", "approved"),
          ],
        ),
      ],
    );
  }

  Widget _filterChip(String label, String value) {
    final c = context;
    final isActive = selectedStatus == value;

    return GestureDetector(
      onTap: () => setState(() => selectedStatus = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? c.primary : c.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isActive ? c.onPrimary : c.textSecondary,
          ),
        ),
      ),
    );
  }

  /// ✅ FIX _buildSelectionInfo (ẩn khi không cần)
  Widget _buildSelectionInfo() {
    final c = context;

    if (!isSelectionMode) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.border.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.checklist, size: 18, color: c.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Đã chọn ${selectedItems.length} mục',
              style: TextStyle(color: c.textPrimary),
            ),
          ),
          GestureDetector(
            onTap: _clearSelection,
            child: Text('Hủy', style: TextStyle(color: c.textSecondary)),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmDialog({
    required String title,
    required String content,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(title),
            content: Text(content),
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
    return result == true;
  }

  void _clearSelection() {
    setState(() {
      selectedItems.clear();
      isSelectionMode = false;
    });
  }

  Future<void> _handleMultiApprove() async {
    final confirm = await _confirmDialog(
      title: 'Xác nhận duyệt',
      content: 'Bạn có chắc muốn duyệt ${selectedItems.length} mục?',
    );

    if (!confirm) return;

    for (final id in selectedItems) {
      // ignore: use_build_context_synchronously
      context.read<DuyetBloc>().add(
        EventDuyetRequest(id: id, userName: user?.userName ?? ''),
      );
    }

    _clearSelection();
  }

  Future<void> _handleMultiUnapprove() async {
    final confirm = await _confirmDialog(
      title: 'Xác nhận hủy duyệt',
      content: 'Bạn có chắc muốn hủy duyệt ${selectedItems.length} mục?',
    );

    if (!confirm) return;

    for (final id in selectedItems) {
      // ignore: use_build_context_synchronously
      context.read<DuyetBloc>().add(
        EventHuyDuyetRequest(id: id, userName: user?.userName ?? ''),
      );
    }

    _clearSelection();
  }

  Widget _buildMultiActionFAB() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CompactActionButton(
          icon: Icons.check,
          label: 'Duyệt',
          backgroundColor: context.success,
          foregroundColor: context.onPrimary,
          onTap: _handleMultiApprove,
        ),
        const SizedBox(width: 8),
        CompactActionButton(
          icon: Icons.close,
          label: 'Hủy',
          backgroundColor: context.warning,
          foregroundColor: context.onPrimary,
          onTap: _handleMultiUnapprove,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
