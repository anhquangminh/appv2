import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/logic/bloc/notification/notification_bloc.dart';
import 'package:ducanherp/logic/bloc/notification/notification_state.dart';
import 'package:ducanherp/presentation/pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final int currentIndex;
  final VoidCallback? onPrimaryAction;

  const HomeAppBar({
    super.key,
    required this.currentIndex,
    this.onPrimaryAction,
  });

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(72);
}

class _HomeAppBarState extends State<HomeAppBar> {
  int countNotifi = 0;
  int countFBNoti = 0;

  int get totalNoti => countNotifi + countFBNoti;

  _AppBarConfig _getConfig() {
    switch (widget.currentIndex) {
      case 0:
        return const _AppBarConfig(
          title: 'Quản lý công việc',
          icon: Icons.assignment_rounded,
        );
      case 1:
        return const _AppBarConfig(
          title: 'Duyệt',
          icon: Icons.fact_check_rounded,
        );
      case 2:
        return const _AppBarConfig(
          title: 'Quản lý nhóm',
          icon: Icons.groups_2_rounded,
          actionIcon: Icons.group_add_rounded,
          actionTooltip: 'Thêm nhóm',
        );
      case 3:
        return const _AppBarConfig(
          title: 'Bảng thử nghiệm',
          icon: Icons.science_rounded,
        );
      case 4:
        return const _AppBarConfig(
          title: 'Trang cá nhân',
          icon: Icons.person_rounded,
        );
      default:
        return const _AppBarConfig(
          title: 'Ứng dụng',
          icon: Icons.dashboard_rounded,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();

    return AppBar(
      toolbarHeight: 72,
      backgroundColor: context.surfaceHighest,
      surfaceTintColor: context.primary.withValues(alpha: 0),
      elevation: 0,
      shadowColor: context.shadow,
      automaticallyImplyLeading: false,
      titleSpacing: AppSpacing.lg,
      title: Row(
        children: [
          Icon(config.icon, size: 20, color: context.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              config.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      actions: [
        if (config.actionIcon != null)
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: _AppBarActionButton(
              tooltip: config.actionTooltip ?? '',
              icon: config.actionIcon!,
              filled: true,
              onTap: widget.onPrimaryAction,
            ),
          ),
        BlocConsumer<NotificationBloc, NotificationState>(
          listener: (context, state) {
            if (!mounted) return;

            if (state is GetUnreadNotiByUserIdSuccessSate) {
              countNotifi = state.countNotifi;
            }

            if (state is GetReadFireBaseIdSuccessSate) {
              countFBNoti = state.countNotifi;
            }

            setState(() {});
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  _AppBarActionButton(
                    tooltip: 'Thông báo',
                    icon: Icons.notifications_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationPage(),
                        ),
                      );
                    },
                  ),
                  if (totalNoti > 0)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                          vertical: 1,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        decoration: BoxDecoration(
                          color: context.error,
                          borderRadius: AppRadius.pillRadius,
                        ),
                        child: Text(
                          totalNoti > 99 ? '99+' : totalNoti.toString(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: context.onPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          height: 1,
          thickness: 1,
          color: context.borderStrong,
        ),
      ),
    );
  }
}

class _AppBarConfig {
  final String title;
  final IconData icon;
  final IconData? actionIcon;
  final String? actionTooltip;

  const _AppBarConfig({
    required this.title,
    required this.icon,
    this.actionIcon,
    this.actionTooltip,
  });
}

class _AppBarActionButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback? onTap;
  final bool filled;

  const _AppBarActionButton({
    required this.tooltip,
    required this.icon,
    this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.pillRadius,
        child: Icon(
            icon,
            size: 20,
            color: context.primary,
          ),
      ),
    );
  }
}
