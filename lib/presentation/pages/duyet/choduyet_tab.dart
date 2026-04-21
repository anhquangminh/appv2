// import 'package:ducanherp/core/themes/app_theme_helper.dart';
// import 'package:ducanherp/presentation/pages/duyet/widgets/duyet_task_item.dart';
// import 'package:ducanherp/presentation/widgets/common/app_load_more_button.dart';
// import 'package:ducanherp/presentation/widgets/common/compact_action_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:ducanherp/core/helpers/user_storage_helper.dart';
// import 'package:ducanherp/data/models/application_user.dart';

// import 'package:ducanherp/logic/bloc/duyet/duyet_bloc.dart';
// import 'package:ducanherp/logic/bloc/duyet/duyet_event.dart';
// import 'package:ducanherp/logic/bloc/duyet/duyet_state.dart';

// class ChoDuyetTab extends StatefulWidget {
//   const ChoDuyetTab({super.key});

//   @override
//   State<ChoDuyetTab> createState() => _ChoDuyetTabState();
// }

// class _ChoDuyetTabState extends State<ChoDuyetTab>
//     with TickerProviderStateMixin {
//   ApplicationUser? user;

//   int currentPage = 0;
//   final int pageSize = 20;
//   int totalItems = 0;
//   bool isLoading = false;

//   final ScrollController _scrollController = ScrollController();

//   /// dữ liệu đã load (paging)
//   List<dynamic> tasksLoaded = [];

//   /// selection
//   final Set<String> selectedItems = {};
//   bool isSelectionMode = false;

//   /// expand
//   final Set<String> expandedItems = {};
//   final Map<String, AnimationController> _controllers = {};

//   @override
//   void initState() {
//     super.initState();
//     _init();
//   }

//   Future<void> _init() async {
//     user = await UserStorageHelper.getCachedUserInfo();
//     if (user != null) {
//       _loadTasks();
//     }
//   }

//   void _loadTasks() {
//     context.read<DuyetBloc>().add(
//       EventGetAwaitingApprovalTasks(
//         groupId: user!.groupId,
//         userId: user!.id,
//         currentPage: currentPage,
//         pageSize: pageSize,
//       ),
//     );
//   }

//   bool get _canLoadMore => tasksLoaded.length <= totalItems && !isLoading;

//   void _onLoadMorePressed() {
//     setState(() {
//       isLoading = true;
//       currentPage++;
//     });
//     _loadTasks();
//   }

//   /// ===============================
//   /// MULTI APPROVE
//   /// ===============================
//   Future<void> _handleMultiApprove() async {
//     final confirm = await _confirmDialog(
//       title: 'Xác nhận duyệt',
//       content: 'Bạn có chắc muốn duyệt ${selectedItems.length} mục đã chọn?',
//     );

//     if (confirm) {
//       for (final id in selectedItems) {
//         // ignore: use_build_context_synchronously
//         context.read<DuyetBloc>().add(
//           EventDuyetRequest(id: id, userName: user?.userName ?? ''),
//         );
//       }
//       _clearSelection();
//     }
//   }

//   /// ===============================
//   /// MULTI UNAPPROVE
//   /// ===============================
//   Future<void> _handleMultiUnapprove() async {
//     final confirm = await _confirmDialog(
//       title: 'Xác nhận hủy duyệt',
//       content:
//           'Bạn có chắc muốn hủy duyệt ${selectedItems.length} mục đã chọn?',
//     );

//     if (confirm) {
//       for (final id in selectedItems) {
//         // ignore: use_build_context_synchronously
//         context.read<DuyetBloc>().add(
//           EventHuyDuyetRequest(id: id, userName: user?.userName ?? ''),
//         );
//       }
//       _clearSelection();
//     }
//   }

//   Future<bool> _confirmDialog({
//     required String title,
//     required String content,
//   }) async {
//     final result = await showDialog<bool>(
//       context: context,
//       builder:
//           (_) => AlertDialog(
//             title: Text(title),
//             content: Text(content),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context, false),
//                 child: const Text('Hủy'),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.pop(context, true),
//                 child: const Text('Đồng ý'),
//               ),
//             ],
//           ),
//     );
//     return result == true;
//   }

//   void _clearSelection() {
//     setState(() {
//       selectedItems.clear();
//       isSelectionMode = false;
//     });
//   }

//   /// ===============================
//   /// BUILD
//   /// ===============================
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<DuyetBloc, StateDuyet>(
//       listener: (context, state) {
//         if (state is StateDuyetSuccess) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text(state.message)));
//           _loadTasks();
//         }

//         if (state is StateAwaitingApprovalTasksLoaded) {
//           setState(() {
//             isLoading = false;
//             totalItems = state.totalCount;

//             if (currentPage == 0) {
//               tasksLoaded = state.tasks;
//             } else {
//               final existingIds = tasksLoaded.map((e) => e.id).toSet();
//               tasksLoaded.addAll(
//                 state.tasks.where((e) => !existingIds.contains(e.id)),
//               );
//             }
//           });
//         }
//       },
//       builder: (context, state) {
//         final displayTasks = tasksLoaded.isNotEmpty ? tasksLoaded : [];

//         if (state is StateDuyetLoading && currentPage == 0) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (displayTasks.isEmpty) {
//           return const Center(child: Text('Không có dữ liệu'));
//         }

//         return Scaffold(
//           floatingActionButton:
//               isSelectionMode && selectedItems.isNotEmpty
//                   ? _buildMultiActionFAB()
//                   : null,
//           body: RefreshIndicator(
//             onRefresh: () async {
//               setState(() {
//                 currentPage = 0;
//                 isLoading = true;
//                 totalItems = 0;
//                 tasksLoaded.clear();
//                 _clearSelection();
//               });
//               _loadTasks();
//             },
//             child: Column(
//               children: [
//                 if (isSelectionMode) _buildSelectionInfo(),

//                 Expanded(
//                   child: ListView.builder(
//                     controller: _scrollController,
//                     physics: const AlwaysScrollableScrollPhysics(),
//                     itemCount: displayTasks.length,
//                     itemBuilder: (context, index) {
//                       final item = displayTasks[index];

//                       return DuyetTaskItem(
//                         item: item,
//                         isSelectionMode: isSelectionMode,
//                         isSelected: selectedItems.contains(item.id),
//                         isExpanded: expandedItems.contains(item.id),

//                         /// TAP
//                         onTap: () {
//                           if (!isSelectionMode) return;
//                           setState(() {
//                             selectedItems.contains(item.id)
//                                 ? selectedItems.remove(item.id)
//                                 : selectedItems.add(item.id);
//                             if (selectedItems.isEmpty) {
//                               isSelectionMode = false;
//                             }
//                           });
//                         },

//                         /// LONG PRESS
//                         onLongPress: () {
//                           setState(() {
//                             isSelectionMode = true;
//                             selectedItems.add(item.id);
//                           });
//                         },

//                         /// EXPAND
//                         onToggleExpand: () {
//                           setState(() {
//                             expandedItems.contains(item.id)
//                                 ? expandedItems.remove(item.id)
//                                 : expandedItems.add(item.id);
//                           });
//                         },

//                         /// MENU
//                         onMenuAction: (isApprove) async {
//                           final confirm = await _confirmDialog(
//                             title:
//                                 isApprove
//                                     ? 'Xác nhận duyệt'
//                                     : 'Xác nhận hủy duyệt',
//                             content:
//                                 isApprove
//                                     ? 'Bạn có chắc muốn duyệt nội dung này?'
//                                     : 'Bạn có chắc muốn hủy duyệt nội dung này?',
//                           );

//                           if (!confirm) return;

//                           // ignore: use_build_context_synchronously
//                           context.read<DuyetBloc>().add(
//                             isApprove
//                                 ? EventDuyetRequest(
//                                   id: item.id,
//                                   userName: user?.userName ?? '',
//                                 )
//                                 : EventHuyDuyetRequest(
//                                   id: item.id,
//                                   userName: user?.userName ?? '',
//                                 ),
//                           );
//                         },

//                         /// CHECKBOX
//                         onCheckboxChanged: (value) {
//                           setState(() {
//                             value == true
//                                 ? selectedItems.add(item.id)
//                                 : selectedItems.remove(item.id);
//                             if (selectedItems.isEmpty) {
//                               isSelectionMode = false;
//                             }
//                           });
//                         },
//                       );
//                     },
//                   ),
//                 ),

//                 /// LOAD MORE
//                 if (_canLoadMore)
//                   AppLoadMoreButton(
//                     isLoading: isLoading,
//                     onPressed: _onLoadMorePressed,
//                   ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   /// ===============================
//   /// UI PARTS
//   /// ===============================
//   Widget _buildSelectionInfo() {

//   return Card(
//     margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
//     elevation: 0,
//     shadowColor: context.opacity(Colors.black, 0.05),
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(12),
//       side: BorderSide(color: context.border, width: 0.8),
//     ),
//     color: context.surface,
//     child: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       child: Row(
//         children: [
//           Text(
//             'Đã chọn ${selectedItems.length} mục',
//             style: TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 13,
//               color: context.textPrimary,
//             ),
//           ),
//           const Spacer(),
//           TextButton(
//             onPressed: _clearSelection,
//             child: Text(
//               'Hủy',
//               style: TextStyle(color: context.primary),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// Widget _buildMultiActionFAB() {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.end,
//     children: [
//       CompactActionButton(
//         icon: Icons.check,
//         label: 'Duyệt',
//         backgroundColor: context.success,
//         foregroundColor: context.onPrimary,
//         onTap: _handleMultiApprove,
//       ),
//       const SizedBox(width: 8),
//       CompactActionButton(
//         icon: Icons.close,
//         label: 'Hủy duyệt',
//         backgroundColor: context.warning,
//         foregroundColor: context.onPrimary,
//         onTap: _handleMultiUnapprove,
//       ),
//     ],
//   );
// }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     for (final c in _controllers.values) {
//       c.dispose();
//     }
//     super.dispose();
//   }

  
// }
