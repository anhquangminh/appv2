import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/logic/bloc/nhanvien/nhanvien_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ducanherp/data/models/nhomnhanvien_model.dart';
import 'package:ducanherp/logic/bloc/nhomnhanvien/nhomnhanvien_bloc.dart';
import 'package:ducanherp/presentation/widgets/shimmer/list_shimmer.dart';

import 'nhom_list_item.dart';

class NhomListView extends StatelessWidget {
  final List<NhomNhanVienModel> filteredList;
  final NhomNhanVienModel searchVM;
  final Function(NhomNhanVienModel) onEdit;
  final Function(NhomNhanVienModel) onDelete;
  final Function(NhomNhanVienModel) onOpen;
  final Function(NhomNhanVienModel, String action) onAction;

  const NhomListView({
    super.key,
    required this.filteredList,
    required this.searchVM,
    required this.onEdit,
    required this.onDelete,
    required this.onOpen,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<NhomNhanVienBloc>().add(GetNhomNhanVienByVM(searchVM));
      },
      child: BlocBuilder<NhomNhanVienBloc, NhomNhanVienState>(
        builder: (context, state) {
          if (state is NhanVienLoading) {
            return const ListShimmer(key: ValueKey('loadingNhomNhanViens'));
          }

          if (state is NhomNhanVienVMLoaded) {
            final listToShow =
                filteredList.isNotEmpty ? filteredList : state.nhomNhanViens;

            if (listToShow.isEmpty) {
              return const Center(child: Text('Không có nhóm nào.'));
            }

            return ListView.separated(
              key: const ValueKey('loadedNhomNhanViens'),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: listToShow.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final nnv = listToShow[index];

                return NhomListItem(
                  nhom: nnv,
                  onTap: () => onOpen(nnv),
                  onEdit: () => onEdit(nnv),
                  onDelete: () => onDelete(nnv),
                  onActionSelected: (action) {
                    onAction(nnv, action);
                  },
                );
              },
            );
          }

          if (state is NhomNhanVienError) {
            return Center(
              key: const ValueKey('errorNhomNhanViens'),
              child: Text(
                'Lỗi: ${state.message}',
                style: TextStyle(color: context.error),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
