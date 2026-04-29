import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ducanherp/data/models/quanlynhanvien_model.dart';
import 'package:ducanherp/logic/bloc/nhanvien/nhanvien_state.dart';
import 'package:ducanherp/logic/bloc/quanlynhanvien/quanlynhanvien_bloc.dart';
import 'package:ducanherp/presentation/widgets/shimmer/list_shimmer.dart';
import 'qltv_list_item.dart';

class QLTVListView extends StatelessWidget {
  final List<QuanLyNhanVienModel> filteredList;
  final QuanLyNhanVienModel searchVM;
  final Function(QuanLyNhanVienModel) onDelete;
  final Function(QuanLyNhanVienModel) onOpen;
  final Function(QuanLyNhanVienModel, String action) onAction;

  const QLTVListView({
    super.key,
    required this.filteredList,
    required this.searchVM,
    required this.onDelete,
    required this.onOpen,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<QuanLyNhanVienBloc>().add(
              GetQuanLyNhanVienByVM(searchVM),
            );
      },
      child: BlocBuilder<QuanLyNhanVienBloc, QuanLyNhanVienState>(
        builder: (context, state) {
          /// LOADING
          if (state is NhanVienLoading) {
            return const ListShimmer(
              key: ValueKey('loadingQuanLyNhanViens'),
            );
          }

          /// LOADED
          if (state is QuanLyNhanVienVMLoaded) {
            final listToShow = filteredList;

            if (listToShow.isEmpty) {
              return const Center(
                child: Text('Không có dữ kiệu.'),
              );
            }

            return ListView.builder(
              key: const ValueKey('loadedQuanLyNhanViens'),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: listToShow.length,
              itemBuilder: (context, index) {
                final qltv = listToShow[index];
            
                return QLTVListItem(
                  qltv: qltv,
                  onDelete: () => onDelete(qltv),
                  onActionSelected: (action) {
                    onAction(qltv, action);
                  },
                );
              },
            );
          }

          /// ERROR
          if (state is QuanLyNhanVienError) {
            return Center(
              key: const ValueKey('errorQuanLyNhanViens'),
              child: Text(
                'Lỗi: ${state.message}',
              
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
