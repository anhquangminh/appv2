import 'package:ducanherp/core/utils/file_utils.dart';
import 'package:ducanherp/data/models/congviec_model.dart';
import 'package:ducanherp/data/models/congvieccon_model.dart';
import 'package:ducanherp/data/models/themngay_model.dart';
import 'package:ducanherp/logic/bloc/congviec/congviec_bloc.dart';
import 'package:ducanherp/logic/bloc/congviec/congviec_event.dart';
import 'package:ducanherp/logic/bloc/congviec/congviec_state.dart';
import 'package:ducanherp/logic/bloc/danhgia/danhgia_bloc.dart';
import 'package:ducanherp/logic/bloc/danhgia/danhgia_event.dart';
import 'package:ducanherp/logic/bloc/danhgia/danhgia_state.dart';
import 'package:ducanherp/logic/bloc/download/download_bloc.dart';
import 'package:ducanherp/logic/bloc/download/download_event.dart';
import 'package:ducanherp/logic/bloc/download/download_state.dart';
import 'package:ducanherp/presentation/widgets/inputs/custom_button.dart';
import 'package:ducanherp/presentation/widgets/inputs/custom_text_area.dart';
import 'package:ducanherp/presentation/widgets/inputs/custom_text_form_field.dart';
import 'package:ducanherp/presentation/widgets/toasts/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:open_filex/open_filex.dart';

class MyJobBottomSheet extends StatefulWidget {
  final CongViecModel congViec;
  final Future<void> Function()? onRefresh;
  final BuildContext rootContext;

  const MyJobBottomSheet({
    super.key,
    required this.congViec,
    this.onRefresh,
    required this.rootContext,
  });

  @override
  State<MyJobBottomSheet> createState() => _MyJobBottomSheetState();
}

class _MyJobBottomSheetState extends State<MyJobBottomSheet> {
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  final List<CongViecConModel> _cachedCvcs = [];

  late ThemNgayModel themNgay;
  late int _sliderValue;

  @override
  void initState() {
    super.initState();

    themNgay = ThemNgayModel(
      id: '',
      idCongViec: '',
      idCongViecThemNgay: '',
      soNgay: 0,
      groupId: '',
      createAt: DateTime.now(),
      createBy: '',
      isActive: 1,
    );

    _sliderValue = widget.congViec.tienDo == 0 ? 1 : widget.congViec.tienDo;

    context.read<CongViecBloc>().add(EventLoadCVCByIdCV(widget.congViec.id));

    context.read<DanhGiaBloc>().add(
      LoadDanhGiaByIdCongViecEvent(widget.congViec.id),
    );
  }

  @override
  void dispose() {
    _loading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final congViec = widget.congViec;
    final colors = Theme.of(context).colorScheme;

    return MultiBlocListener(
      listeners: [
        /// ===== UPDATE CÔNG VIỆC =====
        BlocListener<CongViecBloc, CongViecState>(
          listener: (context, state) async {
            if (state is StateCongViecUpdated) {
              _loading.value = false;

              await widget.onRefresh?.call();

              if (mounted) {
                // ignore: use_build_context_synchronously
                Navigator.pop(context, true);
              }

              /// ✅ TOAST THÀNH CÔNG
              showAppToast(
                // ignore: use_build_context_synchronously
                widget.rootContext,
                message: 'Cập nhật công việc thành công',
                icon: Icons.check_circle,
                backgroundColor: Colors.green,
              );
            }

            if (state is StateCongViecError) {
              _loading.value = false;

              /// ❌ TOAST LỖI
              showAppToast(
                // ignore: use_build_context_synchronously
                widget.rootContext,
                message: state.message,
                icon: Icons.error,
                backgroundColor: Colors.red,
              );
            }
          },
        ),

        BlocListener<DownloadBloc, DownloadState>(
          listener: (context, state) {
            /// ===== BẮT ĐẦU TẢI (chỉ 1 lần) =====
            if (state is DownloadInProgress && state.progress < 0.05) {
              showAppToast(
                widget.rootContext,
                message: '⏳ Đang tải file...',
                icon: Icons.download,
                backgroundColor: Colors.blueGrey,
              );
            }
            /// ===== THÀNH CÔNG =====
            else if (state is DownloadSuccess) {
              showAppToast(
                widget.rootContext,
                message: '📥 Tải file thành công',
                icon: Icons.check_circle,
                backgroundColor: Colors.green,
                actionLabel: 'MỞ',
                onAction: () {
                  OpenFilex.open(state.path);
                },
              );
            }
            /// ===== THẤT BẠI =====
            else if (state is DownloadFailure) {
              showAppToast(
                widget.rootContext,
                message: state.error,
                icon: Icons.error,
                backgroundColor: Colors.red,
              );
            }
          },
        ),
      ],
      child: ValueListenableBuilder<bool>(
        valueListenable: _loading,
        builder: (_, isLoading, __) {
          return Stack(
            children: [
              DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.8,
                maxChildSize: 0.95,
                minChildSize: 0.4,
                builder: (_, controller) {
                  return Container(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      20,
                      20,
                      MediaQuery.of(context).viewInsets.bottom + 20,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildHeader(),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: controller,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 12),

                                CustomTextArea(
                                  label: 'Nội dung công việc',
                                  initialValue: congViec.noiDungCongViec,
                                  enabled: false,
                                ),

                                const SizedBox(height: 12),
                                CustomTextFormField(
                                  label: 'Người giao việc',
                                  initialValue: congViec.idNguoiGiaoViec,
                                  enabled: false,
                                ),

                                const SizedBox(height: 12),
                                CustomTextFormField(
                                  label: 'Tên nhóm',
                                  initialValue: congViec.tenNhom,
                                  enabled: false,
                                ),

                                const SizedBox(height: 12),
                                CustomTextFormField(
                                  label: 'Ngày bắt đầu',
                                  initialValue: congViec.ngayBatDau.toString(),
                                  enabled: false,
                                ),

                                const SizedBox(height: 12),
                                CustomTextFormField(
                                  label: 'Ngày kết thúc',
                                  initialValue: congViec.ngayKetThuc.toString(),
                                  enabled: false,
                                ),

                                const SizedBox(height: 16),

                                _buildMainFileRow(context, congViec),

                                const SizedBox(height: 12),

                                /// ===== ĐÁNH GIÁ =====
                                BlocBuilder<DanhGiaBloc, DanhGiaState>(
                                  builder: (_, state) {
                                    if (state is DanhGiaLoadedIdCongViec &&
                                        state.danhGia.id.isNotEmpty) {
                                      return Column(
                                        children: [
                                          CustomTextFormField(
                                            label: 'Được đánh giá',
                                            initialValue:
                                                '${state.danhGia.danhGia}/10',
                                            enabled: false,
                                          ),
                                          const SizedBox(height: 12),
                                          CustomTextFormField(
                                            label: 'Ghi chú',
                                            initialValue: state.danhGia.ghiChu,
                                            enabled: false,
                                          ),
                                        ],
                                      );
                                    }
                                    return const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Text(
                                        'Chưa có đánh giá',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 12),

                                /// ===== SUB TASK TABLE =====
                                _buildSubTaskTable(context),

                                const SizedBox(height: 12),

                                /// ===== TỰ ĐÁNH GIÁ =====
                                TextFormField(
                                  initialValue: congViec.tuDanhGia,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    labelText: 'Tự đánh giá',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onChanged: (v) => congViec.tuDanhGia = v,
                                ),

                                const SizedBox(height: 16),

                                /// ===== SLIDER =====
                                const Text(
                                  'Tiến độ',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Slider(
                                        min: 1,
                                        max: 10,
                                        divisions: 9,
                                        value: _sliderValue.toDouble(),
                                        label: '$_sliderValue / 10',
                                        onChanged: (v) {
                                          setState(() {
                                            _sliderValue = v.round();
                                            congViec.tienDo = _sliderValue;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40,
                                      child: Text(
                                        '$_sliderValue/10',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                /// ===== ACTION =====
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomButton(
                                        label: 'Hủy',
                                        backgroundColor: Colors.grey,
                                        onPressed: () async {
                                          Navigator.pop(context, true);
                                          await widget.onRefresh?.call();
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: CustomButton(
                                        label: 'Lưu',
                                        backgroundColor: Colors.blue,
                                        onPressed: () {
                                          _loading.value = true;
                                          context.read<CongViecBloc>().add(
                                            EventUpdateCongViec(
                                              congViec: congViec,
                                              themNgay: themNgay,
                                              nhanViens: const [],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              if (isLoading)
                Positioned.fill(
                  child: Container(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMainFileRow(BuildContext context, CongViecModel congViec) {
    final hasFile = congViec.fileDinhKem.isNotEmpty;

    if (!hasFile) return const SizedBox.shrink();

    final fileName = congViec.fileDinhKem.split('/').last;
    final isImage = isImageFile(fileName);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Tệp đính kèm:',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        Row(
          children: [
            SizedBox(
              width: 40,
              child: Opacity(
                opacity: isImage ? 1 : 0,
                child: IconButton(
                  tooltip: 'Xem ảnh',
                  icon: const Icon(Icons.image),
                  onPressed:
                      isImage
                          ? () {
                            showImageViewer(
                              context,
                              '${dotenv.env['API_URL']}${congViec.fileDinhKem}',
                            );
                          }
                          : null,
                ),
              ),
            ),
            SizedBox(
              width: 40,
              child: IconButton(
                tooltip: 'Tải xuống',
                icon: const Icon(Icons.download),
                onPressed: () {
                  context.read<DownloadBloc>().add(
                    StartDownload(
                      '${dotenv.env['API_URL']}${congViec.fileDinhKem}',
                      fileName,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// ===== HEADER =====
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Chi tiết công việc',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () async {
            Navigator.pop(context, true);
            await widget.onRefresh?.call();
          },
        ),
      ],
    );
  }

  /// ===== SUB TASK TABLE =====
  Widget _buildSubTaskTable(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocBuilder<CongViecBloc, CongViecState>(
      buildWhen:
          (_, curr) => curr is StateLoadCVCByIdCV || curr is StateUpdateCVC,
      builder: (_, state) {
        if (state is StateLoadCVCByIdCV) {
          _cachedCvcs
            ..clear()
            ..addAll(state.cvcs);
        }

        if (_cachedCvcs.isEmpty) {
          return const SizedBox.shrink();
        }

        return Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: colors.outline),
          ),
          clipBehavior: Clip.antiAlias,
          child: Table(
            columnWidths: const {
              0: FixedColumnWidth(40),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
              3: FixedColumnWidth(80),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                ),
                children: const [
                  _Cell('#', isHeader: true),
                  _Cell('Tên công việc', isHeader: true),
                  _Cell('Tệp', isHeader: true),
                  _Cell('Hoàn thành', isHeader: true),
                ],
              ),
              ..._cachedCvcs.asMap().entries.map((entry) {
                final index = entry.key;
                final cvc = entry.value;

                return TableRow(
                  children: [
                    _Cell('${index + 1}'),
                    _Cell(cvc.noiDungCongViec),
                    _buildFileCell(context, cvc),
                    Center(
                      child: Checkbox(
                        value: cvc.hoanThanh == 1,
                        onChanged: (v) {
                          setState(() {
                            cvc.hoanThanh = v == true ? 1 : 0;
                          });
                          context.read<CongViecBloc>().add(EventUpdateCVC(cvc));
                        },
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFileCell(BuildContext context, CongViecConModel cvc) {
    final hasFile = cvc.fileDinhKem != null && cvc.fileDinhKem!.isNotEmpty;
    final fileName = hasFile ? cvc.fileDinhKem!.split('/').last : '';
    final isImage = hasFile && isImageFile(fileName);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 36,
            child: Opacity(
              opacity: isImage ? 1 : 0,
              child: IconButton(
                icon: const Icon(Icons.image, color: Colors.green),
                onPressed:
                    isImage
                        ? () {
                          showImageViewer(
                            context,
                            '${dotenv.env['API_URL']}${cvc.fileDinhKem}',
                          );
                        }
                        : null,
              ),
            ),
          ),
          SizedBox(
            width: 36,
            child: Opacity(
              opacity: hasFile ? 1 : 0,
              child: IconButton(
                icon: const Icon(Icons.download, color: Colors.blue),
                onPressed:
                    hasFile
                        ? () {
                          context.read<DownloadBloc>().add(
                            StartDownload(
                              '${dotenv.env['API_URL']}${cvc.fileDinhKem}',
                              fileName,
                            ),
                          );
                        }
                        : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ===== CELL =====
class _Cell extends StatelessWidget {
  final String text;
  final bool isHeader;

  const _Cell(this.text, {this.isHeader = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
