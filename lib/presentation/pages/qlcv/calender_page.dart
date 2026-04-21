
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/presentation/widgets/bages/quahan_bage.dart';
import 'package:ducanherp/presentation/widgets/common/app_card.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ducanherp/data/models/congviec_model.dart';

class CalendarPage extends StatefulWidget {
  final List<CongViecModel> congViecModels;

  const CalendarPage({super.key, required this.congViecModels});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  final DateTime _firstDay = DateTime.utc(2020, 1, 1);
  final DateTime _lastDay = DateTime.utc(2030, 12, 31);

  late ValueNotifier<List<CongViecModel>> _selectedEvents;

  final Map<String, Map<DateTime, List<CongViecModel>>> _monthlyCache = {};
  final ScrollController _listController = ScrollController();

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();

    _buildMonthCache(_focusedDay);
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    _listController.dispose();
    super.dispose();
  }

  String _monthKey(DateTime day) =>
      '${day.year}-${day.month.toString().padLeft(2, '0')}';

  void _buildMonthCache(DateTime month) {
    final key = _monthKey(month);
    if (_monthlyCache.containsKey(key)) return;

    final Map<DateTime, List<CongViecModel>> map = {};

    for (final e in widget.congViecModels) {
      DateTime start =
          DateTime(e.ngayBatDau.year, e.ngayBatDau.month, e.ngayBatDau.day);
      DateTime end =
          DateTime(e.ngayKetThuc.year, e.ngayKetThuc.month, e.ngayKetThuc.day);

      for (int i = 0; i <= end.difference(start).inDays; i++) {
        final day = DateTime(start.year, start.month, start.day + i);
        if (day.month == month.month && day.year == month.year) {
          map.putIfAbsent(day, () => []).add(e);
        }
      }
    }

    _monthlyCache[key] = map;
  }

  List<CongViecModel> _getEventsForDay(DateTime day) {
    final key = _monthKey(day);
    return _monthlyCache[key]?[DateTime(day.year, day.month, day.day)] ?? [];
  }

  DateTime _findNearestEventDay(DateTime month) {
    final key = _monthKey(month);
    final map = _monthlyCache[key];
    if (map == null || map.isEmpty) {
      return DateTime(month.year, month.month, 1);
    }

    final sortedKeys = map.keys.toList()..sort();
    return sortedKeys.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lịch công việc',
          style: TextStyle(color: context.textPrimary),
        ),
        backgroundColor: context.surface,
      ),
      body: Column(
        children: [
          TableCalendar<CongViecModel>(
            firstDay: _firstDay,
            lastDay: _lastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getEventsForDay,

            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedEvents.value = _getEventsForDay(selectedDay);
              });

              if (_listController.hasClients) {
                _listController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            },

            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
              _buildMonthCache(focusedDay);

              final nearestDay = _findNearestEventDay(focusedDay);

              setState(() {
                _selectedDay = nearestDay;
                _selectedEvents.value = _getEventsForDay(nearestDay);
              });
            },

            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, _) {
                final events = _getEventsForDay(day);
                if (events.isEmpty) return null;

                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: context.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                  ),
                );
              },

              todayBuilder: (context, day, _) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: context.error),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${day.day}',
                    style: TextStyle(color: context.textPrimary),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: ValueListenableBuilder<List<CongViecModel>>(
              valueListenable: _selectedEvents,
              builder: (context, events, _) {
                if (events.isEmpty) {
                  return Center(
                    child: Text(
                      'Không có công việc',
                      style: TextStyle(color: context.textSecondary),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _listController,
                  itemCount: events.length,
                  itemBuilder: (_, index) {
                    final e = events[index];
                    final quaHan = isQuaHan(e);

                    return Stack(
                      children: [
                        AppCard(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: ListTile(
                            title: Text(
                              e.tenCongViec,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: context.textPrimary,
                              ),
                            ),
                            subtitle: Text(
                              '${e.ngayBatDau.day}/${e.ngayBatDau.month} → '
                              '${e.ngayKetThuc.day}/${e.ngayKetThuc.month}',
                              style: TextStyle(
                                color: context.textSecondary,
                              ),
                            ),
                            trailing: Text(
                              '${e.tienDo * 10}%',
                              style:
                                  TextStyle(color: context.textSecondary),
                            ),
                            onTap: () =>
                                _showCongViecDetail(context, e),
                          ),
                        ),
                        if (quaHan)
                          const Positioned(
                            top: 10,
                            right: 10,
                            child: QuaHanBadge(),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool isQuaHan(CongViecModel job) {
    final now = DateTime.now();
    return job.tienDo < 10 && job.ngayKetThuc.isBefore(now);
  }

  void _showCongViecDetail(BuildContext context, CongViecModel e) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.65,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: context.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: context.border,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: Text(
                            e.tenCongViec,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: context.textPrimary,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.close,
                                color: context.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(height: 1, color: context.border),

                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle(context, 'Thông tin chung'),
                          _infoTile(
                            context,
                            icon: Icons.calendar_month_outlined,
                            title: 'Thời gian',
                            value:
                                '${e.ngayBatDau.day}/${e.ngayBatDau.month}/${e.ngayBatDau.year}'
                                ' → '
                                '${e.ngayKetThuc.day}/${e.ngayKetThuc.month}/${e.ngayKetThuc.year}',
                          ),
                          _infoTile(
                            context,
                            icon: Icons.assignment_outlined,
                            title: 'Nội dung',
                            value: e.noiDungCongViec,
                          ),

                          const SizedBox(height: 8),
                          _sectionTitle(context, 'Nhân sự'),
                          _infoTile(
                            context,
                            icon: Icons.person_outline,
                            title: 'Người giao',
                            value: e.idNguoiGiaoViec,
                          ),
                          _infoTile(
                            context,
                            icon: Icons.engineering_outlined,
                            title: 'Người thực hiện',
                            value: e.nguoiThucHien,
                          ),

                          const SizedBox(height: 8),
                          _sectionTitle(context, 'Trạng thái'),
                          _infoTile(
                            context,
                            icon: Icons.folder_outlined,
                            title: 'Nhóm',
                            value: e.tenNhom,
                          ),
                          _infoTile(
                            context,
                            icon: Icons.priority_high,
                            title: 'Ưu tiên',
                            value: e.mucDoUuTien,
                          ),
                          _infoTile(
                            context,
                            icon: Icons.trending_up,
                            title: 'Tiến độ',
                            value: '${e.tienDo * 10}%',
                          ),
                          _infoTile(
                            context,
                            icon: Icons.repeat,
                            title: 'Lặp lại',
                            value: e.lapLai,
                          ),
                          _infoTile(
                            context,
                            icon: Icons.rate_review_outlined,
                            title: 'Tự đánh giá',
                            value: e.tuDanhGia,
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        label: const Text('Đóng'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: context.primary,
        ),
      ),
    );
  }

  Widget _infoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    if (value.isEmpty) return const SizedBox.shrink();

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 16, color: context.textSecondary),
      title: Text(
        title,
        style: TextStyle(fontSize: 13, color: context.textSecondary),
      ),
      subtitle: Text(
        value,
        style: TextStyle(fontSize: 12, color: context.textPrimary),
      ),
    );
  }
}