import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/logic/bloc/congviec/congviec_bloc.dart';
import 'package:ducanherp/logic/bloc/congviec/congviec_event.dart';
import 'package:ducanherp/presentation/widgets/common/app_card.dart';
import 'package:ducanherp/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ducanherp/data/models/congviec_model.dart';
import 'package:ducanherp/logic/bloc/nhanvien/nhanvienthuchien_bloc.dart';
import 'package:ducanherp/logic/bloc/nhanvien/nhanvienthuchien_event.dart';
import 'package:ducanherp/logic/bloc/nhanvien/nhanvienthuchien_state.dart';
import 'package:ducanherp/logic/bloc/nhanvien/nhanvienthuchien_repository.dart';

import 'package:ducanherp/presentation/widgets/avatar/avatar_stack.dart';
import 'package:ducanherp/presentation/pages/qlcv/widgets/job/job_meta_item.dart';
import 'package:ducanherp/presentation/pages/qlcv/widgets/job/job_time_range.dart';
import 'package:ducanherp/presentation/widgets/progress/build_job_progress.dart';
import 'package:ducanherp/presentation/widgets/tags/app_tag.dart';

class JobItem extends StatelessWidget {
  final CongViecModel? congViecModel;

  const JobItem({super.key, this.congViecModel});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            constraints.maxWidth == double.infinity || constraints.maxWidth == 0
                ? MediaQuery.of(context).size.width
                : constraints.maxWidth;

        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: width,
            child: AppCard(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRouter.congViecDetailPage,
                  arguments: {'id': congViecModel?.id},
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Header(congViecModel),
                    const SizedBox(height: 6),
                    Text(
                      congViecModel?.noiDungCongViec ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 12),
                    _ProgressRow(congViecModel),
                    Divider(
                      height: 24,
                      thickness: 0.6,
                      color: context.border,
                    ),
                    _Footer(congViecModel),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// ================= HEADER =================
class _Header extends StatelessWidget {
  final CongViecModel? model;
  const _Header(this.model);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: context.opacity(context.primary, 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.work_outline,
            color: context.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model?.tenCongViec ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: context.textPrimary,
                    ),
              ),
              Wrap(
                spacing: 12,
                runSpacing: 4,
                children: [
                  JobMetaItem(
                    icon: Icons.repeat,
                    text: model?.lapLai ?? 'Không lặp',
                  ),
                  JobMetaItem(
                    icon: Icons.calendar_today_outlined,
                    text: model != null
                        ? '${model!.ngayBatDau.day}/${model!.ngayBatDau.month}/${model!.ngayBatDau.year}'
                        : '--/--/--',
                  ),
                ],
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert,
            size: 20,
            color: context.textSecondary,
          ),
          onSelected: (value) async {
            switch (value) {
              case 'detail':
                Navigator.pushNamed(
                  context,
                  AppRouter.congViecDetailPage,
                  arguments: {'id': model?.id},
                );
                break;

              case 'edit':
                Navigator.pushNamed(
                  context,
                  AppRouter.addThemCongViec,
                  arguments: {'congViec': model},
                );
                break;

              case 'delete':
                final congViecBloc = context.read<CongViecBloc>();

                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    backgroundColor: context.surface,
                    title: Text(
                      'Xác nhận xóa',
                      style: TextStyle(color: context.textPrimary),
                    ),
                    content: Text(
                      'Bạn có chắc chắn muốn xóa công việc "${model!.tenCongViec}"?',
                      style: TextStyle(color: context.textSecondary),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(dialogContext, false),
                        child: Text(
                          'Hủy',
                          style: TextStyle(color: context.textSecondary),
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(dialogContext, true),
                        child: Text(
                          'Xóa',
                          style: TextStyle(color: context.error),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  congViecBloc.add(EventDeleteCongViec(model!.id));
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      // ignore: use_build_context_synchronously
                      backgroundColor: context.surface,
                      content: Text(
                        'Đã xóa công việc',
                        // ignore: use_build_context_synchronously
                        style: TextStyle(color: context.textPrimary),
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
                break;

              case 'rate':
                Navigator.pushNamed(
                  context,
                  AppRouter.danhGiaCongViec,
                  arguments: {'congViec': model},
                );
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'detail',
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 18, color: context.textPrimary),
                  const SizedBox(width: 8),
                  Text('Chi tiết',
                      style: TextStyle(color: context.textPrimary)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, size: 18, color: context.textPrimary),
                  const SizedBox(width: 8),
                  Text('Sửa',
                      style: TextStyle(color: context.textPrimary)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline,
                      size: 18, color: context.error),
                  const SizedBox(width: 8),
                  Text('Xóa',
                      style: TextStyle(color: context.error)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'rate',
              child: Row(
                children: [
                  Icon(Icons.star_border,
                      size: 18, color: context.warning),
                  const SizedBox(width: 8),
                  Text('Đánh giá',
                      style: TextStyle(color: context.textPrimary)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// ================= PROGRESS =================
class _ProgressRow extends StatelessWidget {
  final CongViecModel? model;
  const _ProgressRow(this.model);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: buildJobProgress(context, model?.tienDo ?? 0)),
        const SizedBox(width: 12),
        SizedBox(
          width: 120,
          child: AppTag(text: model?.mucDoUuTien ?? ''),
        ),
      ],
    );
  }
}

/// ================= FOOTER =================
class _Footer extends StatelessWidget {
  final CongViecModel? model;
  const _Footer(this.model);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlocProvider(
          create: (_) => NhanVienThucHienBloc(
            repository: NhanVienThucHienRepository(
              client: RepositoryProvider.of<http.Client>(context),
              prefs: RepositoryProvider.of<SharedPreferences>(context),
            ),
          )..add(
              FetchNhanVienThucHien(
                congViecId: model?.id ?? '',
                groupId: model?.groupId ?? '',
              ),
            ),
          child: BlocBuilder<NhanVienThucHienBloc, NhanVienThucHienState>(
            builder: (_, state) {
              if (state is NhanVienThucHienLoaded) {
                return AvatarStack(nhanViens: state.nhanViens);
              }
              return const SizedBox(width: 36, height: 36);
            },
          ),
        ),
        const Spacer(),
        JobTimeRange(date: model?.ngayKetThuc),
      ],
    );
  }
}