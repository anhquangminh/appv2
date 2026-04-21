import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ducanherp/data/models/nhanvien_model.dart';
import 'package:ducanherp/logic/bloc/nhanvien/nhanvien_bloc.dart';
import 'package:ducanherp/logic/bloc/nhanvien/nhanvien_state.dart';
import 'package:ducanherp/presentation/widgets/shimmer/list_shimmer.dart';

import 'qlnv_list_item.dart';

class QLNVListView extends StatelessWidget {
  final List<NhanVienModel> filteredList;
  final String? currentUser;
  final VoidCallback onRefresh;
  final Function(NhanVienModel) onEdit;
  final Function(NhanVienModel) onDelete;
  final Function(NhanVienModel, String action) onAction;

  const QLNVListView({
    super.key,
    required this.filteredList,
    required this.currentUser,
    required this.onRefresh,
    required this.onEdit,
    required this.onDelete,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: context.primary,
      backgroundColor: context.surface,
      onRefresh: () async => onRefresh(),
      child: BlocBuilder<NhanVienBloc, NhanVienState>(
        builder: (context, state) {
          // ================= LOADING =================
          if (state is NhanVienLoading) {
            return const ListShimmer(
              key: ValueKey('loadingNhanViens'),
            );
          }

          // ================= SUCCESS =================
          if (state is NhanVienByVMLoaded) {
            final listToShow =
                filteredList.isNotEmpty
                    ? filteredList
                    : state.nhanViens
                        .where((nv) => nv.taiKhoan != currentUser)
                        .toList();

            if (listToShow.isEmpty) {
              return Center(
                child: Text(
                  'Không có nhân viên.',
                  style: TextStyle(
                    color: context.textSecondary,
                    fontSize: 14,
                  ),
                ),
              );
            }

            return ListView.builder(
              key: const ValueKey('loadedNhanViens'),
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: listToShow.length,
              itemBuilder: (context, index) {
                final nv = listToShow[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: QLNVListItem(
                    nhanVien: nv,
                    onTap: () => onEdit(nv),
                    onEdit: () => onEdit(nv),
                    onDelete: () => onDelete(nv),
                    onActionSelected: (action) => onAction(nv, action),
                  ),
                );
              },
            );
          }

          // ================= ERROR =================
          if (state is NhanVienError) {
            return Center(
              child: Text(
                'Lỗi: ${state.message}',
                style: TextStyle(
                  color: context.error,
                  fontSize: 14,
                ),
              ),
            );
          }

          // ================= EMPTY =================
          return const SizedBox.shrink();
        },
      ),
    );
  }
}