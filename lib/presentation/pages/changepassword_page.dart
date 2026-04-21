import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/changepassword_mode.dart';
import '../../logic/bloc/appuser/appuser_bloc.dart';
import '../../logic/bloc/appuser/appuser_event.dart';
import '../../logic/bloc/appuser/appuser_state.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  String errorMessage = '';

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final model = ChangePasswordModel(
        email: "",
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      context.read<AppUserBloc>().add(
            ChangePasswordSubmitted(changePasswordModel: model),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        title: Text(
          'Đổi mật khẩu',
          style: GoogleFonts.robotoCondensed(
            fontWeight: FontWeight.bold,
            color: context.textPrimary,
          ),
        ),
        backgroundColor: context.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: context.textPrimary),
      ),
      body: BlocListener<AppUserBloc, AppUserState>(
        listener: (context, state) async {
          if (state.isLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => Center(
                child: CircularProgressIndicator(
                  color: context.primary,
                ),
              ),
            );
          } else {
            if (Navigator.canPop(context)) Navigator.pop(context);
          }

          if (state.errorMessage != null &&
              state.errorMessage!.isNotEmpty) {
            setState(() {
              errorMessage = state.errorMessage!;
            });
          }

          if (state.isPasswordChanged) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Đổi mật khẩu thành công!'),
                backgroundColor: context.success,
              ),
            );

            await Future.delayed(const Duration(seconds: 1));

            if (mounted) {
              // ignore: use_build_context_synchronously
              Navigator.of(context)
                  .pushReplacementNamed(AppRouter.login);
            }
          }
        },
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.lg),

                      // TITLE
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'CẬP NHẬT MẬT KHẨU',
                          style: GoogleFonts.robotoCondensed(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: context.textSecondary,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      if (errorMessage.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppSpacing.md),
                          margin: const EdgeInsets.only(
                              bottom: AppSpacing.md),
                          decoration: BoxDecoration(
                            color: context.error.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppRadius.md),
                          ),
                          child: Text(
                            errorMessage,
                            style: TextStyle(
                              color: context.error,
                              fontSize: 12,
                            ),
                          ),
                        ),

                      _buildLabel('MẬT KHẨU HIỆN TẠI'),
                      const SizedBox(height: AppSpacing.xs),
                      _buildTextField(
                        controller: _currentPasswordController,
                        hintText: 'Nhập mật khẩu hiện tại',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        obscure: _obscureCurrent,
                        onToggle: () => setState(
                            () => _obscureCurrent = !_obscureCurrent),
                        validator: (value) =>
                            value == null || value.isEmpty
                                ? 'Nhập mật khẩu hiện tại'
                                : null,
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      _buildLabel('MẬT KHẨU MỚI'),
                      const SizedBox(height: AppSpacing.xs),
                      _buildTextField(
                        controller: _newPasswordController,
                        hintText: '••••••••',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        obscure: _obscureNew,
                        onToggle: () => setState(
                            () => _obscureNew = !_obscureNew),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập mật khẩu';
                          }
                          if (value.length < 6) {
                            return 'Mật khẩu phải từ 6 ký tự';
                          }

                          final upper = RegExp(r'[A-Z]');
                          final lower = RegExp(r'[a-z]');
                          final digit = RegExp(r'\d');
                          final special =
                              RegExp(r'[!@#\$%^&*(),.?":{}|<>]');

                          if (!upper.hasMatch(value)) {
                            return 'Mật khẩu phải có chữ hoa';
                          }
                          if (!lower.hasMatch(value)) {
                            return 'Mật khẩu phải có chữ thường';
                          }
                          if (!digit.hasMatch(value)) {
                            return 'Mật khẩu phải có số';
                          }
                          if (!special.hasMatch(value)) {
                            return 'Mật khẩu phải có ký tự đặc biệt';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      _buildLabel('XÁC NHẬN MẬT KHẨU'),
                      const SizedBox(height: AppSpacing.xs),
                      _buildTextField(
                        controller: _confirmPasswordController,
                        hintText: '••••••••',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        obscure: _obscureConfirm,
                        onToggle: () => setState(
                            () => _obscureConfirm = !_obscureConfirm),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập lại mật khẩu';
                          }
                          if (value !=
                              _newPasswordController.text) {
                            return 'Mật khẩu không khớp';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSpacing.xxxl),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _submit,
                          child: Text(
                            'CẬP NHẬT',
                            style: GoogleFonts.robotoCondensed(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // LOADING OVERLAY
            context.watch<AppUserBloc>().state.isLoading
                ? Container(
                    color: context.opacity(Colors.black, 0.5),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: context.primary,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
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
    required bool obscure,
    required VoidCallback onToggle,
    required String? Function(String?)? validator,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? obscure : false,
      validator: validator,
      style: GoogleFonts.inter(color: context.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: context.textSecondary),
        prefixIcon: Icon(icon, color: context.textSecondary),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscure
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: context.textSecondary,
                ),
                onPressed: onToggle,
              )
            : null,
        filled: true,
        fillColor: context.surfaceLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: context.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: context.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide:
              BorderSide(color: context.primary, width: 1.5),
        ),
      ),
    );
  }
}