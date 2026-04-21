// ✅ UI CLEAN + MODERN (Material 3), chart đẹp hơn, không overflow, có legend + spacing chuẩn

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
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SummaryCard(model: model, onTap: _openDanhSachCongViecPage),

          const SizedBox(height: AppSpacing.md),
          _buildTrangThaiBar(report),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(child: _buildDanhGiaDonut(report)),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _buildThoiHanBar(report)),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          _buildUuTienHorizontal(report),
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

  Widget _buildDanhGiaDonut(ReportNVTHModel report) {
    final total = report.danhGia.daDanhGia + report.danhGia.chuaDanhGia;

    if (total == 0) return _emptyCard('Đánh giá');

    return _card(
      'Đánh giá',
      Column(
        children: [
          SizedBox(
            height: 140,
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 40,
                sectionsSpace: 2,
                sections: [
                  PieChartSectionData(
                    value: report.danhGia.daDanhGia.toDouble(),
                    color: context.success,
                    radius: 30,
                    title: '',
                  ),
                  PieChartSectionData(
                    value: report.danhGia.chuaDanhGia.toDouble(),
                    color: context.warning,
                    radius: 30,
                    title: '',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          _legend([
            ('Đã đánh giá', context.success),
            ('Chưa đánh giá', context.warning),
          ]),
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

  final labels = ['Đúng hạn', 'Sắp quá hạn', 'Quá hạn'];

  return _card(
    'Thời hạn',
    SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),

          // ✅ dùng bottomTitles làm labels
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= labels.length) {
                    return const SizedBox();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      labels[index],
                      style: AppTextStyles.small(context),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
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
                  width: 18,
                  borderRadius: BorderRadius.circular(6),
                  color: i == 0
                      ? context.success
                      : i == 1
                          ? context.warning
                          : context.error,
                ),
              ],
            );
          }),
        ),
      ),
    ),
  );
}

  Widget _buildUuTienHorizontal(ReportNVTHModel report) {
    if (report.uuTien.isEmpty) return _emptyCard('Ưu tiên');

    final max = report.uuTien
        .map((e) => e.soLuong)
        .reduce((a, b) => a > b ? a : b);

    return _card(
      'Mức độ ưu tiên',
      Column(
        children:
            report.uuTien.map((e) {
              final percent = max == 0 ? 0 : e.soLuong / max;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.mucDoUuTien, style: AppTextStyles.small(context)),
                    const SizedBox(height: 4),
                    Stack(
                      children: [
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: context.surfaceLow,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: percent.toDouble(),
                          child: Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: _getPriorityColor(e.mucDoUuTien),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  // ===================== UI =====================

  Widget _card(String title, Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surface,
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

  Color _getPriorityColor(String level) {
    switch (level.toLowerCase()) {
      case 'cao':
        return context.error;
      case 'trung bình':
        return context.warning;
      case 'thấp':
        return context.success;
      default:
        return context.info;
    }
  }
}
