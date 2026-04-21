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
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
    final savedEmail = prefs.getString('saved_email') ?? '';
    final savedPassword = prefs.getString('saved_password') ?? '';
    final remember = prefs.getBool('remember_me') ?? false;

    setState(() {
      emailController.text = savedEmail;
      passwordController.text = savedPassword;
      _rememberMe = remember;
    });
  }

  Future<void> _saveLoginInfoIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('saved_email', emailController.text);
      await prefs.setString('saved_password', passwordController.text);
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.remove('saved_email');
      await prefs.remove('saved_password');
      await prefs.setBool('remember_me', false);
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

              final permissionBloc =
                  // ignore: use_build_context_synchronously
                  BlocProvider.of<PermissionBloc>(context);

              permissionBloc.add(
                FetchPermissions(
                  groupId: user.groupId,
                  userId: user.id,
                  parentMajorId: "249ff511-8f10-45e8-bf8f-29b0ada5ab84",
                ),
              );

              permissionBloc.stream
                  .firstWhere((permState) => permState is PermissionLoaded)
                  .then((permState) async {
                final permissions =
                    (permState as PermissionLoaded).permissions;

                final prefs = await SharedPreferences.getInstance();
                final permissionJsonList =
                    permissions.map((p) => jsonEncode(p.toJson())).toList();

                await prefs.setStringList('permissions', permissionJsonList);
                await prefs.setString(
                  'permissions_date',
                  DateTime.now().toIso8601String(),
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
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.sm,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '9:41',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: context.textPrimary,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.signal_cellular_4_bar,
                                    size: 16, color: context.textPrimary),
                                const SizedBox(width: AppSpacing.xs),
                                Icon(Icons.wifi,
                                    size: 16, color: context.textPrimary),
                                const SizedBox(width: AppSpacing.xs),
                                Icon(Icons.battery_full,
                                    size: 16, color: context.textPrimary),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xxl),
                          child: Column(
                            children: [
                              const SizedBox(height: AppSpacing.xxxl),
                              Image.asset('assets/images/logo.png',
                                  height: 100),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                'Hệ Thống Quản Lý',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: context.textPrimary,
                                ),
                              ),
                              
                              const SizedBox(height: AppSpacing.xxxl),

                              _buildLabel('TÊN ĐĂNG NHẬP'),
                              const SizedBox(height: AppSpacing.xs),
                              _buildTextField(
                                controller: emailController,
                                hintText: 'Nhập email',
                                icon: Icons.person_outline,
                                errorText: emailError,
                              ),

                              const SizedBox(height: AppSpacing.lg),

                              _buildLabel('MẬT KHẨU'),
                              const SizedBox(height: AppSpacing.xs),
                              _buildTextField(
                                controller: passwordController,
                                hintText: '••••••••',
                                icon: Icons.lock_outline,
                                isPassword: true,
                                errorText: passwordError,
                                onSubmitted: (_) => _handleLogin(),
                              ),

                              const SizedBox(height: AppSpacing.md),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () => setState(
                                        () => _rememberMe = !_rememberMe),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Checkbox(
                                            value: _rememberMe,
                                            onChanged: (val) => setState(
                                                () => _rememberMe = val!),
                                            activeColor: context.primary,
                                            side: BorderSide(
                                                color: context.border),
                                          ),
                                        ),
                                        const SizedBox(width: AppSpacing.sm),
                                        Text(
                                          'Ghi nhớ đăng nhập',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: context.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'QUÊN MẬT KHẨU?',
                                      style: GoogleFonts.robotoCondensed(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: context.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: AppSpacing.xl),

                              if (state.errorMessage != null)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    state.errorMessage!,
                                    style: TextStyle(
                                      color: context.error,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),

                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _handleLogin,
                                  child: Text(
                                    'ĐĂNG NHẬP',
                                    style:
                                        GoogleFonts.robotoCondensed(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: AppSpacing.xxxl),

                              Row(
                                children: [
                                  Expanded(
                                      child:
                                          Divider(color: context.border)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.md),
                                    child: Text(
                                      'Bạn chưa có tài khoản?',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: context.textSecondary,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child:
                                          Divider(color: context.border)),
                                ],
                              ),

                              const SizedBox(height: AppSpacing.lg),

                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/register');
                                  },
                                  icon: Icon(Icons.person_add_outlined,
                                      color: context.textPrimary),
                                  label: const Text(
                                      'Yêu cầu tạo tài khoản mới'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor:
                                        context.textPrimary,
                                    side: BorderSide(
                                        color: context.border),
                                  ),
                                ),
                              ),

                              const SizedBox(height: AppSpacing.xxxl),

                              Text(
                                '© 2024 Quang Minh. All rights reserved.',
                                style: GoogleFonts.robotoCondensed(
                                  fontSize: 10,
                                  color: context.textSecondary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                if (state.isLoading)
                  Container(
                    color: context.opacity(Colors.black, 0.5),
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

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.robotoCondensed(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: context.textSecondary,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    String? errorText,
    bool isPassword = false,
    void Function(String)? onSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: isPassword && !_isPasswordVisible,
          style: GoogleFonts.inter(color: context.textPrimary),
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: context.textSecondary),
            prefixIcon:
                Icon(icon, color: context.textSecondary),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: context.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )
                : null,
            filled: true,
            fillColor: context.surfaceLow,
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: context.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: context.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppRadius.md),
              borderSide:
                  BorderSide(color: context.primary, width: 1.5),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              errorText,
              style: TextStyle(
                color: context.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}