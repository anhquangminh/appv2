// import 'package:ducanherp/data/models/congviec_model.dart';
// import 'package:ducanherp/presentation/pages/qlcv/widgets/myjob/list_item_duoc_giao.dart';
// import 'package:flutter/material.dart';


// class ListCongViecDuocGiao extends StatelessWidget {
//   final List<CongViecModel> items;
//   final Future<void> Function() onRefresh;

//   const ListCongViecDuocGiao({
//     super.key,
//     required this.items,
//     required this.onRefresh,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: onRefresh,
//       child: ListView.builder(
//         padding: const EdgeInsets.only(bottom: 50),
//         itemCount: items.length,
//         itemBuilder: (context, index) {
//           final item = items[index];
//           return ListItemDuocGiao(
//             congViec: item,
//             onRefresh: onRefresh
//           );
//         },
//       ),
//     );
//   }
// }
