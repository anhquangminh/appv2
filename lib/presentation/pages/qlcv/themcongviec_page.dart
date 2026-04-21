import 'package:ducanherp/core/themes/app_radius.dart';
import 'package:ducanherp/core/themes/app_spacing.dart';
import 'package:ducanherp/core/themes/app_text_styles.dart';
import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/logic/bloc/congviec/congviec_event.dart';
import 'package:ducanherp/logic/bloc/congviec/congviec_state.dart';
import 'package:ducanherp/logic/bloc/download/download_bloc.dart';
import 'package:ducanherp/logic/bloc/download/download_event.dart';
import 'package:ducanherp/logic/bloc/download/download_state.dart';
import 'package:ducanherp/logic/bloc/nhanvien/nhanvien_bloc.dart';
import 'package:ducanherp/presentation/widgets/inputs/custom_datepicker.dart';
import 'package:ducanherp/presentation/widgets/inputs/custom_text_area.dart';
import 'package:ducanherp/presentation/widgets/inputs/custom_text_form_field.dart';
import 'package:ducanherp/presentation/widgets/toasts/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';

import '../../../logic/bloc/congviec/congviec_bloc.dart';
import '../../../logic/bloc/congviec/congviec_event.dart' as congviec_event;
import '../../../logic/bloc/nhanvien/nhanvien_event.dart' as nhan_vien_event;
import '../../../logic/bloc/nhanvien/nhanvien_state.dart';
import '../../../logic/bloc/nhomnhanvien/nhomnhanvien_bloc.dart';
import '../../../core/helpers/user_storage_helper.dart';
import '../../../data/models/application_user.dart';
import '../../../data/models/congviec_model.dart';
import '../../../data/models/nhanvien_model.dart';
import '../../../data/models/nhomnhanvien_model.dart';
import '../../../data/models/themngay_model.dart';
import '../../../data/models/nhanvienthuchien_model.dart';
import '../../widgets/inputs/custom_dropdown_form_field.dart';

class ThemCongViecPage extends StatefulWidget {
  final CongViecModel? congViecToEdit;

  const ThemCongViecPage({super.key, this.congViecToEdit});

  @override
  State<ThemCongViecPage> createState() => _ThemCongViecState();
}

class _ThemCongViecState extends State<ThemCongViecPage> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  ApplicationUser? user;
  List<String> groupNames = [];
  List<NhanVienModel> nhanviens = [];
  List<CongViecModel> existingTasks = [];
  // ignore: unused_field
  List<NhanVienModel> _selectedNhanViens = [];
  bool isLoadingGroups = true;
  bool isLoadingNhanviens = false;
  bool isLoadingTasks = false;
  String? fileName;
  bool isUploading = false;
  String idNhomNhanVienEdit = '';

  List<NhomNhanVienModel> nhomNhanViens = [];

  late final CongViecModel newTask;

  @override
  void initState() {
    super.initState();
    newTask =
        widget.congViecToEdit ??
        CongViecModel(
          id: '',
          idNguoiGiaoViec: '',
          nguoiThucHien: '',
          nhomCongViec: '',
          tenNhom: '',
          ngayBatDau: DateTime.now(),
          ngayKetThuc: DateTime.now().add(const Duration(days: 7)),
          mucDoUuTien: '',
          tuDanhGia: '',
          duocDanhGia: 0,
          tienDo: 0,
          lapLai: '',
          tenCongViec: '',
          noiDungCongViec: '',
          fileDinhKem: '',
          groupId: '',
          companyId: user?.companyId ?? '',
          companyName: '',
          createAt: DateTime.now(),
          createBy: '',
          isActive: 1,
          pageNumber: 1,
          pageSize: 10,
        );
    if (widget.congViecToEdit != null) {
      newTask.nhomCongViec = widget.congViecToEdit!.nhomCongViec;
      newTask.fileDinhKem = widget.congViecToEdit!.fileDinhKem;
      idNhomNhanVienEdit = widget.congViecToEdit!.nhomCongViec;
      context.read<NhanVienBloc>().add(
        nhan_vien_event.GetNhanVienByNhom(
          groupId: newTask.groupId,
          idNhomNhanVien: newTask.nhomCongViec,
          companyId: newTask.companyId,
        ),
      );
    }
    initData();
  }

  ThemNgayModel themNgay = ThemNgayModel(
    id: '',
    idCongViec: '',
    idCongViecThemNgay: '',
    soNgay: 0,
    groupId: '',
    createAt: DateTime.now(),
    createBy: '',
    isActive: 1,
  );

  Future<void> initData() async {
    user = await UserStorageHelper.getCachedUserInfo();
    if (user == null) return;
    newTask.groupId = user!.groupId;
    newTask.companyId = user!.companyId;
    newTask.idNguoiGiaoViec = user!.userName;
    newTask.createBy = user!.userName;
    // ignore: use_build_context_synchronously
    context.read<NhomNhanVienBloc>().add(
      LoadNhomNhanVien(
        groupId: user!.groupId,
        companyId: user!.companyId,
        taiKhoan: user!.userName,
      ),
    );

    // ignore: use_build_context_synchronously
    context.read<CongViecBloc>().add(
      congviec_event.EventGetCongViecByVM(newTask),
    );

    if (widget.congViecToEdit != null) {
      // ignore: use_build_context_synchronously
      context.read<NhanVienBloc>().add(
        nhan_vien_event.GetNhanVienByNhom(
          groupId: newTask.groupId,
          idNhomNhanVien: newTask.nhomCongViec,
          companyId: user?.companyId ?? '',
        ),
      );
    }
  }

  bool get isNhanvienselectEnabled => newTask.nhomCongViec.isNotEmpty;

  bool isValidCongViecModel(CongViecModel model) {
    return model.idNguoiGiaoViec.trim().isNotEmpty &&
        _selectedNhanViens.isNotEmpty &&
        model.nhomCongViec.trim().isNotEmpty &&
        model.mucDoUuTien.trim().isNotEmpty &&
        model.lapLai.trim().isNotEmpty &&
        model.noiDungCongViec.trim().isNotEmpty &&
        model.tenCongViec.trim().isNotEmpty &&
        model.groupId.trim().isNotEmpty;
  }

  List<CongViecModel> items = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Đóng bàn phím khi click ra ngoài
      },
      child: Scaffold(
  backgroundColor: context.background,
  appBar: AppBar(
    centerTitle: true,
    elevation: 0,
    backgroundColor: context.primary,
    surfaceTintColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(AppRadius.lg),
      ),
    ),
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: context.onPrimary),
      onPressed: () => Navigator.pop(context, true),
    ),
    title: Text(
      newTask.id.isEmpty ? 'Thêm Công Việc' : 'Cập Nhật Công Việc',
      style: AppTextStyles.title(context).copyWith(
        fontWeight: FontWeight.bold,
        color: context.onPrimary,
      ),
    ),
  ),

        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 12),

                    BlocConsumer<NhomNhanVienBloc, NhomNhanVienState>(
                      listener: (context, state) {
                        if (state is NhomNhanVienLoaded) {
                          setState(() {
                            nhomNhanViens = state.nhomNhanViens;
                          });
                        }
                        if (state is NhomNhanVienError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Lỗi tải nhóm: ${state.message}'),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is NhomNhanVienLoading) {
                          return const LinearProgressIndicator();
                        }
                        return CustomDropdownFormField<NhomNhanVienModel>(
  label: 'Nhóm',
  items: nhomNhanViens,
  selectedId: newTask.nhomCongViec,
  getId: (e) => e.id,
  getLabel: (e) => e.tenNhom,
  onChanged: (nnv) {
    setState(() {
      newTask.nhomCongViec = nnv?.id ?? '';
      _selectedNhanViens = [];
      nhanviens = [];
    });
    if (nnv != null) {
      context.read<NhanVienBloc>().add(
        nhan_vien_event.GetNhanVienByNhom(
          groupId: newTask.groupId,
          idNhomNhanVien: newTask.nhomCongViec,
          companyId: user?.companyId ?? '',
        ),
      );
    }
  },

  // ✅ dùng theme extension (auto light/dark)
  fillColor: context.surfaceLow,
  borderColor: context.border,
  dropdownColor: context.surface,
  iconColor: context.textSecondary,
);
                      },
                    ),
                    const SizedBox(height: 12),
                    BlocListener<CongViecBloc, CongViecState>(
                      listener: (context, congViecState) {
                        if (congViecState is StateGetAllNVTHLoaded) {
                          final selectedIds =
                              congViecState.nvths
                                  .map((e) => e.idNhanVien)
                                  .expand((ids) => ids.split(','))
                                  .map((e) => e.trim())
                                  .toSet();

                          _selectedNhanViens =
                              nhanviens
                                  .where((nv) => selectedIds.contains(nv.id))
                                  .toList();

                          setState(() {});
                        }
                      },
                      child: BlocListener<NhanVienBloc, NhanVienState>(
                        listener: (context, state) {
                          if (state is NhanVienLoaded) {
                            nhanviens = state.nhanViens;
                            if (widget.congViecToEdit != null) {
                              final nvthModel = NhanVienThucHienModel(
                                id: '',
                                idCongViec: widget.congViecToEdit!.id,
                                idNhanVien: '',
                                createBy: user?.userName ?? '',
                                groupId: newTask.groupId,
                                createAt: DateTime.now(),
                                isActive: 1,
                              );
                              context.read<CongViecBloc>().add(
                                congviec_event.EventGetAllNVTH(
                                  newTask.groupId,
                                  nvthModel,
                                ),
                              );
                            }
                            setState(() {});
                          } else if (state is NhanVienError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Lỗi nhân viên: ${state.message}',
                                ),
                              ),
                            );
                          }
                        },
                        child: AbsorbPointer(
  absorbing: !isNhanvienselectEnabled,
  child: Opacity(
    opacity: isNhanvienselectEnabled ? 1 : 0.5,
    child: Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: context.border,
          width: 1.2,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 4,
      ),
      child: MultiSelectDialogField<NhanVienModel>(
        items: nhanviens
            .map(
              (e) => MultiSelectItem<NhanVienModel>(
                e,
                e.tenNhanVien,
              ),
            )
            .toList(),
        title: Text(
          "Chọn nhân viên",
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: context.primary,
            fontSize: 14,
          ),
        ),
        isDismissible: true,
        decoration: const BoxDecoration(
          border: Border.fromBorderSide(BorderSide.none),
        ),
        buttonText: Text(
          "Chọn nhân viên",
          style: TextStyle(
            color: context.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        itemsTextStyle: TextStyle(
          color: context.textPrimary,
          fontSize: 13,
        ),
        selectedColor: context.primary,
        checkColor: context.onPrimary,
        selectedItemsTextStyle: TextStyle(
          fontWeight: FontWeight.normal,
          color: context.primary,
          fontSize: 14,
        ),
        initialValue: _selectedNhanViens,
        onConfirm: (results) {
          setState(() {
            _selectedNhanViens =
                results.cast<NhanVienModel>();
            if (_selectedNhanViens.isNotEmpty) {
              if (widget.congViecToEdit != null) {
                items = [];
              } else {
                items = existingTasks.where((task) {
                  final taskEmails = task.nguoiThucHien
                      .split(',')
                      .map((e) {
                        final match = RegExp(r'\(([^)]+)\)')
                            .firstMatch(e);
                        return match
                            ?.group(1)
                            ?.trim()
                            .toLowerCase();
                      })
                      .whereType<String>()
                      .toList();
                  return _selectedNhanViens.any(
                    (nv) => taskEmails.contains(
                      nv.taiKhoan.trim().toLowerCase(),
                    ),
                  );
                }).toList();
              }
            } else {
              items = [];
            }
          });
        },
        dialogHeight:
            MediaQuery.of(context).size.height * 0.5,
        listType: MultiSelectListType.LIST,
      ),
    ),
  ),
),
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomTextFormField(
                      label: 'Tên công việc',
                      onSaved: (v) => newTask.tenCongViec = v ?? '',
                      validator:
                          (v) =>
                              v == null || v.isEmpty
                                  ? 'Vui lòng nhập tên công việc'
                                  : null,
                      initialValue: newTask.tenCongViec,
                    ),
                    const SizedBox(height: 12),
                    CustomTextArea(
                      label: 'Nội dung công việc',
                      onSaved: (v) => newTask.noiDungCongViec = v ?? '',
                      validator:
                          (v) =>
                              v == null || v.isEmpty
                                  ? 'Vui lòng nhập nội dung'
                                  : null,
                      initialValue: newTask.noiDungCongViec,
                    ),
                    const SizedBox(height: 12),
                    CustomDropdownFormField<String>(
  label: 'Mức độ ưu tiên',
  items: const ['Thấp', 'Trung bình', 'Cao', 'Khẩn cấp'],
  selectedId: newTask.mucDoUuTien,
  getId: (e) => e,
  getLabel: (e) => e,
  onChanged: (val) => newTask.mucDoUuTien = val ?? '',

  // ✅ dùng theo Theme (auto light/dark)
  fillColor: context.surfaceLow,
  borderColor: context.border,
  dropdownColor: context.surface,
  iconColor: context.textSecondary,
),
                    const SizedBox(height: 12),
                    CustomDropdownFormField<String>(
  label: 'Lặp lại',
  items: const [
    'Hàng ngày',
    'Hàng tuần',
    'Hàng tháng',
    'Không lặp lại',
  ],
  selectedId: newTask.lapLai,
  getId: (e) => e,
  getLabel: (e) => e,
  onChanged: (val) => newTask.lapLai = val ?? '',
  fillColor: context.surfaceLow,
  borderColor: context.border,
  dropdownColor: context.surface,
  iconColor: context.textSecondary,
),

const SizedBox(height: AppSpacing.md),

CustomDatePicker(
  label: 'Ngày bắt đầu',
  selectedDate: newTask.ngayBatDau,
  onDateSelected: (date) {
    setState(() {
      newTask.ngayBatDau = date;
    });
  },
  fillColor: context.surfaceLow,
  borderColor: context.border,
  iconColor: context.textSecondary,
),

const SizedBox(height: AppSpacing.md),

CustomDatePicker(
  label: 'Ngày Kết Thúc',
  selectedDate: newTask.ngayKetThuc,
  onDateSelected: (date) {
    setState(() {
      newTask.ngayKetThuc = date;
    });
  },
  fillColor: context.surfaceLow,
  borderColor: context.border,
  iconColor: context.textSecondary,
),

const SizedBox(height: AppSpacing.md),

Divider(
  color: context.border,
  thickness: 1,
),
                    const SizedBox(height: 12),
                    // Nút chọn file và icon tải file
                    BlocListener<DownloadBloc, DownloadState>(
  listener: (context, state) {
    if (state is DownloadInProgress) {
      showAppToast(
        context,
        message: 'Đang tải file...',
        icon: Icons.downloading,
        backgroundColor: context.primary,
      );
    }

    if (state is DownloadSuccess) {
      showAppToast(
        context,
        message: 'Tải file thành công',
        icon: Icons.check_circle,
        backgroundColor: context.success,
        actionLabel: 'MỞ',
        onAction: () {
          OpenFilex.open(state.path);
        },
      );
    }

    if (state is DownloadFailure) {
      showAppToast(
        context,
        message: 'Tải file thất bại',
        icon: Icons.error,
        backgroundColor: context.error,
      );
    }
  },
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: context.primary,
          foregroundColor: context.onPrimary,
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.mdRadius,
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          elevation: 2,
        ),
        onPressed: () async {
          _formKey.currentState?.save();
          FilePickerResult? result =
              await FilePicker.platform.pickFiles();
          if (result != null &&
              result.files.single.path != null) {
            final file = result.files.single;
            // ignore: use_build_context_synchronously
            context.read<CongViecBloc>().add(
              EventUploadFile(file),
            );
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.attach_file,
              size: 20,
              color: context.onPrimary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Chọn File',
              style: TextStyle(
                fontSize: 13,
                color: context.onPrimary,
              ),
            ),
          ],
        ),
      ),
      if (newTask.fileDinhKem != "")
        IconButton(
          icon: Icon(
            Icons.download,
            size: 32,
            color: context.primary,
          ),
          onPressed: () {
            final url =
                '${dotenv.env['API_URL']}${newTask.fileDinhKem}';
            final fileName =
                newTask.fileDinhKem.split('/').last;

            context.read<DownloadBloc>().add(
              StartDownload(url, fileName),
            );
          },
        ),
    ],
  ),
),
                    const SizedBox(height: 16),
                    BlocListener<CongViecBloc, CongViecState>(
                      listener: (context, state) {
                        if (state is StateUploadFile) {
                          setState(() {
                            newTask.fileDinhKem =
                                state.url; // Lưu URL file đã tải lên
                          });
                        }
                      },
                      child: GridView.builder(
                        shrinkWrap:
                            true, // Để GridView không chiếm toàn bộ chiều cao
                        physics:
                            NeverScrollableScrollPhysics(), // Vô hiệu hóa cuộn bên trong GridView
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Số cột trong lưới
                          crossAxisSpacing: 8.0, // Khoảng cách giữa các cột
                          mainAxisSpacing: 8.0, // Khoảng cách giữa các hàng
                        ),
                        itemCount: newTask.fileDinhKem.isNotEmpty ? 1 : 0,
                        itemBuilder: (context, index) {
                          final fileUrl =
                              '${dotenv.env['API_URL']}${newTask.fileDinhKem}';
                          final fileName = newTask.fileDinhKem.split('/').last;
                          final isImage =
                              fileName.toLowerCase().endsWith('.jpg') ||
                              fileName.toLowerCase().endsWith('.jpeg') ||
                              fileName.toLowerCase().endsWith('.png') ||
                              fileName.toLowerCase().endsWith('.gif');

                          return Stack(
                            children: [
                              if (isImage)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    fileUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      fileName,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      newTask.fileDinhKem =
                                          ""; // Xóa file đã chọn
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                       // Nền đỏ mờ
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),
                    BlocConsumer<CongViecBloc, CongViecState>(
                      listener: (context, state) {
                        if (state is StateCongViecByVMLoaded) {
                          setState(() {
                            existingTasks = state.congViecs;
                            isLoadingTasks = false;
                          });
                        } else if (state is StateCongViecError) {
                          setState(() {
                            isLoadingTasks = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Lỗi tải danh sách công việc: ${state.message}',
                              ),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (isLoadingTasks) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Thêm ngày cho công việc',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                LinearProgressIndicator(),
                              ],
                            ),
                          );
                        }
                        return _selectedNhanViens.isEmpty || items.isEmpty
                            ? SizedBox.shrink()
                            : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomDropdownFormField<CongViecModel>(
                                  label: 'Thêm ngày cho công việc',
                                  items: items,
                                  selectedId: themNgay.idCongViecThemNgay,
                                  getId: (task) => task.id,
                                  getLabel: (task) => task.noiDungCongViec,
                                  onChanged: (task) {
                                    if (task != null) {
                                      setState(() {
                                        themNgay = themNgay.copyWith(
                                          idCongViecThemNgay: task.id,
                                        );
                                      });
                                    } else {
                                      setState(() {
                                        themNgay = themNgay.copyWith(
                                          idCongViecThemNgay: "",
                                        );
                                      });
                                    }
                                  },
                                ),
                                const SizedBox(height: 12),
                                if (themNgay.idCongViecThemNgay != "")
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Số ngày thêm',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^[1-9][0-9]*$'),
                                      ),
                                    ],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Vui lòng nhập số ngày';
                                      }
                                      final num = int.tryParse(value);
                                      if (num == null || num <= 0) {
                                        return 'Số ngày phải là số nguyên dương';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      final num = int.tryParse(value);
                                      setState(() {
                                        themNgay = themNgay.copyWith(
                                          soNgay: (num ?? 0),
                                        );
                                      });
                                    },
                                  ),
                              ],
                            );
                      },
                    ),
                    const SizedBox(height: 12),
                    BlocConsumer<CongViecBloc, CongViecState>(
                      listener: (context, state) {
                        if (state is StateCongViecLoaded ||
                            state is StateCongViecUpdated) {
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pop(context, true);
                        } else if (state is StateCongViecError) {
                          setState(() {
                            isLoading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              if (!isValidCongViecModel(newTask)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Vui lòng điền đầy đủ thông tin!',
                                    ),
                                  ),
                                );
                                return;
                              }

                              if (_selectedNhanViens.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Vui lòng chọn nhân viên thực hiện!',
                                    ),
                                  ),
                                );
                                return;
                              }
                              final nhanVienIds =
                                  _selectedNhanViens.map((e) => e.id).toList();
                              setState(() {
                                isLoading = true;
                              });

                              if (widget.congViecToEdit != null) {
                                if (widget.congViecToEdit!.id.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Vui lòng chọn công việc để cập nhật!',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                newTask.id = widget.congViecToEdit!.id;
                                context.read<CongViecBloc>().add(
                                  congviec_event.EventUpdateCongViec(
                                    congViec: newTask,
                                    themNgay: themNgay,
                                    nhanViens: nhanVienIds,
                                  ),
                                );
                              } else {
                                context.read<CongViecBloc>().add(
                                  congviec_event.EventAddCongViec(
                                    congViec: newTask,
                                    themNgay: themNgay,
                                    nhanViens: nhanVienIds,
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            widget.congViecToEdit != null
                                ? 'Cập nhật'
                                : 'Thêm Công Việc',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
            if (isLoading)
              Container(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.5),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
