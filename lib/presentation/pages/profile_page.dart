import 'package:ducanherp/core/helpers/user_storage_helper.dart';
import 'package:ducanherp/core/themes/theme_notifier.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/logic/bloc/appuser/appuser_bloc.dart';
import 'package:ducanherp/logic/bloc/appuser/appuser_event.dart';
import 'package:ducanherp/logic/bloc/appuser/appuser_repository.dart';
import 'package:ducanherp/logic/bloc/appuser/appuser_state.dart';
import 'package:ducanherp/logic/bloc/notification/notification_bloc.dart';
import 'package:ducanherp/logic/bloc/notification/notification_event.dart';
import 'package:ducanherp/data/models/application_user.dart';
import 'package:ducanherp/presentation/pages/changepassword_page.dart';
import 'package:ducanherp/presentation/pages/qr_login_page.dart';
import 'package:ducanherp/presentation/screens/login_screen.dart';
import 'package:ducanherp/routes/app_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ApplicationUser? user;

  bool isNotify = false;
  Map<String, bool> expandMap = {};

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadNotify();
  }

  Future<void> _loadUser() async {
    final cachedUser = await UserStorageHelper.getCachedUserInfo();
    setState(() => user = cachedUser);
  }

  Future<void> _loadNotify() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotify = prefs.getBool('notificationsMuted') ?? false;
    });
  }

  Future<void> _saveNotificationPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsMuted', value);
  }

  Future<void> logout() async {
    final messaging = FirebaseMessaging.instance;
    final fcmToken = await messaging.getToken();

    if (fcmToken != null) {
      final user = await UserStorageHelper.getCachedUserInfo();
      if (user != null && user.id.isNotEmpty) {
        // ignore: use_build_context_synchronously
        context.read<NotificationBloc>().add(
          UnregisterTokenEvent(
            token: fcmToken,
            groupId: user.groupId,
            userId: user.id,
          ),
        );
      }
    }

    await messaging.deleteToken();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('expiration');

    // ignore: use_build_context_synchronously
    final client = Provider.of<http.Client>(context, listen: false);

    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder:
            (context) => BlocProvider(
              create:
                  (context) => AppUserBloc(
                    AppUserRepository(client: client, prefs: prefs),
                  ),
              child: const LoginScreen(),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context;
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return BlocListener<AppUserBloc, AppUserState>(
      listener: (context, state) {
        if (state is DeleteCurrentUserSuccess) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRouter.login, (route) => false);
        }
        if (state is DeleteCurrentUserFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: Scaffold(
        backgroundColor: c.background,
        body:
            user == null
                ? const Center(child: CircularProgressIndicator())
                : SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),

                        // ================= HERO =================
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: c.surface,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              /// AVATAR
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  /// glow effect
                                  Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          context.primary.withValues(
                                            alpha: 0.25,
                                          ),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),

                                  /// avatar border
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                        width: 2,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 44,
                                      backgroundColor: context.surfaceLow,
                                      child: Icon(
                                        Icons.person,
                                        size: 60,
                                        color: context.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              /// NAME
                              Text(
                                '${user!.firstName} ${user!.lastName}',
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: context.textSecondary,
                                ),
                              ),

                              /// EMAIL
                              Text(
                                user!.email,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: context.textSecondary.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        _sectionTitle("THÔNG TIN CÁ NHÂN"),
                        _card([
                          _item(
                            Icons.person,
                            "Thông tin cá nhân",
                            "${user!.firstName} ${user!.lastName}",
                            children: [
                              _subItem("Email", user!.email, Icons.email),
                              _subItem(
                                "Số điện thoại",
                                user!.phoneNumber,
                                Icons.phone,
                              ),
                              _subItem(
                                "Địa chỉ",
                                user!.address,
                                Icons.location_on,
                              ),
                            ],
                          ),
                          _item(
                            Icons.qr_code,
                            "Quét QR Code",
                            "Đăng nhập nhanh",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const QRLoginPage(),
                                ),
                              );
                            },
                          ),
                        ]),

                        const SizedBox(height: 16),

                        _sectionTitle("CÀI ĐẶT"),
                        _card([
                          _switchItem(
                            Icons.dark_mode,
                            "Dark Mode",
                            "Bật/tắt giao diện tối",
                            themeNotifier.isDarkMode,
                            (v) => themeNotifier.toggleTheme(),
                          ),
                          _switchItem(
                            Icons.notifications,
                            "Thông báo",
                            "Bật/tắt thông báo",
                            isNotify,
                            (v) async {
                              await _saveNotificationPreference(v);
                              setState(() => isNotify = v);
                            },
                          ),
                        ]),

                        const SizedBox(height: 16),

                        _sectionTitle("BẢO MẬT"),
                        _card([
                          _item(
                            Icons.lock,
                            "Đổi mật khẩu",
                            "Cập nhật mật khẩu",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChangePasswordPage(),
                                ),
                              );
                            },
                          ),
                          _item(
                            Icons.delete,
                            "Xóa tài khoản",
                            "Không thể hoàn tác",
                            color: c.error,
                            onTap: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder:
                                    (_) => AlertDialog(
                                      title: const Text("Xác nhận"),
                                      content: const Text(
                                        "Bạn có chắc chắn muốn xóa tài khoản?",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, false),
                                          child: const Text("Hủy"),
                                        ),
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, true),
                                          child: const Text("Xóa"),
                                        ),
                                      ],
                                    ),
                              );
                              if (confirm == true) {
                                // ignore: use_build_context_synchronously
                                context.read<AppUserBloc>().add(
                                  DeleteCurrentUserRequested(),
                                );
                              }
                            },
                          ),
                        ]),

                        const SizedBox(height: 16),

                        _card([_logoutItem()]),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    final c = context;
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          color: c.textSecondary.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  Widget _card(List<Widget> children) {
    final c = context;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: c.surfaceLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(children: children),
    );
  }

  Widget _item(
    IconData icon,
    String title,
    String sub, {
    List<Widget>? children,
    VoidCallback? onTap,
    Color? color,
  }) {
    final c = context;
    final isExpanded = expandMap[title] ?? false;

    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (children != null && children.isNotEmpty) {
              setState(() {
                expandMap[title] = !isExpanded;
              });
            } else {
              onTap?.call();
            }
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                _iconBox(icon, color: c.textPrimary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: color ?? c.textPrimary,
                        ),
                      ),
                      Text(
                        sub,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: c.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (children != null)
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.expand_more, color: c.textSecondary),
                  ),
              ],
            ),
          ),
        ),
        if (children != null)
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              padding: const EdgeInsets.all(8),

              child: Column(children: children),
            ),
            crossFadeState:
                isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
      ],
    );
  }

  // ================= SUB ITEM (UPDATED UI giống ảnh) =================
  Widget _subItem(String title, String sub, IconData icon) {
    final c = context;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // ICON BOX
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20),
          ),

          const SizedBox(width: 12),

          // TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: c.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _switchItem(
    IconData icon,
    String title,
    String sub,
    bool value,
    Function(bool) onChanged,
  ) {
    final c = context;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _iconBox(icon, color: c.textPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: c.textPrimary,
                  ),
                ),
                Text(
                  sub,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: c.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: c.primary),
        ],
      ),
    );
  }

  Widget _logoutItem() {
    final c = context;
    return InkWell(
      onTap: logout,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            _iconBox(Icons.logout, color: c.error),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Đăng xuất",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: c.error,
                    ),
                  ),
                  Text(
                    "Hẹn gặp lại bạn!",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: c.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconBox(IconData icon, {Color? color}) {
    final c = context;
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color ?? c.primary),
    );
  }
}
