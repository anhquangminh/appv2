import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_shadows.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/data/models/application_user.dart';
import 'package:ducanherp/data/models/nhanvien_model.dart';
import 'package:ducanherp/data/models/nhomnhanvien_model.dart';
import 'package:ducanherp/data/models/quanlynhanvien_model.dart';
import 'package:ducanherp/logic/bloc/nhanvien/nhanvien_bloc.dart';
import 'package:ducanherp/logic/bloc/nhanvien/nhanvien_event.dart';
import 'package:ducanherp/logic/bloc/nhanvien/nhanvien_state.dart';
import 'package:ducanherp/logic/bloc/quanlynhanvien/quanlynhanvien_bloc.dart';
import 'package:ducanherp/presentation/pages/quanlynhom/widgets/nhom_thanh_vien_list_item.dart';
import 'package:ducanherp/presentation/widgets/inputs/custom_dropdown_form_field.dart';
import 'package:ducanherp/presentation/widgets/shimmer/list_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NhomThanhVienDialog extends StatefulWidget {
  final ApplicationUser user;
  final NhomNhanVienModel nhom;
  final VoidCallback onChanged;

  const NhomThanhVienDialog({
    super.key,
    required this.user,
    required this.nhom,
    required this.onChanged,
  });

  @override
  State<NhomThanhVienDialog> createState() => _NhomThanhVienDialogState();
}

class _NhomThanhVienDialogState extends State<NhomThanhVienDialog> {
  final _formKey = GlobalKey<FormState>();
  late QuanLyNhanVienModel _searchVM;
  List<QuanLyNhanVienModel> _thanhVienList = [];
  List<NhanVienModel> _nhanVienList = [];
  NhanVienModel? _selectedNhanVien;
  bool _showAddForm = false;
  String? _errorMessage;

  List<NhanVienModel> get _availableNhanVienList {
    return _nhanVienList.where(_canAddNhanVien).toList();
  }

  bool _canAddNhanVien(NhanVienModel nhanVien) {
    final nhanVienId = nhanVien.id.trim().toLowerCase();
    final taiKhoan = nhanVien.taiKhoan.trim().toLowerCase();
    final managerId = widget.nhom.idQuanLy.trim().toLowerCase();
    final managerAccount = widget.nhom.taiKhoan.trim().toLowerCase();

    final isManager =
        (nhanVienId.isNotEmpty && nhanVienId == managerId) ||
        (taiKhoan.isNotEmpty && taiKhoan == managerAccount);
    if (isManager) return false;

    return !_thanhVienList.any((member) {
      if (member.isActive == 90) return false;

      final memberNhanVienId = member.idNhanVien.trim().toLowerCase();
      final memberAccount = member.taiKhoan.trim().toLowerCase();

      return (nhanVienId.isNotEmpty && nhanVienId == memberNhanVienId) ||
          (taiKhoan.isNotEmpty && taiKhoan == memberAccount);
    });
  }

  @override
  void initState() {
    super.initState();
    _searchVM = QuanLyNhanVienModel(
      id: '',
      idNhomNhanVien: widget.nhom.id,
      tenNhom: widget.nhom.tenNhom,
      groupId: widget.user.groupId,
      companyId: widget.nhom.companyId,
      companyName: widget.nhom.companyName,
      createAt: DateTime.now(),
      createBy: '',
      isActive: -1,
      pageNumber: 1,
      pageSize: 100,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _reloadMembers();
      _loadNhanVien();
    });
  }

  void _reloadMembers() {
    context.read<QuanLyNhanVienBloc>().add(GetQuanLyNhanVienByVM(_searchVM));
  }

  void _loadNhanVien() {
    context.read<NhanVienBloc>().add(
      GetNhanVienByVM(_createNhanVienSearchVM()),
    );
  }

  NhanVienModel _createNhanVienSearchVM() {
    return NhanVienModel(
      id: '',
      tenNhanVien: '',
      taiKhoan: '',
      companyId: widget.nhom.companyId,
      companyName: widget.nhom.companyName,
      groupId: widget.user.groupId,
      departmentId: '',
      departmentName: '',
      chucVuId: '',
      chucVu: '',
      chuyenMonId: '',
      chuyenMon: '',
      ordinarily: 1,
      createAt: DateTime.now(),
      createBy: '',
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
  }

  Future<bool?> _showConfirmDialog({
    required String title,
    required String message,
    bool danger = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: context.surfaceHighest,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.xlRadius),
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: context.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: context.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Hủy'),
              ),
              FilledButton(
                style:
                    danger
                        ? FilledButton.styleFrom(backgroundColor: context.error)
                        : null,
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Đồng ý'),
              ),
            ],
          ),
    );
  }

  Future<void> _deleteThanhVien(QuanLyNhanVienModel thanhVien) async {
    final confirm = await _showConfirmDialog(
      title: 'Xác nhận xóa',
      message:
          'Bạn có chắc muốn xóa "${thanhVien.tenNhanVien}" khỏi nhóm "${widget.nhom.tenNhom}" không?',
      danger: true,
    );

    if (confirm == true && mounted) {
      context.read<QuanLyNhanVienBloc>().add(
        DeleteQuanLyNhanVien(thanhVien.id, widget.user.userName),
      );
    }
  }

  Future<void> _handleMemberAction(
    QuanLyNhanVienModel thanhVien,
    String action,
  ) async {
    final isApprove = action == 'approve';
    final confirm = await _showConfirmDialog(
      title: isApprove ? 'Xác nhận duyệt' : 'Xác nhận hủy duyệt',
      message:
          'Bạn có chắc muốn ${isApprove ? 'duyệt' : 'hủy duyệt'} "${thanhVien.tenNhanVien}" không?',
    );

    if (confirm != true || !mounted) return;

    final bloc = context.read<QuanLyNhanVienBloc>();
    if (isApprove) {
      bloc.add(DuyetQuanLyNhanVien(thanhVien.id, widget.user.userName));
    } else {
      bloc.add(HuyDuyetQuanLyNhanVien(thanhVien.id, widget.user.userName));
    }
  }

  void _submitAddMember() {
    if (!_formKey.currentState!.validate()) return;
    final selected = _selectedNhanVien;
    if (selected == null) return;
    if (!_canAddNhanVien(selected)) {
      setState(() {
        _errorMessage =
            'Nhân viên này là quản lý nhóm hoặc đã tồn tại trong nhóm.';
        _selectedNhanVien = null;
      });
      return;
    }

    final model = QuanLyNhanVienModel(
      id: '',
      idNhomNhanVien: widget.nhom.id,
      tenNhom: widget.nhom.tenNhom,
      iconName: widget.nhom.iconName ?? '',
      idNhanVien: selected.id,
      tenNhanVien: selected.tenNhanVien,
      taiKhoan: selected.taiKhoan,
      groupId: widget.user.groupId,
      companyId: widget.nhom.companyId,
      companyName: widget.nhom.companyName,
      createAt: DateTime.now(),
      createBy: widget.user.userName,
      isActive: 1,
      pageNumber: 1,
      pageSize: 10,
    );

    context.read<QuanLyNhanVienBloc>().add(
      AddQuanLyNhanVien(model, widget.user.userName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<NhanVienBloc, NhanVienState>(
          listener: (context, state) {
            if (state is NhanVienByVMLoaded) {
              setState(() {
                _nhanVienList = state.nhanViens;
              });
            }
          },
        ),
        BlocListener<QuanLyNhanVienBloc, QuanLyNhanVienState>(
          listener: (context, state) {
            if (state is QuanLyNhanVienVMLoaded) {
              setState(() {
                _thanhVienList = state.quanLyNhanViens;
                if (_selectedNhanVien != null &&
                    !_canAddNhanVien(_selectedNhanVien!)) {
                  _selectedNhanVien = null;
                }
              });
            }
            if (state is QuanLyNhanVienSuccess) {
              setState(() {
                _errorMessage = null;
                _showAddForm = false;
                _selectedNhanVien = null;
              });
              _reloadMembers();
              widget.onChanged();
            }
            if (state is QuanLyNhanVienError) {
              setState(() {
                _errorMessage = state.message;
              });
            }
          },
        ),
      ],
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(AppSpacing.lg),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 680, maxHeight: 720),
          decoration: BoxDecoration(
            color: context.surfaceHighest,
            borderRadius: AppRadius.xlRadius,
            boxShadow: AppShadows.botanicalModal,
            border: Border.all(color: context.borderStrong),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    0,
                    AppSpacing.xl,
                    AppSpacing.xl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_errorMessage != null) _buildErrorBanner(context),
                      _buildAddMemberSection(context),
                      const SizedBox(height: AppSpacing.lg),
                      _buildMemberList(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
            child: Icon(Icons.group_rounded, color: context.primary, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thành viên nhóm',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: context.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  widget.nhom.tenNhom.isEmpty
                      ? 'Nhóm chưa đặt tên'
                      : widget.nhom.tenNhom,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: context.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
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

  Widget _buildErrorBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.error.withValues(alpha: 0.1),
        borderRadius: AppRadius.mdRadius,
        border: Border.all(color: context.error.withValues(alpha: 0.2)),
      ),
      child: Text(
        _errorMessage!,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: context.error),
      ),
    );
  }

  Widget _buildAddMemberSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.surfaceLow,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: context.borderStrong),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Thêm thành viên',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: context.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: _showAddForm ? 'Thu gọn' : 'Thêm thành viên',
                onPressed: () {
                  setState(() {
                    _showAddForm = !_showAddForm;
                    _selectedNhanVien = null;
                  });
                },
                icon: Icon(
                  _showAddForm
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.person_add_alt_1_rounded,
                ),
              ),
            ],
          ),
          if (_showAddForm) ...[
            const SizedBox(height: AppSpacing.md),
            Form(
              key: _formKey,
              child: CustomDropdownFormField<NhanVienModel>(
                label: 'Nhân viên',
                items: _availableNhanVienList,
                selectedId: _selectedNhanVien?.id ?? '',
                getId: (item) => item.id,
                getLabel: (item) => '${item.tenNhanVien} (${item.taiKhoan})',
                isRequired: true,
                onChanged: (value) {
                  setState(() {
                    _selectedNhanVien = value;
                  });
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _showAddForm = false;
                        _selectedNhanVien = null;
                      });
                    },
                    child: const Text('Hủy'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _submitAddMember,
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Thêm'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMemberList(BuildContext context) {
    return BlocBuilder<QuanLyNhanVienBloc, QuanLyNhanVienState>(
      builder: (context, state) {
        final isLoading =
            state is QuanLyNhanVienLoading && _thanhVienList.isEmpty;
        if (isLoading) {
          return const ListShimmer(key: ValueKey('loadingNhomThanhViens'));
        }

        if (_thanhVienList.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: context.background,
              borderRadius: AppRadius.lgRadius,
            ),
            child: Column(
              children: [
                Icon(
                  Icons.people_outline_rounded,
                  size: 44,
                  color: context.textSecondary,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Chưa có thành viên',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: context.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Danh sách thành viên (${_thanhVienList.length})',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: context.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ..._thanhVienList.map(
              (thanhVien) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: NhomThanhVienListItem(
                  thanhVien: thanhVien,
                  onDelete: () => _deleteThanhVien(thanhVien),
                  onActionSelected:
                      (action) => _handleMemberAction(thanhVien, action),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
