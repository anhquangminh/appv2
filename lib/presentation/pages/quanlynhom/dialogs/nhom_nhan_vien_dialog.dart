import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:ducanherp/common/fa_icons.dart';
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
import 'package:ducanherp/presentation/widgets/dialog/custom_dialog.dart';

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
  final TextEditingController iconSearchController = TextEditingController();

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

    tenNhomController =
        TextEditingController(text: widget.nnv?.tenNhom ?? '');
    taiKhoanController =
        TextEditingController(text: widget.nnv?.taiKhoan ?? '');

    selectedIconName =
        (widget.nnv?.iconName != null &&
                faIconNames.contains(widget.nnv!.iconName))
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
            context.read<ChiNhanhBloc>().add(
                  FetchChiNhanh(groupId: widget.user.groupId),
                );
          });
        }

        return MultiBlocListener(
          listeners: [
            /// ================== CHI NHÁNH ==================
            BlocListener<ChiNhanhBloc, ChiNhanhState>(
              listener: (context, state) {
                if (state is ChiNhanhLoaded) {
                  setStateSB(() {
                    chiNhanhModels = state.list;

                    if (isEditing) {
                      selectedChiNhanh = chiNhanhModels.firstWhere(
                        (e) => e.id == widget.nnv?.companyId,
                        orElse: () => chiNhanhModels.first,
                      );
                    }
                  });

                  /// 🔥 FIX QUAN TRỌNG: EDIT → LOAD NHÂN VIÊN NGAY
                  if (isEditing && selectedChiNhanh != null) {
                    context.read<NhanVienBloc>().add(
                          GetNhanVienByVM(
                            NhanVienModel(
                              id: '',
                              tenNhanVien: '',
                              taiKhoan: '',
                              companyId: selectedChiNhanh!.id,
                              companyName: '',
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
                            ),
                          ),
                        );
                  }
                }
              },
            ),

            /// ================== NHÂN VIÊN ==================
            BlocListener<NhanVienBloc, NhanVienState>(
              listener: (context, state) {
                if (state is NhanVienByVMLoaded) {
                  setStateSB(() {
                    nhanVienList = state.nhanViens;

                    if (isEditing) {
                      selectedNhanVien = nhanVienList.firstWhere(
                        (e) => e.id == widget.nnv?.idQuanLy
                      );

                      taiKhoanController.text =
                          selectedNhanVien?.taiKhoan ?? '';
                    }
                  });
                }
              },
            ),

            /// ================== NHÓM ==================
            BlocListener<NhomNhanVienBloc, NhomNhanVienState>(
              listener: (context, state) {
                if (state is NhomNhanVienSuccess) {
                  context.read<NhomNhanVienBloc>().add(
                        GetNhomNhanVienByVM(widget.searchVM),
                      );
                  Navigator.pop(context);
                }
                if (state is NhomNhanVienError) {
                  setStateSB(() {
                    errorMessage = state.message;
                  });
                }
              },
            ),
          ],
          child: CustomDialog(
            title: isEditing ? 'Sửa nhóm' : 'Thêm nhóm',
            onClose: () => Navigator.pop(context),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),

                    /// ========== CHI NHÁNH ==========
                    CustomDropdownFormField<ChiNhanhModel>(
                      label: 'Chi nhánh',
                      items: chiNhanhModels,
                      selectedId: selectedChiNhanh?.id ?? '',
                      getId: (e) => e.id,
                      getLabel: (e) => e.tenChiNhanh,
                      isRequired: true,
                      errorMessage: 'Vui lòng chọn chi nhánh',
                      onChanged: (value) {
                        setStateSB(() {
                          selectedChiNhanh = value;
                          selectedNhanVien = null;
                          nhanVienList = [];
                        });

                        if (value != null) {
                          context.read<NhanVienBloc>().add(
                                GetNhanVienByVM(
                                  NhanVienModel(
                                    id: '',
                                    tenNhanVien: '',
                                    taiKhoan: '',
                                    companyId: value.id,
                                    companyName: '',
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
                                  ),
                                ),
                              );
                        }
                      },
                      fillColor: context.surface,
                      borderColor: context.surface,
                      dropdownColor: context.surface,
                      iconColor: context.surface,
                    ),
                    const SizedBox(height: 10),

                    /// ========== NGƯỜI QUẢN LÝ ==========
                    CustomDropdownFormField<NhanVienModel>(
                      label: 'Người quản lý',
                      items: nhanVienList,
                      selectedId: selectedNhanVien?.id ?? '',
                      getId: (e) => e.id,
                      getLabel: (e) =>
                          '${e.tenNhanVien} (${e.taiKhoan})',
                      isRequired: true,
                      errorMessage: 'Vui lòng chọn người quản lý',
                      onChanged: (value) {
                        setStateSB(() {
                          selectedNhanVien = value;
                          taiKhoanController.text =
                              value?.taiKhoan ?? '';
                        });
                      },
                      fillColor: context.surface,
                      borderColor: context.surface,
                      dropdownColor:context.surface,
                      iconColor: context.surface,
                    ),
                    const SizedBox(height: 10),

                    CustomTextFormField(
                      label: 'Tên nhóm',
                      controller: tenNhomController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng nhập Tên nhóm';
                        }
                        if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]')
                            .hasMatch(value)) {
                          return 'Tên không được chứa ký tự đặc biệt';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    DropdownButtonFormField2<String>(
                      value: selectedIconName,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Biểu tượng nhóm',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: faIconNames.map((icon) {
                        return DropdownMenuItem(
                          value: icon,
                          child: Row(
                            children: [
                              FaIcon(getFaIcon(icon), size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  icon
                                      .replaceAll('fa-', '')
                                      .replaceAll('-', ' '),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (v) =>
                          setStateSB(() => selectedIconName = v!),
                      validator: (v) =>
                          v == null || v.isEmpty
                              ? 'Vui lòng chọn biểu tượng'
                              : null,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: _submit,
                child: Text(isEditing ? 'Cập nhật' : 'Thêm'),
              ),
            ],
          ),
        );
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

    context.read<NhomNhanVienBloc>().add(
          isEditing
              ? UpdateNhomNhanVien(model, widget.user.userName)
              : AddNhomNhanVien(model, widget.user.userName),
        );
  }
}
