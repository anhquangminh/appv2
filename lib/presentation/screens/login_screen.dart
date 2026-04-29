import 'dart:convert';

import 'package:ducanherp/core/helpers/user_storage_helper.dart';
import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/logic/bloc/appuser/appuser_bloc.dart';
import 'package:ducanherp/logic/bloc/appuser/appuser_event.dart';
import 'package:ducanherp/logic/bloc/appuser/appuser_state.dart';
import 'package:ducanherp/logic/bloc/notification/notification_bloc.dart';
import 'package:ducanherp/logic/bloc/notification/notification_event.dart';
import 'package:ducanherp/logic/bloc/permission/permission_bloc.dart';
import 'package:ducanherp/logic/bloc/permission/permission_event.dart';
import 'package:ducanherp/logic/bloc/permission/permission_state.dart';
import 'package:ducanherp/routes/app_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedLogin();
  }

  bool isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }

  void _loadSavedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      emailController.text = prefs.getString('saved_email') ?? '';
      passwordController.text = prefs.getString('saved_password') ?? '';
      _rememberMe = prefs.getBool('remember_me') ?? false;
    });
  }

  Future<void> _saveLoginInfoIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('saved_email', emailController.text);
      await prefs.setString('saved_password', passwordController.text);
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.clear();
    }
  }

  void _handleLogin() {
    final email = emailController.text;
    final password = passwordController.text;

    setState(() {
      emailError = null;
      passwordError = null;
    });

    if (email.isEmpty) {
      setState(() => emailError = 'Email không được để trống!');
      return;
    } else if (!isValidEmail(email)) {
      setState(() => emailError = 'Email không hợp lệ');
      return;
    }

    if (password.isEmpty) {
      setState(() => passwordError = 'Mật khẩu không được để trống!');
      return;
    }

    context.read<AppUserBloc>().add(AppUserLoginEvent(email, password));
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: context.background,
      body: BlocListener<AppUserBloc, AppUserState>(
        listener: (context, state) async {
          if (state.isLoggedIn) {
            await _saveLoginInfoIfNeeded();

            final fcmToken = await FirebaseMessaging.instance.getToken();
            final user = await UserStorageHelper.getCachedUserInfo();

            if (fcmToken != null &&
                user != null &&
                user.id.isNotEmpty &&
                user.groupId != "") {
              // ignore: use_build_context_synchronously
              context.read<NotificationBloc>().add(
                    RegisterTokenEvent(
                      token: fcmToken,
                      groupId: user.groupId,
                      userId: user.id,
                    ),
                  );

              // ignore: use_build_context_synchronously
              final permissionBloc = context.read<PermissionBloc>();

              permissionBloc.add(
                FetchPermissions(
                  groupId: user.groupId,
                  userId: user.id,
                  parentMajorId: "249ff511-8f10-45e8-bf8f-29b0ada5ab84",
                ),
              );

              permissionBloc.stream
                  .firstWhere((e) => e is PermissionLoaded)
                  .then((permState) async {
                final permissions =
                    (permState as PermissionLoaded).permissions;

                final prefs = await SharedPreferences.getInstance();
                await prefs.setStringList(
                  'permissions',
                  permissions.map((e) => jsonEncode(e.toJson())).toList(),
                );

                // ignore: use_build_context_synchronously
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRouter.home,
                  (route) => false,
                );
              });
            }
          }
        },
        child: BlocBuilder<AppUserBloc, AppUserState>(
          builder: (context, state) {
            return Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet
                          ? MediaQuery.of(context).size.width * 0.2
                          : AppSpacing.xl,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: AppSpacing.xxxl),

                        /// LOGO
                        Image.asset(
                          'assets/images/logo.png',
                          height: 90,
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        Text(
                          'Chào mừng trở lại!',
                          style: context.theme.textTheme.headlineMedium!
                              .copyWith(fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: AppSpacing.sm),

                        Text(
                          'Vui lòng đăng nhập để tiếp tục quản lý công việc.',
                          style: context.theme.textTheme.bodyMedium!
                              .copyWith(color: context.textSecondary),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: AppSpacing.xxxl),

                        /// CARD
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          decoration: BoxDecoration(
                            color: context.surface,
                            borderRadius: AppRadius.xlRadius,
                            boxShadow: [
                              BoxShadow(
                                color: context.shadow,
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Tên đăng nhập / Email'),
                              const SizedBox(height: AppSpacing.sm),
                              _input(
                                controller: emailController,
                                hint: 'example@evergreen.com',
                                icon: Icons.alternate_email,
                                error: emailError,
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              _label('Mật khẩu'),
                              const SizedBox(height: AppSpacing.sm),
                              _input(
                                controller: passwordController,
                                hint: '••••••••',
                                icon: Icons.lock_outline,
                                isPassword: true,
                                error: passwordError,
                              ),
                              const SizedBox(height: AppSpacing.md),

                              /// remember + forgot
                              Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    onChanged: (v) =>
                                        setState(() => _rememberMe = v!),
                                  ),
                                  Text(
                                    'Ghi nhớ đăng nhập',
                                    style: context.theme.textTheme.bodyMedium,
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Quên mật khẩu?',
                                      style: context
                                          .theme.textTheme.bodyMedium!
                                          .copyWith(color: context.primary),
                                    ),
                                  )
                                ],
                              ),

                              const SizedBox(height: AppSpacing.lg),

                              if (state.errorMessage != null)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: AppSpacing.sm),
                                  child: Text(
                                    state.errorMessage!,
                                    style: TextStyle(color: context.error),
                                  ),
                                ),

                              /// BUTTON
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _handleLogin,
                                  child: const Text('ĐĂNG NHẬP'),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: AppSpacing.xl),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Chưa có tài khoản?',
                              style: context.theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            GestureDetector(
                              onTap: () =>
                                  Navigator.pushNamed(context, '/register'),
                              child: Text(
                                'Đăng ký ngay',
                                style: context.theme.textTheme.bodyMedium!
                                    .copyWith(color: context.primary),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.xxxl),

                        Text(
                          '©2026 design by quang minh',
                          style: context.theme.textTheme.labelSmall!
                              .copyWith(color: context.textHint),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ),
                  ),
                ),

                if (state.isLoading)
                  Container(
                    color: context.opacity(context.black, 0.4),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: context.theme.textTheme.labelLarge,
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? error,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: isPassword && !_isPasswordVisible,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(_isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible),
                  )
                : null,
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              error,
              style: TextStyle(color: context.error),
            ),
          )
      ],
    );
  }
}