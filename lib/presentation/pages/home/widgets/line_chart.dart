import 'package:ducanherp/core/themes/app_theme_helper.dart';
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
      duration: const Duration(milliseconds: 600),
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

    return GestureDetector(
      onTapDown: (details) {
        final box = context.findRenderObject() as RenderBox;
        final localX = box.globalToLocal(details.globalPosition).dx;
        final stepX = box.size.width / (data.length - 1);
        final index = (localX / stepX).round().clamp(0, data.length - 1);
        setState(() => _tappedIndex = index);
      },
      child: Stack(
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
                ),
                size: const Size(double.infinity, double.infinity),
              );
            },
          ),
          if (_tappedIndex != null)
            Positioned(
              left: (_tappedIndex! / (data.length - 1)) *
                  MediaQuery.of(context).size.width -
                  20,
              top: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                decoration: BoxDecoration(
                  color: context.surface,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.1), blurRadius: 4)
                  ],
                ),
                child: Text(
                  '${data[_tappedIndex!]}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Painter giữ nguyên như trước (_LineChartPainter)

/// =====================
/// Custom Painter
/// =====================
class _LineChartPainter extends CustomPainter {
  final List<int> data;
  final double maxValue;
  final double progress;
  final Color color;

  _LineChartPainter({
    required this.data,
    required this.maxValue,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final path = Path();
    final fillPath = Path();

    final stepX = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height - (data[i] / maxValue) * size.height * progress;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      if (i == data.length - 1) {
        fillPath.lineTo(x, size.height);
        fillPath.close();
      }
    }

    /// fill gradient
    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          // ignore: deprecated_member_use
          color.withOpacity(0.25),
          // ignore: deprecated_member_use
          color.withOpacity(0.05),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    /// line
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}