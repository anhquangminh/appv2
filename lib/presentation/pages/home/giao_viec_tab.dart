import 'package:ducanherp/core/helpers/user_storage_helper.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/data/models/application_user.dart';
import 'package:ducanherp/presentation/pages/home/widgets/chart_section.dart';
import 'package:ducanherp/presentation/pages/home/widgets/summary_card.dart';
import 'package:ducanherp/presentation/pages/home/widgets/task_progress_section.dart';
import 'package:ducanherp/presentation/pages/home/widgets/team_section.dart';
import 'package:ducanherp/presentation/pages/qlcv/danhsachcongviec_page.dart';
import 'package:ducanherp/presentation/widgets/shimmer/app_shimmer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ducanherp/logic/bloc/congviec/status_report_bloc.dart';
import 'package:ducanherp/logic/bloc/congviec/status_report_event.dart';
import 'package:ducanherp/logic/bloc/congviec/status_report_state.dart';
import 'package:ducanherp/logic/bloc/congviec/status_report_repository.dart';
import 'package:ducanherp/logic/bloc/congviec/group_report_bloc.dart';
import 'package:ducanherp/logic/bloc/congviec/group_report_event.dart';
import 'package:ducanherp/logic/bloc/congviec/group_report_state.dart';
import 'package:ducanherp/logic/bloc/congviec/group_report_repository.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class GiaoViecTab extends StatefulWidget {
  const GiaoViecTab({super.key});

  @override
  State<GiaoViecTab> createState() => _GiaoViecTabState();
}

class _GiaoViecTabState extends State<GiaoViecTab> {
  ApplicationUser? user;

  late final StatusReportBloc _statusBloc;
  late final GroupReportBloc _groupBloc;

  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();

    final statusRepo = StatusReportRepository(
      client: http.Client(),
      prefs: prefs,
    );

    final groupRepo = GroupReportRepository(
      client: http.Client(),
      prefs: prefs,
    );

    _statusBloc = StatusReportBloc(repository: statusRepo);
    _groupBloc = GroupReportBloc(repository: groupRepo);

    final cachedUser = await UserStorageHelper.getCachedUserInfo();
    if (cachedUser == null) return;

    user = cachedUser;

    _statusBloc.add(
      FetchStatusReport(
        groupId: user!.groupId,
        idNguoiGiaoViec: user!.userName,
      ),
    );

    _groupBloc.add(
      FetchGroupReport(
        groupId: user!.groupId,
        idNguoiGiaoViec: user!.userName,
      ),
    );

    if (!mounted) return;
    setState(() => _isReady = true);
  }

  @override
  void dispose() {
    _statusBloc.close();
    _groupBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return Center(
        child: CircularProgressIndicator(color: context.primary),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _statusBloc),
        BlocProvider.value(value: _groupBloc),
      ],
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _StatusSummary(),
              SizedBox(height: 16),
              _ChartWrapper(),
              SizedBox(height: 16),
              _GroupSection(),
              SizedBox(height: 16),
              _TaskProgress(),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
// =============================
// STATUS SUMMARY
// =============================
class _StatusSummary extends StatelessWidget {
  const _StatusSummary();

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<StatusReportBloc, StatusReportState>(
      builder: (context, state) {
        if (state is StatusReportLoading ||
            state is StatusReportInitial) {
          return const SummaryCardShimmer();
        }

        if (state is StatusReportLoaded) {
          return SummaryCard(model: state.report,onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DanhSachCongViecPage()),
            );
          });
        }

        if (state is StatusReportError) {
          return _ErrorView(message: state.message);
        }

        return const SizedBox();
      },
    );
  }
}

// =============================
// CHART WRAPPER (NEW)
// =============================
class _ChartWrapper extends StatelessWidget {
  const _ChartWrapper();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatusReportBloc, StatusReportState>(
      builder: (context, statusState) {
        return BlocBuilder<GroupReportBloc, GroupReportState>(
          builder: (context, groupState) {
            final status = statusState is StatusReportLoaded
                ? statusState.report
                : null;

            final groups = groupState is GroupReportLoaded
                ? groupState.groups
                : null;

            final isLoading =
                statusState is StatusReportLoading ||
                groupState is GroupReportLoading ||
                statusState is StatusReportInitial ||
                groupState is GroupReportInitial;

            if (isLoading) {
              return const ChartShimmer();
            }

            if (statusState is StatusReportError) {
              return _ErrorView(message: statusState.message);
            }

            if (groupState is GroupReportError) {
              return _ErrorView(message: groupState.message);
            }

            return ChartSection(
              status: status,
              groups: groups,
            );
          },
        );
      },
    );
  }
}

// =============================
// GROUP SECTION
// =============================
class _GroupSection extends StatelessWidget {
  const _GroupSection();

  @override
  Widget build(BuildContext context) {
    final parent = context.findAncestorStateOfType<_GiaoViecTabState>();

    return BlocBuilder<GroupReportBloc, GroupReportState>(
      builder: (context, state) {
        if (state is GroupReportLoading ||
            state is GroupReportInitial) {
           return const TeamShimmer();
        }

        if (state is GroupReportLoaded) {
          return TeamSection(
            groupList: state.groups,
            user: parent?.user,
          );
        }

        if (state is GroupReportError) {
          return _ErrorView(message: state.message);
        }

        return const SizedBox();
      },
    );
  }
}

// =============================
// TASK PROGRESS
// =============================
class _TaskProgress extends StatelessWidget {
  const _TaskProgress();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatusReportBloc, StatusReportState>(
      builder: (context, state) {
        if (state is StatusReportLoading ||
            state is StatusReportInitial) {
          return const TaskProgressShimmer();
        }

        if (state is StatusReportLoaded) {
          return TaskProgressSection(model: state.report);
        }

        if (state is StatusReportError) {
          return _ErrorView(message: state.message);
        }

        return const SizedBox();
      },
    );
  }
}

// =============================
// ERROR VIEW
// =============================
class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.opacity(context.error, 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: context.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: context.error,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}