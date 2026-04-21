import 'package:ducanherp/data/models/congvieccon_model.dart';
import 'package:ducanherp/data/models/nhanvienthuchien_model.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import '../../../data/models/congviec_model.dart';

abstract class CongViecDGState extends Equatable {
  const CongViecDGState();
  @override
  List<Object> get props => [];
}

class CongViecDGInitial extends CongViecDGState {}

class CongViecDGLoading extends CongViecDGState {}

class CongViecDGInsertSuccess extends CongViecDGState {}

class CongViecDGDeleteSuccess extends CongViecDGState {}

class CongViecDGError extends CongViecDGState {
  final String message;
  final DateTime errorTime;
  const CongViecDGError(this.message, {required this.errorTime});
  @override
  List<Object> get props => [message, errorTime];
}

class CongViecDGLoaded extends CongViecDGState {
  final List<CongViecModel> congViecs;
  final DateTime lastUpdated;
  const CongViecDGLoaded({
    required this.congViecs,
    required this.lastUpdated,
  });
  @override
  List<Object> get props => [congViecs, lastUpdated];
}

class CongViecDGByVMLoaded extends CongViecDGState {
  final List<CongViecModel> congViecs;
  final String groupId;
  const CongViecDGByVMLoaded({required this.congViecs, required this.groupId});
  @override
  List<Object> get props => [congViecs, groupId];
}

class GetAllNVTHLoadedDG extends CongViecDGState {
  final String groupId;
  final List<NhanVienThucHienModel> nvths;

  const GetAllNVTHLoadedDG({required this.nvths, required this.groupId});
  @override
  List<Object> get props => [nvths, groupId];
}

class CongViecDGUpdatedDG extends CongViecDGState {
  final CongViecModel congViec;
  const CongViecDGUpdatedDG(this.congViec);
  @override
  List<Object> get props => [congViec];
}

class UploadFileDG extends CongViecDGState {
  final PlatformFile file;
  final String url;
  const UploadFileDG(this.file, this.url);
  @override
  List<Object> get props => [file,url];
}

class LoadCVCByIdCVStateDG extends CongViecDGState {
  final List<CongViecConModel> cvcs;
  const LoadCVCByIdCVStateDG(this.cvcs);
  @override
  List<Object> get props => [cvcs];
}

class LoadCVCStateDG extends CongViecDGState {
  final List<CongViecConModel> cvcs;
  const LoadCVCStateDG(this.cvcs);
  @override
  List<Object> get props => [cvcs];
}

class InsertCVCStateDG extends CongViecDGState {
  final List<CongViecConModel> cvcs;
  const InsertCVCStateDG(this.cvcs);
  @override
  List<Object> get props => [cvcs];
}

class UpdateCVCStateDG extends CongViecDGState {
  final List<CongViecConModel> cvcs;
  const UpdateCVCStateDG(this.cvcs);
  @override
  List<Object> get props => [cvcs];
}

class DeleteCVCStateDG extends CongViecDGState {
  final List<CongViecConModel> cvcs;
  const DeleteCVCStateDG(this.cvcs);
  @override
  List<Object> get props => [cvcs];
}
