
// import 'package:ducanherp/core/permissions/permission_helper.dart';
// import 'package:ducanherp/core/permissions/permission_type.dart';
// import 'package:ducanherp/core/themes/app_colors.dart';
// import 'package:ducanherp/data/models/permission_model.dart';
// import 'package:ducanherp/presentation/pages/quanlythanhviennhom/quanlythanhviennhom_page.dart';
// import 'package:ducanherp/presentation/pages/dashboard/giao_viec_tab.dart';
// import 'package:ducanherp/presentation/pages/dashboard/thuc_hien_tab.dart';
// import 'package:ducanherp/presentation/pages/quanlynhanvien/quanlynhanvien_page.dart';
// import 'package:ducanherp/presentation/pages/quanlynhom/quanlynhom_page.dart';
// import 'package:flutter/material.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   int _selectedTabIndex = 0;
//   late Future<List<PermissionModel>> _permissionsFuture;

//   @override
//   void initState() {
//     super.initState();
//     _permissionsFuture = PermissionHelper.getPermissions();
//   }

  // void _onMenuSelected(String value) {
  //   switch (value) {
  //     case 'manage_group':
  //       Navigator.of(
  //         context,
  //       ).push(MaterialPageRoute(builder: (_) => const QuanLyNhomPage()));
  //       break;
  //     case 'group_members':
  //       Navigator.of(context).push(
  //         MaterialPageRoute(builder: (_) => const QuanLyThanhVienNhomPage()),
  //       );
  //       break;
  //     case 'employees':
  //       Navigator.of(
  //         context,
  //       ).push(MaterialPageRoute(builder: (_) => const QuanLyNhanVienPage()));
  //       break;
  //   }
  // }

  // Widget _tabItem(BuildContext context, int index, String title) {
  //   final bool selected = _selectedTabIndex == index;

  //   return Expanded(
  //     child: GestureDetector(
  //       onTap: () {
  //         setState(() => _selectedTabIndex = index);
  //       },
  //       child: AnimatedContainer(
  //         duration: const Duration(milliseconds: 200),
  //         padding: const EdgeInsets.symmetric(vertical: 10),
  //         decoration: BoxDecoration(
  //           color:
  //               selected
  //                   ? AppColors.primaryContainer(context) // xanh nhạt
  //                   : AppColors.card(context), // 🤍 nền trắng
  //           borderRadius: BorderRadius.circular(10),
  //           border: Border.all(
  //             color:
  //                 selected
  //                     ? AppColors.onPrimary(context) // xanh viền
  //                     : AppColors.cardBorder(context), // viền xám nhạt
  //             width: selected ? 1.2 : 1,
  //           ),
  //           boxShadow:
  //               selected
  //                   ? [
  //                     BoxShadow(
  //                       // ignore: deprecated_member_use
  //                       color: AppColors.onPrimary(context).withOpacity(0.15),
  //                       blurRadius: 6,
  //                       offset: const Offset(0, 2),
  //                     ),
  //                   ]
  //                   : [],
  //         ),
  //         alignment: Alignment.center,
  //         child: Text(
  //           title,
  //           style: TextStyle(
  //             fontSize: 14,
  //             fontWeight: FontWeight.w600,
  //             color:
  //                 selected
  //                     ? AppColors.onPrimaryContainer(context)
  //                     : AppColors.onSurfaceVariant(context),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SafeArea(
  //       child: Column(
  //         children: [
            // Padding(
            //   padding: EdgeInsets.fromLTRB(16, 16, 0, 8),
            //   child: Row(
            //     mainAxisSize: MainAxisSize.max,
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       _tabItem(context, 0, "Bạn Đã Giao"),
            //       const SizedBox(width: 10),
            //       _tabItem(context, 1, "Bạn Thực Hiện"),
            //       FutureBuilder<List<PermissionModel>>(
            //         future: _permissionsFuture,
            //         builder: (context, snapshot) {
            //           if (!snapshot.hasData) return const SizedBox.shrink();

            //           final permissions = snapshot.data!;

            //           final canManageEmployees = PermissionHelper.hasPermission(
            //             permissions: permissions,
            //             parentMajorId: '249ff511-8f10-45e8-bf8f-29b0ada5ab84',
            //             majorName: 'Nhân viên',
            //             type: PermissionType.access,
            //           );

            //           final canManageGroup = PermissionHelper.hasPermission(
            //             permissions: permissions,
            //             parentMajorId: '249ff511-8f10-45e8-bf8f-29b0ada5ab84',
            //             majorName: 'Nhóm nhân viên',
            //             type: PermissionType.access,
            //           );

            //           final canManageGroupMembers =
            //               PermissionHelper.hasPermission(
            //                 permissions: permissions,
            //                 parentMajorId:
            //                     '249ff511-8f10-45e8-bf8f-29b0ada5ab84',
            //                 majorName: 'Quản lý nhân viên',
            //                 type: PermissionType.access,
            //               );

            //           final hasAnyPermission =
            //               canManageEmployees ||
            //               canManageGroup ||
            //               canManageGroupMembers;

            //           if (!hasAnyPermission) return const SizedBox(width: 16);

            //           return PopupMenuButton<String>(
            //             icon: Icon(
            //               Icons.more_vert,
            //               color: AppColors.iconColor(context),
            //             ),
            //             onSelected: _onMenuSelected,
            //             padding: EdgeInsets.zero,
            //             itemBuilder:
            //                 (_) => [
            //                   if (canManageEmployees)
            //                     PopupMenuItem(
            //                       value: 'employees',
            //                       child: Row(
            //                         children: [
            //                           Icon(
            //                             Icons.people_outline,
            //                             size: 18,
            //                             color: AppColors.onPrimary(context),
            //                           ),
            //                           const SizedBox(width: 8),
            //                           Text(
            //                             'Nhân viên',
            //                             style: TextStyle(
            //                               fontSize: 13,
            //                               color: AppColors.textColor(context),
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ),

            //                   if (canManageGroup)
            //                     PopupMenuItem(
            //                       value: 'manage_group',
            //                       child: Row(
            //                         children: [
            //                           Icon(
            //                             Icons.groups_2_outlined,
            //                             size: 18,
            //                             color: AppColors.onPrimary(context),
            //                           ),
            //                           const SizedBox(width: 8),
            //                           Text(
            //                             'Quản lý nhóm',
            //                             style: TextStyle(
            //                               fontSize: 13,
            //                               color: AppColors.textColor(context),
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ),

            //                   if (canManageGroupMembers)
            //                     PopupMenuItem(
            //                       value: 'group_members',
            //                       child: Row(
            //                         children: [
            //                           Icon(
            //                             Icons.group_outlined,
            //                             size: 18,
            //                             color: AppColors.onPrimary(context),
            //                           ),
            //                           const SizedBox(width: 8),
            //                           Text(
            //                             'Thành viên nhóm',
            //                             style: TextStyle(
            //                               fontSize: 13,
            //                               color: AppColors.textColor(context),
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                 ],
            //           );
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            // Expanded(
            //   child:
            //       _selectedTabIndex == 0
            //           ? const GiaoViecTab()
            //           : const ThucHienTab(),
            // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
