import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ducanherp/common/fa_icons.dart';
import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_shadows.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/data/models/application_user.dart';
import 'package:ducanherp/data/models/chinhanh_model.dart';
import 'package:ducanherp/data/models/nhanvien_model.dart';
import 'package:ducanherp/data/models/nhomnhanvien_model.dart';
import 'package:ducanherp/logic/bloc/chinhanh/chinhanh_bloc.dart';
import 'package:ducanherp/logic/bloc/chinhanh/chinhanh_event.dart';
import 'package:ducanherp/logic/bloc/chinhanh/chinhanh_state.dart';
import 'package:ducanherp/logic/bloc/nhanvien/nhanvien_bloc.dart';
import 'package:ducanherp/logic/bloc/nhanvien/nhanvien_event.dart';
import 'package:ducanherp/logic/bloc/nhanvien/nhanvien_state.dart';
import 'package:ducanherp/logic/bloc/nhomnhanvien/nhomnhanvien_bloc.dart';
import 'package:ducanherp/presentation/widgets/inputs/custom_dropdown_form_field.dart';
import 'package:ducanherp/presentation/widgets/inputs/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NhomNhanVienDialog extends StatefulWidget {
  final ApplicationUser user;
  final NhomNhanVienModel searchVM;
  final NhomNhanVienModel? nnv;

  const NhomNhanVienDialog({
    super.key,
    required this.user,
    required this.searchVM,
    this.nnv,
  });

  @override
  State<NhomNhanVienDialog> createState() => _NhomNhanVienDialogState();
}

class _NhomNhanVienDialogState extends State<NhomNhanVienDialog> {
  final _formKey = GlobalKey<FormState>();
  late bool isEditing;
  String? errorMessage;

  late TextEditingController tenNhomController;
  late TextEditingController taiKhoanController;

  List<ChiNhanhModel> chiNhanhModels = [];
  List<NhanVienModel> nhanVienList = [];

  ChiNhanhModel? selectedChiNhanh;
  NhanVienModel? selectedNhanVien;

  late String selectedIconName;
  bool firstLoad = true;

  @override
  void initState() {
    super.initState();
    isEditing = widget.nnv != null;
    tenNhomController = TextEditingController(text: widget.nnv?.tenNhom ?? '');
    taiKhoanController = TextEditingController(text: widget.nnv?.taiKhoan ?? '');
    selectedIconName = (widget.nnv?.iconName != null && faIconNames.contains(widget.nnv!.iconName))
        ? widget.nnv!.iconName!
        : faIconNames.first;
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setStateSB) {
        if (firstLoad) {
          firstLoad = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<ChiNhanhBloc>().add(FetchChiNhanh(groupId: widget.user.groupId));
          });
        }

        return MultiBlocListener(
          listeners: [
            _buildChiNhanhListener(setStateSB),
            _buildNhanVienListener(setStateSB),
            _buildNhomNhanVienListener(setStateSB),
          ],
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(AppSpacing.xl),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 640),
              decoration: BoxDecoration(
                color: context.surfaceHighest,
                borderRadius: AppRadius.xlRadius,
                boxShadow: AppShadows.botanicalModal,
                border: Border.all(color: context.borderStrong),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(context),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                      child: _buildBody(context, setStateSB),
                    ),
                    _buildFooter(context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // --- Header ---
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: context.secondaryContainer,
              borderRadius: AppRadius.mdRadius,
            ),
            child: Icon(Icons.groups_rounded, color: context.primary, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              isEditing ? 'Cập nhật nhóm' : 'Thêm nhóm mới',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: context.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded),
            style: IconButton.styleFrom(
              backgroundColor: context.surfaceLow,
              foregroundColor: context.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // --- Body ---
  Widget _buildBody(BuildContext context, StateSetter setStateSB) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (errorMessage != null) _buildErrorBanner(context),
          
          // Chi nhánh & Người quản lý
          _buildResponsiveRow([
            _buildBranchField(context, setStateSB),
            _buildManagerField(context, setStateSB),
          ]),
          const SizedBox(height: AppSpacing.lg),
          
          // Tên nhóm & Icon
          _buildResponsiveRow([
            _buildNameField(context, setStateSB),
            _buildIconField(context, setStateSB),
          ]),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  // --- Footer ---
  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: context.surfaceLow,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(AppRadius.xl)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy bỏ'),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: ElevatedButton(
              onPressed: _submit,
              child: Text(isEditing ? 'Cập nhật' : 'Thêm mới'),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---
  Widget _buildResponsiveRow(List<Widget> children) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 500) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children.map((e) => Expanded(child: Padding(
            padding: EdgeInsets.only(right: e == children.last ? 0 : AppSpacing.md),
            child: e,
          ))).toList(),
        );
      }
      return Column(children: children.map((e) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: e,
      )).toList());
    });
  }

  Widget _buildErrorBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.error.withValues(alpha: 0.1),
        borderRadius: AppRadius.mdRadius,
        border: Border.all(color: context.error.withValues(alpha: 0.2)),
      ),
      child: Text(
        errorMessage!,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.error),
      ),
    );
  }

  Widget _buildBranchField(BuildContext context, StateSetter setStateSB) {
    return CustomDropdownFormField<ChiNhanhModel>(
      label: 'Chi nhánh',
      items: chiNhanhModels,
      selectedId: selectedChiNhanh?.id ?? '',
      getId: (e) => e.id,
      getLabel: (e) => e.tenChiNhanh,
      isRequired: true,
      onChanged: (value) {
        setStateSB(() {
          selectedChiNhanh = value;
          selectedNhanVien = null;
          nhanVienList = [];
        });
        if (value != null) {
          context.read<NhanVienBloc>().add(GetNhanVienByVM(_createEmptyNhanVienModel(value.id)));
        }
      },
    );
  }

  Widget _buildManagerField(BuildContext context, StateSetter setStateSB) {
    return CustomDropdownFormField<NhanVienModel>(
      label: 'Người quản lý',
      items: nhanVienList,
      selectedId: selectedNhanVien?.id ?? '',
      getId: (e) => e.id,
      getLabel: (e) => '${e.tenNhanVien} (${e.taiKhoan})',
      isRequired: true,
      onChanged: (value) {
        setStateSB(() {
          selectedNhanVien = value;
          taiKhoanController.text = value?.taiKhoan ?? '';
        });
      },
    );
  }

  Widget _buildNameField(BuildContext context, StateSetter setStateSB) {
    return CustomTextFormField(
      label: 'Tên nhóm',
      controller: tenNhomController,
      hintText: 'Nhập tên nhóm quản lý...',
      onChanged: (_) => setStateSB(() {}),
      validator: (val) => (val == null || val.isEmpty) ? 'Vui lòng nhập tên nhóm' : null,
    );
  }

  Widget _buildIconField(BuildContext context, StateSetter setStateSB) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Biểu tượng', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: AppSpacing.xs),
        DropdownButtonFormField2<String>(
          value: selectedIconName,
          isExpanded: true,
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(color: context.surfaceHighest, borderRadius: AppRadius.lgRadius),
          ),
          items: faIconNames.map((icon) => DropdownMenuItem(
            value: icon,
            child: Row(
              children: [
                FaIcon(getFaIcon(icon), size: 16, color: context.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(icon.replaceAll('fa-', '').replaceAll('-', ' ')),
              ],
            ),
          )).toList(),
          onChanged: (val) => setStateSB(() => selectedIconName = val!),
        ),
      ],
    );
  }

  // --- Logic & BLoC Handlers ---
  NhanVienModel _createEmptyNhanVienModel(String companyId) {
    return NhanVienModel(
      id: '', tenNhanVien: '', taiKhoan: '', companyId: companyId,
      companyName: '', groupId: widget.user.groupId, departmentId: '',
      departmentName: '', chucVuId: '', chucVu: '', chuyenMonId: '',
      chuyenMon: '', ordinarily: 1, createAt: DateTime.now(), createBy: '',
      isActive: 1, approvalUserId: '', dateApproval: DateTime.now(),
      approvalDept: '', departmentOrder: 2, approvalOrder: 1, approvalId: '',
      lastApprovalId: '', isStatus: '',
    );
  }

  BlocListener _buildChiNhanhListener(StateSetter setStateSB) {
    return BlocListener<ChiNhanhBloc, ChiNhanhState>(
      listener: (context, state) {
        if (state is ChiNhanhLoaded) {
          setStateSB(() {
            chiNhanhModels = state.list;
            if (isEditing) {
              selectedChiNhanh = chiNhanhModels.firstWhere((e) => e.id == widget.nnv?.companyId, orElse: () => chiNhanhModels.first);
            }
          });
          if (isEditing && selectedChiNhanh != null) {
            context.read<NhanVienBloc>().add(GetNhanVienByVM(_createEmptyNhanVienModel(selectedChiNhanh!.id)));
          }
        }
      },
    );
  }

  BlocListener _buildNhanVienListener(StateSetter setStateSB) {
    return BlocListener<NhanVienBloc, NhanVienState>(
      listener: (context, state) {
        if (state is NhanVienByVMLoaded) {
          setStateSB(() {
            nhanVienList = state.nhanViens;
            if (isEditing) {
              selectedNhanVien = nhanVienList.firstWhere((e) => e.id == widget.nnv?.idQuanLy, orElse: () => nhanVienList.first);
            }
          });
        }
      },
    );
  }

  BlocListener _buildNhomNhanVienListener(StateSetter setStateSB) {
    return BlocListener<NhomNhanVienBloc, NhomNhanVienState>(
      listener: (context, state) {
        if (state is NhomNhanVienSuccess) {
          context.read<NhomNhanVienBloc>().add(GetNhomNhanVienByVM(widget.searchVM));
          Navigator.pop(context);
        }
        if (state is NhomNhanVienError) setStateSB(() => errorMessage = state.message);
      },
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final model = NhomNhanVienModel(
      id: widget.nnv?.id ?? '',
      idQuanLy: selectedNhanVien!.id,
      tenNhanVien: '',
      tenNhom: tenNhomController.text.trim(),
      iconName: selectedIconName,
      taiKhoan: '',
      total: 0,
      groupId: widget.user.groupId,
      companyId: selectedChiNhanh!.id,
      companyName: selectedChiNhanh!.tenChiNhanh,
      createAt: DateTime.now(),
      createBy: widget.user.userName,
      isActive: 1,
      pageNumber: 1,
      pageSize: 10,
    );
    context.read<NhomNhanVienBloc>().add(isEditing ? UpdateNhomNhanVien(model, widget.user.userName) : AddNhomNhanVien(model, widget.user.userName));
  }
}