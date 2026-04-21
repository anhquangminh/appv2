import 'package:ducanherp/core/themes/app_text_styles.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ducanherp/core/helpers/user_storage_helper.dart';
import 'package:ducanherp/data/models/application_user.dart';
import 'package:ducanherp/logic/bloc/duyet/duyet_bloc.dart';
import 'package:ducanherp/logic/bloc/duyet/duyet_event.dart';
import 'package:ducanherp/logic/bloc/duyet/duyet_state.dart';
import 'package:ducanherp/presentation/widgets/common/app_load_more_button.dart';

import 'widgets/daduyet_task_item.dart';

class DaDuyetTab extends StatefulWidget {
  const DaDuyetTab({super.key});

  @override
  State<DaDuyetTab> createState() => _DaDuyetTabState();
}

class _DaDuyetTabState extends State<DaDuyetTab> with TickerProviderStateMixin {
  ApplicationUser? user;

  int currentPage = 0;
  final int pageSize = 20;
  bool isLoading = false;
  bool showLoadMoreButton = false;

  final ScrollController _scrollController = ScrollController();

  /// local accumulated tasks
  List<dynamic> tasksLoaded = [];

  /// expand state
  final Set<String> expandedItems = {};
  final Map<String, AnimationController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    user = await UserStorageHelper.getCachedUserInfo();
    if (user != null) {
      _loadTasks();
    }
  }

  void _loadTasks() {
    context.read<DuyetBloc>().add(
      EventGetApprovalByUserIdTasks(
        groupId: user!.groupId,
        userId: user!.id,
        currentPage: currentPage,
        pageSize: pageSize,
      ),
    );
  }

  void _onLoadMorePressed() {
    setState(() {
      isLoading = true;
      currentPage++;
    });
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DuyetBloc, StateDuyet>(
      listener: (context, state) {
        if (state is StateApprovalByUserIdTasksLoaded) {
          setState(() {
            isLoading = false;
            final newItems = state.tasks;

            if (currentPage == 0) {
              final seen = <dynamic>{};
              tasksLoaded =
                  newItems.where((item) {
                    final id = item.id;
                    if (seen.contains(id)) return false;
                    seen.add(id);
                    return true;
                  }).toList();
            } else {
              final existingIds = tasksLoaded.map((e) => e?.id).toSet();
              final itemsToAdd =
                  newItems.where((ni) {
                    return !existingIds.contains(ni.id);
                  }).toList();
              tasksLoaded.addAll(itemsToAdd);
            }

            showLoadMoreButton = newItems.length == pageSize;
          });
        }
      },
      builder: (context, state) {
        if (state is StateDuyetLoading && currentPage == 0) {
          return const Center(child: CircularProgressIndicator());
        }

        final displayTasks =
            tasksLoaded.isNotEmpty
                ? tasksLoaded
                : (state is StateApprovalByUserIdTasksLoaded
                    ? state.tasks
                    : []);

        if (displayTasks.isEmpty) {
          if (state is StateDuyetLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Center(
            child: Text(
              'Không có dữ liệu',
              style: AppTextStyles.body(
                context,
              ).copyWith(color: context.textSecondary),
            ),
          );
        }

        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                currentPage = 0;
                tasksLoaded.clear();
                isLoading = true;
                showLoadMoreButton = false;
              });
              _loadTasks();
            },
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount:
                  displayTasks.length +
                  ((isLoading || showLoadMoreButton) ? 1 : 0),
              itemBuilder: (context, index) {
                /// LOAD MORE / LOADING
                if (index == displayTasks.length) {
                  if (isLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(12),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (!showLoadMoreButton) {
                    return const SizedBox.shrink();
                  }

                  return AppLoadMoreButton(
                    isLoading: isLoading,
                    onPressed: _onLoadMorePressed,
                  );
                }

                final item = displayTasks[index];

                return DaDuyetTaskItem(
                  item: item,
                  isExpanded: expandedItems.contains(item.id),
                  onToggleExpand: () {
                    setState(() {
                      final isExpanded = expandedItems.contains(item.id);

                      isExpanded
                          ? expandedItems.remove(item.id)
                          : expandedItems.add(item.id);

                      isExpanded
                          ? _getController(item.id).reverse()
                          : _getController(item.id).forward();
                    });
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  AnimationController _getController(String itemId) {
    if (!_controllers.containsKey(itemId)) {
      _controllers[itemId] = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );
    }
    return _controllers[itemId]!;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
