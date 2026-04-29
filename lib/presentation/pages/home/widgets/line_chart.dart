import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/core/themes/app_shadows.dart';
import 'package:ducanherp/data/models/status_report_model.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatefulWidget {
  final StatusReportModel status;

  const LineChartWidget({super.key, required this.status});

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  int? _tappedIndex;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Tăng thời gian để animation mượt hơn
    )..forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = [
      widget.status.chuaLam,
      widget.status.cho,
      widget.status.dangThucHien,
      widget.status.hoanThanh,
      widget.status.quaHan,
    ];

    final maxValue = data.reduce((a, b) => a > b ? a : b).toDouble();

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) {
            final stepX = width / (data.length - 1);
            final index = (details.localPosition.dx / stepX).round().clamp(0, data.length - 1);
            setState(() => _tappedIndex = index);
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedBuilder(
                animation: controller,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _LineChartPainter(
                      data: data,
                      maxValue: maxValue == 0 ? 1 : maxValue,
                      progress: controller.value,
                      color: context.primary,
                      surfaceColor: context.surfaceHighest,
                    ),
                    size: Size(width, height),
                  );
                },
              ),
              if (_tappedIndex != null) _buildTooltip(width, height, data),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTooltip(double width, double height, List<int> data) {
    final stepX = width / (data.length - 1);
    final maxValue = data.reduce((a, b) => a > b ? a : b).toDouble();
    final xPos = _tappedIndex! * stepX;
    final yPos = height - (data[_tappedIndex!] / (maxValue == 0 ? 1 : maxValue)) * height;

    return Positioned(
      left: xPos - 20,
      top: yPos - 35,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs, horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: context.primary, // Dùng primary làm tooltip để nổi bật
          borderRadius: AppRadius.smRadius,
          boxShadow: AppShadows.soft,
        ),
        child: Text(
          '${data[_tappedIndex!]}',
          style: context.theme.textTheme.labelSmall?.copyWith(
            color: context.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<int> data;
  final double maxValue;
  final double progress;
  final Color color;
  final Color surfaceColor;

  _LineChartPainter({
    required this.data,
    required this.maxValue,
    required this.progress,
    required this.color,
    required this.surfaceColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final path = Path();
    final fillPath = Path();
    final stepX = size.width / (data.length - 1);

    List<Offset> points = [];
    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height - (data[i] / maxValue) * size.height * progress;
      points.add(Offset(x, y));
    }

    // Vẽ đường cong mượt (Bezier) thay vì đường thẳng gấp khúc
    path.moveTo(points[0].dx, points[0].dy);
    fillPath.moveTo(points[0].dx, size.height);
    fillPath.lineTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      final controlPoint1 = Offset(p1.dx + (p2.dx - p1.dx) / 2, p1.dy);
      final controlPoint2 = Offset(p1.dx + (p2.dx - p1.dx) / 2, p2.dy);

      path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
          controlPoint2.dy, p2.dx, p2.dy);
      fillPath.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
          controlPoint2.dy, p2.dx, p2.dy);
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // 1. Vẽ Gradient Fill (Tonal Depth)
    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withValues(alpha: 0.15),
          color.withValues(alpha: 0.0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);

    // 2. Vẽ Line chính
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);

    // 3. Vẽ các điểm nút (Points) với hiệu ứng Focus Pulse nhẹ
    for (var point in points) {
      // Viền trắng ngoài điểm
      canvas.drawCircle(point, 5, Paint()..color = surfaceColor);
      // Điểm màu chính
      canvas.drawCircle(point, 3, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.data != data;
}