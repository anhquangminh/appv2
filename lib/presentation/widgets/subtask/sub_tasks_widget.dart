// import 'package:ducanherp/core/themes/app_colors.dart';
// import 'package:ducanherp/core/utils/file_utils.dart';
// import 'package:ducanherp/data/models/congviec_model.dart';
// import 'package:ducanherp/data/models/congvieccon_model.dart';
// import 'package:ducanherp/logic/bloc/congviec/congviec_bloc.dart';
// import 'package:ducanherp/logic/bloc/congviec/congviec_event.dart';
// import 'package:ducanherp/logic/bloc/congviec/congviec_state.dart';
// import 'package:ducanherp/logic/bloc/download/download_bloc.dart';
// import 'package:ducanherp/logic/bloc/download/download_event.dart';
// import 'package:ducanherp/logic/bloc/download/download_state.dart';
// import 'package:ducanherp/presentation/widgets/attachment/attachment_card.dart';
// import 'package:ducanherp/presentation/widgets/common/app_card.dart';
// import 'package:ducanherp/presentation/widgets/dialog/custom_dialog.dart';
// import 'package:ducanherp/presentation/widgets/toasts/app_toast.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:open_filex/open_filex.dart';

// class SubTasksWidget extends StatefulWidget {
//   final CongViecModel congViec;
//   final List<CongViecConModel> itemCvcs;
//   final CongViecBloc congviecBloc;
//   final Function(CongViecConModel)? onAddSubTask;
//   final Function(CongViecConModel)? onUpdateSubTask;
//   final Function(String)? onDeleteSubTask;
//   final Function(dynamic, CongViecConModel)? onFileSelected;

//   const SubTasksWidget({
//     super.key,
//     required this.congViec,
//     required this.itemCvcs,
//     required this.congviecBloc,
//     this.onAddSubTask,
//     this.onUpdateSubTask,
//     this.onDeleteSubTask,
//     this.onFileSelected,
//   });

//   @override
//   State<SubTasksWidget> createState() => _SubTasksWidgetState();
// }

// class _SubTasksWidgetState extends State<SubTasksWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocListener(
//       listeners: [
//         /// ===== DOWNLOAD LISTENER (TOAST) =====
//         BlocListener<DownloadBloc, DownloadState>(
//           listener: (context, state) {
//             if (state is DownloadInProgress) {
//               showAppToast(
//                 context,
//                 message: 'Đang tải file...',
//                 icon: Icons.downloading,
//                 backgroundColor: AppColors.primary(context),
//               );
//             }

//             if (state is DownloadSuccess) {
//               showAppToast(
//                 context,
//                 message: 'Tải file thành công',
//                 icon: Icons.check_circle,
//                 backgroundColor: AppColors.success(context),
//                 actionLabel: 'MỞ',
//                 onAction: () {
//                   OpenFilex.open(state.path);
//                 },
//               );
//             }

//             if (state is DownloadFailure) {
//               showAppToast(
//                 context,
//                 message: 'Tải file thất bại',
//                 icon: Icons.error,
//                 backgroundColor: AppColors.error(context),
//               );
//             }
//           },
//         ),
//       ],
//       child: AppCard(
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: _buildContent(context),
//         ),
//       ),
//     );
//   }

//   /// ================= CONTENT =================
//   Widget _buildContent(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         /// ===== HEADER =====
//         Padding(
//           padding: const EdgeInsets.all(12),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Wrap(
//                 children: [
//                   Icon(
//                     Icons.playlist_add_check,
//                     color: AppColors.primary(context),
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     'Công việc con (${widget.itemCvcs.length})',
//                     style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.add,
//                   size: 20,
//                   color: AppColors.primary(context),
//                 ),
//                 onPressed: () => _showTaskDialog(context),
//                 tooltip: 'Thêm công việc con',
//                 padding: EdgeInsets.zero,
//                 constraints: const BoxConstraints(),
//               ),
//             ],
//           ),
//         ),

//         const Divider(height: 1),

//         /// ===== LIST =====
//         ListView.separated(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: widget.itemCvcs.length,
//           separatorBuilder: (_, __) => const Divider(height: 1),
//           itemBuilder: (context, i) {
//             final task = widget.itemCvcs[i];
//             final hasAttachment = task.fileDinhKem?.isNotEmpty == true;

//             return Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// ===== TASK ROW =====
//                   Row(
//                     children: [
//                       Text(
//                         '${i + 1}.',
//                         style: Theme.of(context).textTheme.labelMedium
//                             ?.copyWith(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(width: 4),
//                       Expanded(
//                         child: Text(
//                           task.noiDungCongViec,
//                           style: Theme.of(context).textTheme.bodyMedium,
//                         ),
//                       ),
//                       PopupMenuButton<String>(
//                         icon: Icon(
//                           Icons.more_vert,
//                           size: 20,
//                           color: AppColors.onSurfaceVariant(context),
//                         ),
//                         onSelected: (value) {
//                           if (value == 'edit') {
//                             _showTaskDialog(context, task: task);
//                           } else if (value == 'delete') {
//                             _confirmDeleteTask(context, task);
//                           }
//                         },
//                         itemBuilder:
//                             (_) => const [
//                               PopupMenuItem(
//                                 value: 'edit',
//                                 child: Row(
//                                   children: [
//                                     Icon(Icons.edit_outlined, size: 18),
//                                     SizedBox(width: 8),
//                                     Text('Sửa'),
//                                   ],
//                                 ),
//                               ),
//                               PopupMenuItem(
//                                 value: 'delete',
//                                 child: Row(
//                                   children: [
//                                     Icon(
//                                       Icons.delete_forever_outlined,
//                                       size: 18,
//                                     ),
//                                     SizedBox(width: 8),
//                                     Text('Xóa'),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                       ),
//                     ],
//                   ),

//                   /// ===== ATTACHMENT + DOWNLOAD =====
//                   if (hasAttachment)
//                     BlocBuilder<DownloadBloc, DownloadState>(
//                       builder: (context, state) {
//                         final isDownloading = state is DownloadInProgress;
//                         final progress = isDownloading ? state.progress : null;

//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             AbsorbPointer(
//                               absorbing: isDownloading,
//                               child: AttachmentCard(
//                                 fileUrl:
//                                     '${dotenv.env['API_URL']}${task.fileDinhKem}',
//                                 onDownload: () {
//                                   final filePath = task.fileDinhKem!;
//                                   context.read<DownloadBloc>().add(
//                                     StartDownload(
//                                       '${dotenv.env['API_URL']}$filePath',
//                                       filePath.split('/').last,
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                             if (isDownloading && progress != null)
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 6),
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(8),
//                                   child: LinearProgressIndicator(
//                                     value: progress,
//                                     minHeight: 6,
//                                     backgroundColor: AppColors.surface(context),
//                                     valueColor: AlwaysStoppedAnimation(
//                                       AppColors.primary(context),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         );
//                       },
//                     ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }

//   /// ================= DIALOG =================
//   Future<void> _showTaskDialog(
//     BuildContext context, {
//     CongViecConModel? task,
//   }) async {
//     final controller = TextEditingController(text: task?.noiDungCongViec ?? '');
//     final formKey = GlobalKey<FormState>();
//     String? currentFile = task?.fileDinhKem;

//     await showDialog(
//       context: context,
//       builder: (_) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return CustomDialog(
//               title: task == null ? 'Thêm công việc con' : 'Sửa công việc con',
//               onClose: () => Navigator.pop(context),
//               body: Form(
//                 key: formKey,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextFormField(
//                       controller: controller,
//                       decoration: const InputDecoration(
//                         labelText: 'Nội dung',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator:
//                           (v) =>
//                               v == null || v.isEmpty
//                                   ? 'Không được bỏ trống'
//                                   : null,
//                       maxLines: 3,
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () async {
//                             final result =
//                                 await FilePicker.platform.pickFiles();
//                             if (result?.files.single.path != null) {
//                               // ignore: use_build_context_synchronously
//                               context.read<CongViecBloc>().add(
//                                 EventUploadFile(result!.files.single),
//                               );
//                             }
//                           },
//                           child: const Text('Chọn file'),
//                         ),
//                         if (currentFile != null)
//                           Row(
//                             children: [
//                               IconButton(
//                                 icon: const Icon(Icons.close),
//                                 onPressed:
//                                     () => setState(() => currentFile = null),
//                               ),
//                               IconButton(
//                                 icon: const Icon(Icons.download),
//                                 onPressed: () {
//                                   context.read<DownloadBloc>().add(
//                                     StartDownload(
//                                       '${dotenv.env['API_URL']}$currentFile',
//                                       currentFile!.split('/').last,
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ],
//                           ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     if (currentFile != null)
//                       _buildPreview(context, currentFile!),
//                     BlocListener<CongViecBloc, CongViecState>(
//                       listenWhen: (_, s) => s is StateUploadFile,
//                       listener: (context, state) {
//                         if (state is StateUploadFile) {
//                           setState(() => currentFile = state.url);
//                         }
//                       },
//                       child: const SizedBox.shrink(),
//                     ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text('Hủy'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (!formKey.currentState!.validate()) return;

//                     final newTask = CongViecConModel(
//                       id: task?.id ?? '',
//                       idCongViec: widget.congViec.id,
//                       noiDungCongViec: controller.text,
//                       fileDinhKem: currentFile,
//                       hoanThanh: task?.hoanThanh ?? 0,
//                       groupId: widget.congViec.groupId,
//                       createBy: widget.congViec.createBy,
//                       createAt: DateTime.now(),
//                       isActive: 1,
//                     );

//                     task == null
//                         ? widget.onAddSubTask!(newTask)
//                         : widget.onUpdateSubTask!(newTask);

//                     Navigator.pop(context);
//                   },
//                   child: const Text('Lưu'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   /// ================= PREVIEW =================
//   Widget _buildPreview(BuildContext context, String file) {
//     final isImage = isImageFile(file);
//     final url = '${dotenv.env['API_URL']}$file';

//     if (isImage) {
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(8),
//         child: Image.network(
//           url,
//           height: 150,
//           width: double.infinity,
//           fit: BoxFit.cover,
//           errorBuilder:
//               (_, __, ___) => const Center(child: Text('Không tải được ảnh')),
//         ),
//       );
//     }

//     return Row(
//       children: [
//         const Icon(Icons.attachment),
//         const SizedBox(width: 6),
//         Expanded(
//           child: Text(
//             file.split('/').last,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }

//   /// ================= DELETE =================
//   Future<void> _confirmDeleteTask(
//     BuildContext context,
//     CongViecConModel task,
//   ) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder:
//           (_) => AlertDialog(
//             title: const Text('Xác nhận xóa'),
//             content: Text(
//               'Bạn có chắc chắn muốn xóa "${task.noiDungCongViec}"?',
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context, false),
//                 child: const Text('Hủy'),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.pop(context, true),
//                 child: const Text('Xóa'),
//               ),
//             ],
//           ),
//     );

//     if (confirmed == true && mounted) {
//       widget.onDeleteSubTask!(task.id.toString());
//     }
//   }
// }
