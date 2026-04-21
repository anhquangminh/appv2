import 'package:ducanherp/core/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/routes/app_router.dart';

import 'package:ducanherp/data/models/notification_model.dart';
import 'package:ducanherp/data/models/notificationfirebase_model.dart';

import 'package:ducanherp/logic/bloc/notification/notification_bloc.dart';
import 'package:ducanherp/logic/bloc/notification/notification_event.dart';
import 'package:ducanherp/logic/bloc/notification/notification_state.dart';

import 'package:ducanherp/presentation/widgets/common/html_content_box.dart';
import 'package:ducanherp/presentation/widgets/common/tab_item.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final List<NotificationModel> notifi = [];
  final List<NotificationFireBaseModel> notifiFB = [];

  int notificationCountHT = 0;
  int notificationCountQLCV = 0;

  int _currentPageNotifi = 0;
  bool _isLoadingNotifi = false;
  bool _hasMoreNotifi = true;
  final int _pageSize = 10;

  int _currentPageNotifiFB = 0;
  bool _isLoadingNotifiFB = false;
  bool _hasMoreNotifiFB = true;
  final int _pageSizeFB = 10;

  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(GetUnreadNotiByUserIdEvent());
    context.read<NotificationBloc>().add(
      GetAllNotiByUserEvent(currentPage: 0, pageSize: _pageSize),
    );
    context.read<NotificationBloc>().add(GetReadFireBaseIdEvent());
    context.read<NotificationBloc>().add(
      GetAllNotiFireBaseByUserIdEvent(currentPage: 0, pageSize: _pageSizeFB),
    );
  }

  void _loadMoreNotifi() {
    if (_isLoadingNotifi || !_hasMoreNotifi) return;
    setState(() {
      _isLoadingNotifi = true;
      _currentPageNotifi++;
    });
    context.read<NotificationBloc>().add(
      GetAllNotiByUserEvent(
        currentPage: _currentPageNotifi,
        pageSize: _pageSize,
      ),
    );
  }

  void _loadMoreNotifiFB() {
    if (_isLoadingNotifiFB || !_hasMoreNotifiFB) return;
    setState(() {
      _isLoadingNotifiFB = true;
      _currentPageNotifiFB++;
    });
    context.read<NotificationBloc>().add(
      GetAllNotiFireBaseByUserIdEvent(
        currentPage: _currentPageNotifiFB,
        pageSize: _pageSizeFB,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: context.background,
        appBar: AppBar(
          backgroundColor: context.background,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Thông báo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(42),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: context.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: context.opacity(context.border, 0.5),
                  width: 0.8,
                ),
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: context.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                labelColor: context.onPrimary,
                unselectedLabelColor: context.textSecondary,
                tabs: [
                  TabItem(title: 'QLCV', count: notificationCountQLCV),
                  TabItem(title: 'Hệ thống', count: notificationCountHT),
                ],
              ),
            ),
          ),
        ),
        body: BlocConsumer<NotificationBloc, NotificationState>(
          listener: (context, state) {
            if (state is GetUnreadNotiByUserIdSuccessSate) {
              setState(() => notificationCountHT = state.countNotifi);
            }

            if (state is GetReadFireBaseIdSuccessSate) {
              setState(() => notificationCountQLCV = state.countNotifi);
            }

            if (state is GetAllNotiByUserSuccessSate) {
              setState(() {
                if (_currentPageNotifi == 0) notifi.clear();
                notifi.addAll(state.notifi);
                _isLoadingNotifi = false;
                _hasMoreNotifi = state.notifi.length == _pageSize;
              });
            }

            if (state is GetAllNotiFireBaseByUserIdSuccessSate) {
              setState(() {
                if (_currentPageNotifiFB == 0) notifiFB.clear();
                notifiFB.addAll(state.notifi);
                _isLoadingNotifiFB = false;
                _hasMoreNotifiFB =
                    state.notifi.length == _pageSizeFB;
              });
            }
          },
          builder: (context, state) {
            return TabBarView(
              children: [
                _buildFirebaseTab(context),
                _buildSystemTab(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFirebaseTab(BuildContext context) {
    if (notifiFB.isEmpty) {
      return Center(
        child: Text(
          'Không có thông báo',
          style: TextStyle(color: context.textSecondary),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: notifiFB.length + (_hasMoreNotifiFB ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == notifiFB.length) {
          return _buildLoadMoreButton(
            context,
            _isLoadingNotifiFB,
            _loadMoreNotifiFB,
          );
        }

        final item = notifiFB[index];
        final isRead = item.isRead == 1;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: context.opacity(context.border, 0.3),
              width: 0.8,
            ),
          ),
          color: isRead
              ? context.surface
              : context.opacity(context.primary, 0.06),
          child: ExpansionTile(
            iconColor: context.textSecondary,
            collapsedIconColor: context.textSecondary,
            onExpansionChanged: (_) {
              if (!isRead) {
                item.isRead = 1;
                context.read<NotificationBloc>().add(
                      IsReadFireBaseIdEvent(id: item.id),
                    );
                setState(() {
                  notificationCountQLCV =
                      (notificationCountQLCV - 1).clamp(0, 9999);
                });
              }
            },
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isRead
                    ? context.surfaceLow
                    : context.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.notifications_active_outlined,
                size: 20,
                color: context.onPrimary,
              ),
            ),
            title: Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isRead
                    ? context.textSecondary
                    : context.textPrimary,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                children: [
                  Icon(Icons.person_outline,
                      size: 14, color: context.textSecondary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      item.creatby,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: context.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.access_time,
                      size: 14, color: context.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    DateUtilsHelper.formatDateTime(item.createdAt),
                    style: TextStyle(
                      fontSize: 11,
                      color: context.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            children: [
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.subject_outlined,
                      size: 18, color: context.primary),
                  const SizedBox(width: 8),
                  Expanded(child: HtmlContentBox(content: item.body)),
                ],
              ),
              if (AppRouter.hasRoute(item.targetPage) &&
                  item.targetId.isNotEmpty)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        item.targetPage,
                        arguments: {'id': item.targetId},
                      );
                    },
                    icon: Icon(Icons.arrow_forward_ios_rounded,
                        size: 14, color: context.primary),
                    label: Text(
                      'Chi tiết',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.primary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSystemTab(BuildContext context) {
    if (notifi.isEmpty) {
      return Center(
        child: Text(
          'Không có thông báo',
          style: TextStyle(color: context.textSecondary),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: notifi.length + (_hasMoreNotifi ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == notifi.length) {
          return _buildLoadMoreButton(
            context,
            _isLoadingNotifi,
            _loadMoreNotifi,
          );
        }

        final item = notifi[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: context.opacity(context.border, 0.3),
              width: 0.8,
            ),
          ),
          color: context.surface,
          child: ExpansionTile(
            iconColor: context.textSecondary,
            collapsedIconColor: context.textSecondary,
            onExpansionChanged: (_) {
              if (item.isRead == 0) {
                item.isRead = 1;
                context.read<NotificationBloc>().add(
                      UpdateNotificationEvent(notifi: item),
                    );
                setState(() {
                  notificationCountHT =
                      (notificationCountHT - 1).clamp(0, 9999);
                });
              }
            },
            leading: CircleAvatar(
              radius: 18,
              backgroundColor: item.isRead == 1
                  ? context.surfaceLow
                  : context.primary,
              child: Icon(
                Icons.notifications,
                size: 18,
                color: context.onPrimary,
              ),
            ),
            title: Text(
              item.subject,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: item.isRead == 1
                    ? context.textSecondary
                    : context.textPrimary,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                children: [
                  Icon(Icons.access_time,
                      size: 14, color: context.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    DateUtilsHelper.formatDateTime(item.createAt),
                    style: TextStyle(
                      fontSize: 11,
                      color: context.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: HtmlContentBox(content: item.content),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadMoreButton(
    BuildContext context,
    bool isLoading,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: isLoading
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: context.onPrimary,
                  ),
                )
              : const Text('Tải thêm'),
        ),
      ),
    );
  }
}