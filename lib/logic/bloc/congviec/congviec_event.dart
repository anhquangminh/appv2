import 'package:ducanherp/data/models/congviec_model.dart';
import 'package:ducanherp/data/models/congvieccon_model.dart';
import 'package:ducanherp/data/models/nhanvienthuchien_model.dart';
import 'package:ducanherp/data/models/themngay_model.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

abstract class CongViecEvent extends Equatable {
  const CongViecEvent();
  @override
  List<Object> get props => [];
}

// --- Công việc chính ---
class EventLoadCongViec extends CongViecEvent {
  final String groupId;
  final String nguoiThucHien;
  const EventLoadCongViec({required this.groupId, required this.nguoiThucHien});

  @override
  List<Object> get props => [groupId, nguoiThucHien];
}

class EventAddCongViec extends CongViecEvent {
  final CongViecModel congViec;
  final ThemNgayModel themNgay;
  final List<String> nhanViens;
  const EventAddCongViec({
    required this.congViec,
    required this.themNgay,
    required this.nhanViens,
  });

  @override
  List<Object> get props => [congViec, themNgay, nhanViens];
}

class EventUpdateCongViec extends CongViecEvent {
  final CongViecModel congViec;
  final ThemNgayModel themNgay;
  final List<String> nhanViens;
  const EventUpdateCongViec({
    required this.congViec,
    required this.themNgay,
    required this.nhanViens,
  });

  @override
  List<Object> get props => [congViec, themNgay, nhanViens];
}

class EventDeleteCongViec extends CongViecEvent {
  final String id;
  const EventDeleteCongViec(this.id);

  @override
  List<Object> get props => [id];
}

class EventRefreshCongViec extends CongViecEvent {
  const EventRefreshCongViec();
}

class EventGetCongViecByVM extends CongViecEvent {
  final CongViecModel congViec;
  const EventGetCongViecByVM(this.congViec);

  @override
  List<Object> get props => [congViec];
}

class EventGetCongViecById extends CongViecEvent {
  final String id;
  const EventGetCongViecById(this.id);

  @override
  List<Object> get props => [id];
}

// --- Nhân viên thực hiện ---
class EventGetAllNVTH extends CongViecEvent {
  final String groupId;
  final NhanVienThucHienModel nvths;
  const EventGetAllNVTH(this.groupId, this.nvths);

  @override
  List<Object> get props => [groupId, nvths];
}

// --- Upload File ---
class EventUploadFile extends CongViecEvent {
  final PlatformFile file;
  const EventUploadFile(this.file);

  @override
  List<Object> get props => [file];
}

// --- CVC (Công việc con) ---
class EventLoadAllCVC extends CongViecEvent {
  const EventLoadAllCVC();
}

class EventLoadCVCByIdCV extends CongViecEvent {
  final String idCongViec;
  const EventLoadCVCByIdCV(this.idCongViec);

  @override
  List<Object> get props => [idCongViec];
}
class EventInsertCVC extends CongViecEvent {
  final CongViecConModel cvc;
  const EventInsertCVC(this.cvc);

  @override
  List<Object> get props => [cvc];
}

class EventUpdateCVC extends CongViecEvent {
  final CongViecConModel cvc;
  const EventUpdateCVC(this.cvc);

  @override
  List<Object> get props => [cvc];
}

class EventDeleteCVC extends CongViecEvent {
  final String id;
  final String userName;
  const EventDeleteCVC(this.id, this.userName);

  @override
  List<Object> get props => [id, userName];
}
