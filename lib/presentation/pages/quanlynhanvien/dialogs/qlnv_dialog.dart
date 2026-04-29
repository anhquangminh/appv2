import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_shadows.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/data/models/application_user.dart';
import 'package:ducanherp/data/models/chinhanh_model.dart';
import 'package:ducanherp/data/models/chucvu_model.dart';
import 'package:ducanherp/data/models/chuyenmon_model.dart';
import 'package:ducanherp/data/models/dapartment_model.dart';
import 'package:ducanherp/data/models/nhanvien_model.dart';
import 'package:ducanherp/logic/bloc/chinhanh/chinhanh_bloc.dart';
import 'package:ducanherp/logic/bloc/chinhanh/chinhanh_event.dart';
import 'package:ducanherp/logic/bloc/chinhanh/chinhanh_state.dart';
import 'package:ducanherp/logic/bloc/chucvu/chucvu_bloc.dart';
import 'package:ducanherp/logic/bloc/chucvu/chucvu_event.dart';
import 'package:ducanherp/logic/bloc/chucvu/chucvu_state.dart';
import 'package:ducanherp/logic/bloc/chuyenmon/chuyenmon_bloc.dart';
import 'package:ducanherp/logic/bloc/chuyenmon/chuyenmon_event.dart';
import 'package:ducanherp/logic/bloc/chuyenmon/chuyenmon_state.dart';
import 'package:ducanherp/logic/bloc/department/department_bloc.dart';
import 'package:ducanherp/logic/bloc/department/department_event.dart';
import 'package:ducanherp/logic/bloc/department/department_state.dart';
import 'package:ducanherp/logic/bloc/nhanvien/nhanvien_bloc.dart';
import 'package:ducanherp/logic/bloc/nhanvien/nhanvien_event.dart';
import 'package:ducanherp/logic/bloc/nhanvien/nhanvien_state.dart';
import 'package:ducanherp/presentation/widgets/inputs/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QLNVDialog extends StatefulWidget {
  final NhanVienModel? nv;
  final ApplicationUser user;
  final NhanVienModel searchVM;

  const QLNVDialog({
    super.key,
    this.nv,
    required this.user,
    required this.searchVM,
  });

  @override
  State<QLNVDialog> createState() => _QLNVDialogState();
}

class _QLNVDialogState extends State<QLNVDialog> {
  final _formKey = GlobalKey<FormState>();
  late final bool isEditing;

  late final TextEditingController tenController;
  late final TextEditingController taiKhoanController;

  List<ChiNhanhModel> chiNhanhs = [];
  List<DepartmentModel> departments = [];
  List<ChucVuModel> chucVus = [];
  List<ChuyenMonModel> chuyenMons = [];

  ChiNhanhModel? selectedChiNhanh;
  DepartmentModel? selectedDepartment;
  ChucVuModel? selectedChucVu;
  ChuyenMonModel? selectedChuyenMon;

  String? errorMessage;
  bool firstLoad = true;

  @override
  void initState() {
    super.initState();
    isEditing = widget.nv != null;
    tenController = TextEditingController(text: widget.nv?.tenNhanVien ?? '');
    taiKhoanController = TextEditingController(text: widget.nv?.taiKhoan ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setStateSB) {
        if (firstLoad) {
          firstLoad = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loadBaseData();
          });
        }

        return MultiBlocListener(
          listeners: [
            BlocListener<NhanVienBloc, NhanVienState>(
              listener: (context, state) {
                if (state is NhanVienSuccess) {
                  context.read<NhanVienBloc>().add(
                    GetNhanVienByVM(widget.searchVM),
                  );
                  Navigator.pop(context);
                } else if (state is NhanVienError) {
                  setStateSB(() => errorMessage = state.message);
                }
              },
            ),
            BlocListener<ChiNhanhBloc, ChiNhanhState>(
              listener: (context, state) {
                if (state is ChiNhanhLoaded) {
                  setStateSB(() {
                    chiNhanhs = state.list;
                    if (isEditing && chiNhanhs.isNotEmpty) {
                      selectedChiNhanh = chiNhanhs.firstWhere(
                        (e) => e.id == widget.nv?.companyId,
                        orElse: () => chiNhanhs.first,
                      );
                    }
                  });
                }
              },
            ),
            BlocListener<DepartmentBloc, DepartmentState>(
              listener: (context, state) {
                if (state is DepartmentLoaded) {
                  setStateSB(() {
                    departments = state.departments;
                    if (isEditing && departments.isNotEmpty) {
                      selectedDepartment = departments.firstWhere(
                        (e) => e.id == widget.nv?.departmentId,
                        orElse: () => departments.first,
                      );
                    }
                  });
                }
              },
            ),
            BlocListener<ChucVuBloc, ChucVuState>(
              listener: (context, state) {
                if (state is ChucVuLoaded) {
                  setStateSB(() {
                    chucVus = state.chucVus;
                    if (isEditing &&
                        chucVus.isNotEmpty &&
                        selectedChucVu == null) {
                      selectedChucVu = chucVus.firstWhere(
                        (e) => e.id == widget.nv?.chucVuId,
                        orElse: () => chucVus.first,
                      );
                    }
                  });
                }
              },
            ),
            BlocListener<ChuyenMonBloc, ChuyenMonState>(
              listener: (context, state) {
                if (state is ChuyenMonLoaded) {
                  setStateSB(() {
                    chuyenMons = state.chuyenMons;
                    if (isEditing &&
                        chuyenMons.isNotEmpty &&
                        selectedChuyenMon == null) {
                      selectedChuyenMon = chuyenMons.firstWhere(
                        (e) => e.id == widget.nv?.chuyenMonId,
                        orElse: () => chuyenMons.first,
                      );
                    }
                  });
                }
              },
            ),
          ],
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 720;
              final dialogWidth = constraints.maxWidth >= 900 ? 720.0 : 640.0;

              return Dialog(
                backgroundColor: context.primary.withValues(alpha: 0),
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.lg,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: dialogWidth),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.surfaceHighest,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      boxShadow: AppShadows.botanicalModal,
                      border: Border.all(color: context.borderStrong),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(),
                            const SizedBox(height: AppSpacing.lg),
                            _buildPreviewCard(),
                            const SizedBox(height: AppSpacing.lg),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  if (errorMessage != null) ...[
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(
                                        AppSpacing.md,
                                      ),
                                      decoration: BoxDecoration(
                                        color: context.error.withValues(
                                          alpha: 0.08,
                                        ),
                                        borderRadius: AppRadius.mdRadius,
                                      ),
                                      child: Text(
                                        errorMessage!,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.copyWith(
                                          color: context.error,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.md),
                                  ],
                                  if (isWide)
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(child: _buildChiNhanh()),
                                        const SizedBox(width: AppSpacing.md),
                                        Expanded(
                                          child: _buildDepartment(setStateSB),
                                        ),
                                      ],
                                    )
                                  else ...[
                                    _buildChiNhanh(),
                                    const SizedBox(height: AppSpacing.md),
                                    _buildDepartment(setStateSB),
                                  ],
                                  const SizedBox(height: AppSpacing.md),
                                  if (isWide)
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(child: _buildChucVu()),
                                        const SizedBox(width: AppSpacing.md),
                                        Expanded(child: _buildChuyenMon()),
                                      ],
                                    )
                                  else ...[
                                    _buildChucVu(),
                                    const SizedBox(height: AppSpacing.md),
                                    _buildChuyenMon(),
                                  ],
                                  const SizedBox(height: AppSpacing.md),
                                  _buildTenNhanVien(),
                                  const SizedBox(height: AppSpacing.md),
                                  _buildTaiKhoan(),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Hủy'),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _submit,
                                    child: Text(
                                      isEditing ? 'Cập nhật' : 'Thêm nhân viên',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _loadBaseData() {
    context.read<ChiNhanhBloc>().add(
      FetchChiNhanh(groupId: widget.user.groupId),
    );
    context.read<DepartmentBloc>().add(
      FetchDepartments(
        DepartmentModel(
          id: '',
          companyId: '',
          deptName: '',
          phone: '',
          email: '',
          groupId: widget.user.groupId,
          ordinarily: 1,
          createAt: null,
          createBy: '',
          isActive: 1,
          approvalUserId: '',
          dateApproval: null,
          approvalDept: '',
          departmentId: '',
          departmentOrder: 0,
          approvalOrder: 0,
          approvalId: '',
          lastApprovalId: '',
          isStatus: '0',
          pageNumber: 1,
          pageSize: 20,
        ),
      ),
    );

    if (isEditing && widget.nv != null) {
      _loadDependentData(widget.nv!.departmentId);
    }
  }

  void _loadDependentData(String departmentId) {
    context.read<ChucVuBloc>().add(
      FetchChucVu(
        ChucVuModel(
          id: '',
          chucVu: '',
          groupId: widget.user.groupId,
          ordinarily: 0,
          createAt: null,
          createBy: '',
          isActive: 0,
          approvalUserId: '',
          dateApproval: null,
          approvalDept: '',
          departmentId: departmentId,
          departmentOrder: 0,
          approvalOrder: 0,
          approvalId: '',
          lastApprovalId: '',
          isStatus: '',
          pageNumber: 1,
          pageSize: 10,
        ),
      ),
    );

    context.read<ChuyenMonBloc>().add(
      FetchChuyenMon(
        ChuyenMonModel(
          id: '',
          chuyenMon: '',
          groupId: widget.user.groupId,
          ordinarily: 1,
          createAt: null,
          createBy: '',
          isActive: 1,
          approvalUserId: '',
          dateApproval: null,
          approvalDept: '',
          departmentId: departmentId,
          departmentOrder: 0,
          approvalOrder: 0,
          approvalId: '',
          lastApprovalId: '',
          isStatus: '',
          pageNumber: 1,
          pageSize: 10,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: context.secondaryContainer,
            borderRadius: AppRadius.mdRadius,
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.person_outline_rounded,
            color: context.primary,
            size: 22,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'Cập nhật nhân viên' : 'Thêm mới nhân viên',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: context.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                'Quản lý thông tin nhân sự theo chi nhánh, phòng ban và vai trò.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: context.textSecondary),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: AppRadius.pillRadius,
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: context.background,
              borderRadius: AppRadius.pillRadius,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.close_rounded,
              color: context.textPrimary,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surfaceHigh,
        borderRadius: AppRadius.xlRadius,
        border: Border.all(color: context.borderStrong),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: context.secondaryContainer,
              borderRadius: AppRadius.mdRadius,
            ),
            alignment: Alignment.center,
            child: Text(
              _previewInitials(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: context.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tenController.text.trim().isEmpty
                      ? 'Tên nhân viên sẽ hiển thị ở đây'
                      : tenController.text.trim(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: context.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  selectedDepartment?.deptName ?? 'Chưa chọn phòng ban',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: context.textSecondary),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  selectedChucVu?.chucVu ?? 'Chưa chọn chức vụ',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _previewInitials() {
    final value = tenController.text.trim();
    if (value.isEmpty) return 'NV';
    final words = value.split(RegExp(r'\s+'));
    if (words.length == 1) return words.first.substring(0, 1).toUpperCase();
    return '${words.first.substring(0, 1)}${words.last.substring(0, 1)}'
        .toUpperCase();
  }

  Widget _buildChiNhanh() => DropdownButtonFormField<ChiNhanhModel>(
    value: selectedChiNhanh,
    decoration: const InputDecoration(labelText: 'Chi nhánh'),
    items:
        chiNhanhs
            .map((e) => DropdownMenuItem(value: e, child: Text(e.tenChiNhanh)))
            .toList(),
    onChanged: (value) => setState(() => selectedChiNhanh = value),
    validator: (value) => value == null ? 'Vui lòng chọn chi nhánh' : null,
  );

  Widget _buildDepartment(StateSetter setStateSB) =>
      DropdownButtonFormField<DepartmentModel>(
        value: selectedDepartment,
        decoration: const InputDecoration(labelText: 'Bộ phận'),
        items:
            departments
                .map((e) => DropdownMenuItem(value: e, child: Text(e.deptName)))
                .toList(),
        onChanged: (value) {
          setStateSB(() {
            selectedDepartment = value;
            selectedChucVu = null;
            selectedChuyenMon = null;
          });
          if (value != null) {
            _loadDependentData(value.id);
          }
        },
        validator: (value) => value == null ? 'Vui lòng chọn bộ phận' : null,
      );

  Widget _buildChucVu() => DropdownButtonFormField<ChucVuModel>(
    value: selectedChucVu,
    decoration: const InputDecoration(labelText: 'Chức vụ'),
    items:
        chucVus
            .map((e) => DropdownMenuItem(value: e, child: Text(e.chucVu)))
            .toList(),
    onChanged: (value) => setState(() => selectedChucVu = value),
    validator: (value) => value == null ? 'Vui lòng chọn chức vụ' : null,
  );

  Widget _buildChuyenMon() => DropdownButtonFormField<ChuyenMonModel>(
    value: selectedChuyenMon,
    decoration: const InputDecoration(labelText: 'Chuyên môn'),
    items:
        chuyenMons
            .map((e) => DropdownMenuItem(value: e, child: Text(e.chuyenMon)))
            .toList(),
    onChanged: (value) => setState(() => selectedChuyenMon = value),
    validator: (value) => value == null ? 'Vui lòng chọn chuyên môn' : null,
  );

  Widget _buildTenNhanVien() => CustomTextFormField(
    label: 'Ten nhan vien',
    controller: tenController,
    onChanged: (_) => setState(() {}),
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return 'Tên nhân viên không được bỏ trống';
      }
      if (value.trim().length < 2) {
        return 'Tên nhân viên phải > 2 ký tự';
      }
      final regex = RegExp(r'^[a-zA-Z\s]+$');
      if (!regex.hasMatch(value.trim())) {
        return 'Tên nhân viên không hợp lệ';
      }
      return null;
    },
  );

  Widget _buildTaiKhoan() => CustomTextFormField(
    label: 'Tài khoản (email)',
    controller: taiKhoanController,
    enabled: !isEditing,
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return 'Email không được bỏ trống';
      }
      final emailRegex = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value.trim())) {
        return 'Email không hợp lệ';
      }
      return null;
    },
  );

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (selectedDepartment == null ||
        selectedChucVu == null ||
        selectedChuyenMon == null ||
        selectedChiNhanh == null) {
      setState(() => errorMessage = 'Vui lòng điền đầy đủ thông tin');
      return;
    }

    final model = NhanVienModel(
      id: widget.nv?.id ?? '',
      tenNhanVien: tenController.text.trim(),
      taiKhoan: taiKhoanController.text.trim(),
      companyId: selectedChiNhanh!.id,
      companyName: selectedChiNhanh!.tenChiNhanh,
      groupId: widget.user.groupId,
      departmentId: selectedDepartment!.id,
      departmentName: selectedDepartment!.deptName,
      chucVuId: selectedChucVu!.id,
      chucVu: selectedChucVu!.chucVu,
      chuyenMonId: selectedChuyenMon!.id,
      chuyenMon: selectedChuyenMon!.chuyenMon,
      ordinarily: 1,
      createAt: DateTime.now(),
      createBy: widget.user.userName,
      isActive: 1,
      approvalUserId: '',
      dateApproval: DateTime.now(),
      approvalDept: '',
      departmentOrder: 2,
      approvalOrder: 1,
      approvalId: '',
      lastApprovalId: '',
      isStatus: '',
    );

    context.read<NhanVienBloc>().add(
      isEditing
          ? UpdateNhanVien(model, widget.user.userName)
          : AddNhanVien(model, widget.user.userName),
    );
  }
}
