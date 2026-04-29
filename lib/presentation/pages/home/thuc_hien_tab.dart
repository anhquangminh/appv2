// ✅ UI CLEAN + MODERN (Material 3), chart đẹp hơn, không overflow, có legend + spacing chuẩn

import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_shadows.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_text_styles.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/data/models/report_nvth_model.dart';
import 'package:ducanherp/data/models/status_report_model.dart';
import 'package:ducanherp/logic/bloc/congviecdg/report_nvth_bloc.dart';
import 'package:ducanherp/logic/bloc/congviecdg/report_nvth_event.dart';
import 'package:ducanherp/logic/bloc/congviecdg/report_nvth_repository.dart';
import 'package:ducanherp/logic/bloc/congviecdg/report_nvth_state.dart';
import 'package:ducanherp/presentation/pages/home/widgets/summary_card.dart';
import 'package:ducanherp/presentation/pages/qlcv/dscvduocgiao_page.dart';
import 'package:ducanherp/presentation/widgets/shimmer/thuc_hien_tab_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

import 'package:ducanherp/core/helpers/user_storage_helper.dart';
import 'package:ducanherp/data/models/application_user.dart';

class ThucHienTab extends StatefulWidget {
  const ThucHienTab({super.key});

  @override
  State<ThucHienTab> createState() => _ThucHienTabState();
}

class _ThucHienTabState extends State<ThucHienTab> {
  ApplicationUser? user;

  late ReportNVTHBloc _reportBloc;
  ReportNVTHRepository? _reportRepository;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _initBloc();
  }

  Future<void> _loadUser() async {
    final cachedUser = await UserStorageHelper.getCachedUserInfo();
    if (!mounted || cachedUser == null) return;
    setState(() => user = cachedUser);
  }

  Future<void> _initBloc() async {
    final prefs = await SharedPreferences.getInstance();

    _reportRepository = ReportNVTHRepository(
      client: http.Client(),
      prefs: prefs,
    );

    _reportBloc = ReportNVTHBloc(repository: _reportRepository!);

    final cachedUser = await UserStorageHelper.getCachedUserInfo();
    if (!mounted || cachedUser == null) return;

    _reportBloc.add(
      FetchReportNVTH(
        groupId: cachedUser.groupId,
        taiKhoan: cachedUser.userName,
      ),
    );

    setState(() {});
  }

  @override
  void dispose() {
    _reportBloc.close();
    super.dispose();
  }

  Future<void> _openDanhSachCongViecPage() async {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => DSCVDuocGiaoPage()));
  }

  @override
  Widget build(BuildContext context) {
    if (user == null || _reportRepository == null) {
      return ThucHienTabShimmer();
    }

    return BlocProvider(
      create: (_) => _reportBloc,
      child: BlocBuilder<ReportNVTHBloc, ReportNVTHState>(
        builder: (context, state) {
          if (state is ReportNVTHLoading) {
            return ThucHienTabShimmer();
          }
          if (state is ReportNVTHError) {
            return Center(child: Text(state.message));
          }
          if (state is ReportNVTHLoaded) {
            return _buildContent(state.data);
          }
          return const SizedBox();
        },
      ),
    );
  }

  // ===================== CONTENT =====================

  Widget _buildContent(ReportNVTHModel report) {
    final model = StatusReportModel(
      cho: report.trangThai.cho,
      hoanThanh: report.trangThai.hoanThanh,
      chuaLam: report.trangThai.chuaLam,
      quaHan: report.trangThai.quaHan,
      tongSo: report.trangThai.tongSo,
      dangThucHien: report.trangThai.dangThucHien,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SummaryCard(model: model, onTap: _openDanhSachCongViecPage),
          SizedBox(height: 16),
          _buildTrangThaiBar(report),
          SizedBox(height: 16),
          _buildChartsRow(report),
          SizedBox(height: 16),
          _buildUuTienHorizontal(report),
           SizedBox(height: 80),
        ],
      ),
    );
  }

  // ===================== CHART =====================
  Widget _buildTrangThaiBar(ReportNVTHModel report) {
    final data = [
      report.trangThai.hoanThanh.toDouble(),
      report.trangThai.dangThucHien.toDouble(),
      report.trangThai.cho.toDouble(),
      report.trangThai.chuaLam.toDouble(),
      report.trangThai.quaHan.toDouble(),
    ];

    final labels = ['Hoàn thành', 'ĐTH', 'Chờ', 'Chưa làm', 'Quá hạn'];

    return _card(
      'Trạng thái công việc',
      Column(
        children: [
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget:
                          (v, _) => Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              labels[v.toInt()],
                              style: AppTextStyles.small(context),
                            ),
                          ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),

                barGroups: List.generate(data.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: data[i],
                        width: 14,
                        borderRadius: BorderRadius.circular(6),
                        color: _barColor(i),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _legend([
            ('Hoàn thành', context.success),
            ('Đang làm', context.info),
            ('Chờ', context.warning),
            ('Chưa làm', context.textSecondary),
            ('Quá hạn', context.error),
          ]),
        ],
      ),
    );
  }

  Widget _buildChartsRow(ReportNVTHModel report) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // Giúp các card cao bằng nhau
        children: [
          Expanded(child: _buildDanhGiaDonut(report)),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: _buildThoiHanBar(report)),
        ],
      ),
    );
  }

  Widget _buildDanhGiaDonut(ReportNVTHModel report) {
    final total = report.danhGia.daDanhGia + report.danhGia.chuaDanhGia;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.surfaceHighest,
        borderRadius: AppRadius.xlRadius,
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ĐÁNH GIÁ',
            style: context.theme.textTheme.labelMedium?.copyWith(
              color: context.textSecondary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (total == 0)
            const SizedBox(height: 140, child: Center(child: Text("Trống")))
          else
            // ✅ Giải pháp: Thay Expanded bằng SizedBox có height cố định
            SizedBox(
              height: 140,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 30,
                  sectionsSpace: 4,
                  sections: [
                    PieChartSectionData(
                      value: report.danhGia.daDanhGia.toDouble(),
                      color: context.success,
                      radius: 18,
                      title: '',
                    ),
                    PieChartSectionData(
                      value: report.danhGia.chuaDanhGia.toDouble(),
                      color: context.warning,
                      radius: 18,
                      title: '',
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          _legend([('Đã xong', context.success), ('Chưa', context.warning)]),
        ],
      ),
    );
  }

  Widget _buildThoiHanBar(ReportNVTHModel report) {
    final data = [
      report.thoiHan.dungHan.toDouble(),
      report.thoiHan.sapQuaHan.toDouble(),
      report.thoiHan.quaHan.toDouble(),
    ];

    final labels = ['Đúng', 'Sắp', 'Trễ'];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.surfaceHighest,
        borderRadius: AppRadius.xlRadius,
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'THỜI HẠN',
            style: context.theme.textTheme.labelMedium?.copyWith(
              color: context.textSecondary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // ✅ Giải pháp: Đặt cùng một height (140) để đảm bảo cân bằng
          SizedBox(
            height: 140,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= labels.length) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs),
                          child: Text(
                            labels[index],
                            style: AppTextStyles.small(
                              context,
                            ).copyWith(fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                barGroups: List.generate(data.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: data[i],
                        width: 12,
                        borderRadius: AppRadius.pillRadius,
                        color:
                            i == 0
                                ? context.success
                                : i == 1
                                ? context.warning
                                : context.error,
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY:
                              (data.reduce((a, b) => a > b ? a : b) + 1)
                                  .toDouble(),
                          color: context.surfaceLow,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Thêm một spacer mờ để cân bằng với phần legend của chart bên trái
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildUuTienHorizontal(ReportNVTHModel report) {
    if (report.uuTien.isEmpty) return _emptyCard('Ưu tiên');

    // Tìm giá trị max để tính toán tỷ lệ phần trăm hiển thị
    final maxCount = report.uuTien
        .map((e) => e.soLuong)
        .fold(0, (a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.surfaceHighest,
        borderRadius: AppRadius.xlRadius,
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MỨC ĐỘ ƯU TIÊN',
            style: context.theme.textTheme.labelMedium?.copyWith(
              color: context.textSecondary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Column(
            children:
                report.uuTien.map((e) {
                  final double percent =
                      maxCount == 0 ? 0 : e.soLuong / maxCount;
                  final Color priorityColor = _getPriorityColor(e.mucDoUuTien);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.mucDoUuTien,
                              style: AppTextStyles.small(context).copyWith(
                                color: context.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              e.soLuong.toString(),
                              style: AppTextStyles.small(context).copyWith(
                                color: priorityColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        ClipRRect(
                          borderRadius: AppRadius.pillRadius,
                          child: LinearProgressIndicator(
                            value: percent,
                            minHeight: 8,
                            backgroundColor: context.surfaceLow,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              priorityColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  /// Helper để mapping màu sắc theo Design System
  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'khẩn cấp':
      case 'cao':
        return context.error;
      case 'trung bình':
        return context.warning;
      case 'thấp':
        return context.success;
      default:
        return context.primary;
    }
  }

  // ===================== UI =====================
  Widget _card(String title, Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surfaceHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.title(context)),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }

  Widget _legend(List<(String, Color)> items) {
    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children:
          items.map((e) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: e.$2,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(e.$1, style: AppTextStyles.small(context)),
              ],
            );
          }).toList(),
    );
  }

  Widget _emptyCard(String title) {
    return _card(
      title,
      SizedBox(
        height: 140,
        child: Center(
          child: Text(
            'Không có dữ liệu',
            style: AppTextStyles.caption(context),
          ),
        ),
      ),
    );
  }
  // ===================== COLORS =====================

  Color _barColor(int i) {
    switch (i) {
      case 0:
        return context.success;
      case 1:
        return context.info;
      case 2:
        return context.warning;
      case 3:
        return context.textSecondary;
      default:
        return context.error;
    }
  }

}
