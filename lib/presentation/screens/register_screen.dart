import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/logic/bloc/appuser/appuser_bloc.dart';
import 'package:ducanherp/logic/bloc/appuser/appuser_event.dart';
import 'package:ducanherp/logic/bloc/appuser/appuser_state.dart';
import 'package:ducanherp/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/register_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _lastNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _taxController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  RegisterModel registerModel = RegisterModel(
    lastName: '',
    firstName: '',
    email: '',
    dob: DateTime.now(),
    phoneNumber: '',
    companyName: '',
    address: '',
    tax: '',
    password: '',
  );

  String errorMessage = '';
  DateTime? _dob;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _companyNameController.dispose();
    _addressController.dispose();
    _taxController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _dob = picked);
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _dob != null) {
      registerModel = RegisterModel(
        lastName: _lastNameController.text,
        firstName: _firstNameController.text,
        email: _emailController.text,
        dob: _dob!,
        phoneNumber: _phoneNumberController.text,
        companyName: _companyNameController.text,
        address: _addressController.text,
        tax: _taxController.text,
        password: _passwordController.text,
      );

      context.read<AppUserBloc>().add(
        RegisterSubmitted(registerModel: registerModel),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        backgroundColor: context.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Đăng ký',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: context.textPrimary,
          ),
        ),
        iconTheme: IconThemeData(color: context.textPrimary),
      ),
      body: BlocListener<AppUserBloc, AppUserState>(
        listener: (context, state) async {
          if (state.isLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else {
            if (Navigator.canPop(context)) Navigator.pop(context);
          }

          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            setState(() {
              errorMessage = state.errorMessage!;
            });
          }

          if (state.isRegistered) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đăng ký thành công!')),
            );
            await Future.delayed(const Duration(seconds: 1));
            if (mounted) {
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushReplacementNamed(
                AppRouter.welcome,
                arguments: {'registerModel': registerModel},
              );
            }
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: AppSpacing.lg),

                        _buildLabel('HỌ'),
                        _buildTextField(
                          controller: _lastNameController,
                          hintText: 'Nhập họ',
                          icon: Icons.person,
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'Vui lòng nhập họ'
                                      : null,
                        ),

                        _buildLabel('TÊN'),
                        _buildTextField(
                          controller: _firstNameController,
                          hintText: 'Nhập tên',
                          icon: Icons.person_outline,
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'Vui lòng nhập tên'
                                      : null,
                        ),

                        _buildLabel('EMAIL'),
                        _buildTextField(
                          controller: _emailController,
                          hintText: 'Nhập email',
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Vui lòng nhập email';
                            }
                            final regex = RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            );
                            if (!regex.hasMatch(v)) {
                              return 'Email không hợp lệ';
                            }
                            return null;
                          },
                        ),

                        _buildLabel('NGÀY SINH'),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: _buildTextField(
                              controller: TextEditingController(
                                text:
                                    _dob == null
                                        ? ''
                                        : '${_dob!.day}/${_dob!.month}/${_dob!.year}',
                              ),
                              hintText: 'Chọn ngày sinh',
                              icon: Icons.cake,
                              validator: (_) {
                                if (_dob == null) {
                                  return 'Vui lòng chọn ngày sinh';
                                }
                                if (_dob!.isAfter(DateTime.now())) {
                                  return 'Ngày sinh phải trước hôm nay';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),

                        _buildLabel('SỐ ĐIỆN THOẠI'),
                        _buildTextField(
                          controller: _phoneNumberController,
                          hintText: 'Nhập số điện thoại',
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Vui lòng nhập số điện thoại';
                            }
                            if (!RegExp(r'^0\d{9}$').hasMatch(v)) {
                              return 'Số điện thoại không hợp lệ';
                            }
                            return null;
                          },
                        ),

                        _buildLabel('TÊN CÔNG TY'),
                        _buildTextField(
                          controller: _companyNameController,
                          hintText: 'Nhập tên công ty',
                          icon: Icons.business,
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'Vui lòng nhập tên công ty'
                                      : null,
                        ),

                        _buildLabel('ĐỊA CHỈ'),
                        _buildTextField(
                          controller: _addressController,
                          hintText: 'Nhập địa chỉ',
                          icon: Icons.home,
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'Vui lòng nhập địa chỉ'
                                      : null,
                        ),

                        _buildLabel('MÃ SỐ THUẾ'),
                        _buildTextField(
                          controller: _taxController,
                          hintText: 'Nhập mã số thuế',
                          icon: Icons.confirmation_number,
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'Vui lòng nhập mã số thuế'
                                      : null,
                        ),

                        _buildLabel('MẬT KHẨU'),
                        _buildTextField(
                          controller: _passwordController,
                          hintText: '••••••••',
                          icon: Icons.lock,
                          isPassword: true,
                          obscure: _obscurePassword,
                          toggle:
                              () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Vui lòng nhập mật khẩu';
                            }
                            if (v.length < 6) {
                              return 'Mật khẩu phải từ 6 ký tự';
                            }
                            if (!RegExp(r'[A-Z]').hasMatch(v)) {
                              return 'Phải có chữ hoa';
                            }
                            if (!RegExp(r'[a-z]').hasMatch(v)) {
                              return 'Phải có chữ thường';
                            }
                            if (!RegExp(r'\d').hasMatch(v)) {
                              return 'Phải có số';
                            }
                            if (!RegExp(
                              r'[!@#\$%^&*(),.?":{}|<>]',
                            ).hasMatch(v)) {
                              return 'Phải có ký tự đặc biệt';
                            }
                            return null;
                          },
                        ),

                        _buildLabel('NHẬP LẠI MẬT KHẨU'),
                        _buildTextField(
                          controller: _confirmPasswordController,
                          hintText: '••••••••',
                          icon: Icons.lock_outline,
                          isPassword: true,
                          obscure: _obscureConfirmPassword,
                          toggle:
                              () => setState(
                                () =>
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword,
                              ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Vui lòng nhập lại mật khẩu';
                            }
                            if (v != _passwordController.text) {
                              return 'Mật khẩu không khớp';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        if (errorMessage.isNotEmpty)
                          Text(
                            errorMessage,
                            style: TextStyle(color: context.error),
                          ),

                        const SizedBox(height: AppSpacing.lg),

                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _submit,
                            child: Text(
                              'ĐĂNG KÝ',
                              style: GoogleFonts.robotoCondensed(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: AppSpacing.xxxl),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(
          top: AppSpacing.lg,
          bottom: AppSpacing.xs,
        ),
        child: Text(
          text,
          style: GoogleFonts.robotoCondensed(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: context.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? toggle,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      validator: validator,
      style: GoogleFonts.inter(color: context.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: context.textSecondary),
        prefixIcon: Icon(icon, color: context.textSecondary),
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    color: context.textSecondary,
                  ),
                  onPressed: toggle,
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
          borderSide: BorderSide(color: context.primary, width: 1.5),
        ),
      ),
    );
  }
}
