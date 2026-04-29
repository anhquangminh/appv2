import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/logic/bloc/appuser/appuser_bloc.dart';
import 'package:ducanherp/logic/bloc/appuser/appuser_event.dart';
import 'package:ducanherp/logic/bloc/appuser/appuser_state.dart';
import 'package:ducanherp/routes/app_router.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    } else if (_dob == null) {
      setState(() {
        errorMessage = 'Vui lòng chọn ngày sinh';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.sizeOf(context).width > 600;

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Đăng ký tài khoản',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: context.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
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
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: AppSpacing.lg,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildHeroSection(context),
                        const SizedBox(height: AppSpacing.xl),
                        _buildForm(context, isTablet),
                        const SizedBox(height: AppSpacing.xxl),
                        _buildBottomSection(context),
                        const SizedBox(height: AppSpacing.xxl),
                        _buildFooter(context),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Chào mừng trở lại!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: context.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            'Đăng nhập để tiếp tục quản lý và theo dõi công việc của bạn một cách hiệu quả.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context, bool isTablet) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isTablet)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildInputGroup(
                    label: 'Họ',
                    child: _buildTextField(
                      controller: _lastNameController,
                      hintText: 'Nguyễn',
                      icon: Icons.person_outline,
                      validator:
                          (v) =>
                              v == null || v.isEmpty
                                  ? 'Vui lòng nhập họ'
                                  : null,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: _buildInputGroup(
                    label: 'Tên',
                    child: _buildTextField(
                      controller: _firstNameController,
                      hintText: 'Anh Quân',
                      icon: Icons.badge_outlined,
                      validator:
                          (v) =>
                              v == null || v.isEmpty
                                  ? 'Vui lòng nhập tên'
                                  : null,
                    ),
                  ),
                ),
              ],
            )
          else ...[
            _buildInputGroup(
              label: 'Họ',
              child: _buildTextField(
                controller: _lastNameController,
                hintText: 'Nguyễn',
                icon: Icons.person_outline,
                validator:
                    (v) => v == null || v.isEmpty ? 'Vui lòng nhập họ' : null,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildInputGroup(
              label: 'Tên',
              child: _buildTextField(
                controller: _firstNameController,
                hintText: 'Anh Quân',
                icon: Icons.badge_outlined,
                validator:
                    (v) => v == null || v.isEmpty ? 'Vui lòng nhập tên' : null,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          _buildInputGroup(
            label: 'Email',
            child: _buildTextField(
              controller: _emailController,
              hintText: 'example@evergreen.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Vui lòng nhập email';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
                  return 'Email không hợp lệ';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildInputGroup(
            label: 'Ngày sinh',
            child: GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: _buildTextField(
                  controller: TextEditingController(
                    text:
                        _dob == null
                            ? ''
                            : '${_dob!.day.toString().padLeft(2, '0')}/${_dob!.month.toString().padLeft(2, '0')}/${_dob!.year}',
                  ),
                  hintText: 'dd/mm/yyyy',
                  icon: Icons.calendar_today_outlined,
                  suffixIcon: Icons.calendar_month,
                  validator: (_) {
                    if (_dob == null) return 'Vui lòng chọn ngày sinh';
                    if (_dob!.isAfter(DateTime.now())) {
                      return 'Ngày sinh phải trước hôm nay';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildInputGroup(
            label: 'Số điện thoại',
            child: _buildTextField(
              controller: _phoneNumberController,
              hintText: '090 123 4567',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Vui lòng nhập SĐT';
                if (!RegExp(r'^0\d{9}$').hasMatch(v.replaceAll(' ', ''))) {
                  return 'Số điện thoại không hợp lệ';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildInputGroup(
            label: 'Tên công ty',
            child: _buildTextField(
              controller: _companyNameController,
              hintText: 'Công ty TNHH Evergreen Việt Nam',
              icon: Icons.business_outlined,
              validator:
                  (v) =>
                      v == null || v.isEmpty
                          ? 'Vui lòng nhập tên công ty'
                          : null,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildInputGroup(
            label: 'Địa chỉ công ty',
            child: _buildTextField(
              controller: _addressController,
              hintText: 'Tầng 12, Tòa nhà X, TP. Hồ Chí Minh',
              icon: Icons.location_on_outlined,
              validator:
                  (v) =>
                      v == null || v.isEmpty ? 'Vui lòng nhập địa chỉ' : null,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildInputGroup(
            label: 'Mã số thuế',
            child: _buildTextField(
              controller: _taxController,
              hintText: '0102030405',
              icon: Icons.receipt_outlined,
              validator:
                  (v) =>
                      v == null || v.isEmpty
                          ? 'Vui lòng nhập mã số thuế'
                          : null,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildInputGroup(
            label: 'Mật khẩu',
            child: _buildTextField(
              controller: _passwordController,
              hintText: '••••••••',
              icon: Icons.lock_outline,
              isPassword: true,
              obscure: _obscurePassword,
              toggle:
                  () => setState(() => _obscurePassword = !_obscurePassword),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Vui lòng nhập mật khẩu';
                if (v.length < 6) return 'Mật khẩu phải từ 6 ký tự';
                return null;
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildInputGroup(
            label: 'Nhập lại mật khẩu',
            child: _buildTextField(
              controller: _confirmPasswordController,
              hintText: '••••••••',
              icon: Icons.history_outlined,
              isPassword: true,
              obscure: _obscureConfirmPassword,
              toggle:
                  () => setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword,
                  ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Vui lòng nhập lại mật khẩu';
                if (v != _passwordController.text) return 'Mật khẩu không khớp';
                return null;
              },
            ),
          ),
          if (errorMessage.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(errorMessage, style: TextStyle(color: context.error)),
          ],
        ],
      ),
    );
  }

  Widget _buildInputGroup({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: context.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        child,
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    IconData? suffixIcon,
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
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(color: context.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: context.textHint),
        prefixIcon: Icon(icon, color: context.textSecondary, size: 20),
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    color: context.textSecondary,
                    size: 20,
                  ),
                  onPressed: toggle,
                )
                : (suffixIcon != null
                    ? Icon(suffixIcon, color: context.textSecondary, size: 20)
                    : null),
        filled: true,
        fillColor: context.surfaceHigh, // Assuming a soft grey filling
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(
            color: context.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: context.error, width: 1),
        ),
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primary,
              foregroundColor: context.onPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
            child: Text(
              'Đăng ký ngay',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: context.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        RichText(
          text: TextSpan(
            text: 'Đã có tài khoản? ',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: context.textSecondary),
            children: [
              TextSpan(
                text: 'Đăng nhập ngay',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: context.primary,
                  fontWeight: FontWeight.bold,
                ),
                recognizer:
                    TapGestureRecognizer()
                      ..onTap = () {
                        // Navigate to Login
                        Navigator.of(context).pop();
                      },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: context.border)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                'ĐỨC ANH',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: context.textHint,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(child: Divider(color: context.border)),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Bằng việc đăng ký, bạn đồng ý với Điều khoản dịch vụ và Chính\nsách bảo mật của chúng tôi.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: context.textHint,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
