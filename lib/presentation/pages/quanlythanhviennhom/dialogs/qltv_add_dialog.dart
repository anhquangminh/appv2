import 'package:ducanherp/data/models/quanlynhanvien_model.dart';
import 'package:ducanherp/logic/bloc/quanlynhanvien/quanlynhanvien_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:ducanherp/presentation/widgets/dialog/custom_dialog.dart';

class QLTVDialog extends StatefulWidget {
  final ApplicationUser user;
  final QuanLyNhanVienModel searchVM;
  final QuanLyNhanVienModel? qlnv;

  const QLTVDialog({
    super.key,
    required this.user,
    required this.searchVM,
    this.qlnv,
  });

  @override
  State<QLTVDialog> createState() => _QLTVDialogState();
}

class _QLTVDialogState extends State<QLTVDialog> {
  final formKey = GlobalKey<FormState>();
  String? errorMessage;
  List<ChiNhanhModel> chiNhanhModels = [];
  List<NhomNhanVienModel> nhomNhanVienList = [];
  NhomNhanVienModel? selectedNhomNhanVien;
  List<NhanVienModel> nhanVienList = [];
  NhanVienModel? selectedNhanVien;
  ChiNhanhModel? selectedChiNhanh;

  bool isFirstLoad = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        if (isFirstLoad) {
          isFirstLoad = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<ChiNhanhBloc>().add(
              FetchChiNhanh(groupId: widget.user.groupId),
            );
          });
        }
        return MultiBlocListener(
          listeners: [
            BlocListener<ChiNhanhBloc, ChiNhanhState>(
              listener: (context, state) {
                if (state is ChiNhanhLoaded) {
                  setState(() {
                    chiNhanhModels = state.list;
                  });
                } else if (state is ChiNhanhLoading) {
                  setState(() {
                    chiNhanhModels = [];
                  });
                } else if (state is ChiNhanhError) {
                  setState(() {
                    errorMessage = state.message;
                    chiNhanhModels = [];
                  });
                }
              },
            ),
            BlocListener<NhomNhanVienBloc, NhomNhanVienState>(
              listener: (context, state) {
                if (state is NhomNhanVienError) {
                  setState(() {
                    errorMessage = state.message;
                  });
                }
                if (state is NhomNhanVienVMLoaded) {
                  setState(() {
                    nhomNhanVienList = state.nhomNhanViens;
                  });
                }
              },
            ),
            BlocListener<NhanVienBloc, NhanVienState>(
              listener: (context, state) {
                if (state is NhanVienByVMLoaded) {
                  setState(() {
                    nhanVienList = state.nhanViens;
                    selectedNhanVien = null;
                  });
                }
              },
            ),
            BlocListener<QuanLyNhanVienBloc, QuanLyNhanVienState>(
              listener: (context, state) {
                if (state is QuanLyNhanVienSuccess) {
                  context.read<QuanLyNhanVienBloc>().add(
                    GetQuanLyNhanVienByVM(widget.searchVM),
                  );
                  Navigator.pop(context);
                }
                if (state is QuanLyNhanVienError) {
                  setState(() {
                    errorMessage = state.message;
                  });
                }
              },
            ),
          ],
          child: CustomDialog(
            title: 'Thêm nhân viên vào nhóm',
            onClose: () => Navigator.pop(context),
            body: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  DropdownButtonFormField<ChiNhanhModel>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Chi nhánh',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    value: selectedChiNhanh,
                    items:
                        chiNhanhModels.map((cn) {
                          return DropdownMenuItem<ChiNhanhModel>(
                            value: cn,
                            child: Text(cn.tenChiNhanh),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedChiNhanh = value;
                        context.read<NhomNhanVienBloc>().add(
                          GetNhomNhanVienByVM(
                            NhomNhanVienModel(
                              id: '',
                              idQuanLy: '',
                              tenNhanVien: '',
                              tenNhom: '',
                              iconName: '',
                              taiKhoan: '',
                              total: 0,
                              companyId: value!.id,
                              companyName: '',
                              groupId: widget.user.groupId,
                              createAt: DateTime.now(),
                              createBy: '',
                              isActive: 1,
                              pageNumber: 1,
                              pageSize: 10,
                            ),
                          ),
                        );
                      });
                    },
                    validator:
                        (value) =>
                            value == null ? 'Vui lòng chọn chi nhánh' : null,
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<NhomNhanVienModel>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Nhóm',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    value: selectedNhomNhanVien,
                    items:
                        nhomNhanVienList.map((nhom) {
                          return DropdownMenuItem<NhomNhanVienModel>(
                            value: nhom,
                            child: Text(nhom.tenNhom),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedNhomNhanVien = value;
                        context.read<NhanVienBloc>().add(
                          GetNhanVienByVM(
                            NhanVienModel(
                              id: '',
                              tenNhanVien: '',
                              taiKhoan: '',
                              companyId: '',
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
                      });
                    },
                    validator:
                        (value) => value == null ? 'Vui lòng chọn nhóm' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<NhanVienModel>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Nhân viên',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    value: selectedNhanVien,
                    items:
                        nhanVienList.map((nhanVien) {
                          return DropdownMenuItem<NhanVienModel>(
                            value: nhanVien,
                            child: Text(
                              '${nhanVien.tenNhanVien} (${nhanVien.taiKhoan})',
                            ),
                          );
                        }).toList(),
                    onChanged:
                        selectedNhomNhanVien == null
                            ? null
                            : (value) {
                              setState(() {
                                selectedNhanVien = value;
                              });
                            },
                    validator:
                        (value) =>
                            value == null ? 'Vui lòng chọn nhân viên' : null,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final newQuanLyNhanVien = QuanLyNhanVienModel(
                      id: '',
                      idNhomNhanVien: selectedNhomNhanVien?.id ?? '',
                      tenNhom: selectedNhomNhanVien?.tenNhom ?? '',
                      idNhanVien: selectedNhanVien?.id ?? '',
                      tenNhanVien: selectedNhanVien?.tenNhanVien ?? '',
                      taiKhoan: selectedNhanVien?.taiKhoan ?? '',
                      groupId: widget.user.groupId,
                      companyId: selectedChiNhanh?.id ?? '',
                      companyName: selectedChiNhanh?.tenChiNhanh ?? '',
                      createAt: DateTime.now(),
                      createBy: widget.user.userName,
                      isActive: 1,
                    );

                    context.read<QuanLyNhanVienBloc>().add(
                      AddQuanLyNhanVien(
                        newQuanLyNhanVien,
                        widget.user.userName,
                      ),
                    );
                  }
                },
                child: const Text('Thêm'),
              ),
            ],
          ),
        );
      },
    );
  }
}
