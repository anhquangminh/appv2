import 'package:ducanherp/data/models/congvieccon_model.dart';
import 'package:ducanherp/data/models/nhanvienthuchien_model.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import '../../../data/models/congviec_model.dart';

abstract class CongViecState extends Equatable {
  const CongViecState();
  @override
  List<Object> get props => [];
}

class StateCongViecInitial extends CongViecState {}

class StateCongViecLoading extends CongViecState {}

class StateCongViecInsertSuccess extends CongViecState {}

class StateCongViecDeleteSuccess extends CongViecState {}

class StateCongViecError extends CongViecState {
  final String message;
  final DateTime errorTime;
  const StateCongViecError(this.message, {required this.errorTime});
  @override
  List<Object> get props => [message, errorTime];
}

class StateCongViecLoaded extends CongViecState {
  final List<CongViecModel> congViecs;
  final DateTime lastUpdated;
  const StateCongViecLoaded({
    required this.congViecs,
    required this.lastUpdated,
  });
  @override
  List<Object> get props => [congViecs, lastUpdated];
}

class StateCongViecByVMLoaded extends CongViecState {
  final List<CongViecModel> congViecs;
  final String groupId;
  const StateCongViecByVMLoaded({required this.congViecs, required this.groupId});
  @override
  List<Object> get props => [congViecs, groupId];
}

class StateCongViecByIdLoaded extends CongViecState {
  final CongViecModel congViec;
  const StateCongViecByIdLoaded(this.congViec);

  @override
  List<Object> get props => [congViec];
}


class StateGetAllNVTHLoaded extends CongViecState {
  final String groupId;
  final List<NhanVienThucHienModel> nvths;

  const StateGetAllNVTHLoaded({required this.nvths, required this.groupId});
  @override
  List<Object> get props => [nvths, groupId];
}

class StateCongViecUpdated extends CongViecState {
  final CongViecModel congViec;
  const StateCongViecUpdated(this.congViec);
  @override
  List<Object> get props => [congViec];
}

class StateUploadFile extends CongViecState {
  final PlatformFile file;
  final String url;
  const StateUploadFile(this.file, this.url);
  @override
  List<Object> get props => [file,url];
}

class StateLoadCVCByIdCV extends CongViecState {
  final List<CongViecConModel> cvcs;
  const StateLoadCVCByIdCV(this.cvcs);
  @override
  List<Object> get props => [cvcs];
}

class StateLoadCVC extends CongViecState {
  final List<CongViecConModel> cvcs;
  const StateLoadCVC(this.cvcs);
  @override
  List<Object> get props => [cvcs];
}

class StateInsertCVC extends CongViecState {
  final CongViecConModel cvc;
  const StateInsertCVC(this.cvc);

  @override
  List<Object> get props => [cvc];
}

class StateUpdateCVC extends CongViecState {
  final CongViecConModel cvc;
  const StateUpdateCVC(this.cvc);

  @override
  List<Object> get props => [cvc];
}

class StateDeleteCVC extends CongViecState {

  @override
  List<Object> get props => [];
}
