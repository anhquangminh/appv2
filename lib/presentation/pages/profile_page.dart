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
import 'package:ducanherp/presentation/widgets/common/app_card.dart';
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),

                        // ================= HERO CARD =================
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          decoration: BoxDecoration(
                            color: c.surfaceHighest,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            children: [
                              /// AVATAR & BADGE
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    radius: 46,
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0.2,
                                    ),
                                    child: CircleAvatar(
                                      radius: 42,
                                      backgroundColor: c.surfaceLow,
                                      child: Icon(
                                        Icons.person,
                                        size: 50,
                                        color: c.textSecondary,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      bottom: 2,
                                      right: 2,
                                    ),
                                    padding: const EdgeInsets.all(3),
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 194, 224, 240),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.verified,
                                      size: 18,
                                      color: c.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              /// NAME
                              Text(
                                '${user!.lastName} ${user!.firstName}',
                                style: GoogleFonts.inter(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  
                                ),
                              ),
                              const SizedBox(height: 4),

                              /// EMAIL
                              Text(
                                user!.email,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ================= THÔNG TIN CÁ NHÂN =================
                        _sectionTitle("THÔNG TIN CÁ NHÂN"),
                        AppCard(
                          child: Column(
                            children: [
                              _item(
                                Icons.person,
                                "Thông tin cá nhân",
                                "Họ tên, ngày sinh, bio...",
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
                                Icons.qr_code_scanner,
                                "Quét QR code",
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
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ================= CÀI ĐẶT =================
                        _sectionTitle("CÀI ĐẶT"),
                        AppCard(
                          child: Column(
                            children: [
                              _switchItem(
                                Icons.dark_mode,
                                "Giao diện tối",
                                "Chuyển đổi chế độ sáng/tối",
                                themeNotifier.isDarkMode,
                                (v) => themeNotifier.toggleTheme(),
                              ),
                              _switchItem(
                                Icons.notifications,
                                "Thông báo",
                                "Cập nhật công việc tức thì",
                                isNotify,
                                (v) async {
                                  await _saveNotificationPreference(v);
                                  setState(() => isNotify = v);
                                },
                              ),
                              _item(
                                Icons.language,
                                "Ngôn ngữ",
                                "Tiếng Việt",
                                onTap: () {}, // Giữ UI trống theo mẫu
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ================= BẢO MẬT & ĐĂNG XUẤT =================
                        _sectionTitle("BẢO MẬT"),
                        AppCard(
                          child: Column(
                            children: [
                              _item(
                                Icons.lock,
                                "Thay đổi mật khẩu",
                                "Cập nhật mật khẩu định kỳ",
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
                                "Xóa vĩnh viễn dữ liệu của bạn",
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
                                                  () => Navigator.pop(
                                                    context,
                                                    false,
                                                  ),
                                              child: const Text("Hủy"),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    true,
                                                  ),
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
                              _item(
                                Icons.logout,
                                "Đăng xuất",
                                "Hẹn gặp lại bạn!",
                                color: c.error,
                                onTap: logout,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ================= FOOTER =================
                        Center(
                          child: Text(
                            "ĐỨC ANH V1.0.0",
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                              color: c.textSecondary.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    final c = context;
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: c.textSecondary,
          ),
        ),
      ),
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
        Material(
          color: Colors.transparent,
          child: InkWell(
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  _iconBox(icon, color: color),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: color ?? c.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          sub,
                          style: GoogleFonts.inter(
                            fontSize: 13,
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
                    )
                  else
                    Icon(Icons.chevron_right, color: color ?? c.textSecondary),
                ],
              ),
            ),
          ),
        ),
        if (children != null)
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
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

  Widget _subItem(String title, String sub, IconData icon) {
    final c = context;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: c.surfaceLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: c.textPrimary),
          ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _iconBox(icon),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: c.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: c.primary,
          ),
        ],
      ),
    );
  }

  Widget _iconBox(IconData icon, {Color? color}) {
    final c = context;
    final isDanger = color == c.error;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isDanger ? c.error.withValues(alpha: 0.1) : c.surfaceLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color ?? c.textPrimary, size: 22),
    );
  }
}
