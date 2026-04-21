// // lib/presentation/pages/qlcv/congviec_detail_page.dart
// import 'package:ducanherp/core/helpers/user_storage_helper.dart';
// import 'package:ducanherp/core/themes/app_colors.dart';
// import 'package:ducanherp/data/models/application_user.dart';
// import 'package:ducanherp/data/models/congviec_model.dart';
// import 'package:ducanherp/data/models/congvieccon_model.dart';
// import 'package:ducanherp/data/models/nhanvien_model.dart';
// import 'package:ducanherp/data/models/nhanvienthuchien_model.dart';
// import 'package:ducanherp/data/models/nhomnhanvien_model.dart';
// import 'package:ducanherp/logic/bloc/congviec/congviec_bloc.dart';
// import 'package:ducanherp/logic/bloc/congviec/congviec_event.dart';
// import 'package:ducanherp/logic/bloc/congviec/congviec_state.dart';
// import 'package:ducanherp/logic/bloc/download/download_bloc.dart';
// import 'package:ducanherp/logic/bloc/download/download_event.dart';
// import 'package:ducanherp/logic/bloc/nhanvien/nhanvien_bloc.dart';
// import 'package:ducanherp/logic/bloc/nhanvien/nhanvien_event.dart';
// import 'package:ducanherp/logic/bloc/nhanvien/nhanvien_state.dart';
// import 'package:ducanherp/logic/bloc/nhomnhanvien/nhomnhanvien_bloc.dart';
// import 'package:ducanherp/presentation/widgets/attachment/attachment_card.dart';
// import 'package:ducanherp/presentation/widgets/common/app_card.dart';
// import 'package:ducanherp/presentation/widgets/subtask/sub_tasks_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:intl/intl.dart';

// class CongViecDetailPage extends StatefulWidget {
//   final String id;
//   const CongViecDetailPage({super.key, required this.id});

//   @override
//   State<CongViecDetailPage> createState() => _CongViecDetailPageState();
// }

// class _CongViecDetailPageState extends State<CongViecDetailPage> {
//   CongViecModel? congViec;
//   ApplicationUser? user;

//   bool isLoading = true;
//   String tenNhom = '';

//   List<NhanVienModel> nhanviens = [];
//   List<NhanVienModel> selectedNhanViens = [];
//   List<NhomNhanVienModel> nhomNhanViens = [];
//   List<CongViecConModel> cvcs = [];

//   final _dateFormat = DateFormat('dd/MM/yyyy');

//   @override
//   void initState() {
//     super.initState();
//     _init();
//   }

//   Future<void> _init() async {
//     user = await UserStorageHelper.getCachedUserInfo();
//     if (!mounted || user == null) return;
//     context.read<CongViecBloc>().add(EventGetCongViecById(widget.id));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final congviecBloc = context.read<CongViecBloc>();
//     return Scaffold(
//       backgroundColor: AppColors.surface(context),
//       appBar: AppBar(
//         centerTitle: true,
//         elevation: 4,
//         backgroundColor: AppColors.appBarColor(context),
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: AppColors.onPrimary(context)),
//           onPressed: () => Navigator.pop(context, true),
//         ),
//         title: Text(
//           'Chi tiết công việc',
//           style: Theme.of(context).textTheme.titleMedium?.copyWith(
//             fontWeight: FontWeight.bold,
//             color: AppColors.onPrimary(context),
//           ),
//         ),
//       ),
//       body: MultiBlocListener(
//         listeners: _buildListeners(),
//         child:
//             isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _InfoCard(
//                         children: [
//                           _InfoItem(
//                             icon: Icons.add_task,
//                             label: 'Tên công việc',
//                             value: congViec?.tenCongViec ?? '',
//                           ),
//                           _InfoItem(
//                             icon: Icons.description,
//                             label: 'Nội dung công việc',
//                             value: congViec?.noiDungCongViec ?? '',
//                           ),
//                           _InfoItem(
//                             icon: Icons.person,
//                             label: 'Người giao việc',
//                             value: congViec?.idNguoiGiaoViec ?? '',
//                           ),
//                           _InfoItem(
//                             icon: Icons.group_work,
//                             label: 'Nhóm công việc',
//                             value: tenNhom,
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       _NhanVienCard(selectedNhanViens),
//                       const SizedBox(height: 12),
//                       _InfoCard(
//                         children: [
//                           _InfoRow(
//                             icon: Icons.calendar_today,
//                             label: 'Ngày bắt đầu',
//                             value: _dateFormat.format(congViec!.ngayBatDau),
//                           ),
//                           _InfoRow(
//                             icon: Icons.event,
//                             label: 'Ngày kết thúc',
//                             value: _dateFormat.format(congViec!.ngayKetThuc),
//                           ),
//                           _InfoRow(
//                             icon: Icons.priority_high,
//                             label: 'Ưu tiên',
//                             value: congViec!.mucDoUuTien,
//                           ),
//                           _ProgressRow(progress: congViec!.tienDo / 10),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       if (congViec?.fileDinhKem.isNotEmpty ?? false)
//                         AppCard(
//                           child: Padding(
//                             padding: EdgeInsets.all(12),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Icon(
//                                       Icons.attach_file_rounded,
//                                       size: 18,
//                                       color: AppColors.onSurfaceVariant(
//                                         context,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 6),
//                                     Text(
//                                       'File đính kèm',
//                                       style: Theme.of(
//                                         context,
//                                       ).textTheme.labelMedium?.copyWith(
//                                         color: AppColors.onSurfaceVariant(
//                                           context,
//                                         ),
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ],
//                                 ),

//                                 AttachmentCard(
//                                   fileUrl:
//                                       '${dotenv.env['API_URL']}${congViec!.fileDinhKem}',
//                                   onDownload: () {
//                                     final filePath = congViec!.fileDinhKem;
//                                     context.read<DownloadBloc>().add(
//                                       StartDownload(
//                                         '${dotenv.env['API_URL']}$filePath',
//                                         filePath.split('/').last,
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),

//                       if (cvcs.isNotEmpty)
//                         SubTasksWidget(
//                           congViec: congViec!,
//                           itemCvcs: cvcs,
//                           congviecBloc: congviecBloc,
//                           onAddSubTask: (cvc) {
//                             congviecBloc.add(EventInsertCVC(cvc));
//                           },
//                           onUpdateSubTask: (cvc) {
//                             congviecBloc.add(EventUpdateCVC(cvc));
//                           },
//                           onDeleteSubTask: (id) {
//                             congviecBloc.add(
//                               EventDeleteCVC(id, congViec!.createBy),
//                             );
//                           },
//                           onFileSelected: (file, task) {
//                             congviecBloc.add(EventUploadFile(file));
//                           },
//                         ),
//                       SizedBox(height: 30),
//                     ],
//                   ),
//                 ),
//       ),
//     );
//   }

//   List<BlocListener> _buildListeners() => [
//     BlocListener<CongViecBloc, CongViecState>(
//       listener: (context, state) {
//         if (state is StateCongViecByIdLoaded) {
//           congViec = state.congViec;
//           isLoading = false;
//           context.read<NhomNhanVienBloc>().add(
//             LoadNhomNhanVien(
//               groupId: user!.groupId,
//               companyId: user!.companyId,
//               taiKhoan: user!.userName,
//             ),
//           );
//           context.read<NhanVienBloc>().add(
//             GetNhanVienByNhom(
//               groupId: congViec!.groupId,
//               idNhomNhanVien: congViec!.nhomCongViec,
//               companyId: user!.companyId,
//             ),
//           );
//           context.read<CongViecBloc>().add(EventLoadCVCByIdCV(congViec!.id));
//           setState(() {});
//         }
//       },
//     ),
//     BlocListener<NhanVienBloc, NhanVienState>(
//       listener: (context, state) {
//         if (state is NhanVienLoaded) {
//           nhanviens = state.nhanViens;
//           final nvth = NhanVienThucHienModel(
//             id: '',
//             idCongViec: congViec!.id,
//             idNhanVien: '',
//             createBy: congViec!.createBy,
//             groupId: congViec!.groupId,
//             createAt: DateTime.now(),
//             isActive: 1,
//           );
//           context.read<CongViecBloc>().add(
//             EventGetAllNVTH(congViec!.groupId, nvth),
//           );
//         }
//       },
//     ),
//     BlocListener<CongViecBloc, CongViecState>(
//       listener: (context, state) {
//         if (state is StateGetAllNVTHLoaded) {
//           final ids =
//               state.nvths
//                   .expand((e) => e.idNhanVien.split(','))
//                   .map((e) => e.trim())
//                   .toSet();
//           selectedNhanViens =
//               nhanviens.where((e) => ids.contains(e.id)).toList();
//           setState(() {});
//         }
//         if (state is StateLoadCVCByIdCV) {
//           cvcs = state.cvcs;
//           setState(() {});
//         }
//         if (state is StateCongViecError) {
//           if (!mounted) return; // Kiểm tra widget còn trong cây

//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text('Lỗi: ${state.message}')));
//         }
//         if (state is StateLoadCVC) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             if (!mounted) return; // Kiểm tra widget còn trong cây
//             setState(() {
//               cvcs = state.cvcs;
//             });
//           });
//         }
//         if (state is StateDeleteCVC) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Xóa công việc con thành công!')),
//           );
//           //context.read<CongViecBloc>().add(EventGetCongViecByVM(congViec!));
//           context.read<CongViecBloc>().add(EventLoadCVCByIdCV(congViec!.id));
//         }
//         if (state is StateUpdateCVC) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Cập nhật công việc con thành công!')),
//           );
//           //context.read<CongViecBloc>().add(EventGetCongViecByVM(congViec!));
//           context.read<CongViecBloc>().add(EventLoadCVCByIdCV(congViec!.id));
//         }
//         if (state is StateInsertCVC) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Thêm công việc con thành công!')),
//           );
//           // context.read<CongViecBloc>().add(EventGetCongViecByVM(congViec!));
//           context.read<CongViecBloc>().add(EventLoadCVCByIdCV(congViec!.id));
//         }
//       },
//     ),
//     BlocListener<NhomNhanVienBloc, NhomNhanVienState>(
//       listener: (context, state) {
//         if (state is NhomNhanVienLoaded) {
//           nhomNhanViens = state.nhomNhanViens;
//           tenNhom =
//               nhomNhanViens
//                   .firstWhere((e) => e.id == congViec!.nhomCongViec)
//                   .tenNhom;
//           setState(() {});
//         }
//       },
//     ),
//   ];
// }

// /* ======================= UI COMPONENTS ======================= */

// class _InfoCard extends StatelessWidget {
//   final List<Widget> children;
//   const _InfoCard({required this.children});

//   @override
//   Widget build(BuildContext context) {
//     return AppCard(
//       child: Padding(
//         padding: EdgeInsets.all(12),
//         child: Column(children: children),
//       ),
//     );
//   }
// }

// class _InfoItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;

//   const _InfoItem({
//     required this.icon,
//     required this.label,
//     required this.value,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: AppColors.primary(context)),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: Theme.of(context).textTheme.labelMedium?.copyWith(
//                     color: AppColors.onSurfaceVariant(context),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(value),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _InfoRow extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;

//   const _InfoRow({
//     required this.icon,
//     required this.label,
//     required this.value,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       dense: true,
//       contentPadding: EdgeInsets.zero,
//       leading: Icon(icon, color: AppColors.primary(context)),
//       title: Text(label),
//       trailing: Text(value),
//     );
//   }
// }

// class _ProgressRow extends StatelessWidget {
//   final double progress;
//   const _ProgressRow({required this.progress});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Icon(Icons.show_chart, color: AppColors.iconColor(context)),
//             const SizedBox(width: 8),
//             Text(
//               'Tiến độ',
//               style: TextStyle(
//                 color: AppColors.titleColor(context),
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const Spacer(),
//             Text(
//               '${(progress * 100).toInt()}%',
//               style: TextStyle(
//                 color: AppColors.onSurfaceVariant(context),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         LinearProgressIndicator(
//           value: progress,
//           minHeight: 6,
//           borderRadius: BorderRadius.circular(6),
//           backgroundColor: AppColors.surface(context),
//           valueColor: AlwaysStoppedAnimation(AppColors.primary(context)),
//         ),
//       ],
//     );
//   }
// }

// class _NhanVienCard extends StatelessWidget {
//   final List<NhanVienModel> items;
//   const _NhanVienCard(this.items);

//   @override
//   Widget build(BuildContext context) {
//     return _InfoCard(
//       children: [
//         Row(
//           children: [
//             Icon(Icons.people, color: AppColors.primary(context)),
//             const SizedBox(width: 8),
//             const Text('Nhân viên thực hiện'),
//           ],
//         ),
//         const SizedBox(height: 6),
//         Wrap(
//           spacing: 0,
//           runSpacing: 0,
//           children:
//               items
//                   .map(
//                     (e) => Chip(
//                       avatar: Icon(Icons.person, size: 16),
//                       label: Text('${e.tenNhanVien} (${e.taiKhoan})'),
//                     ),
//                   )
//                   .toList(),
//         ),
//       ],
//     );
//   }
// }
