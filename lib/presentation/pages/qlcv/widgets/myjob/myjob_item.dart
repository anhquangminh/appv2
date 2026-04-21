import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/logic/bloc/download/download_bloc.dart';
import 'package:ducanherp/presentation/pages/qlcv/widgets/myjob/myjob_bottomsheet.dart';
import 'package:ducanherp/presentation/widgets/common/app_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
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

class MyJobItem extends StatelessWidget {
  final CongViecModel congViecModel;
  final Future<void> Function() onRefresh;

  const MyJobItem({
    super.key,
    required this.congViecModel,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            constraints.maxWidth == double.infinity || constraints.maxWidth == 0
                ? MediaQuery.of(context).size.width
                : constraints.maxWidth;

        return GestureDetector(
          onTap: () async {
            final result = await _showCongViecModal(
              context,
              congViecModel,
              onRefresh,
            );
            if (result == null) {
              await onRefresh();
            }
          },
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: width,
              child: AppCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _Header(congViecModel, onRefresh),
                      const SizedBox(height: 6),
                      Text(
                        congViecModel.noiDungCongViec,
                        style: Theme.of(context).textTheme.bodySmall,
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
          ),
        );
      },
    );
  }
}

/// ================= HEADER =================
class _Header extends StatelessWidget {
  final CongViecModel model;
  final Future<void> Function() onRefresh;
  const _Header(this.model, this.onRefresh);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.work_outline, color: Colors.blue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.tenCongViec,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),

              Wrap(
                spacing: 12,
                runSpacing: 4,
                children: [
                  JobMetaItem(icon: Icons.repeat, text: model.lapLai),
                  JobMetaItem(
                    icon: Icons.calendar_today_outlined,
                    text:
                        '${model.ngayBatDau.day}/${model.ngayBatDau.month}/${model.ngayBatDau.year}',
                  ),
                ],
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, size: 20, color: context.textSecondary),
          onSelected: (value) async {
            switch (value) {
              case 'detail':
                await _showCongViecModal(context, model, onRefresh);
                break;
            }
          },
          itemBuilder:
              (context) => [
                const PopupMenuItem(
                  value: 'detail',
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 18),
                      SizedBox(width: 8),
                      Text('Chi tiết'),
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
        SizedBox(width: 120, child: AppTag(text: model?.mucDoUuTien ?? '')),
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
          create:
              (_) => NhanVienThucHienBloc(
                repository: NhanVienThucHienRepository(
                  client: RepositoryProvider.of<Client>(context),
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

Future<bool?> _showCongViecModal(
  BuildContext context,
  CongViecModel congViec,
  Future<void> Function()? onRefresh,
) async {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return MultiBlocProvider(
        providers: [BlocProvider.value(value: context.read<DownloadBloc>())],
        child: MyJobBottomSheet(
          congViec: congViec,
          onRefresh: onRefresh,
          rootContext: context, // nếu có
        ),
      );
    },
  );
}
