import 'package:ducanherp/data/models/congviec_model.dart';
import 'package:ducanherp/data/models/congvieccon_model.dart';
import 'package:ducanherp/data/models/nhanvienthuchien_model.dart';
import 'package:ducanherp/data/models/themngay_model.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

abstract class CongViecDGEvent extends Equatable {
  const CongViecDGEvent();
  @override
  List<Object> get props => [];
}

// --- Công việc chính ---
class LoadCongViecDG extends CongViecDGEvent {
  final String groupId;
  final String nguoiThucHien;
  const LoadCongViecDG({required this.groupId, required this.nguoiThucHien});

  @override
  List<Object> get props => [groupId, nguoiThucHien];
}

class AddCongViecDG extends CongViecDGEvent {
  final CongViecModel congViec;
  final ThemNgayModel themNgay;
  final List<String> nhanViens;
  const AddCongViecDG({
    required this.congViec,
    required this.themNgay,
    required this.nhanViens,
  });

  @override
  List<Object> get props => [congViec, themNgay, nhanViens];
}

class UpdateCongViecDGEvent extends CongViecDGEvent {
  final CongViecModel congViec;
  final ThemNgayModel themNgay;
  final List<String> nhanViens;
  const UpdateCongViecDGEvent({
    required this.congViec,
    required this.themNgay,
    required this.nhanViens,
  });

  @override
  List<Object> get props => [congViec, themNgay, nhanViens];
}

class DeleteCongViecDG extends CongViecDGEvent {
  final String id;
  const DeleteCongViecDG(this.id);

  @override
  List<Object> get props => [id];
}

class RefreshCongViecDG extends CongViecDGEvent {
  const RefreshCongViecDG();
}

class GetCongViecDGByVM extends CongViecDGEvent {
  final CongViecModel congViec;
  const GetCongViecDGByVM(this.congViec);

  @override
  List<Object> get props => [congViec];
}

// --- Nhân viên thực hiện ---
class GetAllNVTHDG extends CongViecDGEvent {
  final String groupId;
  final NhanVienThucHienModel nvths;
  const GetAllNVTHDG(this.groupId, this.nvths);

  @override
  List<Object> get props => [groupId, nvths];
}

// --- Upload File ---
class UploadFileEventDG extends CongViecDGEvent {
  final PlatformFile file;
  const UploadFileEventDG(this.file);

  @override
  List<Object> get props => [file];
}

// --- CVC (Công việc con) ---
class LoadAllCVCEventDG extends CongViecDGEvent {
  const LoadAllCVCEventDG();
}

class LoadCVCByIdCVEventDG extends CongViecDGEvent {
  final String idCongViecDG;
  const LoadCVCByIdCVEventDG(this.idCongViecDG);

  @override
  List<Object> get props => [idCongViecDG];
}

class UpdateCVCEventDG extends CongViecDGEvent {
  final CongViecConModel cvc;
  const UpdateCVCEventDG(this.cvc);

  @override
  List<Object> get props => [cvc];
}

class InsertCVCEventDG extends CongViecDGEvent {
  final CongViecConModel cvc;
  const InsertCVCEventDG(this.cvc);

  @override
  List<Object> get props => [cvc];
}

class DeleteCVCEventDG extends CongViecDGEvent {
  final String id;
  final String userName;
  const DeleteCVCEventDG(this.id, this.userName);

  @override
  List<Object> get props => [id, userName];
}
