// import 'package:ducanherp/data/models/quanlynhanvien_model.dart';
// import 'package:ducanherp/presentation/widgets/common/app_card.dart';
// import 'package:flutter/material.dart';
// import 'package:ducanherp/common/fa_icons.dart';
// import 'package:ducanherp/core/themes/app_colors.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class QLTVListItem extends StatelessWidget {
//   final QuanLyNhanVienModel qltv;
//   final VoidCallback onDelete;
//   final Function(String action) onActionSelected;

//   const QLTVListItem({
//     super.key,
//     required this.qltv,
//     required this.onDelete,
//     required this.onActionSelected,
//   });

//   IconData _getGroupIcon(String? iconName) {
//     if (iconName == null || iconName.isEmpty) {
//       return FontAwesomeIcons.users;
//     }
//     return faIcons[iconName] ?? FontAwesomeIcons.users;
//   }

//   @override
//   Widget build(BuildContext context) {
//     String statusText;
//     Color statusColor;

//     switch (qltv.isActive) {
//       case 3:
//         statusText = 'Đã duyệt';
//         statusColor = Colors.green;
//         break;
//       case 0:
//         statusText = 'Chờ duyệt thêm';
//         statusColor = Colors.grey;
//         break;
//       case 1:
//         statusText = 'Chờ duyệt sửa';
//         statusColor = Colors.orange;
//         break;
//       case 2:
//         statusText = 'Chờ duyệt xóa';
//         statusColor = Colors.red;
//         break;
//       case 90:
//         statusText = 'Không duyệt';
//         statusColor = Colors.red;
//         break;
//       default:
//         statusText = 'Không rõ';
//         statusColor = Colors.grey;
//     }

//     return AppCard(
//       child: InkWell(
//         borderRadius: BorderRadius.circular(10),
    
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         const Icon(
//                           Icons.home_work_outlined,
//                           size: 12,
//                           color: Colors.grey,
//                         ),
//                         const SizedBox(width: 4),
//                         Expanded(
//                           child: Text(
//                             qltv.companyName.isNotEmpty
//                                 ? qltv.companyName
//                                 : '-',
//                             style: TextStyle(
                              
//                               color: AppColors.textColor(context),
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 2),
//                     Row(
//                       children: [
//                         FaIcon(
//                           _getGroupIcon(qltv.iconName),
//                           color: Colors.grey,
//                           size: 12,
//                         ),
//                         const SizedBox(width: 6),
//                         Text(
//                           qltv.tenNhom.isNotEmpty ? qltv.tenNhom : '.',
//                           style: TextStyle(
                              
//                               color: AppColors.textColor(context),
//                             ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 2),
    
//                     Row(
//                       children: [
//                         const Icon(
//                           Icons.people,
//                           size: 12,
//                           color: Colors.grey,
//                         ),
//                         const SizedBox(width: 6),
//                         Expanded(
//                           child: Text(
//                             qltv.tenNhanVien.isNotEmpty
//                                 ? '${qltv.tenNhanVien} (${qltv.taiKhoan})'
//                                 : '-',
//                             style: TextStyle(
                              
//                               color: AppColors.textColor(context),
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 2),
//                     Row(
//                       children: [
//                         const Icon(
//                           Icons.info_outlined,
//                           size: 12,
//                           color: Colors.grey,
//                         ),
//                         const SizedBox(width: 6),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 6,
//                             vertical: 3,
//                           ),
//                           decoration: BoxDecoration(
//                             // ignore: deprecated_member_use
//                             color: statusColor.withOpacity(0.12),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             statusText,
//                             style: TextStyle(
//                               color: statusColor,
                              
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               PopupMenuButton<String>(
//                 icon: const Icon(Icons.more_vert),
//                 onSelected: (action) {
//                   switch (action) {
//                     case 'delete':
//                       onDelete();
//                       break;
//                     default:
//                       onActionSelected(action);
//                       break;
//                   }
//                 },
//                 itemBuilder: (ctx) {
//                   final isApproved = qltv.isActive == 3;
//                   final items = <PopupMenuEntry<String>>[];
    
//                   items.add(
//                     PopupMenuItem(
//                       value: 'delete',
//                       child: Row(
//                         children: const [
//                           Icon(Icons.delete, size: 18, color: Colors.red),
//                           SizedBox(width: 8),
//                           Text('Xóa'),
//                         ],
//                       ),
//                     ),
//                   );
    
//                   if (!isApproved) {
//                     items.add(const PopupMenuDivider());
//                     items.add(
//                       const PopupMenuItem(
//                         value: 'approve',
//                         child: Row(
//                           children: [
//                             Icon(Icons.check, size: 18, color: Colors.green),
//                             SizedBox(width: 8),
//                             Text('Duyệt'),
//                           ],
//                         ),
//                       ),
//                     );
//                     items.add(
//                       const PopupMenuItem(
//                         value: 'unapprove',
//                         child: Row(
//                           children: [
//                             Icon(Icons.undo, size: 18, color: Colors.orange),
//                             SizedBox(width: 8),
//                             Text('Hủy duyệt'),
//                           ],
//                         ),
//                       ),
//                     );
//                   }
    
//                   return items;
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
