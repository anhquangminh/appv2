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
import 'package:ducanherp/presentation/widgets/dialog/custom_dialog.dart';
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
  bool _firstLoad = true;

  @override
  void initState() {
    super.initState();

    isEditing = widget.nv != null;

    tenController = TextEditingController(text: widget.nv?.tenNhanVien ?? '');
    taiKhoanController = TextEditingController(text: widget.nv?.taiKhoan ?? '');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_firstLoad) {
      _firstLoad = false;

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

      if (isEditing) {
        final deptId = widget.nv!.departmentId;

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
              departmentId: deptId,
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
              departmentId: deptId,
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
    }
  }

  @override
  Widget build(BuildContext context) {
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
              setState(() => errorMessage = state.message);
            }
          },
        ),

        BlocListener<ChiNhanhBloc, ChiNhanhState>(
          listener: (context, state) {
            if (state is ChiNhanhLoaded) {
              setState(() {
                chiNhanhs = state.list;

                if (isEditing) {
                  selectedChiNhanh = chiNhanhs.firstWhere(
                    (e) => e.id == widget.nv!.companyId,
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
              setState(() {
                departments = state.departments;

                if (isEditing) {
                  selectedDepartment = departments.firstWhere(
                    (e) => e.id == widget.nv!.departmentId,
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
              setState(() {
                chucVus = state.chucVus;

                if (isEditing && selectedChucVu == null) {
                  selectedChucVu = chucVus.firstWhere(
                    (e) => e.id == widget.nv!.chucVuId,
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
              setState(() {
                chuyenMons = state.chuyenMons;

                if (isEditing && selectedChuyenMon == null) {
                  selectedChuyenMon = chuyenMons.firstWhere(
                    (e) => e.id == widget.nv!.chuyenMonId,
                    orElse: () => chuyenMons.first,
                  );
                }
              });
            }
          },
        ),
      ],
      child: CustomDialog(
        title: isEditing ? 'Sửa Nhân Viên' : 'Thêm Nhân Viên',
        onClose: () => Navigator.pop(context),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),

                _buildChiNhanh(),
                const SizedBox(height: 16),
                _buildDepartment(),
                const SizedBox(height: 16),
                _buildChucVu(),
                const SizedBox(height: 16),
                _buildChuyenMon(),
                const SizedBox(height: 16),
                _buildTenNhanVien(),
                const SizedBox(height: 16),
                _buildTaiKhoan(),
              ],
            ),
          ),
        ),
        actions: _buildActions(),
      ),
    );
  }

  // ================= UI =================

  Widget _buildChiNhanh() => DropdownButtonFormField<ChiNhanhModel>(
    value: selectedChiNhanh,
    decoration: const InputDecoration(labelText: 'Chi nhánh'),
    items:
        chiNhanhs
            .map((e) => DropdownMenuItem(value: e, child: Text(e.tenChiNhanh)))
            .toList(),
    onChanged: (v) => setState(() => selectedChiNhanh = v),
    validator: (v) => v == null ? 'Vui lòng chọn chi nhánh' : null,
  );

  Widget _buildDepartment() => DropdownButtonFormField<DepartmentModel>(
    value: selectedDepartment,
    decoration: const InputDecoration(labelText: 'Bộ phận'),
    items:
        departments
            .map((e) => DropdownMenuItem(value: e, child: Text(e.deptName)))
            .toList(),
    onChanged: (value) {
      setState(() {
        selectedDepartment = value;
        selectedChucVu = null;
        selectedChuyenMon = null;
      });

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
            departmentId: value!.id,
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
            departmentId: value.id,
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
    },
    validator: (v) => v == null ? 'Vui lòng chọn bộ phận' : null,
  );

  Widget _buildChucVu() => DropdownButtonFormField<ChucVuModel>(
    value: selectedChucVu,
    decoration: const InputDecoration(labelText: 'Chức vụ'),
    items:
        chucVus
            .map((e) => DropdownMenuItem(value: e, child: Text(e.chucVu)))
            .toList(),
    onChanged: (v) => setState(() => selectedChucVu = v),
    validator: (v) => v == null ? 'Vui lòng chọn chức vụ' : null,
  );

  Widget _buildChuyenMon() => DropdownButtonFormField<ChuyenMonModel>(
    value: selectedChuyenMon,
    decoration: const InputDecoration(labelText: 'Chuyên môn'),
    items:
        chuyenMons
            .map((e) => DropdownMenuItem(value: e, child: Text(e.chuyenMon)))
            .toList(),
    onChanged: (v) => setState(() => selectedChuyenMon = v),
    validator: (v) => v == null ? 'Vui lòng chọn chuyên môn' : null,
  );

  Widget _buildTenNhanVien() => CustomTextFormField(
    label: 'Tên nhân viên',
    controller: tenController,
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return 'Tên nhân viên không được để trống';
      }

      if (value.trim().length < 2) {
        return 'Tên nhân viên phải có ít nhất 2 ký tự';
      }

      final regex = RegExp(r'^[a-zA-ZÀ-ỹ\s]+$');
      if (!regex.hasMatch(value.trim())) {
        return 'Tên nhân viên không được chứa số hoặc ký tự đặc biệt';
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
        return 'Email không được để trống';
      }

      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

      if (!emailRegex.hasMatch(value.trim())) {
        return 'Email không hợp lệ';
      }

      return null;
    },
  );

  List<Widget> _buildActions() => [
    TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text('Hủy'),
    ),
    ElevatedButton(
      onPressed: _submit,
      child: Text(isEditing ? 'Cập nhật' : 'Thêm'),
    ),
  ];

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final model = NhanVienModel(
      id: widget.nv?.id ?? '',
      tenNhanVien: tenController.text.trim(),
      taiKhoan: taiKhoanController.text.trim(),
      companyId: selectedChiNhanh?.id ?? '',
      companyName: selectedChiNhanh?.tenChiNhanh ?? '',
      groupId: widget.user.groupId,
      departmentId: selectedDepartment!.id,
      departmentName: '',
      chucVuId: selectedChucVu!.id,
      chucVu: '',
      chuyenMonId: selectedChuyenMon!.id,
      chuyenMon: '',
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
