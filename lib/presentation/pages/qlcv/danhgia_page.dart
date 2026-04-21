// import 'package:ducanherp/data/models/congvieccon_model.dart';
// import 'package:ducanherp/logic/bloc/congviec/congviec_event.dart';
// import 'package:ducanherp/presentation/widgets/common/app_card.dart';
// import 'package:ducanherp/presentation/widgets/subtask/sub_tasks_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:ducanherp/core/themes/app_colors.dart';
// import 'package:ducanherp/core/helpers/user_storage_helper.dart';
// import 'package:ducanherp/core/utils/date_utils.dart';
// import 'package:ducanherp/presentation/widgets/inputs/custom_text_form_field.dart';

// import '../../../logic/bloc/danhgia/danhgia_bloc.dart';
// import '../../../logic/bloc/danhgia/danhgia_event.dart';
// import '../../../logic/bloc/danhgia/danhgia_state.dart';

// import '../../../logic/bloc/congviec/congviec_bloc.dart';
// import '../../../logic/bloc/congviec/congviec_state.dart';

// import '../../../data/models/application_user.dart';
// import '../../../data/models/congviec_model.dart';
// import '../../../data/models/danhgia_model.dart';

// class DanhGiaPage extends StatefulWidget {
//   final CongViecModel congViec;

//   const DanhGiaPage({super.key, required this.congViec});

//   @override
//   State<DanhGiaPage> createState() => _DanhGiaState();
// }

// class _DanhGiaState extends State<DanhGiaPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _ghiChuController = TextEditingController();
//   final ValueNotifier<bool> _loadingNotifier = ValueNotifier(false);

//   ApplicationUser? user;

//   /// ===== DANH SÁCH CÔNG VIỆC CON =====
//   List<CongViecConModel> cvcs = [];

//   late DanhGiaModel danhgia = DanhGiaModel(
//     id: '',
//     idCongViec: '',
//     danhGia: 0,
//     groupId: '',
//     createAt: DateTime.now(),
//     createBy: '',
//     isActive: 1,
//   );

//   @override
//   void initState() {
//     super.initState();
//     _initData();
//   }

//   Future<void> _initData() async {
//     user = await UserStorageHelper.getCachedUserInfo();
//     if (user == null) return;

//     danhgia = danhgia.copyWith(
//       idCongViec: widget.congViec.id,
//       groupId: user!.groupId,
//       createBy: user!.userName,
//     );

//     // Load đánh giá
//     // ignore: use_build_context_synchronously
//     context.read<DanhGiaBloc>().add(
//       LoadDanhGiaByIdCongViecEvent(widget.congViec.id),
//     );
//     // ignore: use_build_context_synchronously
//     context.read<CongViecBloc>().add(EventGetCongViecById(widget.congViec.id));
//     // ignore: use_build_context_synchronously
//     context.read<CongViecBloc>().add(EventLoadCVCByIdCV(widget.congViec.id));
//   }

//   // ================= UI COMPONENT =================

//   Widget _infoTile(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 130,
//             child: Text(
//               label,
//               style: const TextStyle(fontWeight: FontWeight.w600),
//             ),
//           ),
//           Expanded(child: Text(value)),
//         ],
//       ),
//     );
//   }
//   // ================= BUILD =================

//   @override
//   Widget build(BuildContext context) {
//     final congviecBloc = context.read<CongViecBloc>();

//     return Scaffold(
//       backgroundColor: AppColors.background(context),
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
//           'Đánh giá',
//           style: Theme.of(context).textTheme.titleMedium?.copyWith(
//             fontWeight: FontWeight.bold,
//             color: AppColors.onPrimary(context),
//           ),
//         ),
//       ),

//       /// ===== LISTEN CÔNG VIỆC CON =====
//       body: BlocListener<CongViecBloc, CongViecState>(
//         listener: (context, state) {
//           if (state is StateLoadCVCByIdCV) {
//             cvcs = state.cvcs;
//             setState(() {});
//           }
//         },
//         child: GestureDetector(
//           onTap: () => FocusScope.of(context).unfocus(),
//           child: ValueListenableBuilder<bool>(
//             valueListenable: _loadingNotifier,
//             builder: (_, isLoading, __) {
//               return Stack(
//                 children: [
//                   ListView(
//                     children: [
//                       // ====== THÔNG TIN CÔNG VIỆC ======
//                       AppCard(
//                         child: Padding(
//                           padding: EdgeInsets.all(12),
//                           child: Column(
//                             children: [
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.wb_incandescent_outlined,
//                                     color: AppColors.primary(context),
//                                   ),
//                                   const SizedBox(width: 6),
//                                   Text(
//                                     'Thông tin công việc',
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                       color: AppColors.titleColor(context),
//                                     ),
//                                   ),
//                                 ],
//                               ),

//                               _infoTile(
//                                 'Người giao việc',
//                                 widget.congViec.idNguoiGiaoViec,
//                               ),
//                               _infoTile('Tên nhóm', widget.congViec.tenNhom),
//                               _infoTile(
//                                 'Nhân viên',
//                                 widget.congViec.nguoiThucHien,
//                               ),
//                               _infoTile(
//                                 'Tên công việc',
//                                 widget.congViec.tenCongViec,
//                               ),
//                               _infoTile(
//                                 'Nội dung',
//                                 widget.congViec.noiDungCongViec,
//                               ),
//                               _infoTile(
//                                 'Thời gian',
//                                 '${DateUtilsHelper.formatDateCustom(widget.congViec.ngayBatDau, "dd/MM/yy")} - '
//                                     '${DateUtilsHelper.formatDateCustom(widget.congViec.ngayKetThuc, "dd/MM/yy")}',
//                               ),
//                               _infoTile('Ưu tiên', widget.congViec.mucDoUuTien),
//                               _infoTile(
//                                 'Tiến độ',
//                                 widget.congViec.tienDo.toString(),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // ====== CÔNG VIỆC CON ======
//                       if (cvcs.isNotEmpty)
//                         SubTasksWidget(
//                           congViec: widget.congViec,
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
//                               EventDeleteCVC(id, widget.congViec.createBy),
//                             );
//                           },
//                           onFileSelected: (file, task) {
//                             congviecBloc.add(EventUploadFile(file));
//                           },
//                         ),
//                       SizedBox(height: 8),
//                       // ====== ĐÁNH GIÁ ======
//                       AppCard(
//                         child: Form(
//                           key: _formKey,
//                           child: Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 /// TITLE
//                                 Row(
//                                   children: [
//                                     Icon(
//                                       Icons.star_rounded,
//                                       color: AppColors.primary(context),
//                                     ),
//                                     const SizedBox(width: 6),
//                                     Text(
//                                       'Đánh giá công việc',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w600,
//                                         color: AppColors.titleColor(context),
//                                       ),
//                                     ),
//                                   ],
//                                 ),

//                                 const SizedBox(height: 16),

//                                 /// SLIDER LABEL
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       'Mức đánh giá',
//                                       style: TextStyle(
//                                         fontSize: 13,
//                                         color: AppColors.subTextColor(context),
//                                       ),
//                                     ),
//                                     Container(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 8,
//                                         vertical: 2,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: AppColors.primary(
//                                           context,
//                                           // ignore: deprecated_member_use
//                                         ).withOpacity(0.12),
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                       child: Text(
//                                         '${danhgia.danhGia}/10',
//                                         style: TextStyle(
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w600,
//                                           color: AppColors.primary(context),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),

//                                 /// SLIDER
//                                 SliderTheme(
//                                   data: SliderTheme.of(context).copyWith(
//                                     trackHeight: 4,
//                                     thumbShape: const RoundSliderThumbShape(
//                                       enabledThumbRadius: 8,
//                                     ),
//                                     overlayShape: const RoundSliderOverlayShape(
//                                       overlayRadius: 16,
//                                     ),
//                                   ),
//                                   child: Slider(
//                                     min: 1,
//                                     max: 10,
//                                     divisions: 9,
//                                     value:
//                                         (danhgia.danhGia == 0
//                                                 ? 5
//                                                 : danhgia.danhGia)
//                                             .toDouble(),
//                                     activeColor: AppColors.primary(context),
//                                     inactiveColor: AppColors.outline(context),
//                                     onChanged: (value) {
//                                       setState(() {
//                                         danhgia = danhgia.copyWith(
//                                           danhGia: value.round(),
//                                         );
//                                       });
//                                     },
//                                   ),
//                                 ),

//                                 const SizedBox(height: 12),

//                                 /// NOTE
//                                 CustomTextFormField(
//                                   label: 'Ghi chú',
//                                   controller: _ghiChuController,
//                                   maxLines: 4,
//                                 ),

//                                 const SizedBox(height: 20),

//                                 /// SUBMIT BUTTON
//                                 BlocConsumer<DanhGiaBloc, DanhGiaState>(
//                                   listener: (context, state) {
//                                     if (state is DanhGiaLoadedIdCongViec) {
//                                       danhgia = state.danhGia;
//                                       _ghiChuController.text =
//                                           danhgia.ghiChu ?? '';
//                                       _loadingNotifier.value = false;
//                                     } else if (state is DanhGiaSuccess) {
//                                       _loadingNotifier.value = false;
//                                       Navigator.pop(context, true);
//                                     } else if (state is DanhGiaError) {
//                                       _loadingNotifier.value = false;
//                                       ScaffoldMessenger.of(
//                                         context,
//                                       ).showSnackBar(
//                                         SnackBar(content: Text(state.message)),
//                                       );
//                                     }
//                                   },
//                                   builder: (_, __) {
//                                     return SizedBox(
//                                       width: double.infinity,
//                                       child: ElevatedButton.icon(
//                                         style: ElevatedButton.styleFrom(
//                                           padding: const EdgeInsets.symmetric(
//                                             vertical: 12,
//                                           ),
//                                           backgroundColor: AppColors.primary(
//                                             context,
//                                           ),
//                                           foregroundColor: AppColors.onPrimary(
//                                             context,
//                                           ),
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(
//                                               12,
//                                             ),
//                                           ),
//                                         ),
//                                         icon: const Icon(
//                                           Icons.send_rounded,
//                                           size: 18,
//                                         ),
//                                         label: const Text(
//                                           'Gửi đánh giá',
//                                           style: TextStyle(
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                         onPressed: () {
//                                           danhgia = danhgia.copyWith(
//                                             ghiChu: _ghiChuController.text,
//                                           );
//                                           _loadingNotifier.value = true;

//                                           if (danhgia.id.isEmpty) {
//                                             context.read<DanhGiaBloc>().add(
//                                               CreateDanhGiaEvent(
//                                                 model: danhgia,
//                                                 userName: user!.userName,
//                                               ),
//                                             );
//                                           } else {
//                                             context.read<DanhGiaBloc>().add(
//                                               UpdateDanhGiaEvent(
//                                                 model: danhgia,
//                                                 userName: user!.userName,
//                                               ),
//                                             );
//                                           }
//                                         },
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                     ],
//                   ),

//                   if (isLoading)
//                     Container(
//                       // ignore: deprecated_member_use
//                       color: Colors.black.withOpacity(0.3),
//                       child: const Center(child: CircularProgressIndicator()),
//                     ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
