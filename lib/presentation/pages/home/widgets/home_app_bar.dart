import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/logic/bloc/notification/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ducanherp/logic/bloc/notification/notification_bloc.dart';
import 'package:ducanherp/presentation/pages/notification_page.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final int currentIndex;

  const HomeAppBar({super.key, required this.currentIndex});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(48); // 👈 giảm chiều cao
}

class _HomeAppBarState extends State<HomeAppBar> {
  int countNotifi = 0;
  int countFBNoti = 0;
  int totalNoti = 0;

  String _getTitle() {
    switch (widget.currentIndex) {
      case 0:
        return 'Quản lý công việc';
      case 1:
        return 'Duyệt';
      case 2:
        return 'Quản lý nhóm';
      case 3:
        return 'Trang cá nhân';
      default:
        return 'Ứng dụng';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 48, // 👈 giảm chiều cao thực tế
      backgroundColor: context.surface,
      elevation: 0,
      centerTitle: true,
      title: Text(
        _getTitle(),
        style: TextStyle(
          color: context.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 16, // 👈 giảm font cho cân đối
        ),
      ),
      iconTheme: IconThemeData(color: context.textPrimary, size: 20),
      actions: [
        BlocConsumer<NotificationBloc, NotificationState>(
          listener: (context, state) {
            if (!mounted) return;

            if (state is GetUnreadNotiByUserIdSuccessSate) {
              countNotifi = state.countNotifi;
            }

            if (state is GetReadFireBaseIdSuccessSate) {
              countFBNoti = state.countNotifi;
            }

            totalNoti = countNotifi + countFBNoti;
            setState(() {});
          },
          builder: (context, state) {
            return Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: context.textPrimary,
                    size: 20,
                  ),
                  onPressed: () {
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
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      decoration: BoxDecoration(
                        color: context.error,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        totalNoti > 99 ? '99+' : totalNoti.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: context.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
